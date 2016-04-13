//
//  ZYJSexBox.h
//  飞扬FM
//
//  Created by Mac os on 16/1/15.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYJSexBox : UIView

//男
@property (weak, nonatomic) IBOutlet UIButton *manBtn;

//女
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;

//点击性别的按钮
- (IBAction)sexChanged:(id)sender;
//创建实例工厂方法

+(instancetype)sexBox;

@end
