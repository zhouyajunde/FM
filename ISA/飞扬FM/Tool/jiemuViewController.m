//
//  jiemuViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/2/22.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "jiemuViewController.h"
#import "UserDefine.h"
#import "jiemuCell.h"
#import "jiemuD.h"
#import "MJExtension.h"

//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f


//设备物理尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height



@interface jiemuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)bac:(id)sender;

@end

@implementation jiemuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _allGroups = [NSMutableArray array];
    
    _allGroups = __alljiemu ;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 设置背景

    _tableView.backgroundColor = [UIColor clearColor];
    //    tableView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
    
    // 分隔线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    [self.view addSubview:_tableView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allGroups.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*KWidth_Scale;
}

#pragma mark 点击了cell后的操作

#pragma mark 每当有一个cell进入视野范围内就会调用，返回当前这行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    jiemuCell *cell = [jiemuCell shoucangCellWithTabView:tableView];
    //2 设置cell内部的子控件
    
    NSDictionary *sc = _allGroups[indexPath.row];
    
    cell.model = [jiemuD mj_objectWithKeyValues:sc];
    
    //返回
    return cell;
 }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 去除选中时的背景
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (IBAction)bac:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}
- (UITableViewCellAccessoryType)tableView:(UITableView*)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath
{
    int current = 0;
    
    for (current ; current < _allGroups.count; current++) {
        
        NSString *a = [NSString stringWithFormat:@"%@",self.timeMn];
        NSString *b = [NSString stringWithFormat:@"%@",[_allGroups[current] objectForKey:@"starttime"]];
        
        if ( [a isEqualToString: b]) {
           
            break;
        }
    }
    
    if(current==indexPath.row)
    {
        return UITableViewCellAccessoryCheckmark;
    }
    else
    {
        return UITableViewCellAccessoryNone;
    }
}

@end
