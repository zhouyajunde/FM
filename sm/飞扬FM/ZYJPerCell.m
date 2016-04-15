//
//  ZYJPerCell.m
//  飞扬FM
//
//  Created by Mac os on 16/1/20.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJPerCell.h"
#import "ZYJShowArrowitem.h"
#import "ZYJShowItem.h"
#import "ZYJList.h"
#import "UserDefine.h"
#import "ZYJseting.h"
#import "ZYJpersonMessage.h"
#import "PreHelper.h"

const int ILCellMargin = 10;

@interface ZYJPerCell()
{
    UIImageView *_arrow;
    UISwitch *_switch;
    UILabel *_label;
    UIView *_divider;
}
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation ZYJPerCell

+ (instancetype)settingCellWithTableView:(UITableView *)tableView
{
    // 0.用static修饰的局部变量，只会初始化一次
    static NSString *ID = @"hero";
    
    // 1.拿到一个标识先去缓存池中查找对应的Cell
    ZYJPerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 2.如果缓存池中没有，才需要传入一个标识创建新的Cell
    if (cell == nil) {
        cell = [[ZYJPerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.tableView = tableView;
    }

    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_top1"]];
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1.设置背景
        [self setupBg];
        
        // 2.设置子控件属性
        [self setupSubviews];
        
        // 3.添加分隔线
        [self setupDivider];
    }
    return self;
}
#pragma mark 分隔线
- (void)setupDivider
{
    _divider = [[UIView alloc] init];
    _divider.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"user_info_nav"]];
    [self.contentView addSubview:_divider];
}

#pragma mark 设置行号
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    _divider.hidden = indexPath.row == 0;
}

#pragma mark 设置子控件属性
- (void)setupSubviews
{
    // 1.文字颜色
    self.textLabel.backgroundColor = [UIColor whiteColor];
    self.detailTextLabel.backgroundColor = [UIColor whiteColor];
    
    // 2.文字大小
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    self.detailTextLabel.textColor = (__bridge UIColor * _Nullable)([[PreHelper colorWithHexString:@"87b4cc"] CGColor]);
    self.textLabel.textColor = [UIColor whiteColor];
    
}

#pragma mark 设置背景
- (void)setupBg
{
//    // 1.默认
//    UIView *bg = [[UIView alloc] init];
//    
//    bg.backgroundColor = [UIColor redColor];
////    [bg addSubview:iv];
//     self.backgroundView = bg;
//   
//    // 2.选中
    UIView *selectedBg = [[UIView alloc] init];
    selectedBg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"user_info_nav"]];
    self.selectedBackgroundView = selectedBg;
}
- (void)setFrame:(CGRect)frame
{
    if (!iOS7) {
        frame.origin.x = - ILCellMargin;
        frame.size.width = [UIScreen mainScreen].bounds.size.width + ILCellMargin * 2;
    }
    [super setFrame:frame];
}

#pragma mark 当cell的宽高改变了就会调用
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _divider.frame = CGRectMake(self.textLabel.frame.origin.x, 0, self.contentView.frame.size.width, 1.2);
    
    if (iOS7) return;
    
    // 右边控件的frame
    CGRect accessF = self.accessoryView.frame;
    accessF.origin.x = self.frame.size.width - accessF.size.width - ILCellMargin * 2;
    self.accessoryView.frame = accessF;
}


- (void)setItem:(ZYJItem *)item
{
    _item = item;
    
    // 设置数据
    self.imageView.image = [UIImage imageNamed:item.icon];
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subtitle;
 
    
    if ([item isKindOfClass:[ZYJList class]]) {
        [self settingArrow];
    } else if ([item isKindOfClass:[ZYJseting class]]) {
       [self settingArrow];
    } else if ([item isKindOfClass:[ZYJList class]]) {
//        [self settingLabel];
    } else {
        // 什么也没有，清空右边显示的view
        self.accessoryView = nil;
        // 用默认的选中样式
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

#pragma mark 设置右边的箭头
- (void)settingArrow
{
    if (_arrow == nil) {
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go"]];
    }
    
    // 右边显示箭头
    self.accessoryView = _arrow;
    // 用默认的选中样式
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

@end
