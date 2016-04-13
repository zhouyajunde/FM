//
//  regViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/12.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "regViewController.h"
#import "Statics.h"
#import "UserDefine.h"
#import "MBProgressHUD+NJ.h"
#import "HTTPManager.h"
#import "regtwoViewController.h"

@interface regViewController ()

/*
 手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *iphoneField;

// 验证码

@property (weak, nonatomic) IBOutlet UITextField *yanmaField;

//获取验证码的按钮
@property (weak, nonatomic) IBOutlet UIButton *yanmaBtn;

//跳转到下一个页面的按钮
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)huoquBtn:(id)sender;
- (IBAction)nextBtn:(id)sender;

@end

@implementation regViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iphoneField.tag = 1001;
    
    self.iphoneField.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
    NSLog(@"name == %@",self.string);

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.iphoneField];
    
}

- (IBAction)huoquBtn:(id)sender {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"loginName"] = self.iphoneField.text;
    
   __block NSDictionary *detailDictionary = [NSDictionary dictionary];
    [[HTTPManager shareManager] postPath:yanzhengmaURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        [MBProgressHUD showMessage:@"正在发送...."];
        
        if ([jsonData length]>0 && error == nil) {
            error = nil;
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            if (jsonObj != nil && error == nil) {
                //如果jsonObject是字典类
                
                    detailDictionary = (NSDictionary *)jsonObj;
                    [MBProgressHUD hideHUD];
                    
                    [MBProgressHUD showSuccess:[detailDictionary objectForKey:@"result"] ];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showSuccess:[detailDictionary objectForKey:@"result"] ];
        
    }];

}

- (IBAction)nextBtn:(id)sender {
  
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"loginName"] = self.iphoneField.text;
    parameters[@"code"] = self.yanmaField.text;
    
    [[HTTPManager shareManager] postPath:yazhengURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        [MBProgressHUD showMessage:@"正在加载...."];
        
        if ([jsonData length]>0 && error == nil) {
            error = nil;
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            if (jsonObj != nil && error == nil) {
                //如果jsonObject是字典类
                
                NSDictionary *detailDictionary = (NSDictionary *)jsonObj;
                if ([[detailDictionary objectForKey:@"result"]isEqualToString:@"success"]) {
//注册页面
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    [MBProgressHUD hideHUD];
                    
                    regtwoViewController *reg =  [storyboard instantiateViewControllerWithIdentifier:@"zhuce2next"];
                    reg.iphone = self.iphoneField.text;
                    
                    [self.navigationController pushViewController:reg animated:YES];
                    
                    self.iphoneField.text = @"";
                    self.yanmaField.text = @"";

                }else{
                    [MBProgressHUD hideHUD];
                    
                    [MBProgressHUD showSuccess:[detailDictionary objectForKey:@"result"] ];

                }
        
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:@"请检查网络"];
        
    }];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    // 3.主动召唤出键盘
    [self.iphoneField becomeFirstResponder];
    //    [self.nameField resignFirstResponder];
}

-(void)textChange{
    
    self.yanmaBtn.enabled =(self.iphoneField.text.length>0);
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
