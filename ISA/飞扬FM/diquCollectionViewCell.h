//
//  diquCollectionViewCell.h
//  飞扬FM
//
//  Created by Mac os on 16/1/27.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "diquModel.h"

@interface diquCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)diquModel *model;
@property (nonatomic, strong)NSIndexPath *section;
@end
