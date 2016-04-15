//
//  NJMessageCell.h
//  01-QQ聊天
//
//  Created by apple on 14-5-30.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NJMessageModel, NJMessageFrameModel;

@interface NJMessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

//@property (nonatomic, strong) NJMessageModel *message;

@property (nonatomic, strong) NJMessageFrameModel *messageFrame;

@end
