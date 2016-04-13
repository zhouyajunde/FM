//
//  huanCell.m
//  飞扬FM
//
//  Created by Mac os on 16/2/29.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "huanCell.h"
#import "UIImageView+header.h"

@interface huanCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bacImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *jiefenLab;

@end


@implementation huanCell


+(instancetype)shoucangCellWithTabView:(UITableView*)tableView
{
    static NSString *reuseId = @"gb";
    huanCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"huanCell" owner:nil options:nil] lastObject];
        
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

-(void)setDuihaun:(duihuanModel *)duihaun
{
    
    [self.bacImg zyj_setHeader:duihaun.img1];
    
    _nameLab.text = duihaun.name;
    _jiefenLab.text = duihaun.jifen ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
