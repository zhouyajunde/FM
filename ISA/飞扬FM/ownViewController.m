//
//  ownViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/12.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ownViewController.h"
#import "ZYJChangePwdViewController.h"
#import "MJExtension.h"
#import "ZYJdic.h"
#import "CZFooterView.h"
#import "UserDefine.h"
#import "xiugaiViewController.h"

@interface ownViewController ()

- (IBAction)pertobianji:(id)sender;


@end

@implementation ownViewController

-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (IBAction)pertobianji:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    xiugaiViewController *xiu = [sb instantiateViewControllerWithIdentifier:@"zhucetoxiugai"];
    
    [self.navigationController pushViewController:xiu animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
    
    // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    _dic = [defaults objectForKey:@"dic"];
    
    //用mj 字典转模型
    _ZYJdic = [ZYJdic mj_objectWithKeyValues:_dic];
    
    
    [self addSectionItems];
    
    [self add0SectionItems];
 
    [self add1SectionItems];
    
    CZFooterView *footer = [CZFooterView footerView];
    
    footer.delegate  = self;
    
    self.tableView.tableFooterView = footer;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

//退出的按钮要代理执行

-(void)tuichu{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"dic"];
    
    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    NSNotification *notification = [NSNotification notificationWithName:@"tuichuLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
}


#pragma mark 添加第0组的模型数据
- (void)addSectionItems
{
    
    ZYJpersonImg *push = [ZYJpersonImg itemWithIcon:_ZYJdic.headimg title:@"头像"];
    push.operation= ^{
    
    };
   
    ZYJShowGroup *group = [ZYJShowGroup groupWithItems:@[push]];
    [_allGroups addObject:group];
}

- (void)add0SectionItems
{
  
    NSLog(@"%@",_ZYJdic.name);
    
    ZYJpersonMessage *push = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.name title:@"昵称"];
    //    push.showVCClass = [NJPushNoticeViewController class];

    NSString *sex = _ZYJdic.sex;
    if ([_ZYJdic.sex isEqualToString:@"0"]) {
        sex = @"女";
    }else if([_ZYJdic.sex isEqualToString:@"1"]){
        sex = @"男";
    }
    ZYJpersonMessage *shake = [ZYJpersonMessage itemWithsubtitle:sex title:@"性别"];
    
    //    shake.key = NJSettingShakeChoose;
 
    ZYJpersonMessage *sound = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.age title:@"年龄"];
   
    ZYJShowGroup *group = [ZYJShowGroup groupWithItems:@[push, shake, sound]];
    [_allGroups addObject:group];
}

#pragma mark 添加第1组的模型数据
- (void)add1SectionItems
{
      ZYJpersonMessage *update = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.email title:@"邮箱"];
    
//    update.operation = ^{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"目前已是最新版本了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    };
    NSString *car = [NSString new];
    if ([_ZYJdic.car isEqualToString:@"0"]) {
        car = @"普通用户";
    }else if([_ZYJdic.car isEqualToString:@"1"]){
        car = @"车载用户";
    }
    
    // 2.2.帮助
    ZYJpersonMessage *help = [ZYJpersonMessage itemWithsubtitle:car title:@"用户类型"];
//    help.showVCClass = [NJHelpViewController class];
    
    // 2.3.分享
    ZYJpersonMessage *share = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.job title:@"职业"];
//    share.showVCClass = [NJShareViewController class];
    
    // 2.4.查看消息
    ZYJpersonMessage *msg = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.education title:@"学历"];
    
    // 2.5.产品推荐
    ZYJpersonMessage *product = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.jifen title:@"积分"];
//    product.showVCClass = [NJProductsViewController class];
    
    // 2.6.关于
    ZYJpersonMessage *about = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.pi title:@"个人收入"];
//    about.showVCClass = [NJAboutViewController class];
    
    ZYJpersonMessage *jiating = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.fi title:@"家庭收入"];
    //    jiating.showVCClass = [NJAboutViewController class];
    
    ZYJShowArrowitem *chongzhi = [ZYJShowArrowitem itemWithsubtitle:@"" title:@"重置密码"];
    chongzhi.showVCClass = [ZYJChangePwdViewController class];
    
    ZYJShowArrowitem *duihuan = [ZYJShowArrowitem itemWithsubtitle:@"" title:@"兑换记录"];
    
    ZYJShowGroup *group = [ZYJShowGroup groupWithItems:@[update, help, share, msg, product, about,jiating,chongzhi,duihuan]];
    [_allGroups addObject:group];
}


@end
