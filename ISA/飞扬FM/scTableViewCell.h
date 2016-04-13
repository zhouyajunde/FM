//
//  scTableViewCell.h
//  飞扬FM
//
//  Created by Mac os on 16/1/21.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@class scModel;

@interface scTableViewCell : UITableViewCell{
    
     NSDate *currenttime;
}

//内容模型

@property (nonatomic,strong) scModel *scdeMedel;
+(instancetype)shoucangCellWithTabView:(UITableView*)tableView;

@end
