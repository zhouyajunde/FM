//
//  topOneCell.h
//  飞扬FM
//
//  Created by Mac os on 16/1/26.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
@class scModel;

@protocol topDelegate <NSObject>

-(void)TapRecommendTableCellDelegate:(scModel *)chaneldata  musicNarrry:(NSArray *)musicArry;

@end

@interface topOneCell : UITableViewCell

+(instancetype)shoucangCellWithTabView:(UITableView*)tableView;
@property(nonatomic ,strong) scModel *model;
@property(nonatomic , strong) id delegate;
@end
