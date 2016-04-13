//
//  MyTimerLabel.h
//  betatown-ios-bhg
//
//  Created by Zhengjun wu on 13-1-31.
//
//

#import <UIKit/UIKit.h>

@interface MyTimerLabel : UIView
{
    UILabel * theLabel;
    NSTimer * theTimer;
    int theTerminalTime;
}
- (id) initWithFrame:(CGRect)frame;
- (void) setRemainingSeconds:(int) remainingSeconds;

@end
