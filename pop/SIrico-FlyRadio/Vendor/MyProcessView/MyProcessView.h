//
//  MyProcessView.h
//  betatown-ios-bhg
//
//  Created by Zhengjun wu on 12-8-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProcessView : UIView


+ (MyProcessView*)sharedMyProcessView;

- (void)startLoadingWithOffset:(CGSize) offsetSize WithName:(NSString*) name;
- (void)stopLoadingWithName:(NSString*)name afterDelay:(float) seconds;
- (void)stopLoadingWithNameWithCenter:(NSString*)name afterDelay:(float) seconds;
- (void)stopLoadingAndDisappear;

@end
