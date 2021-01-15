//
//  WhenProtocol.h
//  When
//
//  Created by PoPo on 2021/1/14.
//

#import <Foundation/Foundation.h>
#import <objc/objc.h>
NS_ASSUME_NONNULL_BEGIN

#define metamacro_head(...) \
metamacro_head_(__VA_ARGS__, 0)

#define metamacro_head_(FIRST, ...) FIRST

/**
 * Returns A and B concatenated after full macro expansion.
 */
#define metamacro_concat(A, B) \
metamacro_concat_(A, B)

/**
 * Returns the number of arguments (up to twenty) provided to the macro. At
 * least one argument must be provided.
 *
 * Inspired by P99: http://p99.gforge.inria.fr
 */
#define metamacro_argcount(...) \
metamacro_at(20, __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)

/**
 * Returns the Nth variadic argument (starting from zero). At least
 * N + 1 variadic arguments must be given. N must be between zero and twenty,
 * inclusive.
 */
#define metamacro_at(N, ...) \
metamacro_concat(metamacro_at, N)(__VA_ARGS__)

// metamacro_at expansions
#define metamacro_at0(...) metamacro_head(__VA_ARGS__)
#define metamacro_at1(_0, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at2(_0, _1, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at3(_0, _1, _2, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at4(_0, _1, _2, _3, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at5(_0, _1, _2, _3, _4, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at6(_0, _1, _2, _3, _4, _5, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at7(_0, _1, _2, _3, _4, _5, _6, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at8(_0, _1, _2, _3, _4, _5, _6, _7, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at9(_0, _1, _2, _3, _4, _5, _6, _7, _8, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at10(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at11(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at12(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at13(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at14(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at15(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at16(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at17(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at18(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at19(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, ...) metamacro_head(__VA_ARGS__)
#define metamacro_at20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) metamacro_head(__VA_ARGS__)

#define metamacro_concat_(A, B) A ## B
#define metamacro_concat_args1(...) metamacro_at(0,__VA_ARGS__)
#define metamacro_concat_args2(...) metamacro_concat(metamacro_at(0,__VA_ARGS__),metamacro_at(1,__VA_ARGS__))
#define metamacro_concat_args3(...) metamacro_concat(metamacro_concat_args2(__VA_ARGS__),metamacro_at(2,__VA_ARGS__))


#define NameGen(cls) NameGen_(cls, __LINE__, __COUNTER__)
#define NameGen_(...)  metamacro_concat( metamacro_concat_args , metamacro_argcount(__VA_ARGS__))(__VA_ARGS__)

#ifndef WhenDATA
#define WhenDATA(sectName) __attribute((used, section("__DATA,"#sectName" "), no_sanitize_address))
#endif

#define When(clz)                                                                                           \
class clz;                                                                                                  \
static id<WhenProtocol> NameGen_(generate_ ## clz, __LINE__)() { return [clz when]; }                       \
void *const NameGen(clz) WhenDATA(when) = &NameGen_(generate_ ## clz, __LINE__);

@protocol WhenProtocol <NSObject>

+ (instancetype)when;

@end

@protocol WhenTaskProtocol <WhenProtocol>

+ (NSString *)identifier;

+ (NSArray<NSString *> *)dependencies;

@end

NS_ASSUME_NONNULL_END
