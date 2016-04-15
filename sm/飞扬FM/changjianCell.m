//
//  changjianCell.m
//  飞扬FM
//
//  Created by Mac os on 16/2/29.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "changjianCell.h"

@interface changjianCell ()

@property (weak, nonatomic) IBOutlet UILabel *timuLab;
@property (weak, nonatomic) IBOutlet UILabel *contenLab;
@property (weak, nonatomic) IBOutlet UITextView *contF;

@end

@implementation changjianCell

+(instancetype)shoucangCellWithTabView:(UITableView*)tableView
{
    static NSString *reuseId = @"gb";
    changjianCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"changjianCell" owner:nil options:nil] lastObject];
        
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}


-(void)setModel:(changjianModel *)model
{
    _model = model;
    
    _timuLab.text = model.something;
    _contF.text = model.huifu;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
