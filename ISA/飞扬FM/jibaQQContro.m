//
//  jibaQQContro.m
//  飞扬FM
//
//  Created by Mac os on 16/2/23.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "jibaQQContro.h"
#import "textfd.h"
#import "ReturnDeviceType.h"
#import "HTTPManager.h"
#import "UserDefine.h"
#import "MBProgressHUD+NJ.h"
#import "NSDictionary+Extension.h"


@interface jibaQQContro ()<UITextFieldDelegate>
{
    NSString *car;
}

@property (weak, nonatomic) IBOutlet UIButton *norBtn;

@property (weak, nonatomic) IBOutlet UIButton *carBtn;

- (IBAction)carChanged:(id)sender;
@property (weak, nonatomic) IBOutlet textfd *iphoneText;
@property (weak, nonatomic) IBOutlet UIButton *xiayibuBtn;

- (IBAction)queding:(id)sender;

@end

@implementation jibaQQContro
@synthesize  name;

- (void)viewDidLoad {
    [super viewDidLoad];
    car = @"0";
   self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
    
    self.iphoneText.tag = 1001;
    self.iphoneText.delegate = self;
}
- (IBAction)queding:(id)sender {

    if ([self.iphoneText.text isEqualToString:@"请输入手机号"]||self.iphoneText.text == nil) {
        return;
    }
    //显示最前面的地标信息
    // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    NSDictionary *loc = [defaults objectForKey:@"dingwei"];
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
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = self.iphoneText.text;
    parameters[@"appInfo"] = ud;
    parameters[@"name"] =  name;
    parameters[@"openid"] = _openid;
    parameters[@"car"] = car;
    if ([_sex isEqualToString:@"男"]) {
        parameters[@"sex"] = @"1";
    }else{
        parameters[@"sex"] =@"0";
    }
    parameters[@"img"] = _img;
    parameters[@"place"] = place;
    parameters[@"coordinate"] = locc;
    
    [[HTTPManager shareManager] postPath:thirdRegisterURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
                    [MBProgressHUD showError:[detailDictionary objectForKey:@"result"]];
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
                     NSNotification * notification  = [NSNotification notificationWithName:@"loginSuccess" object:nil];

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

- (IBAction)carChanged:(id)sender {
    
    NSLog(@"5555");
    
    if (!_norBtn.enabled) {
        //        选中
        _norBtn.enabled = NO;
        _carBtn.enabled = YES;
        car = @"1";
       
    }else
    {
        //        选中
        _norBtn.enabled = YES;
        _carBtn.enabled = NO;
        car = @"1";

    }
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
