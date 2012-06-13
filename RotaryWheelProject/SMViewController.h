//
//  SMRotaryWheel.m
//  RotaryWheelProject
//
//  Created by cesarerocchi on 2/10/12.
//  Copyright (c) 2012 studiomagnolia.com. All rights reserved.

#import <UIKit/UIKit.h>
#import "SMRotaryWheel.h"
#import "SMRotaryWheelProtocols.h"

@interface SMViewController : UIViewController <SMRotaryWheelDelegate>

@property (nonatomic, retain) SMRotaryWheel *wheel;

@end
