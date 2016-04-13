//
//  xinxideViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/2/24.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "xinxideViewController.h"
#import "UserDefine.h"
#import "ZYJShowCell.h"
#import "ZYJShowGroup.h"

//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f


//设备物理尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height


const int popoLTableViewHeaderH = 10;


@interface xinxideViewController ()

@end

@implementation xinxideViewController
- (void)loadView
{
    
    
    _allGroups = [NSMutableArray array];
    
    //    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame style:UITableViewStyleGrouped];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height*0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    // 设置背景
    tableView.backgroundView = nil;
    
    tableView.backgroundColor = [UIColor clearColor];
    //    tableView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
    
    // 分隔线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.sectionFooterHeight = 0;
    tableView.sectionHeaderHeight = popoLTableViewHeaderH;
    
    if (iOS7) {
        tableView.contentInset = UIEdgeInsetsMake(popoLTableViewHeaderH-35, 0, 0, 0);
    }
    UIView *view　= [[UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    　
    self.view = view;
    [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]]] ;
    _tableView = tableView;
    
    [self.view addSubview:_tableView];
    //      self.view = tableView;
    //
    //    _tableView = tableView;
    
    
}

//每一个分组下对应的tableview 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*KWidth_Scale;
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
    ZYJShowCell *cell = [ZYJShowCell settingCellWithTableView:tableView];
    
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
    ZYJShowItem *item = group.items[indexPath.row];
    
    // 1.取出这行对应模型中的block代码
    if (item.operation) {
        // 执行block
        item.operation();
        return;
    }
    
    // 2.检测有没有要跳转的控制
    
    NSLog(@"%ld",(long)indexPath.row);
    if ([item isKindOfClass:[ZYJShowArrowitem class]]) {
        ZYJShowArrowitem *arrowItem = (ZYJShowArrowitem *)item;
        //        if (arrowItem.showVCClass) {
        //            UIViewController *vc = [[arrowItem.showVCClass alloc] init];
        //            [self.navigationController pushViewController:vc animated:YES];
        //        }
        
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
