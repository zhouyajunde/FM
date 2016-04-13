//
//  xiugaidexinxinViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/2/24.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "xiugaidexinxinViewController.h"


@interface xiugaidexinxinViewController ()


- (IBAction)wanchengBtn:(id)sender;

@end

@implementation xiugaidexinxinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
    self.contentLab.text = self.content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)wanchengBtn:(id)sender {
    
    [_delegate xiugai:self.contentLab.text gundan:_section indexPath:_row];
    [self.navigationController popViewControllerAnimated:YES];

}


-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}


@end
