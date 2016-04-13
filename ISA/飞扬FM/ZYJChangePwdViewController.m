//
//  ZYJChangePwdViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/19.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJChangePwdViewController.h"
#import "textfd.h"
#import "HTTPManager.h"
#import "UserDefine.h"
#import "MBProgressHUD+NJ.h"
#import "NSDictionary+Extension.h"

@interface ZYJChangePwdViewController ()
{
     NSString *_useId;
}
@property (weak, nonatomic) IBOutlet textfd *iPhoneLab;
@property (weak, nonatomic) IBOutlet textfd *oldPassword;
@property (weak, nonatomic) IBOutlet textfd *PassW;
@property (weak, nonatomic) IBOutlet textfd *twoPass;
- (IBAction)nextBtn:(id)sender;

@end

@implementation ZYJChangePwdViewController

-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
    // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    NSDictionary *_dic = [defaults objectForKey:@"dic"];
    
    _useId = [ NSString stringWithFormat:@"%@", [_dic objectForKey:@"id"]];
}
- (IBAction)nextBtn:(id)sender {
    
    if (self.iPhoneLab.text.length==0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"手机号或密码不能为空！"];
        return;
    }
   
     if (self.PassW.text.length==0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"手机号或密码不能为空！"];
        return;
    }
    if (![self.PassW.text isEqualToString:self.twoPass.text]) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"2次输入的密码不一致！"];
        return;
    }
 
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = _useId;
    parameters[@"oldpassword"] = self.iPhoneLab.text;
    parameters[@"newpassword"] =  self.PassW.text;
    [[HTTPManager shareManager] getPath:changenUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
//        [MBProgressHUD showMessage:@""];
        
        if ([jsonData length]>0 && error == nil) {
            error = nil;
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            if (jsonObj != nil && error == nil) {
                //如果jsonObject是字典类
//                key	NSTaggedPointerString *	@"result"	0xa00746c757365726
                NSDictionary *detailDictionary = (NSDictionary *)jsonObj;
                [MBProgressHUD hideHUD];
                    
                [MBProgressHUD showSuccess:[detailDictionary objectForKey:@"result"]];
               
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:@"请检查网络"];
        
    }];


}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
