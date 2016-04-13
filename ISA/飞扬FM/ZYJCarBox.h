//
//  ZYJCarBox.h
//  飞扬FM
//
//  Created by Mac os on 16/1/15.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYJCarBox : UIView
@property (weak, nonatomic) IBOutlet UIButton *norBtn;

@property (weak, nonatomic) IBOutlet UIButton *carBtn;

- (IBAction)carChanged:(id)sender;

+(instancetype)carBox;

@end
