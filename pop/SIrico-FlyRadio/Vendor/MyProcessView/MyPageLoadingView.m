//
//  MyAlertView.m
//  Loading
//
//  Created by Hunk on 11-3-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyPageLoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyPageLoadingView

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if(self){
        if ([animationID isEqualToString:@"fadeout"]) {
            // Restore the opacity
            CGFloat originalOpacity = [(NSNumber *)context floatValue];
            self.layer.opacity = originalOpacity;
            [self removeFromSuperview];
            [(NSNumber *)context release];
        }
    }
}

- (void)removeFromSuperviewAnimated {
    if(self){
        [UIView beginAnimations:@"fadeout" context:[[NSNumber numberWithFloat:self.layer.opacity] retain]];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDelegate:self];
        self.layer.opacity = 0;
        [UIView commitAnimations];
    }
}

- (id)initWithRect:(CGRect) theFrame
{
	if((self = [super init]))
	{
		self.frame = theFrame;
		self.layer.opacity = 1;
        self.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:12.0/255.0 blue:12.0/255.0 alpha:0.8f];
        self.tag = TAG_PAGE_LOADING_VIEW;
        
        // Create ActivityIndicator
		UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.frame.size.width - 30.0)/2, (self.frame.size.height - 30.0)/2 - 15, 30.0, 30.0)];
		activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
        activityIndicatorView.center = CGPointMake(theFrame.size.width/2, (theFrame.size.height)/2);
        [activityIndicatorView startAnimating];
        [self addSubview:activityIndicatorView];
		[activityIndicatorView release];
	}
	return self;
}

- (void)stopLoadingAndDisappear{
    if(!self) return;
    
    for(UIGestureRecognizer * gestureRecognizer in [self gestureRecognizers]){
        if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
            [gestureRecognizer setEnabled:YES];
        }
    }
    [self removeFromSuperviewAnimated];
}

- (void)dealloc{
    //DLog(@"MyLoadingView release");
	[super dealloc];
}

@end
