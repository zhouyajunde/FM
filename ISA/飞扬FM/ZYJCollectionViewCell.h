//
//  ZYJCollectionViewCell.h
//  飞扬FM
//
//  Created by Mac os on 16/1/25.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  scModel;

@interface ZYJCollectionViewCell : UICollectionViewCell

+ (NSString *)xib;

+(instancetype)CellWithcollectionView:(UICollectionView *)tableView;
@property (nonatomic, strong) scModel *product;
@end
