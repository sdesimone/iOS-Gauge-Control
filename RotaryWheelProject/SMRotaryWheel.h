//
//  SMRotaryWheel.m
//  RotaryWheelProject
//
//  Created by cesarerocchi on 2/10/12.
//  Copyright (c) 2012 studiomagnolia.com. All rights reserved.

// Changes by Sergio De Simone, freescaepes labs
// converted to not using ARC

#import <UIKit/UIKit.h>
#import "SMRotaryProtocol.h"
#import "SMClove.h"

@interface SMRotaryWheel : UIView 

@property (assign) id <SMRotaryProtocol> delegate;
@property (nonatomic, retain) UIView *container;
@property (nonatomic, retain) NSMutableArray *cloves;
@property CGAffineTransform startTransform;
@property int currentValue;
@property int numberOfSections;
@property CGPoint wheelCenter;
@property (nonatomic, retain) NSMutableDictionary *cloveNames;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber;
- (void) initWheel;
- (void) buildClovesEven;
- (void) buildClovesOdd;
- (float) calculateDistanceFromCenter:(CGPoint)point;
- (UILabel *) getLabelByValue:(int)value;
- (NSString *) getCloveName:(int)position;


@end
