//
//  OCModule.m
//  When_Example
//
//  Created by PoPo on 2021/1/14.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "OCModule.h"
#import <When/WhenProtocol.h>
#import <When/When-Swift.h>
#import "OCStartUpProtocol.h"

@interface OCModule()<OCStartUpProtocol>

@end

@interface OCOtherModule: NSObject <OCStartUpProtocol>

@end

@When(OCModule)
@implementation OCModule

+ (nonnull instancetype)when {
    return [OCModule new];
}

+ (NSString *)identifier {
    return @"OCModule";
}

+ (NSArray<NSString *> *)dependencies {
    return @[];
}

- (void)bootstrap {
    printf("OCModule:bootstrap\n");
}

@end


@When(OCOtherModule)
@implementation OCOtherModule

+ (nonnull instancetype)when {
    return [OCOtherModule new];
}

+ (NSString *)identifier {
    return @"OCOtherModule";
}

+ (NSArray<NSString *> *)dependencies {
    return @[OCModule.identifier];
}

- (void)bootstrap {
    printf("OCOtherModule:bootstrap\n");
}

@end
