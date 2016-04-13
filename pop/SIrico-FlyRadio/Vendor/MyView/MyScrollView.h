//
//  MyScrollView.h
//  betatown-ios-bhg
//
//  Created by Zhengjun wu on 13-1-28.
//
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>


@protocol MyViewScrollViewDelegate;

@interface MyScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView * imageScrollView;
    EGOImageView * imageView;
    UIPageControl * pageControl;
}

@property (nonatomic,retain) UIPageControl * pageControl;

- (id)initWithFrame:(CGRect)frame;
- (void)reloadData:(NSArray *) imageUrlArray WithFrame:(CGRect)frame;
@end
