//
//  WhenProtocol.swift
//  Pods-When_Example
//
//  Created by luoqisheng on 2020/7/21.
//

import Foundation

public protocol When {
    
    // required
    static func When() -> When

}

public protocol WhenTask: When {
    
    // optional
    func dependencies() -> [AnyHashable]
    
    static func identifier() -> AnyHashable?
    
}

public extension WhenTask {
    
    func dependencies() -> [AnyHashable] {
        return []
    }
    
    static func identifier() -> AnyHashable? {
        return nil
    }
    
}

public class Milestone {
    
    let milestone: BlockOperation
    public let identifier: AnyHashable
    
    public init(identifier: AnyHashable, block: @escaping () -> Void) {
        self.milestone = BlockOperation(block:block)
        self.identifier = identifier
    }
    
    public func start() -> Void {
        self.milestone.start()
    }
    
}
