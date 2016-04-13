//
//  zhaohuiViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/2/25.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "zhaohuiViewController.h"
#import "textfd.h"
#import "HTTPManager.h"
#import "UserDefine.h"
#import "MBProgressHUD+NJ.h"

@interface zhaohuiViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet textfd *iphoneLab;
@property (weak, nonatomic) IBOutlet textfd *mima;
@property (weak, nonatomic) IBOutlet textfd *twmima;
@property (weak, nonatomic) IBOutlet textfd *yanzhengma;

- (IBAction)nextBtn:(id)sender;

@end

@implementation zhaohuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.usename);
    
    self.iphoneLab.tag = 1001;
    
    self.iphoneLab.delegate = self;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];

}

- (IBAction)nextBtn:(id)sender {

    if (self.iphoneLab.text.length==0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"手机号或密码不能为空！"];
        return;
    }
    if (self.mima.text.length==0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"手机号或密码不能为空！"];
        return;
    }

    if (self.mima.text.length <= 6) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"密码长度要大于6！"];
        return;
    }

    if (self.twmima.text.length==0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"手机号或密码不能为空！"];
        return;
    }
    if (![self.mima.text isEqualToString:self.twmima.text]) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"两次输入的密码不一致！"];
        return;
    }

    if (self.yanzhengma.text.length==0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"验证码不能为空！"];
        return;
    }

    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"loginName"] = self.iphoneLab.text;
    parameter[@"password"] = self.mima.text;
    parameter[@"password1"] = self.twmima.text;
    parameter[@"code"] = self.yanzhengma.text;
    
    [[HTTPManager shareManager] postPath:resetpassURL parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        [MBProgressHUD showMessage:@"正在发送...."];
        
        if ([jsonData length]>0 && error == nil) {
            error = nil;
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            if (jsonObj != nil && error == nil) {
                //如果jsonObject是字典类
                
                NSDictionary *detailDictionary = (NSDictionary *)jsonObj;
                
             
                if([[detailDictionary objectForKey:@"result"]isEqualToString:@"success"])
                {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:[detailDictionary objectForKey:@"result"]];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else
                {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:[detailDictionary objectForKey:@"result"]];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:@"请检查网络"];
        
    }];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1001) {
        
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11){
            return NO;
        }
        
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest) {
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请输入电话号码"];
            return NO;
        }
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
