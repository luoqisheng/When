
import Foundation
import MachO
import Accelerate

/// http://www.itkeyword.com/doc/143214251714949x965/uleb128p1-sleb128-uleb128
fileprivate func read_uleb128(p: inout UnsafeMutablePointer<UInt8>, end: UnsafeMutablePointer<UInt8>) -> UInt64 {
    var result: UInt64 = 0
    var bit = 0
    var read_next = true
    
    repeat {
        if p == end {
            assert(false, "malformed uleb128")
        }
        let slice = UInt64(p.pointee & 0x7f)
        if bit > 63 {
            assert(false, "uleb128 too big for uint64")
        } else {
            result |= (slice << bit)
            bit += 7
        }
        read_next = (p.pointee & 0x80) != 0  // = 128
        p += 1
    } while (read_next)
    
    return result
}

public class WhenEngine {
    
    private static var symbols: [UnsafeMutableRawPointer?] = [] 
    
    public func setup() {
        _dyld_register_func_for_add_image { (image, slide) in
            WhenEngine.symbols += WhenEngine.shared.getDyldExportedTrie(image: image, slide: slide)
        }
    }
    
    private var linkeditName = SEG_LINKEDIT.utf8CString

    private func getDyldExportedTrie(image:UnsafePointer<mach_header>!, slide: Int) -> [UnsafeMutableRawPointer?] {
        var linkeditCmd: UnsafeMutablePointer<segment_command_64>!
        var dynamicLoadInfoCmd: UnsafeMutablePointer<dyld_info_command>!
        
        var cur_cmd = UnsafeMutableRawPointer(mutating: image).advanced(by: MemoryLayout<mach_header_64>.size).assumingMemoryBound(to: segment_command_64.self)
        
        for _ in 0..<image.pointee.ncmds {
            if cur_cmd.pointee.cmd == LC_SEGMENT_64 {
          
                if  cur_cmd.pointee.segname.0 == linkeditName[0] &&
                    cur_cmd.pointee.segname.1 == linkeditName[1] &&
                    cur_cmd.pointee.segname.2 == linkeditName[2] &&
                    cur_cmd.pointee.segname.3 == linkeditName[3] &&
                    cur_cmd.pointee.segname.4 == linkeditName[4] &&
                    cur_cmd.pointee.segname.5 == linkeditName[5] &&
                    cur_cmd.pointee.segname.6 == linkeditName[6] &&
                    cur_cmd.pointee.segname.7 == linkeditName[7] &&
                    cur_cmd.pointee.segname.8 == linkeditName[8] &&
                    cur_cmd.pointee.segname.9 == linkeditName[9]
                {
                    linkeditCmd = cur_cmd
                }
            } else if cur_cmd.pointee.cmd == LC_DYLD_INFO_ONLY || cur_cmd.pointee.cmd == LC_DYLD_INFO {
                dynamicLoadInfoCmd = cur_cmd.withMemoryRebound(to: dyld_info_command.self, capacity: 1, { $0 })
            }
            
            let cur_cmd_size = Int(cur_cmd.pointee.cmdsize)
            let _cur_cmd = cur_cmd.withMemoryRebound(to: Int8.self, capacity: 1, { $0 }).advanced(by: cur_cmd_size)
            cur_cmd = _cur_cmd.withMemoryRebound(to: segment_command_64.self, capacity: 1, { $0 })
        }
        
        guard linkeditCmd != nil, dynamicLoadInfoCmd != nil else {
            return []
        }
        
        let linkeditBase = slide + Int(linkeditCmd.pointee.vmaddr) - Int(linkeditCmd.pointee.fileoff)
        let exportedInfoBase = linkeditBase + Int(dynamicLoadInfoCmd.pointee.export_off)
        guard let exportedInfo = UnsafeMutableRawPointer(bitPattern: exportedInfoBase)?.assumingMemoryBound(to: UInt8.self) else {
            return []
        }
        let exportedInfoSize = Int(dynamicLoadInfoCmd.pointee.export_size)
        
        var symbols: [UnsafeMutableRawPointer?] = []
        dumpExportedSymbols(image: image, start: exportedInfo, loc: exportedInfo, end: exportedInfo + exportedInfoSize, currentSymbol: "", symbols: &symbols)
        
        return symbols
    }

    /*
     terminal Size:  p + terminalSize + 1 -> child count
     flags
     Symbol offset
     child count
     Node Label
     Child Node
     */
    private func dumpExportedSymbols(image:UnsafePointer<mach_header>!,
                                     start:UnsafeMutablePointer<UInt8>,
                                     loc:UnsafeMutablePointer<UInt8>,
                                     end:UnsafeMutablePointer<UInt8>,
                                     currentSymbol: String,
                                     symbols: inout [UnsafeMutableRawPointer?]) {
        var p = loc
        if p <= end {
            var terminalSize = UInt64(p.pointee)
            if terminalSize > 127 {
                p -= 1
                terminalSize = read_uleb128(p: &p, end: end)
            }
            // 符号结束节点
            if terminalSize != 0 {
                guard currentSymbol.hasPrefix("_When:") else {
                    return
                }

                let returnSwiftSymbolAddress = { () -> UnsafeMutableRawPointer in
                    let machO = image.withMemoryRebound(to: Int8.self, capacity: 1, { $0 })
                    let swiftSymbolAddress = machO.advanced(by: Int(read_uleb128(p: &p, end: end)))
                    return UnsafeMutableRawPointer(mutating: swiftSymbolAddress)
                }
                
                p = p + 1 // advance to the flags
                let flags = read_uleb128(p: &p, end: end)
                switch flags & UInt64(EXPORT_SYMBOL_FLAGS_KIND_MASK) {
                case UInt64(EXPORT_SYMBOL_FLAGS_KIND_REGULAR):
                    symbols += [returnSwiftSymbolAddress()]
                case UInt64(EXPORT_SYMBOL_FLAGS_KIND_THREAD_LOCAL):
                    break;
                case UInt64(EXPORT_SYMBOL_FLAGS_KIND_ABSOLUTE):
                    symbols += [UnsafeMutableRawPointer(bitPattern: UInt(read_uleb128(p: &p, end: end)))]
                default:
                    break
                }
            }
            
            let child = loc.advanced(by: Int(terminalSize + 1))
            let childCount = child.pointee
            p = child + 1
            for _ in 0 ..< childCount {
                let nodeLabel = String(cString: p.withMemoryRebound(to: CChar.self, capacity: 1, { $0 }), encoding: .utf8)
                // advance to the end of node's label
                while p.pointee != 0 {
                    p += 1
                }
                
                // so advance to the child's node
                p += 1
                let nodeOffset = Int(read_uleb128(p: &p, end: end))
                if nodeOffset != 0, let nodeLabel = nodeLabel {
                    let symbol = currentSymbol + nodeLabel
                    if symbol.hasPrefix("_When:") || "_When:".hasPrefix(symbol) {
                        dumpExportedSymbols(image: image, start: start, loc: start.advanced(by: nodeOffset), end: end, currentSymbol: symbol, symbols: &symbols)
                    }
                }
            }
        }
    }

    public static var shared = WhenEngine()
}

extension WhenEngine: When {
    
    typealias EventFunc = @convention(thin) () -> When

    public static func When() -> When {
        return WhenEngine.shared
    }
    
    public static func broadcast<T>(protocol: T.Type, observers: (T) -> Void) -> Void {
        WhenEngine.symbols.forEach {
            let f = unsafeBitCast($0, to: EventFunc.self)
            if let when = f() as? T {
                observers(when)
            }
        }
    }
    
}
