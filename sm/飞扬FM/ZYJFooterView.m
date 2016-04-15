//
//  ZYJFooterView.m
//  飞扬FM
//
//  Created by Mac os on 16/3/2.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJFooterView.h"

@interface ZYJFooterView()
@property (weak, nonatomic) IBOutlet UIButton *loadMoreBtn;
- (IBAction)wanBtn:(id)sender;

@end

@implementation ZYJFooterView

+ (instancetype)footerView
{
    ZYJFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:@"ZYJFooterView" owner:nil options:nil] lastObject];
    
    //设置按钮的圆角
    footerView.loadMoreBtn.layer.cornerRadius = 5;
    footerView.loadMoreBtn.layer.masksToBounds = YES;
    
    return footerView;
}

- (IBAction)wanBtn:(id)sender {
    
    [_delegate tuichude];
}
@end
