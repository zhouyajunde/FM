//
//  NJAboutHeaderView.m
//  01-ItcastLottery
//
//  Created by 李南江 on 14-5-10.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NJAboutHeaderView.h"
#import "UserDefine.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+header.h"
#import "UIImage+Image.h"
#import <QuartzCore/QuartzCore.h>



@interface NJAboutHeaderView ()
{
    
}


@end

@implementation NJAboutHeaderView

+ (instancetype)headerView
{ 
    return [[NSBundle mainBundle] loadNibNamed:@"NJAboutHeaderView" owner:nil options:nil][0];
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
      
    }
    return self;
}

-(void)setImg:(NSString *)img
{
    
    _img = img;
    
    UIImage *placeholder = [UIImage imageNamed:@"user_info.png"];
    
    NSString *filrfileURL = zongdizhiURL;
    
    NSString *url = [filrfileURL stringByAppendingString:[NSString stringWithFormat:@"%@",self.img]];
    
    [_bacImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
    
}

-(void)setName:(NSString *)name
{
    _personLab.text = name;

}

- (IBAction)bacButton:(id)sender {
    
    
    [self.delegate huanBac];
    
}

@end
