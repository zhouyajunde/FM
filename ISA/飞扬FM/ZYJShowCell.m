//
//  ZYJShowCell.m
//  飞扬FM
//
//  Created by Mac os on 16/1/19.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJShowCell.h"
#import "ZYJShowItem.h"
#import "ZYJpersonImg.h"
#import "ZYJpersonMessage.h"
#import "ZYJShowArrowitem.h"
#import "UserDefine.h"
#import "ZYJSettingSwitchItem.h"
#import "ZYJyinzhisettingde.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+header.h"
#import "UIImage+Image.h"

const int YILCellMargin = 10;
@interface ZYJShowCell()
{
    UIImageView *_arrow;
    UISwitch *_switch;
    UILabel *_label;
    UIView *_divider;
}
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation ZYJShowCell


+ (instancetype)settingCellWithTableView:(UITableView *)tableView
{
    // 0.用static修饰的局部变量，只会初始化一次
    static NSString *ID = @"Cell";
    
    // 1.拿到一个标识先去缓存池中查找对应的Cell
    ZYJShowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 2.如果缓存池中没有，才需要传入一个标识创建新的Cell
    if (cell == nil) {
        cell = [[ZYJShowCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
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

#pragma mark 设置背景
- (void)setupBg
{
//    // 1.默认
//    UIView *bg = [[UIView alloc] init];
////    bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_top1"]];
//    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,bg.frame.size.width,bg.frame.size.height)];
//
//    self.backgroundView = iv;
    
    // 2.选中
    UIView *selectedBg = [[UIView alloc] init];
    selectedBg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"user_info_nav"]];
    self.selectedBackgroundView = selectedBg;
}



- (void)setItem:(ZYJShowItem *)item
{
    _item = item;
    // 设置数据
    
//    UIImage *img = [UIImage bs_circleImageNamed:@"item.icon"];
    
    self.imageView.image =  [UIImage bs_circleImageNamed:@"item.icon"];
    
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subtitle;
    
    if ([item isKindOfClass:[ZYJpersonMessage class]]){
//        [self settingMessage];
    }else if ([item isKindOfClass:[ZYJpersonImg class]]){
        [self settingImg];
    }else if ([item isKindOfClass:[ZYJShowArrowitem class]]){
         [self settingArrow];
    }else if ([item isKindOfClass:[ZYJSettingSwitchItem class]]){
        [self settingSwitch];
    }else if ([item isKindOfClass:[ZYJyinzhisettingde class]]){
//        [self settingSwitch];
    }
    else {
        // 什么也没有，清空右边显示的view
        self.accessoryView = nil;
        // 用默认的选中样式
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
}
#pragma mark 设置右边的开关
- (void)settingSwitch
{
    if (_switch == nil) {
        _switch = [[UISwitch alloc] init];
        [_switch addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];
    }
    
    ZYJSettingSwitchItem *switchItem = (ZYJSettingSwitchItem *)_item;
    _switch.on = !switchItem.isOff;
    
    // 右边显示开关
    self.accessoryView = _switch;
    // 禁止选中
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)switchChange
{
    ZYJSettingSwitchItem *switchItem = (ZYJSettingSwitchItem *)_item;
    switchItem.off = !_switch.isOn;
    
    if (_switch.isOn) {
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:@"1" forKey:@"net"];
        
        [defaults synchronize];
        
    }else{
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:@"0" forKey:@"net"];
        
        [defaults synchronize];
    }
    
}


- (void)settingImg
{
    
     self.textLabel.text = @"";
    
    UIImage *placeholder = [UIImage imageNamed:@"user_info.png"];
    
    NSString *filrfileURL = zongdizhiURL;
    
    NSString *url = [filrfileURL stringByAppendingString:[NSString stringWithFormat:@"%@",_item.icon]];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
    
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

#pragma mark 设置子控件属性
- (void)setupSubviews
{
    // 1.文字颜色
    self.textLabel.backgroundColor = [UIColor whiteColor];
    self.detailTextLabel.backgroundColor = [UIColor whiteColor];
    
    // 2.文字大小
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.detailTextLabel.font = [UIFont systemFontOfSize:13];
    self.detailTextLabel.textColor = [UIColor whiteColor];
    self.textLabel.textColor = [UIColor whiteColor];

}

- (void)setFrame:(CGRect)frame
{
    if (!iOS7) {
        frame.origin.x = - YILCellMargin;
        frame.size.width = [UIScreen mainScreen].bounds.size.width + YILCellMargin * 2;
    }
    [super setFrame:frame];
}


#pragma mark 当cell的宽高改变了就会调用
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _divider.frame = CGRectMake(self.textLabel.frame.origin.x, 0, self.contentView.frame.size.width + 100, 1.2);
    
    if (iOS7) return;
    
    // 右边控件的frame
    CGRect accessF = self.accessoryView.frame;
    accessF.origin.x = self.frame.size.width - accessF.size.width - YILCellMargin * 2;
    self.accessoryView.frame = accessF;
}


#pragma mark 设置右边的文本标签
- (void)settingLabel
{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.bounds = CGRectMake(0, 0, 100, self.frame.size.height);
        _label.textAlignment = NSTextAlignmentRight;
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = NJColor(173, 69, 14);
        _label.font = [UIFont systemFontOfSize:13];
        _label.text = @"00:00";
    }
    
    // 右边显示标签
    self.accessoryView = _label;
    // 用默认的选中样式
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

//- (void)initWithStyle:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//}
@end
