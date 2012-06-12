//
//  SMRotaryWheel.m
//  RotaryWheelProject
//
//  Created by cesarerocchi on 2/10/12.
//  Copyright (c) 2012 studiomagnolia.com. All rights reserved.

// Changes by Sergio De Simone, freescaepes labs
// converted to not using ARC
// moved private members to .m file

#import <UIKit/UIKit.h>
#import "SMRotaryWheelProtocols.h"
#import "SMClove.h"

@interface SMRotaryWheel : UIView 

@property (nonatomic, readonly) NSString* wheelId;
@property (nonatomic, assign) id <SMRotaryWheelDelegate> delegate;
@property (nonatomic, assign) id <SMRotaryWheelDatasource> datasource;

- (id)initWithFrame:(CGRect)frame delegate:(id<SMRotaryWheelDelegate>)del datasource:(id<SMRotaryWheelDatasource>)ds;


@end
