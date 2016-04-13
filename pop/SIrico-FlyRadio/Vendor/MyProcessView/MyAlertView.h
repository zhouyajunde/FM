//
//  MyLoadingView.h
//  Loading
//
//  Created by Hunk on 11-3-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyAlertView : UIView 

+ (MyAlertView*)sharedMyAlertView;

- (void)showWithName:(NSString*)name afterDelay:(float) seconds;

@end
