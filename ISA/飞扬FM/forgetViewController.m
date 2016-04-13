//
//  forgetViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/14.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "forgetViewController.h"
#import "textfd.h"
#import "HTTPManager.h"
#import "UserDefine.h"
#import "MBProgressHUD+NJ.h"
#import "zhaohuiViewController.h"


@interface forgetViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet textfd *userLab;

- (IBAction)nextBtn:(id)sender;

@end

@implementation forgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.userLab.tag = 1001;
    
    self.userLab.delegate = self;

    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.userLab becomeFirstResponder];
}


- (IBAction)nextBtn:(id)sender {
    
      if (self.userLab.text.length==0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"手机号不能为空！"];
        return;
    }
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"loginName"] = self.userLab.text;
    
    [[HTTPManager shareManager] postPath:resetpasswordURL parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        [MBProgressHUD showMessage:@"正在发送...."];
        
        if ([jsonData length]>0 && error == nil) {
            error = nil;
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            if (jsonObj != nil && error == nil) {
                //如果jsonObject是字典类
                
                NSDictionary *detailDictionary = (NSDictionary *)jsonObj;
                
                NSString *res = @"找回密码验证码已发送至您的手机，请注意查收，30分钟内有效！";
                if([res isEqualToString:[detailDictionary objectForKey:@"result"]])
                {
                     [MBProgressHUD hideHUD];
                     [MBProgressHUD showSuccess:@"已发送"];
                     [self performSegueWithIdentifier:@"zhaohuito" sender:nil];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
      UIViewController *vc =  segue.destinationViewController;
      zhaohuiViewController *zhaohui = (zhaohuiViewController *)vc;
      zhaohui.usename = self.userLab.text;
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

@end
