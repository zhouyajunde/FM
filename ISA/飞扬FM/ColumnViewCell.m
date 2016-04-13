//
//  ColumnViewCell.m
//  DouYU
//
//  Created by Alesary on 15/11/2.
//  Copyright © 2015年 Alesary. All rights reserved.
//

#import "ColumnViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+header.h"
@interface ColumnViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) IBOutlet UILabel *title;
@end

@implementation ColumnViewCell

-(void)setModel:(scModel *)model
{

     [self.image zyj_setHeader:model.img];
//    [self.image sd_setImageWithURL:[NSURL URLWithString:[model.game_icon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"Image_no_data.png"]];
    self.title.text=model.name;
    self.title.backgroundColor = [UIColor clearColor];
    
}

-(void)setChaneldata:(scModel *)chaneldata
{
    //    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[chaneldata.room_src stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"Img_default.png"]];
    self.title.text=chaneldata.name;
    
    //    self.onlinePeople.text=[NSString stringWithFormat:@"%0.1f万",[chaneldata.online doubleValue]/10000];
    //    self.Title.text=chaneldata.room_name;
    
}

@end
