///Users/mac/Desktop/storyboard/飞扬FM/飞扬FM/ZYJyijian.m
//  wenjuanTableViewCell.m
//  飞扬FM
//
//  Created by Mac os on 16/2/29.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "wenjuanTableViewCell.h"
#import "Statics.h"

@interface wenjuanTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *jifen;
@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *end;

@end

@implementation wenjuanTableViewCell



+(instancetype)shoucangCellWithTabView:(UITableView*)tableView
{
    static NSString *reuseId = @"gb";
    wenjuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"wenjuanTableViewCell" owner:nil options:nil] lastObject];
        
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}


-(void)setModel:(wenModel *)model
{
    _model = model;
    
    self.name.text = model.name;
    self.start.text = [Statics zoneChange: model.papStart];
    _end.text = [Statics zoneChange: model.papEnd];
    _jifen.text = model.jifen;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
