//
//  MyScrollView.m
//  betatown-ios-bhg
//
//  Created by Zhengjun wu on 13-1-28.
//
//

#import "MyScrollView.h"

@implementation MyScrollView
@synthesize pageControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageScrollView = [[UIScrollView alloc]init];
        imageScrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        imageScrollView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.3f];
        imageScrollView.backgroundColor = [UIColor clearColor];
        imageScrollView.pagingEnabled = YES;
        imageScrollView.userInteractionEnabled = YES;
        imageScrollView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        imageScrollView.showsVerticalScrollIndicator = NO;
        imageScrollView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        imageScrollView.bounces = NO;        
        imageScrollView.delegate = self;
        [self addSubview:imageScrollView];
        [imageScrollView release];
        
    }
    return self;
}


- (void)reloadData:(NSArray *) imageUrlArray WithFrame:(CGRect)frame
{
    pageControl = [[UIPageControl alloc] init];
    pageControl.userInteractionEnabled = NO;
    pageControl.frame = CGRectMake(0, frame.size.height-20, frame.size.width, 20);
    pageControl.numberOfPages = [imageUrlArray count];
    pageControl.currentPage = 0;
//    pageControl.backgroundColor = [UIColor colorWithRed:26.0/255 green:26.0/255 blue:26.0/255 alpha:1.0];
    pageControl.backgroundColor = [UIColor clearColor];
    if ([imageUrlArray count]==1) {
        pageControl.hidden = YES;
    }
    [self addSubview:pageControl];
    [pageControl release];
    
    //设置内容大小
    imageScrollView.contentSize = CGSizeMake(frame.size.width * imageUrlArray.count, imageScrollView.frame.size.height);
    for(int i=0;i<imageUrlArray.count;i++){
        EGOImageView * tempImageView = [[EGOImageView alloc]init];
        tempImageView.imageURL = [imageUrlArray objectAtIndex:i];
        tempImageView.userInteractionEnabled = YES;
        tempImageView.frame = CGRectMake(imageScrollView.frame.size.width * i, 0, imageScrollView.frame.size.width, imageScrollView.frame.size.height);
        [imageScrollView addSubview:tempImageView];
        [tempImageView release];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

@end
