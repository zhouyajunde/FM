//
//  dianzanViewController.h
//  飞扬FM
//
//  Created by Mac os on 15/10/12.
//  Copyright © 2015年 SFware. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol dianzDelegate <NSObject>

@end

@interface dianzanViewController : UIViewController<UITextViewDelegate>
{
    BOOL jisuan,daozan,xingxing;
     NSString *programmeId, *unmber,*userId,*pinglun;
}

@property(nonatomic,strong)NSString *program,*unmberber;

@property (retain, nonatomic) IBOutlet UIButton *dianzan;
@property (retain, nonatomic) IBOutlet UIButton *diandaozan;
@property (retain, nonatomic) IBOutlet UIButton *tiajiaopj;
@property (retain, nonatomic) IBOutlet UIButton *quxioab;
@property (retain, nonatomic) IBOutlet UITextView *yijianuser;
@property (retain, nonatomic) IBOutlet UIButton *one;
@property (retain, nonatomic) IBOutlet UIButton *two;
@property (retain, nonatomic) IBOutlet UIButton *tre;
@property (retain, nonatomic) IBOutlet UIButton *four;
@property (retain, nonatomic) IBOutlet UIButton *five;
@property (retain, nonatomic) IBOutlet UILabel *pingjia;
@property (retain, nonatomic) IBOutlet UIImageView *xianz;
@property (retain, nonatomic) IBOutlet UIImageView *xiany;
@property (retain, nonatomic) IBOutlet UILabel *dtpingjia;


- (IBAction)diyi:(id)sender;
- (IBAction)dier:(id)sender;
- (IBAction)disan:(id)sender;
- (IBAction)disi:(id)sender;
- (IBAction)diwu:(id)sender;

- (IBAction)dianzan:(id)sender;
- (IBAction)dianzaib:(id)sender;
- (IBAction)tijiaopj:(id)sender;
- (IBAction)quxiao:(id)sender;

@property(assign,nonatomic)id<dianzDelegate>delegate;

- (NSString *)encodeToPercentEscapeString: (NSString *) input;

@end
