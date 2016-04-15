//
//  ZYJCollectionViewCell.m
//  飞扬FM
//
//  Created by Mac os on 16/1/25.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJCollectionViewCell.h"

@interface ZYJCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *diantaixinxi;
@property (weak, nonatomic) IBOutlet UIImageView *diantaiImg;


@end

@implementation ZYJCollectionViewCell


+ (NSString *)xib
{
    return @"ZYJCollectionViewCell";
}

- (void)awakeFromNib {
    
    _diantaiImg.layer.cornerRadius = 8;
    // 让内部的所有图层都遵循父图层的边框来显示
    // 超出父图层边框的内容全部不显示（裁剪掉）
    _diantaiImg.layer.masksToBounds = YES;
    
    //    _iconView.clipsToBounds = YES;
}

- (void)setProduct:(scModel *)product
{
    _product = product;
  
//    _diantaixinxi.text = product.name;
    // 1.图标
//    _diantaiImg.image = [UIImage imageNamed:product.icon];
//    
//    // 2.标题
//    _diantaiImg.text = product.title;
}


@end
