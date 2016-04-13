//
//  hasChildCollectionViewCell.m
//  飞扬FM
//
//  Created by Mac os on 16/3/3.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "hasChildCollectionViewCell.h"

@interface hasChildCollectionViewCell()
{
    UIView *_divider;
    
    UIView *_cnmdebi;
}
@property (weak, nonatomic) IBOutlet UILabel *DiquLab;

@end

@implementation hasChildCollectionViewCell

-(void)setModel:(hasDiquModel *)model
{
    
    //    [self.image zyj_setHeader:model.img];
    //    [self.image sd_setImageWithURL:[NSURL URLWithString:[model.game_icon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"Image_no_data.png"]];
    self.DiquLab.text=model.name;
    //    self.title.backgroundColor = [UIColor clearColor];
    
}

#pragma mark 分隔线
- (void)setupDivider
{
//    _divider = [[UIView alloc] init];
//    _divider.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"user_info_nav"]];
//    [self.contentView addSubview:_divider];
//    
//    _cnmdebi = [[UIView alloc] init];
//    _cnmdebi.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"user_info_nav"]];
//    [self.contentView addSubview:_cnmdebi];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    _divider.frame = CGRectMake(self.DiquLab.frame.origin.x +2, 0, self.contentView.frame.size.width-4, 1);
//    _cnmdebi.frame = CGRectMake(0, 3, 1, 34);
}

#pragma mark 设置行号

//-(void)setSection:(NSIndexPath *)section
//{
//    section = section;
//    
//    if (section.row  == 0) {
//        _divider.hidden = YES;
//        _cnmdebi.hidden = YES;
//    }if (section.row  == 1) {
//        _divider.hidden = YES;
//    }
//    if (section.row  == 2) {
//        _divider.hidden = YES;
//    }
//    if (section.row  == 3) {
//        _divider.hidden = YES;
//    }if (section.row  == 4) {
//        _cnmdebi.hidden = YES;
//    }
//}

- (void)awakeFromNib {
    // Initialization code
    
//    [self setupDivider];
}

@end
