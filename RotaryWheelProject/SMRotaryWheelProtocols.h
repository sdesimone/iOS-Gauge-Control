//
//  SMRotaryWheel.m
//  RotaryWheelProject
//
//  Created by cesarerocchi on 2/10/12.
//  Copyright (c) 2012 studiomagnolia.com. All rights reserved.

#import <Foundation/Foundation.h>

@class SMRotaryWheel;


@protocol SMRotaryWheelDatasource <NSObject>
- (NSUInteger)numberOfCloves;
- (NSUInteger)currentClove;
- (UIImage*)wheelBackground;
- (UIImage*)bud;
- (UIImage*)cloveBackgroungAtIndex:(NSUInteger)index;
- (id)cloveForegroungAtIndex:(NSUInteger)index;
@end


@protocol SMRotaryWheelDelegate <NSObject>
- (void)wheel:(SMRotaryWheel*)wheel didChangeValue:(NSUInteger)newValue;
@end
