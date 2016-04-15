//
//  ColumnViewCell.h
//  DouYU
//
//  Created by Alesary on 15/11/2.
//  Copyright © 2015年 Alesary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "scModel.h"

@interface ColumnViewCell : UICollectionViewCell

@property(nonatomic,strong)scModel *model;
@property(nonatomic,strong)scModel *chaneldata;
@end
