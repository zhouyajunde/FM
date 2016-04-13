//
//  jiemuCell.h
//  飞扬FM
//
//  Created by Mac os on 16/2/22.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jiemuD.h"



@interface jiemuCell : UITableViewCell


+(instancetype)shoucangCellWithTabView:(UITableView*)tableView;

@property(nonatomic ,strong) jiemuD *model;


@end
