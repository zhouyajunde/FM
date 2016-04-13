//
//  MyProcessView.h
//  betatown-ios-bhg
//
//  Created by Zhengjun wu on 12-8-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_PAGE_LOADING_VIEW 6000311

@interface MyPageLoadingView : UIView

- (id)initWithRect:(CGRect) theFrame;
- (void)stopLoadingAndDisappear;

@end
