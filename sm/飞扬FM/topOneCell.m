//
//  topOneCell.m
//  飞扬FM
//
//  Created by Mac os on 16/1/26.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "topOneCell.h"
#import "scModel.h"
#import "UIImageView+header.h"

@interface topOneCell()

@property (weak, nonatomic) IBOutlet UIImageView *topImg;
@property (weak, nonatomic) IBOutlet UILabel *mainLab;
@property (weak, nonatomic) IBOutlet UILabel *subLable;

@end


@implementation topOneCell

+(instancetype)shoucangCellWithTabView:(UITableView*)tableView
{
    static NSString *reuseId = @"gb";
    topOneCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"topOneCell" owner:nil options:nil] lastObject];
        
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

-(void)setModel:(scModel *)model{

    [self.topImg zyj_setHeader:model.img];
    self.mainLab.text = model.name;
    self.subLable.text = model.desc;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
////    [super setSelected:selected animated:NO];
//    // Configure the view for the selected state
//    
//    scModel *chanelD=self.model;
//    
//    [self.delegate TapRecommendTableCellDelegate:chanelD musicNarrry:nil];
//}

@end
