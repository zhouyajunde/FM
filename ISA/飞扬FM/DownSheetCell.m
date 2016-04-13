//
//  DownSheetCell.m
//  audioWriting
//
//  Created by wolf on 14-7-19.
//  Copyright (c) 2014年 wangruiyy. All rights reserved.
//

#import "DownSheetCell.h"
#import "UserDefine.h"

@implementation DownSheetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1.设置背景
        [self setupBg];
        // 3.添加分隔线
        [self setupDivider];

        leftView = [[UIImageView alloc]init];
        InfoLabel = [[UILabel alloc]init];
        InfoLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:leftView];
        [self.contentView addSubview:InfoLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma mark 设置背景
- (void)setupBg
{
    // 1.默认
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_top1"]];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,bg.frame.size.width,bg.frame.size.height)];
    self.backgroundView = iv;
    
    // 2.选中
    UIView *selectedBg = [[UIView alloc] init];
    selectedBg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"user_info_nav"]];
    self.selectedBackgroundView = selectedBg;
}
#pragma mark 分隔线
- (void)setupDivider
{
    _divider = [[UIView alloc] init];
    _divider.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"user_info_nav"]];
    [self.contentView addSubview:_divider];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    leftView.frame = CGRectMake(20, (self.frame.size.height-20)/2, 20, 20);
//    InfoLabel.frame = CGRectMake(leftView.frame.size.width+leftView.frame.origin.x+15, (self.frame.size.height-20)/2, 140, 20);
    
//    _divider.frame = CGRectMake(self.textLabel.frame.origin.x, 0, self.contentView.frame.size.width + 100, 1.2);
//    
//    if (iOS7) return;
//    
//    // 右边控件的frame
//    CGRect accessF = self.accessoryView.frame;
//    accessF.origin.x = self.frame.size.width - accessF.size.width - YILCellMargin * 2;
//    self.accessoryView.frame = accessF;

}

-(void)setData:(DownSheetModel *)dicdata{
//    cellData = dicdata;
//    leftView.image = [UIImage imageNamed:dicdata.icon];
//    InfoLabel.text = dicdata.title;
    self.imageView.image = [UIImage imageNamed:dicdata.icon];
    
    self.textLabel.text = dicdata.title;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(selected){
        self.backgroundColor = RGBCOLOR(12, 102, 188);
        leftView.image = [UIImage imageNamed:cellData.icon_on];
        InfoLabel.textColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        leftView.image = [UIImage imageNamed:cellData.icon];
        InfoLabel.textColor = [UIColor blackColor];
    }
    // Configure the view for the selected state
}

@end
