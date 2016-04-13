//
//  duihuanCell.m
//  飞扬FM
//
//  Created by Mac os on 16/3/1.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "duihuanCell.h"
#import "UIImageView+header.h"
#import "Statics.h"

@implementation duihuanCell

+(instancetype)shoucangCellWithTabView:(UITableView*)tableView
{
    static NSString *reuseId = @"gb";
    duihuanCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"duihuanCell" owner:nil options:nil] lastObject];
        
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

-(void)setDuihaun:(huanModel *)duihaun
{
    
    [self.bac zyj_setHeader:duihaun.Img1];
    
    _name.text = duihaun.giftName;

    _timeLab.text =  [self duihuantime:[duihaun.exchangeTime longLongValue]];
    
    _zhuanghao.text = duihaun.giftNumber;
    
    _pwd.text = duihaun.giftpwd;
}

-(NSDate*)duihuantime:(long long)spString
{
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setTimeZone:formatter.timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:spString/1000];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    return confromTimespStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
