//
//  SIJLCell.m
//  SIrico-FlyRadio
//
//  Created by Jin on 8/10/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SIJLCell.h"
#import "SIDHJLEntity.h"

@interface SIJLCell ()

@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;

@end

@implementation SIJLCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _label1 = [[UILabel alloc] initWithFrame:CGRectZero];
        _label1.backgroundColor = CLEAR_COLOR;
        _label1.font = [UIFont systemFontOfSize:13];
        _label1.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_label1];
        
        _label2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _label2.backgroundColor = CLEAR_COLOR;
        _label2.font = [UIFont systemFontOfSize:13];
        _label2.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label2];

        _label3 = [[UILabel alloc] initWithFrame:CGRectZero];
        _label3.backgroundColor = CLEAR_COLOR;
        _label3.font = [UIFont systemFontOfSize:13];
        _label3.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_label3];
        
        self.backgroundColor = CLEAR_COLOR;
    }
    return self;
}

- (void)configCell:(SIDHJLEntity *)data
{
    _label1.text = [[data.addTime componentsSeparatedByString:@" "] firstObject];
    _label2.text = data.lpname;
    _label3.text = data.jifen;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _label1.frame = CGRectMake(10, 0, 100, 44);
    _label2.frame = CGRectMake(110, 0, 100, 44);
    _label3.frame = CGRectMake(210, 0, 100, 44);
    
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
