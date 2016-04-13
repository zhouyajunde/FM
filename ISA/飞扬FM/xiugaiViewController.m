//
//  xiugaiViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/2/24.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "xiugaiViewController.h"
#import "cnmwangjibaViewController.h"
#import "dierViewController.h"
#import "disanViewController.h"
#import "disiViewController.h"
#import "diwuViewController.h"
#import "diliuViewController.h"
#import "diqiViewController.h"
#import "ZYJdic.h"
#import "CZFooterView.h"
#import "MJExtension.h"
#import "HTTPManager.h"
#import "UserDefine.h"
#import "xiugaidexinxinViewController.h"
#import "ZYJItem.h"
#import "MBProgressHUD+NJ.h"
#import "ZYJFooterView.h"
#import "Statics.h"
#import "NSDictionary+Extension.h"

@interface xiugaiViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,wangjibaDelegate,dieraDelegate,disanaDelegate,disanaDelegate,diwuaDelegate,disiaDelegate,diliuaDelegate,logOutDelegate,diqiaDelegate,diaoboDelegate,wanchengDelegate>{
    UITableView *DataTable;
    UIView *nBarView;
    UIButton *bianjibutton;
   
    dierViewController *dier;
    disanViewController *disan;
    disiViewController *disi;
    diwuViewController *diwu;
    diliuViewController *diliu;
    diqiViewController *diqi;
    
    NSString *NAME,*_userId;
    NSMutableDictionary *result;
    
    ZYJpersonMessage *push;
    ZYJpersonMessage *shake;
}


@property(nonatomic,strong)NSMutableDictionary *dic;
@property(nonatomic,strong)ZYJdic *ZYJdic;



- (IBAction)tuichu:(id)sender;

@end

@implementation xiugaiViewController

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    result = [NSMutableDictionary dictionary];
    _dic = [defaults objectForKey:@"dic"];
    
    //用mj 字典转模型
    _ZYJdic = [ZYJdic mj_objectWithKeyValues:_dic];

    _userId = _ZYJdic.id;
    [self add0SectionItems];
    
    [self add1SectionItems];
    
    ZYJFooterView *footer = [ZYJFooterView footerView];
    
    footer.delegate  = self;
    
    self.tableView.tableFooterView = footer;
    
}
- (void)add0SectionItems
{
    
    NSLog(@"%@",_ZYJdic.name);
    
    NAME = _ZYJdic.name;
    
    push = [ZYJpersonMessage itemWithsubtitle:NAME title:@"昵称"];
    push.operation = ^{
        xiugaidexinxinViewController *xin = [[xiugaidexinxinViewController alloc]init];
        xin.delegate = self;
        xin.content = _ZYJdic.name;
        xin.section = 0;
        xin.row = 0;
        [self.navigationController pushViewController:xin animated:YES];
    };
    
    NSString *sex = [NSString new];
    if ([_ZYJdic.sex isEqualToString:@"0"]) {
        sex = @"女";
    }else if([_ZYJdic.sex isEqualToString:@"1"]){
        sex = @"男";
    }
    shake = [ZYJpersonMessage itemWithsubtitle:sex title:@"性别"];
    shake.operation = ^{
       
        cnmwangjibaViewController *xb = [[cnmwangjibaViewController alloc]init];
        xb.delegate = self;
        xb.view.frame = CGRectMake(0, 900, self.view.frame.size.width, 150);
        
        xb._nameArray = [NSMutableArray arrayWithObjects:@"男",@"女",nil];
        xb.section = 0;
        xb.row = 1;
        [self .view addSubview:xb.view];
        [UIView animateWithDuration:0.3 animations:^{
            xb.view.frame = CGRectMake(0, 420, self.view.frame.size.width,150);
        }];

    };

    
    ZYJpersonMessage *sound = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.age title:@"年龄"];
    
    sound.operation = ^{
        
        dier = [[dierViewController alloc]init];
        dier.delegate = self;
        dier.view.frame = CGRectMake(0, 900, self.view.frame.size.width, 150);
        dier._nameArray = [NSMutableArray arrayWithObjects:@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",nil];
        dier.section = 0;
        dier.row = 2;
      
        [self .view addSubview:dier.view];
        
        [UIView animateWithDuration:0.3 animations:^{
            dier.view.frame = CGRectMake(0, 420, self.view.frame.size.width,150);
        }];
        
    };

    
    ZYJShowGroup *group = [ZYJShowGroup groupWithItems:@[push, shake, sound]];
    [_allGroups addObject:group];
}


#pragma mark 添加第1组的模型数据
- (void)add1SectionItems
{
    ZYJpersonMessage *update = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.email title:@"邮箱"];
    update.operation = ^{
        xiugaidexinxinViewController *xin = [[xiugaidexinxinViewController alloc]init];
        xin.delegate = self;
        xin.content = _ZYJdic.email;
        xin.section = 1;
        xin.row = 0;
        [self.navigationController pushViewController:xin animated:YES];
    };
    
    NSString *car = [NSString new];
    if ([_ZYJdic.car isEqualToString:@"0"]) {
        car = @"普通用户";
    }else if ([_ZYJdic.car isEqualToString:@"1"]){
        car = @"车载用户";
    }

    ZYJpersonMessage *help = [ZYJpersonMessage itemWithsubtitle:car title:@"用户类型"];
    help.operation = ^{
        disan = [[disanViewController alloc]init];
        disan.delegate = self;
        disan.view.frame = CGRectMake(0, 900, self.view.frame.size.width, 150);
        disan.section = 1;
        disan.row = 1;
        disan._nameArray = [NSMutableArray arrayWithObjects:@"普通用户",@"车载用户",nil];
        
        [self .view addSubview:disan.view];
        
        [UIView animateWithDuration:0.3 animations:^{
            disan.view.frame = CGRectMake(0, 420, self.view.frame.size.width,150);
        }];

    };
   
    ZYJpersonMessage *share = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.job title:@"职业"];
    share.operation = ^{
        [[HTTPManager shareManager] getPath:zhixueURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *error = nil;
            
            NSData *jsonData = responseObject;
            
            if ([jsonData length]>0 && error == nil) {
                error = nil;
                
                id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
                
                if (jsonObj != nil && error == nil) {
                    NSMutableArray *detailArrayt = (NSMutableArray *)jsonObj;
                    
                    disi = [[disiViewController alloc]init];
                    disi.delegate = self;
                    disi.view.frame = CGRectMake(0, 900, self.view.frame.size.width, 150);
                    disi.section = 1;
                    disi.row = 2;
                    
                    disi._nameArray = [[NSMutableArray alloc]init];
                    for (int i=0 ;i < detailArrayt.count;i++) {
                        if ([[detailArrayt[i] objectForKey:@"type"] isEqualToString:@"1"]) {
                            
                            [disi._nameArray addObject:[detailArrayt[i] objectForKey:@"beijingxinxi"]];
                        }
                    }
                    
                    [self .view addSubview:disi.view];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        disi.view.frame = CGRectMake(0, 420, self.view.frame.size.width,150);
                    }];

                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

    };
    
    ZYJpersonMessage *msg = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.education title:@"学历"];
    msg.operation = ^{
        [[HTTPManager shareManager] getPath:zhixueURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *error = nil;
            
            NSData *jsonData = responseObject;
            
            if ([jsonData length]>0 && error == nil) {
                error = nil;
                
                id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
                
                if (jsonObj != nil && error == nil) {
                    NSMutableArray *detailArrayt = (NSMutableArray *)jsonObj;
                    
                    diwu = [[diwuViewController alloc]init];
                    diwu.delegate = self;
                    diwu.view.frame = CGRectMake(0, 900, self.view.frame.size.width, 150);
                    diwu.section = 1;
                    diwu.row = 3;
                    diwu._nameArray = [[NSMutableArray alloc]init];
                    
                    for (int i=0 ;i < detailArrayt.count;i++) {
                        if ([[detailArrayt[i] objectForKey:@"type"] isEqualToString:@"0"]) {
                            
                            [diwu._nameArray addObject:[detailArrayt[i] objectForKey:@"beijingxinxi"]];
                        }
                    }
                    
                    NSLog(@"%@",diwu._nameArray);
                    
                    [self .view addSubview:diwu.view];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        diwu.view.frame = CGRectMake(0, 420, self.view.frame.size.width,150);
                    }];
                    
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

    };
    ZYJpersonMessage *product = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.jifen title:@"积分"];
    
    ZYJpersonMessage *about = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.pi title:@"个人收入"];
    about.operation = ^{
        [[HTTPManager shareManager] getPath:zhixueURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *error = nil;
            
            NSData *jsonData = responseObject;
            
            if ([jsonData length]>0 && error == nil) {
                error = nil;
                
                id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
                
                if (jsonObj != nil && error == nil) {
                    NSMutableArray *detailArrayt = (NSMutableArray *)jsonObj;
                    
                    diliu = [[diliuViewController alloc]init];
                    diliu.delegate = self;
                    diliu.view.frame = CGRectMake(0, 900, self.view.frame.size.width, 150);
                    diliu.section = 1;
                    diliu.row = 5;
                    diliu._nameArray = [[NSMutableArray alloc]init];
                    
                    for (int i=0 ;i < detailArrayt.count;i++) {
                        if ([[detailArrayt[i] objectForKey:@"type"] isEqualToString:@"2"]) {
                            
                            [diliu._nameArray addObject:[detailArrayt[i] objectForKey:@"beijingxinxi"]];
                        }
                    }
                    [self .view addSubview:diliu.view];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        diliu.view.frame = CGRectMake(0, 420, self.view.frame.size.width,150);
                    }];
                    
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    };
    
    ZYJpersonMessage *jiating = [ZYJpersonMessage itemWithsubtitle:_ZYJdic.fi title:@"家庭收入"];
    jiating.operation = ^{
        [[HTTPManager shareManager] getPath:zhixueURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *error = nil;
            
            NSData *jsonData = responseObject;
            
            if ([jsonData length]>0 && error == nil) {
                error = nil;
                
                id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
                
                if (jsonObj != nil && error == nil) {
                    NSMutableArray *detailArrayt = (NSMutableArray *)jsonObj;
                    diqi = [[diqiViewController alloc]init];
                    diqi.delegate = self;
                    diqi.view.frame = CGRectMake(0, 900, self.view.frame.size.width, 150);
                    diqi.section = 1;
                    diqi.row = 6;
                    diqi._nameArray = [[NSMutableArray alloc]init];
                    
                    for (int i=0 ;i < detailArrayt.count;i++) {
                        if ([[detailArrayt[i] objectForKey:@"type"] isEqualToString:@"2"]) {
                            
                            [diqi._nameArray addObject:[detailArrayt[i] objectForKey:@"beijingxinxi"]];
                        }
                    }
                    [self .view addSubview:diqi.view];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        diqi.view.frame = CGRectMake(0, 420, self.view.frame.size.width,150);
                    }];
                    
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    };
    
    ZYJShowGroup *group = [ZYJShowGroup groupWithItems:@[update, help, share, msg, product, about,jiating]];
    [_allGroups addObject:group];
}
- (void)newMessageReceived:(NSString *)messageContent gundan:(NSUInteger)section indexPath:(NSUInteger)row{
    
    ZYJShowGroup *group = _allGroups[section];
    ZYJItem *item = group.items[row];
    
    if (section == 0 && row == 0) {
        

        result[@"name"] = messageContent;
    
    }else if (section == 0 && row == 1)
    {
        NSString *a =[NSString new];
        if ([messageContent isEqualToString:@"男"]) {
            a = @"1";
        }else
        {
            a = @"0";
        }
        
        result[@"sex"] = a;
    }else if (section == 0 && row == 2)
    {
        result[@"age"] = messageContent;
    }else if (section == 1 && row == 0)
    {
        result[@"email"] =  messageContent;
    }else if (section == 1 && row == 1)
    {
        NSString *a =[NSString new];
        if ([messageContent isEqualToString:@"普通用户"]) {
            a = @"0";
        }else
        {
            a = @"1";
        }
        result[@"car"] = a;
    }
    else if (section == 1 && row == 2)
    {
        result[@"job"] = messageContent;
    }else if (section == 1 && row == 3)
    {
        result[@"education"] = messageContent;
    }
    else if (section == 1 && row == 5)
    {
        result[@"pi"] = messageContent;
    }else if (section == 1 && row == 6){
        result[@"fi"] = messageContent;
    }
        NSLog(@"%@",_allGroups);

        item.subtitle = messageContent;
        
        NSLog(@"%@",_allGroups[section]);

        _allGroups[section] = group;
        
        [self.tableView reloadData];
}

-(void)xiugai:(NSString *)message gundan:(NSUInteger)section indexPath:(NSUInteger)row{
    ZYJShowGroup *group = _allGroups[section];
    ZYJItem *item = group.items[row];
    
    if (section == 0 && row == 0) {
      
        result[@"name"] = message;

    }    else if (section == 1 && row == 0)
    {
        result[@"email"] = message;
    }
    NSLog(@"%@",_allGroups);
    
    item.subtitle = message;
    
    NSLog(@"%@",_allGroups[section]);
    
    _allGroups[section] = group;
    
    [self.tableView reloadData];
}

- (IBAction)tuichu:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)tuichude{
    
    result[@"userId"] = _userId;
    
    [[HTTPManager shareManager]  postPath:xinixURL parameters:result success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
       
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            NSDictionary *detailDictionary = (NSDictionary *)jsonObj;

            
            if(![[detailDictionary allKeys] containsObject:@"id"])
            {
                
                [MBProgressHUD  hideHUD];
                [MBProgressHUD showError:@""];
                
            }else{
                
                [self personMessagel];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ss");
        
    }];
}
-(void)personMessagel

{
    result[@"userId"] = _userId;
    
    [[HTTPManager shareManager]  getPath:personMessage parameters:result success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        [MBProgressHUD showMessage:@"正在修改"];
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            NSArray *detailDictionary = (NSArray *)jsonObj;
       
            NSDictionary *dic = detailDictionary[0];
            
            if(![[dic allKeys] containsObject:@"id"])
            {
                [MBProgressHUD  hideHUD];
                [MBProgressHUD showError:@""];
                
            }else{
            
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
                
                detailDictionary = [NSDictionary safeDictionaryWithDic:dic];
                
                [defaults setObject:detailDictionary forKey:@"dic"];
                
                //这里建议同步存储到磁盘中，但是不是必须的
                [defaults synchronize];
                
                [MBProgressHUD  hideHUD];
                [MBProgressHUD showSuccess:@"修改成功"];
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ss");
        
    }];

    
}

@end
