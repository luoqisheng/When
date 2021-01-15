//
//  WhenAppEventProtocol.h
//  When_Example
//
//  Created by PoPo on 2021/1/15.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <When/When-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OCStartUpProtocol <WhenTaskProtocol>

@optional
- (void)bootstrap;

@end

NS_ASSUME_NONNULL_END
