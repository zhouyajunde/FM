//
//  MyAlertView.m
//  Loading
//
//  Created by Hunk on 11-3-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyProcessView.h"
#import "SIAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define TAG_PROCESS_VIEW_BG_VIEW 60001
#define TAG_PROCESS_VIEW_LABEL 60002
#define TAG_PROCESS_VIEW_ACTIVITYINDICATORVIEW 60003
#define PROCESS_VIEW_MESSAGE_LOADING @"loading..."

static MyProcessView * _sharedMyProcessView = nil;

@implementation MyProcessView

+ (MyProcessView*)sharedMyProcessView
{
	@synchronized([MyProcessView class])
	{
		if(!_sharedMyProcessView)
		{
			_sharedMyProcessView = [[MyProcessView alloc] init];
		}
		return _sharedMyProcessView;
	}
	return nil;
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if(self){
        if ([animationID isEqualToString:@"fadeout"]) {
            // Restore the opacity
            CGFloat originalOpacity = [(NSNumber *)context floatValue];
            self.layer.opacity = originalOpacity;
            self.hidden = YES;
            [(NSNumber *)context release];
        }
    }
}
- (void)removeFromSuperviewAnimated {
    if(self){
        [UIView beginAnimations:@"fadeout" context:[[NSNumber numberWithFloat:self.layer.opacity] retain]];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDelegate:self];
        self.layer.opacity = 0;
        [UIView commitAnimations];
    }
}

#pragma mark TapDetectingImageViewDelegate methods  
- (void) handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {    
    //CGPoint p = [gestureRecognizer locationInView:self]; 
    [self removeFromSuperviewAnimated];
}

- (id)init
{
	if((self = [super init]))
	{
		self.frame = [[UIScreen mainScreen] bounds];
		self.layer.opacity = 1;    
        self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2f];
        // Add Bg
		UIView* alertBGView = [[UIView alloc] init];
		alertBGView.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:12.0/255.0 blue:12.0/255.0 alpha:0.8f];
        
        alertBGView.layer.cornerRadius = 4.0;
		alertBGView.layer.masksToBounds = YES;
        //alertBGView.layer.borderWidth = 1.0;
        alertBGView.tag = TAG_PROCESS_VIEW_BG_VIEW;
        alertBGView.layer.borderColor = [UIColor whiteColor].CGColor;
        alertBGView.layer.shadowColor = [UIColor blackColor].CGColor;
		alertBGView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
		[self addSubview:alertBGView];
		[alertBGView release];
        
		// Add name label
		UILabel* m_pNameLabel = [[UILabel alloc] init];
		m_pNameLabel.backgroundColor = [UIColor clearColor];
		m_pNameLabel.textColor = [UIColor whiteColor];
		m_pNameLabel.font = [UIFont boldSystemFontOfSize:14];
		m_pNameLabel.textAlignment = NSTextAlignmentLeft;
        m_pNameLabel.lineBreakMode = UILineBreakModeWordWrap;
		m_pNameLabel.text = PROCESS_VIEW_MESSAGE_LOADING;
        m_pNameLabel.numberOfLines = 0;
		m_pNameLabel.tag = TAG_PROCESS_VIEW_LABEL;

		[alertBGView addSubview:m_pNameLabel];
		[m_pNameLabel release];
        
        UITapGestureRecognizer *closeGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];        
        [self addGestureRecognizer:closeGestureRecognizer];
        [closeGestureRecognizer release];
        
        // Create ActivityIndicator
		UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.frame.size.width - 30.0)/2, (self.frame.size.height - 30.0)/2 - 15, 30.0, 30.0)];
		activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		activityIndicatorView.tag = TAG_PROCESS_VIEW_ACTIVITYINDICATORVIEW;

        [activityIndicatorView startAnimating];
        [alertBGView addSubview:activityIndicatorView];
		[activityIndicatorView release];
		
		// Add to main window
		SIAppDelegate* appDelegate = (SIAppDelegate*)[[UIApplication sharedApplication] delegate];
		[appDelegate.window addSubview:self];
	}
	return self;
}

- (void)startLoadingWithOffset:(CGSize) offsetSize WithName:(NSString*) name
{	
	if(!self) return;
    
    for(UIGestureRecognizer * gestureRecognizer in [self gestureRecognizers]){
        if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
            [gestureRecognizer setEnabled:NO];
        }
    }
    if(!name || name.length <1){
    	name = @"数据更新中...";
    }
    
	[[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];    
	self.hidden = NO;
    
    float height = 35.0f;
    float activityIndicatorView_size = 35.0f;
    float y = (self.frame.size.height - height)/2 + offsetSize.height;
    float width = activityIndicatorView_size + name.length * 12;
    float x = (self.frame.size.width - width)/2 + offsetSize.width;
    
    CGRect frame = CGRectMake(x, y, width, height);
    UIView* bgView = (UIView*)[self viewWithTag:TAG_PROCESS_VIEW_BG_VIEW];
    bgView.frame = frame;
    
    UILabel* nameLabel = (UILabel*)[self viewWithTag:TAG_PROCESS_VIEW_LABEL];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = name;
    
    // set label frame
    CGRect nameLabelFrame = CGRectMake(activityIndicatorView_size, 0, frame.size.width - activityIndicatorView_size, frame.size.height);
    nameLabel.frame = nameLabelFrame;
    
    UIActivityIndicatorView* activityIndicatorView = (UIActivityIndicatorView*)[self viewWithTag:TAG_PROCESS_VIEW_ACTIVITYINDICATORVIEW];
	
    activityIndicatorView.frame = CGRectMake(0 ,0,activityIndicatorView_size,activityIndicatorView_size);
    [activityIndicatorView startAnimating];
}

- (void)stopLoadingAndDisappear{
    if(!self) return;
    self.hidden = YES;
}

- (void)stopLoadingWithNameWithCenter:(NSString*)name afterDelay:(float) seconds{
    if(!self) return;
    
    UIActivityIndicatorView* activityIndicatorView = (UIActivityIndicatorView*)[self viewWithTag:TAG_PROCESS_VIEW_ACTIVITYINDICATORVIEW];
	[activityIndicatorView stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    for(UIGestureRecognizer * gestureRecognizer in [self gestureRecognizers]){
        if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
            [gestureRecognizer setEnabled:YES];
        }
    }
    
    UIView* bgView = (UIView*)[self viewWithTag:TAG_PROCESS_VIEW_BG_VIEW];
    
    // set name
    UILabel* nameLabel = (UILabel*)[self viewWithTag:TAG_PROCESS_VIEW_LABEL];
    nameLabel.text = name;
    
    float nameWidth = 0;
    float nameHeight  = 0;
    
    float bgViewOriX = 0;
    float bgViewOriY = bgView.frame.origin.y;
    
    CGSize stringSize = [name sizeWithFont:[UIFont boldSystemFontOfSize:14]];
    int row = stringSize.width / 220 + 1;
    if(row == 1){
        nameWidth = stringSize.width + 20;
        nameHeight = stringSize.height + 20;
        nameLabel.textAlignment = NSTextAlignmentCenter;
    }else {
        nameWidth = 230 + 20 ;
        nameHeight = (stringSize.height +5) * row + 20;
        nameLabel.textAlignment = NSTextAlignmentCenter;
       	bgViewOriY =  bgViewOriY- nameHeight/2;
    }
    bgViewOriX = (self.frame.size.width - nameWidth)/2;
    
    bgView.frame = CGRectMake(bgViewOriX, bgViewOriY, nameWidth, nameHeight);
    nameLabel.frame = CGRectMake(10, 10, nameWidth-20, nameHeight-20);
    
    if(seconds>0.2){
        [self performSelector:@selector(removeFromSuperviewAnimated) withObject:nil afterDelay:seconds];
    }
}

- (void)stopLoadingWithName:(NSString*)name afterDelay:(float) seconds
{
	if(!self) return;
    
    UIActivityIndicatorView* activityIndicatorView = (UIActivityIndicatorView*)[self viewWithTag:TAG_PROCESS_VIEW_ACTIVITYINDICATORVIEW];
	[activityIndicatorView stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    for(UIGestureRecognizer * gestureRecognizer in [self gestureRecognizers]){
        if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
            [gestureRecognizer setEnabled:YES];
        }
    }
    
    UIView* bgView = (UIView*)[self viewWithTag:TAG_PROCESS_VIEW_BG_VIEW];
    
    // set name
    UILabel* nameLabel = (UILabel*)[self viewWithTag:TAG_PROCESS_VIEW_LABEL];
    nameLabel.text = name;
    
    float nameWidth = 0;
    float nameHeight  = 0;
    
    float bgViewOriX = 0;
    float bgViewOriY = bgView.frame.origin.y;
    
    CGSize stringSize = [name sizeWithFont:[UIFont boldSystemFontOfSize:14]];
    int row = stringSize.width / 220 + 1;
    if(row == 1){
        nameWidth = stringSize.width + 20;
        nameHeight = stringSize.height + 20;
        nameLabel.textAlignment = NSTextAlignmentCenter;
    }else {
        nameWidth = 230 + 20 ;
        nameHeight = (stringSize.height +5) * row + 20;
        nameLabel.textAlignment = NSTextAlignmentLeft;
       	bgViewOriY =  bgViewOriY- nameHeight/2;
    }
    bgViewOriX = (self.frame.size.width - nameWidth)/2;
    
    bgView.frame = CGRectMake(bgViewOriX, bgViewOriY, nameWidth, nameHeight);
    nameLabel.frame = CGRectMake(10, 10, nameWidth-20, nameHeight-20);
    
    if(seconds>0.2){
        [self performSelector:@selector(removeFromSuperviewAnimated) withObject:nil afterDelay:seconds];
    }
}

- (void)dealloc{	
	[super dealloc];
}

@end
