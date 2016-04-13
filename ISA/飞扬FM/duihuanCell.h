//
//  duihuanCell.h
//  飞扬FM
//
//  Created by Mac os on 16/3/1.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "huanModel.h"

@interface duihuanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bac;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property(nonatomic,copy)huanModel *duihaun;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *zhuanghao;
@property (weak, nonatomic) IBOutlet UILabel *pwd;

+(instancetype)shoucangCellWithTabView:(UITableView*)tableView;
@end
