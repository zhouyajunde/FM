//
//  NJAboutHeaderView.h
//  01-ItcastLottery
//
//  Created by 李南江 on 14-5-10.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol bacDelegate <NSObject>

-(void)huanBac;

@end

@interface NJAboutHeaderView : UIView
{
    
}

@property (weak, nonatomic) IBOutlet UIImageView *bacImg;
@property (weak, nonatomic) IBOutlet UILabel *personLab;

@property (weak, nonatomic) IBOutlet UIImageView *topView;
- (IBAction)bacButton:(id)sender;


@property(nonatomic,copy)NSString *img;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,assign) id delegate;

+ (instancetype)headerView;

@end
