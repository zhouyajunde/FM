//
//  MyTimerLabel.m
//  betatown-ios-bhg
//
//  Created by Zhengjun wu on 13-1-31.
//
//

#import "MyTimerLabel.h"
#import "NSDate+Helper.h"

@implementation MyTimerLabel

- (void) clearTimer{
    if(theTimer){        
    	[theTimer invalidate];
    	theTimer = nil;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        theLabel = [[UILabel alloc] init];
        theLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        theLabel.backgroundColor = [UIColor clearColor];
        theLabel.textColor = [UIColor redColor];
        theLabel.font = [UIFont boldSystemFontOfSize:13];
        theLabel.text = @"0小时0分0秒";
        [self addSubview:theLabel];
        [theLabel release];
        // Initialization code
    }
    return self;
}

- (void) autoChangeLabelTextByTimer {
    NSDate *now = [[NSDate alloc]init];
    NSTimeInterval currentTime = [now timeIntervalSince1970];
    int interval = theTerminalTime - currentTime;
    
	int hour = interval /3600;
	int min = (interval - hour * 3600) / 60 ;
	int sec = (interval - hour * 3600 - 60 * min) /1 ;
	theLabel.text = [NSString stringWithFormat:@"%02d小时%02d分%02d秒", hour, min,sec];
    [now release];
}

- (void) setRemainingSeconds:(int) remainingSeconds{
    if(remainingSeconds>1){
        NSDate *now = [[NSDate alloc]init];
        NSTimeInterval interval = [now timeIntervalSince1970];
        
        [self clearTimer];
        theTerminalTime = remainingSeconds + interval;
        theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(autoChangeLabelTextByTimer) userInfo:nil repeats:YES];
        [now release];
    }
}

- (void) dealloc{
    [self clearTimer];
    [super dealloc];
}

@end
