//
//  loginViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/12.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "loginViewController.h"
#import "HTTPManager.h"
#import "UserDefine.h"
#import "MBProgressHUD+NJ.h"
#import "NSDictionary+Extension.h"
#import "ReturnDeviceType.h"
#import "textfd.h"
#import "Statics.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApi.h>

#import "jibaQQContro.h"

@interface loginViewController ()<TencentSessionDelegate>
{
      TencentOAuth *tencentOAuth;
      NSString *UU,*imageString,*buzhidqin,*usernamee;
    NSNotification *notification;
}
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UITextField *login;

@property (weak, nonatomic) IBOutlet UITextField *passWord;


@property (weak, nonatomic) IBOutlet UIButton *qqLogin;

- (IBAction)denglu:(id)sender;

- (IBAction)qqdenglu:(id)sender;

- (IBAction)quxiao:(id)sender;

- (IBAction)youkedenglu:(id)sender;

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
    self.login.tag = 1001;
    
    self.login.delegate = self;
    
    
    if (![QQApi isQQInstalled]) {
        
        _qqLogin.hidden = YES;
    }
    // 1.拿到通知中心
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    // 2.注册监听
    // 注意点: 一定要写上通知的发布者
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.login];
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.passWord];
    
    notification  = [NSNotification notificationWithName:@"loginSuccess" object:nil];

    // Do any additional setup after loading the view
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textChange
{
    /*
     // 1.判断是否同时输入了账号和密码
     if (self.accountField.text.length > 0  &&
     self.pwdField.text.length > 0) {
     // 2.让登录按钮可用
     self.loginBtn.enabled = YES;
     }else
     {
     self.loginBtn.enabled = NO;
     }
     */
    self.loginBtn.enabled = (self.login.text.length > 0  &&
                             self.passWord.text.length > 0);
}

- (IBAction)denglu:(id)sender {
    
    if (self.login.text.length==0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"手机号或密码不能为空！"];
        return;
    }
    if (self.passWord.text.length==0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"手机号或密码不能为空！"];
        return;
    }
 
     NSDictionary *parameter = @{@"loginName":self.login.text,@"password":self.passWord.text};
    
    [[HTTPManager shareManager] postPath:loginListURL parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        [MBProgressHUD showMessage:@"正在拼命登录...."];
        
        if ([jsonData length]>0 && error == nil) {
            error = nil;
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            if (jsonObj != nil && error == nil) {
                //如果jsonObject是字典类
                
                NSDictionary *detailDictionary = (NSDictionary *)jsonObj;
                if(![[detailDictionary allKeys] containsObject:@"id"])
                {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"手机号或密码错误！"];
                }
                else
                {
                    [MBProgressHUD hideHUD];
                    // 偏好设置是专门用来保存应用程序的配置信息的, 一般情况不要再偏好设置中保存其他数据
                    // 如果利用系统的偏好设置来存储数据, 默认就是存储在Preferences文件夹下面的
                    // 偏好设置会将所有的数据保存到同一个文件中
                    
                    // 获取NSUserDefaults对象
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    // 保存数据(如果设置数据之后没有同步, 会在将来某一时间点自动将数据保存到Preferences文件夹下面)
                    
                    //这里对NSDictionary 进行了扩展
                    
                    /*
                     还有要注意的一点是:类型为NSNull的空数据也是无法存入NSUserDefaults的。若数据中有NSNull类型空数据，把它置 nil或@"" 即可存入NSUserDefaults,否则程序会崩溃。
                     如果要存储的NSDictionary里面有NSNull对象,可以使用遍历方法将NSNull对象转为@""对象再次存储
                     */
                    
                    detailDictionary = [NSDictionary safeDictionaryWithDic:detailDictionary];
                    
                    [defaults setObject:detailDictionary forKey:@"dic"];
                    
                    //这里建议同步存储到磁盘中，但是不是必须的
                    [defaults synchronize];
                    
                    [MBProgressHUD showSuccess:@"登陆成功"];
                   
                    //发修改信息界面的消息
                    
                    [[NSNotificationCenter defaultCenter]postNotification:notification];
                    
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    [self.login becomeFirstResponder];
    //    [self.nameField resignFirstResponder];
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

- (IBAction)qqdenglu:(id)sender {
    
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.rawData);
             
             imageString = [NSString stringWithFormat:@"%@",[user.rawData objectForKey:@"figureurl_qq_2"]];//用户头像
             UU = user.uid ;
             
             usernamee = user.nickname;
             
             buzhidqin = [user.rawData objectForKey:@"gender"];
             
             NSDictionary *parameter = @{@"openid":UU};
             [[HTTPManager shareManager] postPath:existThirdUserURL parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 NSError *error = nil;
                 
                 NSData *jsonData = responseObject;
                 [MBProgressHUD showMessage:@"正在拼命登录...."];
                 
                 if ([jsonData length]>0 && error == nil) {
                     error = nil;
                     
                     id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
                     
                     if (jsonObj != nil && error == nil) {
                         //如果jsonObject是字典类
                         
                         NSDictionary *detailDictionary = (NSDictionary *)jsonObj;
                         if(![[detailDictionary allKeys] containsObject:@"id"])
                         {
                             [MBProgressHUD hideHUD];
                             jibaQQContro *jiba = [[jibaQQContro alloc]init];
                             
                             jiba.openid = UU;
                             jiba.name = usernamee;
                             jiba.sex =  buzhidqin;
                             jiba.img = imageString;
                             
                             [self.navigationController pushViewController:jiba animated:YES];          
                             
                         }
                         else
                         {
                             [MBProgressHUD hideHUD];
                             // 偏好设置是专门用来保存应用程序的配置信息的, 一般情况不要再偏好设置中保存其他数据
                             // 如果利用系统的偏好设置来存储数据, 默认就是存储在Preferences文件夹下面的
                             // 偏好设置会将所有的数据保存到同一个文件中
                             // 获取NSUserDefaults对象
                             
                             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                             // 保存数据(如果设置数据之后没有同步, 会在将来某一时间点自动将数据保存到Preferences文件夹下面)
                             
                             //这里对NSDictionary 进行了扩展
                             
                             /*
                              还有要注意的一点是:类型为NSNull的空数据也是无法存入NSUserDefaults的。若数据中有NSNull类型空数据，把它置 nil或@"" 即可存入NSUserDefaults,否则程序会崩溃。
                              如果要存储的NSDictionary里面有NSNull对象,可以使用遍历方法将NSNull对象转为@""对象再次存储
                              */
                             
                             detailDictionary = [NSDictionary safeDictionaryWithDic:detailDictionary];
                             
                             [defaults setObject:detailDictionary forKey:@"dic"];
                             
                             //这里建议同步存储到磁盘中，但是不是必须的
                             [defaults synchronize];
                             
                             [MBProgressHUD hideHUD];
                             [MBProgressHUD showSuccess:@"登陆成功"];
                             
                             [[NSNotificationCenter defaultCenter]postNotification:notification];
                             
                             [self dismissViewControllerAnimated:YES completion:nil];
                         }
                     }
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 [MBProgressHUD hideHUD];
                 
                 [MBProgressHUD showError:@"请检查网络"];
                 [self dismissViewControllerAnimated:YES completion:nil];

                 
             }];

         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}

- (NSString *)encodeToPercentEscapeString: (NSString *) input

{
    
    NSString *outputStr = (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            
                                            (CFStringRef)input,
                                            
                                            NULL,
                                            
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            
                                            kCFStringEncodingUTF8));
    
    return outputStr;
    
}

- (IBAction)quxiao:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)youkedenglu:(id)sender {
    
    // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据

    NSDictionary *loc = [defaults objectForKey:@"dingwei"];

    //显示最前面的地标信息
    
    NSString * stringStr = [ReturnDeviceType deviceString];
    
    NSString *udid = [stringStr stringByReplacingOccurrencesOfString:@" " withString:@""];//stringStr为
    
    NSString *shebi = @"1";
    
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    // 有没有,都不会出现错误
    NSString *ud = [NSString stringWithFormat:@"%@,%@,%@",identifierForVendor,udid,shebi];
    
    NSString *locc = [loc objectForKey:@"loc"];
    
    NSString *place = [loc objectForKey:@"place"];
    
    if (locc == nil) {
        locc = @"";
    }if (place == nil) {
        place = @"";
    }
    
    NSDictionary *parameter = @{@"appInfo":ud,@"place":place,@"coordinate":locc};
    
    [[HTTPManager shareManager] postPath:youkeListenUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            error = nil;
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            if (jsonObj != nil && error == nil) {
                //如果jsonObject是字典类
                
                NSDictionary *detailDictionary = (NSDictionary *)jsonObj;
                // 偏好设置是专门用来保存应用程序的配置信息的, 一般情况不要再偏好设置中保存其他数据
                // 如果利用系统的偏好设置来存储数据, 默认就是存储在Preferences文件夹下面的
                // 偏好设置会将所有的数据保存到同一个文件中
                
                // 获取NSUserDefaults对象
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                // 保存数据(如果设置数据之后没有同步, 会在将来某一时间点自动将数据保存到Preferences文件夹下面)
                
                //这里对NSDictionary 进行了扩展
                
                /*
                 还有要注意的一点是:类型为NSNull的空数据也是无法存入NSUserDefaults的。若数据中有NSNull类型空数据，把它置 nil或@"" 即可存入NSUserDefaults,否则程序会崩溃。
                 如果要存储的NSDictionary里面有NSNull对象,可以使用遍历方法将NSNull对象转为@""对象再次存储
                 */
                
                detailDictionary = [NSDictionary safeDictionaryWithDic:detailDictionary];
                
                [defaults setObject:detailDictionary forKey:@"dic"];
                
                //这里建议同步存储到磁盘中，但是不是必须的
                [defaults synchronize];
                
                // 移除当前栈顶的控制器
                //                    [self.navigationController popViewControllerAnimated:YES];
                
                //移除上一个栈顶的控制器
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
      [self.view endEditing:YES];
}

@end
