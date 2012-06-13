//
//  SMRotaryWheel.m
//  RotaryWheelProject
//
//  Created by cesarerocchi on 2/10/12.
//  Copyright (c) 2012 studiomagnolia.com. All rights reserved.

#import <Foundation/Foundation.h>

@protocol SMRotaryWheelDatasource <NSObject>
- (NSUInteger)numberOfCloves;
- (NSUInteger)currentClove;
- (UIImage*)wheelBackground;
- (UIImage*)bud;
- (UIImage*)cloveBackgroungAtIndex:(NSUInteger)index;
- (UIImage*)cloveForegroungAtIndex:(NSUInteger)index;
@end


@protocol SMRotaryProtocol <NSObject>

- (void) didChangeValue:(NSString *)newValue;

@end
