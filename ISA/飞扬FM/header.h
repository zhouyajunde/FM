//
//  header.h
//  飞扬FM
//
//  Created by Mac os on 16/2/29.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface header : UIView

+(instancetype)header;

@property (weak, nonatomic) IBOutlet UILabel *jifenLab;
-(void)lipin:(NSString *)pin;

@end
