//
//  SIJPCell.m
//  SIrico-FlyRadio
//
//  Created by Jin on 8/10/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SILPCell.h"
#import "SILPEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SILPCell ()

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jfLabel;
@property (nonatomic, strong) UILabel *dhLabel;

@end

@implementation SILPCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _photoView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _photoView.backgroundColor = CLEAR_COLOR;
        [self.contentView addSubview:_photoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = CLEAR_COLOR;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        
        _jfLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _jfLabel.backgroundColor = CLEAR_COLOR;
        _jfLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_jfLabel];
        
        _dhLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dhLabel.backgroundColor = CLEAR_COLOR;
        _dhLabel.font = [UIFont systemFontOfSize:15];
        _dhLabel.textColor = [UIColor blueColor];
        _dhLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_dhLabel];
        
        
        self.backgroundColor = CLEAR_COLOR;
    }
    return self;
}

- (void)configCell:(SILPEntity *)item
{
    NSString *path = [NSString stringWithFormat:@"%@%@",BASE_URL,item.lpimg];
    [_photoView setImageWithURL:[NSURL URLWithString:path]];
    _nameLabel.text = item.lpname;
    _jfLabel.text = [NSString stringWithFormat:@"所需积分:%@",item.lpjifen];
    _dhLabel.text = @"点击兑换→";
}

- (void)layoutSubviews
{
    _photoView.frame = CGRectMake(10, 10, 120, 100);
    _nameLabel.frame = CGRectMake(140, 10, 180, 30);
    _jfLabel.frame = CGRectMake(140, 40, 180, 30);
    _dhLabel.frame = CGRectMake(140, 110-30, 170, 30);
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
