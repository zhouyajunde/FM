//
//  feIleizhiboCell.h
//  飞扬FM
//
//  Created by Mac os on 16/3/4.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "scModel.h"

@interface feIleizhiboCell : UITableViewCell

+(instancetype)shoucangCellWithTabView:(UITableView*)tableView;

@property(nonatomic ,strong) scModel *model;

@end
