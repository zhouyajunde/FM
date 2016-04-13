//
//  regtwoViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/15.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "regtwoViewController.h"
#import "ZYJSexBox.h"
#import "ZYJCarBox.h"
#import "MBProgressHUD+NJ.h"
#import "HTTPManager.h"
#import "textfd.h"
#import "Statics.h"
#import "NSDictionary+Extension.h"
#import "ReturnDeviceType.h"
#import "UserDefine.h"
#import "dierViewController.h"
#import "xiugaiViewController.h"

@interface regtwoViewController()<dieraDelegate>
{
    NSString *car,*sex,*appId;
    NSDictionary *dic;
    dierViewController *dier;
}

@property (weak, nonatomic) IBOutlet UIButton *manBtn;

@property (weak, nonatomic) IBOutlet UIButton *nianlinLab;

@property (weak, nonatomic) IBOutlet UIButton *womanBtn;

@property (weak, nonatomic) IBOutlet UIButton *norBtn;

@property (weak, nonatomic) IBOutlet UIButton *carBtn;

- (IBAction)nianlinBtn:(id)sender;
- (IBAction)carChanged:(id)sender;
- (IBAction)change:(id)sender;

@property (weak, nonatomic) IBOutlet textfd *nichengLab;
@property (weak, nonatomic) IBOutlet textfd *mimaLab;
@property (weak, nonatomic) IBOutlet textfd *twoLab;
- (IBAction)nextBtn:(id)sender;

@end

@implementation regtwoViewController


-(void)viewDidLoad{
    
    [super viewDidLoad];
    car = @"0";
    sex = @"1";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
    
    // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    dic = [defaults objectForKey:@"dic"];
  
    appId = [dic objectForKey:@"appId"];
    
    
    dier = [[dierViewController alloc]init];
    dier.delegate = self;
    dier.view.frame = CGRectMake(0, 900, self.view.frame.size.width, 150);
    dier.section = 0;
    dier.row = 2;
    dier._nameArray = [NSMutableArray arrayWithObjects:@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",nil];
    [self.view addSubview:dier.view];

}


- (void)newMessageReceived:(NSString *)messageContent gundan:(NSUInteger)section indexPath:(NSUInteger)row{
    _nianlinLab.titleLabel.text = messageContent;
}


- (IBAction)nianlinBtn:(id)sender {
    
    dier.view.frame = CGRectMake(0, 570, self.view.frame.size.width, 150);
    [self.view addSubview:dier.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        dier.view.frame = CGRectMake(0, 420, self.view.frame.size.width,150);
    }];

}

- (IBAction)carChanged:(id)sender {

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
        car = @"0";
        
    }
}

- (IBAction)change:(id)sender {
    if (!_manBtn.enabled) {
        //        选中
        _womanBtn.enabled = NO;
        _manBtn.enabled = YES;
        sex = @"0";
        
    }else
    {
        //        选中
        _womanBtn.enabled = YES;
        _manBtn.enabled = NO;
        sex = @"1";
        
    }
}
- (IBAction)nextBtn:(id)sender {
    
    if (self.nichengLab.text.length==0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"昵称或密码不能为空！"];
        return;
    }
    if (self.mimaLab.text.length==0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"昵称或密码不能为空！"];
        return;
    }
    if (self.mimaLab.text.length <= 6) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"密码的长度要大于6"];
        return;
    }
    
    if (dic == nil) {
        [self dingwei];
    }
    if ([[dic objectForKey:@"status"]isEqualToString:@""]) {
        [self dingwei];
    }else if ([[dic objectForKey:@"status"]isEqualToString:@"0"])
    {
        [self youkeBt];
    }
}

-(void)youkeBt
{
    NSString * stringStr = [ReturnDeviceType deviceString];
    
    NSString *udid = [stringStr stringByReplacingOccurrencesOfString:@" " withString:@""];//stringStr为
    
    NSString *shebi = @"1";
    
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    // 有没有,都不会出现错误
    NSString *ud = [NSString stringWithFormat:@"%@%@%@",identifierForVendor,udid,shebi];
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"name"] =  self.nichengLab.text;
    parameters[@"appInfo"] = ud;
    parameters[@"password"] = self.mimaLab.text;
    parameters[@"password1"] = self.twoLab.text;
    parameters[@"car"] = car;
    parameters[@"sex"] = sex;
    parameters[@"appId"] = appId;
    parameters[@"age"] = _nianlinLab.titleLabel.text;
    parameters[@"phone"] = _iphone;
    
    [[HTTPManager shareManager] postPath:youkeListURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            error = nil;
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            if (jsonObj != nil && error == nil) {
                
                NSDictionary *detailDictionary = (NSDictionary *)jsonObj;
                //如果jsonObject是字典类
                if(![[detailDictionary allKeys] containsObject:@"id"])
                {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:[detailDictionary objectForKey:@"result"]];
                }else
                {

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
                
                //移除上一个栈顶的控制器
                    
                xiugaiViewController *xiugai = [self.storyboard instantiateViewControllerWithIdentifier:@"zhucetoxiugai"];
                [self.navigationController pushViewController:xiugai animated:YES];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
      
        
    }];
}

// 当地的电台的处理
-(void)dingwei{
    // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    NSDictionary *loc = [defaults objectForKey:@"dingwei"];
    
    NSString *locc = [loc objectForKey:@"loc"];
    
    NSString *place = [loc objectForKey:@"place"];

    if (locc == nil) {
        locc = @"";
    }if (place == nil) {
        place = @"";
    }

    
    NSString * stringStr = [ReturnDeviceType deviceString];
    
    NSString *udid = [stringStr stringByReplacingOccurrencesOfString:@" " withString:@""];//stringStr为
    
    NSString *shebi = @"1";
    
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    // 有没有,都不会出现错误
    NSString *ud = [NSString stringWithFormat:@"%@,%@,%@",identifierForVendor,udid,shebi];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"name"] = self.nichengLab.text;
    parameters[@"appInfo"] = ud;
    parameters[@"password"] = self.mimaLab.text;;
    parameters[@"password1"] = self.twoLab.text;;
    parameters[@"car"] = car;
    parameters[@"sex"] = sex;
    parameters[@"age"] = _nianlinLab.titleLabel.text;
    parameters[@"phone"] = _iphone;
    parameters[@"place"] = place;
    parameters[@"coordinate"] = locc;
    
    [[HTTPManager shareManager] postPath:zhuceListURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
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
                    
                    xiugaiViewController *xiugai = [self.storyboard instantiateViewControllerWithIdentifier:@"zhucetoxiugai"];
                    [self.navigationController pushViewController:xiugai animated:YES];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    
        
    }];

}
- (void)cancelPicker
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         dier.view.frame= CGRectMake(0, 600, self.view.frame.size.width, 120);
                     }
                     completion:^(BOOL finished){
                         [dier.view removeFromSuperview];
                         
                     }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [self cancelPicker];

}


@end
