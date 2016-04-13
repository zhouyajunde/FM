//
//  SILoginViewController.m
//  SIrico-FlyRadio
//
//  Created by fantasee on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SILoginViewController.h"
#import "SIHomeViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "MyAlertView.h"
#import "SIricoUtils.h"

@interface SILoginViewController ()

@end

@implementation SILoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loginAction:(UIButton *)sender
{
    
    if(idTextField.text == nil || idTextField.text.length == 0){
        [[MyAlertView sharedMyAlertView]showWithName:@"请填写用户名" afterDelay:0.5f];
        return ;
    }
    if(passwordTextField.text == nil || passwordTextField.text.length == 0){
        [[MyAlertView sharedMyAlertView]showWithName:@"请填写密码" afterDelay:0.5f];
        return ;
    }
    
    progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHud.mode = MBProgressHUDModeIndeterminate;
    progressHud.removeFromSuperViewOnHide = YES;
    
    [self getData];

}

- (void)getData
{
  
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:passwordTextField.text forKey:@"tel"];
    
    [[HTTPManager shareManager] postPath:YANGBEN_LOGIN_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [XMLReader dictionaryForXMLData:responseObject error:&error];
        DBLog(@"dic=++++%@",dic);
        
        NSString * userDeviceId  = [[NSString alloc] initWithData:adData encoding:NSUTF8StringEncoding];
        NSLog(@"string44444:::::%@",userDeviceId);
        
        [SIricoUtils storeStringInUserDefaults:kSettingOfUserDeviceId string:userDeviceId];
        [SIricoUtils storeStringInUserDefaults:kSettingOfUserName string:idTextField.text];
        [SIricoUtils storeStringInUserDefaults:kSettingOfUserPassWord string:passwordTextField.text];
        
        
        progressHud.hidden = YES;
        
        [self.navigationController popViewControllerAnimated:YES];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBError(error);
        progressHud.hidden = YES;

    }];
    
//    [[SIFRDotNetManager shareManager] request:YANGBEN_LOGIN_URL parameter:parameters success:^(NSData *data) {
//        NSError *error = nil;
//        
//        NSData *adData = [[XMLReader dictionaryForXMLData:data error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
//        
//        NSDictionary *dic = [XMLReader dictionaryForXMLData:data error:&error];
//        DBLog(@"dic=%@",dic);
//        NSLog(@"adData2222:::::%@",adData);
//        
//        NSString * userDeviceId  = [[NSString alloc] initWithData:adData encoding:NSUTF8StringEncoding];
//        NSLog(@"string44444:::::%@",userDeviceId);
//
//        [SIricoUtils storeStringInUserDefaults:kSettingOfUserDeviceId string:userDeviceId];
//        [SIricoUtils storeStringInUserDefaults:kSettingOfUserName string:idTextField.text];
//        [SIricoUtils storeStringInUserDefaults:kSettingOfUserPassWord string:passwordTextField.text];
//
//
//        progressHud.hidden = YES;
//        
////        SIHomeViewController * viewController = [[SIHomeViewController alloc] init];
////        [self.navigationController pushViewController:viewController animated:YES];
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//
//    } error:^(NSError *error) {
//        DBError(error);
//        progressHud.hidden = YES;
//
//    } netStatus:^(BOOL flag) {
//        DBLog(@"网络异常");
//        progressHud.hidden = YES;
//    }];
}

- (void)enterToListen
{
    int x = arc4random() % 100;
    NSLog(@"x====%d",x);
    NSString * tempDeviceId = [NSString stringWithFormat:@"APPIOS%d",x];
    [SIricoUtils storeStringInUserDefaults:kSettingOfTempUserDeviceId string:tempDeviceId];
//    SIHomeViewController * viewController = [[SIHomeViewController alloc] init];
//    [self.navigationController pushViewController:viewController animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];

}

- (void) initTextField
{
    DBLog(@"终于学会了，还有什么问题呢？");
    UILabel * userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 180 + StatusBarHeight, 45, 30)];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.text = @"用户名";
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:userNameLabel];
    
    idTextField = [[UITextField alloc]init];
    idTextField.borderStyle = UITextBorderStyleRoundedRect;
    idTextField.frame = CGRectMake(100, 180 + StatusBarHeight , 150, 30);
    idTextField.textColor = [UIColor colorWithRed:152.0/255.0f green:152.0/255.0f blue:152.0/255.0f alpha:1.0];
    idTextField.textAlignment = NSTextAlignmentLeft;
    idTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    idTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    idTextField.font = [UIFont systemFontOfSize:16];
    idTextField.layer.cornerRadius = 1.0f;
    idTextField.returnKeyType = UIReturnKeyNext;
    idTextField.backgroundColor = [UIColor whiteColor];
    idTextField.tag = 100001;
    [bgView addSubview:idTextField];
    
    UILabel * passWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 180 + 45 + StatusBarHeight, 45, 30)];
    passWordLabel.backgroundColor = [UIColor clearColor];
    passWordLabel.text = @"密   码";
    passWordLabel.textAlignment = NSTextAlignmentLeft;
    passWordLabel.textColor = [UIColor whiteColor];
    passWordLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:passWordLabel];
    
    passwordTextField = [[UITextField alloc]init];
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.frame = CGRectMake(100, 180 + 45 + StatusBarHeight, 150, 30);
    passwordTextField.textColor = [UIColor colorWithRed:152.0/255.0f green:152.0/255.0f blue:152.0/255.0f alpha:1.0];
    passwordTextField.textAlignment = NSTextAlignmentLeft;
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.keyboardType = UIKeyboardTypeDefault;
    passwordTextField.font = [UIFont systemFontOfSize:16];
    passwordTextField.layer.cornerRadius = 1.0f;
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.tag = 100002;
    passwordTextField.secureTextEntry = YES;
    [bgView addSubview:passwordTextField];
    
    
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(100, 180 + 45 + 45 +StatusBarHeight, 60, 30);
    [loginButton setBackgroundImage:[UIImage imageNamed:@"fy_login_user"] forState:UIControlStateNormal];
    loginButton.showsTouchWhenHighlighted = YES;
    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:loginButton];
    
    UIButton * enterButton = [[UIButton alloc] initWithFrame:CGRectMake(170,180 + 45 + 45 +StatusBarHeight, 80, 30)];
    [enterButton setBackgroundImage:[UIImage imageNamed:@"fy_enter.png"] forState:UIControlStateNormal];
    [enterButton addTarget:self action:@selector(enterToListen) forControlEvents:UIControlEventTouchUpInside];
    enterButton.showsTouchWhenHighlighted = YES;
    [bgView addSubview:enterButton];
    
    
    if (self.view.frame.size.height < 500) {
        userNameLabel.frame = CGRectMake(50, 150 + StatusBarHeight, 45, 30);
        idTextField.frame = CGRectMake(100, 150 + StatusBarHeight , 150, 30);
        passWordLabel.frame = CGRectMake(50, 150 + 40 + StatusBarHeight, 45, 30);
        passwordTextField.frame = CGRectMake(100, 150 + 40 + StatusBarHeight, 150, 30);
        loginButton.frame = CGRectMake(100, 150 + 40 + 40 +StatusBarHeight, 60, 30);
        enterButton.frame = CGRectMake(170,150 + 40 + 40 +StatusBarHeight, 80, 30);
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showTopMenuWithStyle:kTopMenuStyleGoBack withTitle:@"用户登陆"];
    
    bgView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, 44 + StatusBarHeight, 320, self.view.frame.size.height -44 - StatusBarHeight)];
    bgView.contentSize = CGSizeMake(320, self.view.frame.size.height);
    bgView.tag = 8702;
    bgView.backgroundColor = [UIColor clearColor];
    bgView.userInteractionEnabled = YES;
    [bgView setScrollEnabled:YES];
    [bgView setShowsVerticalScrollIndicator:YES];
    [bgView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:bgView];
    
    
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(95, 15 + StatusBarHeight, 128, 133)];
    [logoImageView setImage:[UIImage imageNamed:@"fy_user_icon"]];
    [bgView addSubview:logoImageView];
    
    if (self.view.frame.size.height < 500) {
        logoImageView.frame = CGRectMake(95, 5 + StatusBarHeight, 128, 133);
    }
    
    [self initTextField];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFeildDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
