//
//  BFSegmentItem.m
//  BFCustomSegmenControl
//
//  Created by ZYVincent on 12-2-19.
//  Copyright (c) 2012年 __ZYProSoft__. All rights reserved.
//  http://www.zyprosoft.com
//  个人QQ:1003081775
//  团队QQ群号：219357847
//  团队主题：奋斗路上携手相伴！
//  给我评论 : http://www.cocoachina.com/bbs/read.php?tid=124045

#import "BFSegmentItem.h"

#define sepImageWidth 0

@implementation BFSegmentItem
@synthesize titleLabel,sepratorLine;
@synthesize index;
@synthesize delegate;
@synthesize backgroundImgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

- (void)dealloc
{
    self.titleLabel = nil;
    self.sepratorLine = nil;
    self.backgroundImgView = nil;
    [super dealloc];
}

- (void)tapOnSelf:(UITapGestureRecognizer*)tapR
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapOnItem:)]) {
        [self.delegate didTapOnItem:self];
    }
}

- (void)switchToNormal
{
//    self.titleLabel.textColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
    self.titleLabel.textColor = [PreHelper colorWithHexString:@"ffffff"];
}
- (void)switchToSelected
{
    self.titleLabel.textColor = [PreHelper colorWithHexString:@"3CB371"];
}

- (id)initWithFrame:(CGRect)frame withSepratorLine:(UIImage *)sepImage withTitle:(NSString *)title isLastRightItem:(BOOL)state withBackgroundImage:(UIImage *)backImage
{
    if (self = [super initWithFrame:frame]) {
        UIView *touyingView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height+2, self.frame.size.width, 2)];
        touyingView.backgroundColor = [UIColor clearColor];
        [self addSubview:touyingView];
        touyingView.alpha = 0.2;
        
        
        //set backgroundImageView
        self.backgroundImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
        self.backgroundImgView.image = backImage;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:backgroundImgView];
        [backgroundImgView release];
        
        //set title
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,2,frame.size.width-sepImageWidth,frame.size.height)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:self.titleLabel];
        [self.titleLabel release];
        //add tap gesture
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf:)];
        [self addGestureRecognizer:tapR];
        [tapR release];
        
        
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
