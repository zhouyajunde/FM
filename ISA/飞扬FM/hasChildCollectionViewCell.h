//
//  hasChildCollectionViewCell.h
//  飞扬FM
//
//  Created by Mac os on 16/3/3.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hasDiquModel.h"

@interface hasChildCollectionViewCell : UICollectionViewCell


@property(nonatomic,strong)hasDiquModel *model;
@property (nonatomic, strong)NSIndexPath *section;
@end
