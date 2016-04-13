//
//  ZYJyijian.m
//  飞扬FM
//
//  Created by Mac os on 16/1/25.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJyijian.h"
#import "HTTPManager.h"
#import "UserDefine.h"
#import "MBProgressHUD+NJ.h"

@interface ZYJyijian ()

{
    NSString *_userId;
}

@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;
- (IBAction)tijiao:(id)sender;

@end

@implementation ZYJyijian

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]]] ;
    // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    _userId = [[defaults objectForKey:@"dic"] objectForKey:@"id"];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)tijiao:(id)sender {
    if (self.content.text.length==0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"内容不能为空！"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"userId"] = [NSString stringWithFormat:@"%@", _userId];
    dic[@"something"] = _content.text;

     [MBProgressHUD showMessage:@"正在提交"];
    
    [[HTTPManager shareManager]  postPath:feedbackUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"提交成功！"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"提交失败！"];
    }];

}
@end
