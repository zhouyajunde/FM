//
//  MyAlertView.m
//  Loading
//
//  Created by Hunk on 11-3-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyAlertView.h"
#import "SIAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define TAG_ALERT_VIEW_BG_VIEW 50001
#define TAG_ALERT_VIEW_LABEL 50002
static MyAlertView* _sharedMyAlertView = nil;

@implementation MyAlertView

+ (MyAlertView*)sharedMyAlertView{
	@synchronized([MyAlertView class]){
		if(!_sharedMyAlertView){
			_sharedMyAlertView = [[MyAlertView alloc] init];
		}
		return _sharedMyAlertView;
	}
	return nil;
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context { 
    if(self){
        if ([animationID isEqualToString:@"fadeout"]) {       
            // Restore the opacity       
//            CGFloat originalOpacity = [(__bridge  NSNumber *)context floatValue];
            CGFloat originalOpacity = 1.0;
            self.layer.opacity = originalOpacity;
            self.hidden = YES;        
//            [(NSNumber *)context release];
        }
    }

} 
- (void)removeFromSuperviewAnimated {    
    if(self){
        [UIView beginAnimations:@"fadeout" context:(__bridge void *)([NSNumber numberWithFloat:self.layer.opacity])];
        [UIView setAnimationDuration:1.0];    
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];    
        [UIView setAnimationDelegate:self];    
        self.layer.opacity = 0;    
        [UIView commitAnimations];
    }
}

#pragma mark TapDetectingImageViewDelegate methods  
- (void) handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {  
    if(self){
        [self removeFromSuperviewAnimated];
    }
}

- (id)init
{
	if((self = [super init])){
        //NSLog(@" alert view height is %f",[[UIScreen mainScreen] bounds].size.height);
        
		self.frame = [[UIScreen mainScreen] bounds];
		self.layer.opacity = 1;  
		self.backgroundColor = [UIColor clearColor];        
        // Add Bg
		UIView* alertBGView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 260.0)/2, (self.frame.size.height - 150.0)/2, 260.0, 150.0)];
		alertBGView.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:12.0/255.0 blue:12.0/255.0 alpha:0.8f];
		
        alertBGView.layer.cornerRadius = 4.0;
		alertBGView.layer.masksToBounds = YES;
        //alertBGView.layer.borderWidth = 1.0;
        alertBGView.layer.borderColor = [UIColor whiteColor].CGColor;
        alertBGView.layer.shadowColor = [UIColor blackColor].CGColor;
		alertBGView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        alertBGView.tag = TAG_ALERT_VIEW_BG_VIEW;
		[self addSubview:alertBGView];
//		[alertBGView release];
        
		// Add name label
		UILabel* m_pNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 260.0)/2, (self.frame.size.height - 150.0)/2 + 25, 240, 130.0)];
		m_pNameLabel.backgroundColor = [UIColor clearColor];
		m_pNameLabel.textColor = [UIColor whiteColor];
		m_pNameLabel.font = [UIFont boldSystemFontOfSize:14];
		m_pNameLabel.textAlignment = NSTextAlignmentCenter;
        m_pNameLabel.lineBreakMode = UILineBreakModeWordWrap;
		m_pNameLabel.text = @"";
        m_pNameLabel.numberOfLines = 0;
		m_pNameLabel.tag = TAG_ALERT_VIEW_LABEL;
		[self addSubview:m_pNameLabel];
//		[m_pNameLabel release];
        
        UITapGestureRecognizer *closeGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];        
        [self addGestureRecognizer:closeGestureRecognizer];
//        [closeGestureRecognizer release];
		
		// Add to main window
		SIAppDelegate* appDelegate = (SIAppDelegate*)[[UIApplication sharedApplication] delegate];
		[appDelegate.window addSubview:self];
	}
	return self;
}

- (void)showWithName:(NSString*)name afterDelay:(float) seconds{
	if(self){
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];    
        self.hidden = NO;

        float width =  200;
        float height = 50;
        float x = (self.frame.size.width - width)/2;
        float y = (self.frame.size.height - height)/2;
        
        CGRect newFrame = CGRectMake(x, y, width, height);
        // set backview frame
        UIView* bgView = (UIView*)[self viewWithTag:TAG_ALERT_VIEW_BG_VIEW];
        bgView.frame = newFrame;
        
        // set name
        UILabel* nameLabel = (UILabel*)[self viewWithTag:TAG_ALERT_VIEW_LABEL];
        nameLabel.text = name;
        
        // set label frame
        CGRect nameLabelFrame = CGRectMake(newFrame.origin.x +2, newFrame.origin.y+2, newFrame.size.width -4, newFrame.size.height-4);
        nameLabel.frame = nameLabelFrame;
    }
    if(seconds>0.2){
        [self performSelector:@selector(removeFromSuperviewAnimated) withObject:nil afterDelay:seconds]; 
    }
}

//- (void)dealloc{	
//	[super dealloc];
//}

@end
