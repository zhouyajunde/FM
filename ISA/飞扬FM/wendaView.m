//
//  wendaView.m
//  飞扬FM
//
//  Created by Mac os on 15/12/21.
//  Copyright © 2015年 SFware. All rights reserved.
//

#import "wendaView.h"
#import "Statics.h"

@implementation wendaView

- (id)initWithFrame:(CGRect)frame withTitle:(NSMutableDictionary *)data
{
     timu = data;
    self = [super initWithFrame:frame];
    if (self) {
        
        title  = [[UILabel alloc]initWithFrame:CGRectMake(10,0,frame.size.width, 30)];
        title.backgroundColor = [UIColor clearColor];
        
        NSString *P = [NSString stringWithFormat:@"%@%@",[data objectForKey:@"name"],@"*"];
        title.text = P;
        title.font = [UIFont fontWithName:@"Helvetica" size:14.f];
        title.textColor = [UIColor whiteColor];
        [self addSubview:title];
        
        username = [[UITextField alloc]initWithFrame:CGRectMake(10, 50, 280, 40)];
        username.backgroundColor = [UIColor clearColor];
        UIColor *color = [UIColor whiteColor];
        username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的答案" attributes:@{NSForegroundColorAttributeName: color}];
        username.font = [UIFont fontWithName:@"Helvetica" size:13.f];
        username.textColor = [UIColor whiteColor];
        username.adjustsFontSizeToFitWidth = YES;
        username.textAlignment = NSTextAlignmentLeft;
        username.borderStyle = UITextBorderStyleRoundedRect;
        //    loginView.clearsOnBeginEditing = YES;
        username.keyboardType = UIKeyboardTypeDefault;
        username.returnKeyType = UIReturnKeyDefault;
        username.delegate = self;
        username.clearButtonMode = UITextFieldViewModeAlways;
        
        [self addSubview:username];
    
        UIImageView *tWview = [[UIImageView alloc]initWithImage:[UIImage  imageNamed:@"login_input_bg.png"]];
        tWview.frame= CGRectMake(10, 50, 280, 40);
        [self addSubview:tWview];
    }
    return self;
    
}
- (id)initWithFrame1:(CGRect)frame withTitle:(NSMutableDictionary *)data1{
    
    sas = data1;
    self = [super initWithFrame:frame];
    if (self) {
        
        title  = [[UILabel alloc]initWithFrame:CGRectMake(10,0,frame.size.width, 30)];
        title.backgroundColor = [UIColor clearColor];
        
        NSString *P = [NSString stringWithFormat:@"%@%@",[data1 objectForKey:@"name"],@"*"];
        title.text = P;
        title.font = [UIFont fontWithName:@"Helvetica" size:14.f];
        title.textColor = [UIColor whiteColor];
        [self addSubview:title];
        
        textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 50, 280, 70)];
        
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        NSDictionary *attributes = @{
//                                     NSFontAttributeName:[UIFont systemFontOfSize:12],
//                                     NSParagraphStyleAttributeName:paragraphStyle
//                                     };
//        textView.attributedText = [[NSAttributedString alloc] initWithString:@"输入您的答案" attributes:attributes];
        
        textView.textColor = [UIColor whiteColor];
        textView.clearsContextBeforeDrawing = YES;
        textView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"login_input_bg.png"]];
        textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
        textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
        textView.scrollEnabled = YES;//是否可以拖动
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
        
        [self addSubview:textView];
    }
    return self;
}

- (NSMutableDictionary *) getValue{

    NSMutableDictionary *result =[NSMutableDictionary new];
    
    [result setObject:@"3" forKey:@"type"];
  
    [result setObject:[timu objectForKey:@"id"] forKey:@"id"];
    
    NSMutableDictionary *selecteds = [NSMutableDictionary new];
    
//    NSString *usernamee = [Statics encodeToPercentEscapeString:username.text];
    [selecteds setObject:username.text forKey:@"value"];
    
    [selecteds setObject: [([timu objectForKey:@"chooses"][0])objectForKey:@"id"] forKey:@"id"];
    
    [result setObject:selecteds forKey:@"value"];
    
    return result;
}
- (NSMutableDictionary *) getValuew{
    
    NSMutableDictionary *result1 =[NSMutableDictionary new];
    
    [result1 setObject:@"4" forKey:@"type"];
    
    [result1 setObject:[sas objectForKey:@"id"] forKey:@"id"];
    
    NSMutableDictionary *selecteds1 = [NSMutableDictionary new];
    
//     [selecteds1 setObject: @"DAAS"forKey:@"value"];
    [selecteds1 setObject:textView.text forKey:@"value"];
    
    [selecteds1 setObject: [([sas objectForKey:@"chooses"][0])objectForKey:@"id"]  forKey:@"id"];
    
    [result1 setObject:selecteds1 forKey:@"value"];
    
    return result1;
}

@end
