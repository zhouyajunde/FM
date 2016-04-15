//
//  huanCell.h
//  飞扬FM
//
//  Created by Mac os on 16/2/29.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "duihuanModel.h"

@interface huanCell : UITableViewCell


@property(nonatomic,copy)duihuanModel *duihaun;

+(instancetype)shoucangCellWithTabView:(UITableView*)tableView;
@end
