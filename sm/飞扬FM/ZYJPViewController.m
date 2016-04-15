//
//  ZYJPViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/20.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJPViewController.h"
#import "UserDefine.h"
#import "ZYJShowGroup.h"
#import "ZYJItem.h"
#import "ZYJPerCell.h"
#import "ZYJList.h"

//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f


//设备物理尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height


const int ILTableViewHeaderH = 10;


@interface ZYJPViewController ()

@end

@implementation ZYJPViewController

- (void)loadView
{
    _allGroups = [NSMutableArray array];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height*0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];

    tableView.delegate = self;
    tableView.dataSource = self;
    
    // 设置背景
    tableView.backgroundView = nil;
//    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
    
    tableView.backgroundColor = [UIColor clearColor];
    // 分隔线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.sectionFooterHeight = 0;
    tableView.sectionHeaderHeight = ILTableViewHeaderH;
    
    if (iOS7) {
        tableView.contentInset = UIEdgeInsetsMake(ILTableViewHeaderH-35, 0, 0, 0);
    }
    
    UIView *view　= [[UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    　
    self.view = view;
      [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]]] ;
     _tableView = tableView;
    
//     self.view = tableView;
    [self.view addSubview:_tableView];
//    _tableView = tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65*KWidth_Scale;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZYJShowGroup *group = _allGroups[section];
    return group.items.count;
}

#pragma mark 每当有一个cell进入视野范围内就会调用，返回当前这行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建一个ILSettingCell
    ZYJPerCell *cell = [ZYJPerCell settingCellWithTableView:tableView];
    
    // 2.取出这行对应的模型（ILSettingItem）
    ZYJShowGroup *group = _allGroups[indexPath.section];
    cell.item = group.items[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark 点击了cell后的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 去除选中时的背景
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 0.取出这行对应的模型
    ZYJShowGroup *group = _allGroups[indexPath.section];
    ZYJItem *item = group.items[indexPath.row];
    
    // 1.取出这行对应模型中的block代码
//    if (item.operation) {
//        // 执行block
//        item.operation();
//        return;
//    }
//    
//    // 2.检测有没有要跳转的控制器
    if ([item isKindOfClass:[ZYJList class]]) {
        ZYJList *arrowItem = (ZYJList *)item;
        if (arrowItem.showVCClass) {
        
            if ((long)indexPath.row == 0) {
                [self performSegueWithIdentifier:@"per2shoucang" sender:nil];
            }else if ((long)indexPath.row == 1){
                [self performSegueWithIdentifier:@"per2zuijin" sender:nil];
            }else if ((long)indexPath.row == 2){
                [self performSegueWithIdentifier:@"per2yue" sender:nil];
            }else if ((long)indexPath.row == 3){
                [self performSegueWithIdentifier:@"per2duihuan" sender:nil];
            }else if ((long)indexPath.row == 4){
                [self performSegueWithIdentifier:@"per2wenjuan" sender:nil];
            }
//            UIViewController *vc = [[arrowItem.showVCClass alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        
            if ((long)indexPath.row == 0) {
                [self performSegueWithIdentifier:@"per2dingshi" sender:nil];
            }else if ((long)indexPath.row == 1){
                [self performSegueWithIdentifier:@"per2setting" sender:nil];
            }
    }
}

#pragma mark 返回每一组的header标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ZYJShowGroup *group = _allGroups[section];
    
    return group.header;
}
#pragma mark 返回每一组的footer标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    ZYJShowGroup *group = _allGroups[section];
    
    return group.footer;
}

@end
