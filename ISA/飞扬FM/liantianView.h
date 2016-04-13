//
//  liantianView.h
//  飞扬FM
//
//  Created by Mac os on 16/3/11.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol liantianDegate <NSObject>

-(void)liaotian:(NSNotification  *)notification;

-(void)liantianxinxi:(UITextField *)textField;

-(void)emojint;

@end




@interface liantianView : UIView

@property (nonatomic, assign)BOOL bolemojin;

@property (weak, nonatomic) IBOutlet UIButton *emojin;


- (IBAction)emonjinBtn:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (assign,nonatomic)id delegate;

@end
