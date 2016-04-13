//
//  CZFooterView.m
//  A01-团购
//
//  Created by Apple on 14/12/19.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "CZFooterView.h"

@interface CZFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *loadMoreBtn;

- (IBAction)loadMoreClick;

@end
@implementation CZFooterView

+ (instancetype)footerView
{
    CZFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:@"CZFooterView" owner:nil options:nil] lastObject];
    
    //设置按钮的圆角
    footerView.loadMoreBtn.layer.cornerRadius = 5;
    footerView.loadMoreBtn.layer.masksToBounds = YES;
    
    return footerView;
}


- (IBAction)loadMoreClick {
   
    if ([self.delegate respondsToSelector:@selector(tuichu)]) {
         [self.delegate tuichu];
    }
}
@end
