//
//  fenleiTableViewCell.h
//  飞扬FM
//
//  Created by Mac os on 16/1/27.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@class diquModel;

@protocol fenleiTableCellDelegate <NSObject>

-(void)fenleiTableCellDelegate:(diquModel *)chaneldata;

@end

@interface fenleiTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property(nonatomic,strong)NSArray *modelArray;

@property(nonatomic,assign)int  tags; //所在section

@property(nonatomic,assign)id delegate;

@property (nonatomic, strong) NSIndexPath *section;

+(instancetype)shoucangCellWithTabView:(UITableView*)tableView;


@end
