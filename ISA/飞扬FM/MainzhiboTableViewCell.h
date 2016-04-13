//
//  MainzhiboTableViewCell.h
//  飞扬FM
//
//  Created by Mac os on 16/1/27.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
@class scModel;

@protocol zhiboDelegate <NSObject>

-(void)TapRecommendTableCellDelegate:(scModel *)chaneldata  musicNarrry:(NSArray *)musicArry;


@end


@interface MainzhiboTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *modelArray;

@property(nonatomic,assign)int  tags; //所在section

@property(nonatomic,assign)id delegate;

+(instancetype)shoucangCellWithTabView:(UITableView*)tableView;

@end
