//
//  dianzanViewController.m
//  飞扬FM
//
//  Created by Mac os on 15/10/12.
//  Copyright © 2015年 SFware. All rights reserved.
//

#import "dianzanViewController.h"
#import "UserDefine.h"
#import "Statics.h"
#import "ReturnDeviceType.h"

#import "MJExtension.h"
#import "HTTPManager.h"

#import "MBProgressHUD+NJ.h"
@interface dianzanViewController ()

@property (nonatomic, weak) HTTPManager *mgr;
@end


@implementation dianzanViewController
@synthesize yijianuser;

#pragma mark - 懒加载
- (HTTPManager *)mgr
{
    if (!_mgr) {
        _mgr = [HTTPManager shareManager];
    }
    return _mgr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    jisuan = YES;
    daozan= YES;
    yijianuser.clearsContextBeforeDrawing = YES;
    yijianuser.returnKeyType = UIReturnKeyDone;
    xingxing = NO;
    unmber = @"0";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    NSDictionary *_dic = [defaults objectForKey:@"dic"];

    userId = [_dic objectForKey:@"id"];
    
      programmeId = self.program;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)diyi:(id)sender {
    if (xingxing) {
        [self.one setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
        [self.two setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
        [self.tre setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
        [self.four setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
        [self.five setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
        xingxing = NO;
          unmber = @"0";
    }
    else{
        [self.one setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
        [self.two setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
        [self.tre setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
        [self.four setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
        [self.five setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
        xingxing = YES;
          unmber = @"1";
    }
    
}

- (IBAction)dier:(id)sender {
    [self.one setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
    [self.two setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
    [self.tre setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
    [self.four setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
    [self.five setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
     unmber = @"2";

}

- (IBAction)disan:(id)sender {
    [self.one setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
    [self.tre setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
    [self.two setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
    [self.four setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
    [self.five setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
     unmber = @"3";
}

- (IBAction)disi:(id)sender {
    [self.one setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
    [self.tre setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
    [self.four setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
    [self.two setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
    [self.five setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
     unmber = @"4";
}

- (IBAction)diwu:(id)sender {
    [self.one setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
    [self.two setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
    [self.tre setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
    [self.four setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
    [self.five setImage:[UIImage imageNamed:@"star_selected.png"] forState:UIControlStateNormal];
     unmber = @"5";
}

- (IBAction)dianzan:(id)sender {
    if (jisuan) {
        [self.dianzan setBackgroundImage: [UIImage imageNamed:@"dianzan_selected.png"] forState:UIControlStateNormal];
        [self.diandaozan setBackgroundImage:[UIImage imageNamed:@"no_dianzan.png"] forState:UIControlStateNormal];
        jisuan = NO;
        daozan = YES;
        
        _unmberber = @"1";
        [self dianzainn];
           }
    else{
          [self.dianzan setBackgroundImage:[UIImage imageNamed:@"dianzan.png"] forState:UIControlStateNormal];
        jisuan = YES;
    }
  
}
- (void)dianzainn{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = userId;
    parameters[@"programmeId"] = programmeId;
    parameters[@"number"] = _unmberber;
    
    [self.mgr getPath:dianzanUrL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSString *aStr = (NSString *)jsonObj;
            //字典数组转模型数组
            
            if ( [aStr intValue] == 5) {
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"点赞成功"];
                return;
            }
            else  if ([aStr intValue] == 1) {
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"今天已经点过赞了！"];
                return;
            }
            else if ([aStr intValue] == 4) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"变倒为顶！"];
                
                return;
            }
            else if ( [aStr intValue] == 3) {
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"变顶为倒！"];
                
                return;
            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ss");
        
    }];


}

- (IBAction)dianzaib:(id)sender {
    if (daozan) {
        [self.diandaozan setBackgroundImage: [UIImage imageNamed:@"no_dianzan_selected.png"] forState:UIControlStateNormal];
        [self.dianzan setBackgroundImage:[UIImage imageNamed:@"dianzan.png"] forState:UIControlStateNormal];
        daozan = NO;
        jisuan = YES;
        _unmberber = @"-1";
        [self dianzainn];
        
    }
    else{
        [self.diandaozan setBackgroundImage:[UIImage imageNamed:@"no_dianzan.png"] forState:UIControlStateNormal];
        daozan = YES;
    }

}

- (IBAction)tijiaopj:(id)sender {
    
 
    pinglun = [Statics encodeToPercentEscapeString:(yijianuser.text)];

    if (pinglun.length == 0) {
        return;
    }
//    pinglun = yijianuser.text;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = userId;
    parameters[@"programmeId"] = programmeId;
    parameters[@"number"] = _unmberber;
    parameters[@"pinglun"] = yijianuser.text;

    [self.mgr postPath:pingfenUrL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSString *aStr = (NSString *)jsonObj;
            //字典数组转模型数组
            
            if ( [aStr intValue] == -1) {
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"今天已经评论过了！"];
                return;
            }
            else  if ([aStr intValue] == 1) {
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"评论成功！"];
                return;
            }
            else if ([aStr intValue] == 0) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"参数错误！"];
                
                return;
            }
        }
        
    [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ss");
        
    }];
}

- (IBAction)quxiao:(id)sender {
    [self.one setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
    [self.two setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
    [self.tre setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
    [self.four setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
    [self.five setImage:[UIImage imageNamed:@"star_no_select.png"] forState:UIControlStateNormal];
    
    [self.dianzan setBackgroundImage: [UIImage imageNamed:@"dianzan.png.png"] forState:UIControlStateNormal];
    [self.diandaozan setBackgroundImage:[UIImage imageNamed:@"no_dianzan.png"] forState:UIControlStateNormal];

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
