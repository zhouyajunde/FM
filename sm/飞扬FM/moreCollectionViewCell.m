//
//  moreCollectionViewCell.m
//  飞扬FM
//
//  Created by Mac os on 16/1/27.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "moreCollectionViewCell.h"
#import "UIImageView+header.h"

@interface moreCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgBac;
@property (weak, nonatomic) IBOutlet UILabel *diantailab;

@end

@implementation moreCollectionViewCell


-(void)setModel:(scModel *)model
{
    [self.imgBac zyj_setHeader:model.img];
    //    [self.image sd_setImageWithURL:[NSURL URLWithString:[model.game_icon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"Image_no_data.png"]];
    self.diantailab.text=model.name;

    self.diantailab.backgroundColor = [UIColor clearColor];
}


- (void)awakeFromNib {
    // Initialization code
}

@end
