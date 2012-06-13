//
//  SMRotaryWheel.m
//  RotaryWheelProject
//
//  Created by cesarerocchi on 2/10/12.
//  Copyright (c) 2012 studiomagnolia.com. All rights reserved.

#import "SMRotaryWheel.h"
#import <QuartzCore/QuartzCore.h>
#import "CALayer+SMRotaryWheel.h"
#import "CALayer+SDSLayerByName.m"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
@interface SMRotaryWheel ()

@property CGPoint wheelCenter;
@property int numberOfSections;
@property CGAffineTransform startTransform;
@property (nonatomic, retain) CALayer* container;
@property (nonatomic,retain) NSString* currentValue;
@property (nonatomic, retain) NSMutableArray* cloves;
@property (nonatomic, retain) NSMutableDictionary* cloveNames;

- (void)buildClovesOdd;
- (void)buildClovesEven;
- (CALayer*)getLabelByValue:(NSString*)value;
- (float)calculateDistanceFromCenter:(CGPoint)point;

@end



//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
static float deltaAngle;
static float minAlphavalue = 0.6;
static float maxAlphavalue = 1.0;


@implementation SMRotaryWheel

@synthesize datasource;
@synthesize startTransform, container, cloves, currentValue, delegate, wheelCenter, cloveNames, numberOfSections;

              
- (void) initWheel {
    
    [self.delegate didChangeValue:[self.datasource currentClove]];
    
}

//////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithFrame:(CGRect)frame
            delegate:(id<SMRotaryWheelDelegate>)del
          datasource:(id<SMRotaryWheelDatasource>)ds {
    
    if ((self = [super initWithFrame:frame])) {
		
        self.delegate = del;
        self.datasource = ds;
        self.numberOfSections = [self.datasource numberOfCloves];
		[self initWheel];
	}
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)layerNameForClove:(NSUInteger)i {
    return [NSString stringWithFormat:@"%@%d", kCloveLayerName, (i +  [self.datasource currentClove]) % self.numberOfSections];
}


//////////////////////////////////////////////////////////////////////////////////////////
//-- everything is set in terms of layers
//-- reload/update of datasource is supported
//-- initial arbitrary rotation of the wheel is also available
//////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    
    self.container = [CALayer layer];
    self.container.frame = self.bounds;
    
    self.numberOfSections = [self.datasource numberOfCloves];
    self.cloves = [NSMutableArray arrayWithCapacity:self.numberOfSections];
    
    if (numberOfSections % 2 == 0)
        [self buildClovesEven];
    else
        [self buildClovesOdd];
    
    CGFloat angleSize = 2*M_PI/numberOfSections;
    self.currentValue = [NSString stringWithFormat:@"%d", [self.datasource currentClove]];
    for (int i = 0; i < numberOfSections; i++) {
        
        CALayer* cloveBkg = [CALayer layerWithImage:[self.datasource cloveBackgroungAtIndex:i]];
        cloveBkg.anchorPoint = CGPointMake(1.0f, 0.5f);
        cloveBkg.position = CGPointMake(container.bounds.size.width/2.0, container.bounds.size.height/2.0); 
        cloveBkg.opacity = (i == 0)?maxAlphavalue:minAlphavalue;
        cloveBkg.name = [self layerNameForClove:i];
        [container addSublayer:cloveBkg];
        
        CALayer* cloveImage = [CALayer layerWithImage:[self.datasource cloveForegroungAtIndex:[cloveBkg.name intValue]]];
        cloveImage.position = CGPointMake(cloveBkg.frame.size.width/2, cloveBkg.frame.size.height/2);
        cloveImage.anchorPoint = CGPointMake(0.8, 0.5);
        
        NSLog(@"cloveImg Frame: %f, %f, %f, %f", cloveImage.frame.origin.x, cloveImage.frame.origin.y,
              cloveImage.frame.size.width, cloveImage.frame.size.height);
        NSLog(@"cloveBkg FRAME: %f, %f, %f, %f", cloveBkg.frame.origin.x, cloveBkg.frame.origin.y,
              cloveBkg.frame.size.width, cloveBkg.frame.size.height);
        
        
        cloveImage.affineTransform = CGAffineTransformMakeScale(0.8, 0.8);
        cloveBkg.affineTransform = CGAffineTransformMakeScale(container.bounds.size.width/640.0, container.bounds.size.height/640.0);
        cloveBkg.affineTransform = CGAffineTransformRotate(cloveBkg.affineTransform, angleSize*i);
        [cloveBkg addSublayer:cloveImage];
    }
    
    CALayer* bg = [CALayer layerWithImage:[self.datasource wheelBackground]];
    bg.frame = self.frame;
    bg.name = kBackgroundLayerName;
    bg.position = [self convertPoint:self.center fromView:self.superview];
    
    CALayer* budLayer = [CALayer layerWithImage:[self.datasource bud]];
    budLayer.position = [self convertPoint:self.center fromView:self.superview];
    budLayer.affineTransform = CGAffineTransformMakeScale(container.bounds.size.width/640.0, container.bounds.size.height/640.0);
    budLayer.name = kBudLayerName;
    
    [self.layer addSublayer:container];
    [self.layer addSublayer:bg];
    [self.layer addSublayer:budLayer];
    
    //    [super layoutSubviews];
}

//////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    
    self.container = nil;
    self.cloves = nil;
    self.cloveNames = nil;
    self.currentValue = nil;
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////////////////////
- (void)reload {    
    CATransition* transition = [CATransition animation];
    transition.delegate = nil;
    transition.duration = 0.75;
    transition.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionFade;
    [self.layer addAnimation:transition forKey:@"kCATransition"];
    while ([self.layer.sublayers count] > 0) {
        [[self.layer.sublayers objectAtIndex:0] removeFromSuperlayer];
    }
    [self layoutSubviews];
}


//////////////////////////////////////////////////////////////////////////////////////////
- (CALayer*)getLabelByValue:(NSString*)value {
    
    CALayer* res = nil;
    for (CALayer* l in [container sublayers]) {
        if ([l.name isEqual:value])
            res = l;
    }
    return res;
}


- (void) buildClovesEven {
    
    CGFloat fanWidth = M_PI*2/numberOfSections;
    CGFloat mid = 0;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        SMClove *clove = [[SMClove alloc] init];
        clove.midValue = mid;
        clove.minValue = mid - (fanWidth/2);
        clove.maxValue = mid + (fanWidth/2);
        clove.value = i;
        
        
        if (clove.maxValue-fanWidth < - M_PI) {
            
            mid = 3.14;
            clove.midValue = mid;
            clove.minValue = fabsf(clove.maxValue);
            
        }
        
        mid -= fanWidth;
        
        
        NSLog(@"cl is %@", clove);
        
        [cloves addObject:clove];
        
    }

}




- (float) calculateDistanceFromCenter:(CGPoint)point {

    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return sqrt(dx*dx + dy*dy);
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    CGPoint delta = [touch locationInView:self];
    float dist = [self calculateDistanceFromCenter:delta];
    
    if (dist < 40 || dist > 100) 
    {
        // forcing a tap to be on the ferrule
        NSLog(@"ignoring tap (%f,%f)", delta.x, delta.y);
        return;
    }
    
    startTransform = container.transform;
    
    UILabel *lab = [self getLabelByValue:currentValue];
    lab.alpha = minAlphavalue;
    
	float dx = delta.x  - container.center.x;
	float dy = delta.y  - container.center.y;
	deltaAngle = atan2(dy,dx); 
    
}




- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint pt = [touch locationInView:self];
	
	float dx = pt.x  - container.center.x;
	float dy = pt.y  - container.center.y;
	float ang = atan2(dy,dx);
    
    float angleDif = deltaAngle - ang;
    
    CGAffineTransform newTrans = CGAffineTransformRotate(startTransform, -angleDif);
    container.transform = newTrans;
    
    //[self sendActionsForControlEvents:UIControlEventValueChanged];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    NSLog(@"rad is %f", radians);
    
    CGFloat newVal = 0.0;
    
    for (SMClove *c in cloves) {
        
        if (c.minValue > 0 && c.maxValue < 0) {
            
            if (c.maxValue > radians || c.minValue < radians) {
                
                if (radians > 0) {
                    
                    newVal = radians - M_PI;
                    
                } else {
                    
                    newVal = M_PI + radians;                    
                    
                }
                currentValue = c.value;
                
            }
            
        }
        
        if (radians > c.minValue && radians < c.maxValue) {
            
            newVal = radians - c.midValue;
            currentValue = c.value;
            
        }
        
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    
    CGAffineTransform t = CGAffineTransformRotate(container.transform, -newVal);
    container.transform = t;
    
    [UIView commitAnimations];
    
    UILabel *lab = [self getLabelByValue:currentValue];
    lab.alpha = maxAlphavalue;
    
    [self.delegate didChangeValue:[self.currentValue intValue]];
    
}

- (void) buildClovesOdd {
    
    CGFloat fanWidth = M_PI*2/numberOfSections;
    CGFloat mid = 0;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        SMClove *clove = [[SMClove alloc] init];
        clove.midValue = mid;
        clove.minValue = mid - (fanWidth/2);
        clove.maxValue = mid + (fanWidth/2);
        clove.value = i;
        
        mid -= fanWidth;
        
        if (clove.minValue < - M_PI) { // odd sections
            
            mid = -mid;
            mid -= fanWidth; 
            
        }
        
        
        NSLog(@"cl is %@", clove);
        
        [cloves addObject:clove];
        
    }
    
    
}

@end
