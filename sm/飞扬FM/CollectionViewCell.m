//
//  CollectionViewCell.m
//  collectionView
//
//  Created by shikee_app05 on 14-12-10.
//  Copyright (c) 2014年 shikee_app05. All rights reserved.
//

#import "CollectionViewCell.h"
#import "UserDefine.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "musicModel.h"
#import "UIImageView+header.h"

#define global_queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _bkimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame)+50)];
        
        _bkimgView.image = [UIImage imageNamed:@"tuijian_top1"];
        [self addSubview:self.bkimgView];
        

        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame)+20)];
        self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_bkimgView addSubview:self.imgView];
        
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame), CGRectGetWidth(self.frame), 30)];
        self.text.backgroundColor = [UIColor whiteColor];
        self.text.textAlignment = NSTextAlignmentCenter;
        self.text.textColor = [UIColor blackColor];
        [_bkimgView addSubview:self.text];
        
//        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.btn.frame = CGRectMake(5, CGRectGetMaxY(self.text.frame), CGRectGetWidth(self.frame)-10,30);
//        [self.btn setTitle:@"按钮" forState:UIControlStateNormal];
//        self.btn.backgroundColor = [UIColor orangeColor];
//        [self addSubview:self.btn];
    }
    return self;
}


- (void)configCell:(NSDictionary *)item
{
    NSLog(@"%@",item);
    
//    if ([item objectForKey:@"name"] != nil) {
//        
//        dispatch_async(global_queue, ^{
//            
//            NSString *filrfileURL = zongdizhiURL;
//            NSString *urlStr = [filrfileURL stringByAppendingString:[NSString stringWithFormat:@"%@",[item objectForKey:@"img"]]];
//            NSData *data3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
//            
//            dispatch_queue_t main =  dispatch_get_main_queue();
//            dispatch_async(main, ^{
//                if (data3) {
//                     self.imgView.image = [UIImage imageWithData:data3];
//                }
//                else{
//                     self.imgView.image = [UIImage imageNamed:@"diantai_default.png"];
//                }
//                
//            });
//            
//        });
//    }
  
     musicModel *app = [musicModel productWithDict:item];
    
    [self.imgView zyj_setHeader:app.img];
    
    self.text.text = app.name;
    
}

@end
