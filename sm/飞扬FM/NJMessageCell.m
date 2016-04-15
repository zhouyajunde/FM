//
//  NJMessageCell.m
//  01-QQ聊天
//
//  Created by apple on 14-5-30.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "NJMessageCell.h"
#import "NJMessageFrameModel.h"
#import "NJMessageModel.h"
#import "UIImage+liaoTian.h"
#import "UserDefine.h"
#import "Utility.h"

#define KFacialSizeWidth 24
#define KFacialSizeHeight 24

#define kContentFontSize        16.0f   //内容字体大小
#define kPadding                5.0f    //控件间隙
#define kEdgeInsetsWidth       20.0f   //内容内边距宽度


@interface NJMessageCell ()
/**
 * 时间
 */
@property (nonatomic, weak) UILabel *timeLabel;
/**
 *  正文
 */
@property (nonatomic, weak) UIButton *contentBtn;
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;

/** 文字内容视图 */
@property (nonatomic, retain) UILabel *contentLabel;


@end

@implementation NJMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"message";
    NJMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NJMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

/*
 重写init方法是为让类一创建出来就拥有某些属性
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 添加将来有可能用到的子控件
        // 1.添加时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        // 2.添加正文
        UIButton *contentBtn = [[UIButton alloc] init];
        contentBtn.titleLabel.font = NJTextFont;
        [contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 设置自动换行
        contentBtn.titleLabel.numberOfLines = 0;
        
        // contentBtn.backgroundColor = [UIColor redColor];
        
        // contentBtn.titleLabel.backgroundColor = [UIColor purpleColor];
        
        [self.contentView addSubview:contentBtn];
        self.contentBtn = contentBtn;
        
        //初始化正文视图
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:kContentFontSize];
        _contentLabel.numberOfLines = 0;
        [ self.contentBtn addSubview:_contentLabel];

        
        // 3.添加头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        // 4.清空cell的背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        // 5.设置按钮的内边距
        /*
         CGFloat top, 
         CGFloat left, 
         CGFloat bottom, 
         CGFloat right
         */
        self.contentBtn.contentEdgeInsets = UIEdgeInsetsMake(NJEdgeInsetsWidth, NJEdgeInsetsWidth, NJEdgeInsetsWidth, NJEdgeInsetsWidth);
    }
    return self;
}

- (void)setMessageFrame:(NJMessageFrameModel *)messageFrame
{
    _messageFrame = messageFrame;
    /*
    // 1.设置子控件的数据
    [self settingData];
    // 2.设置子控件的frame
    [self settingFrame];
     */
    // 0. 获取数据模型
    
    [self settingFrame];
    NJMessageModel *message = _messageFrame.message;
    
    // 1.设置时间
    self.timeLabel.text = message.time;
    self.timeLabel.frame = _messageFrame.timeF;
    
    // 2.设置头像
    if (NJMessageModelTypeMe == message.type) {

        // 自己发的
        self.iconView.image = [UIImage imageNamed:@"me"];
    }else
    {
        self.iconView.image = [UIImage imageNamed:@"other"];
    }
    self.iconView.frame = _messageFrame.iconF;

    // 1、计算文字的宽高
    float textMaxWidth = fDeviceWidth-40-kPadding *2-60; //60是消息框体距离右侧或者左侧的距离
    
    //    NSMutableAttributedString *attrStr = [Utility emotionStrWithString:_message.content];
    NSMutableAttributedString *attrStr = [Utility emotionStrWithString:message.text plistName:@"emoticons.plist" y:-8];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:kContentFontSize]
                    range:NSMakeRange(0, attrStr.length)];
    CGSize textSize = [attrStr boundingRectWithSize:CGSizeMake(textMaxWidth, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                            context:nil].size;
    
    _contentLabel.attributedText = attrStr;
    
    _contentLabel.frame = CGRectMake(kEdgeInsetsWidth, kEdgeInsetsWidth, textSize.width, textSize.height);
    // 2、计算背景图片的frame，X坐标发送和接收计算方式不一样
    CGFloat bgY = CGRectGetMinY(_iconView.frame);
    CGFloat width = textSize.width + kEdgeInsetsWidth*2;
    CGFloat height = textSize.height + kEdgeInsetsWidth*2;
    UIImage *bgImage; //声明一个背景图片对象
    UIImage *bgHighImage;
    // 3、判断是否为自己发送，来设置frame以及背景图片
    if (NJMessageModelTypeMe == message.type) { //如果是自己发送的
        CGFloat bgX = fDeviceWidth-kPadding*2-CGRectGetWidth(_iconView.frame)-width;
        _contentBtn.frame = CGRectMake(bgX,bgY, width, height);
        [_contentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        bgImage = [UIImage resizableImageWithName:@"chat_send_nor"];
        bgHighImage = [UIImage resizableImageWithName:@"chat_send_press_pic"];
    } else {
        CGFloat bgX = CGRectGetMaxX(_iconView.frame)+5;
        _contentBtn.frame = CGRectMake(bgX, bgY, width, height);
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bgImage = [UIImage resizableImageWithName:@"chat_recive_nor"];
        bgHighImage = [UIImage resizableImageWithName:@"chat_recive_press_pic"];
    }
    [_contentBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [_contentBtn setBackgroundImage:bgHighImage forState:UIControlStateHighlighted];
    
//    CGFloat upX=0;
    
//    if ([message.text hasPrefix:@"-"]&&[message.text hasSuffix:@"-"]) {
//        NSString *imageName=[message.text substringWithRange:NSMakeRange(1, message.text.length-2)];
//        
//        NSString* s = [NSString stringWithFormat:@"f_static_%@.png",imageName];
//        UIImage *img=[UIImage imageNamed:s];
//        
//        [img drawInRect:CGRectMake(upX, 0, KFacialSizeWidth, KFacialSizeHeight)];
//        upX=KFacialSizeWidth+upX;
//
//        [self.contentBtn setImage:img forState:UIControlStateNormal];
//
//    }else {
//        
//    }
    
//    
//    self.contentBtn.frame = _messageFrame.textF;
//    
//    // 4.设置背景图片
//    UIImage *newImage =  nil;
//    if (NJMessageModelTypeMe == message.type) {
//    
//        newImage = [UIImage resizableImageWithName:@"chat_send_nor"];
//
//    }else
//    {
//        // 别人发的
//        newImage = [UIImage resizableImageWithName:@"chat_recive_nor"];
//    }
//    [self.contentBtn setBackgroundImage:newImage forState:UIControlStateNormal];
}

-(void)settingFrame
{
    
}

// 分类是在不改变原有类的情况下为原有类增加一些新的方法

- (UIImage *)resizableImageWithName:(NSString *)imageName
{
    
    // 加载原有图片
    UIImage *norImage = [UIImage imageNamed:imageName];
    // 获取原有图片的宽高的一半
    CGFloat w = norImage.size.width * 0.5;
    CGFloat h = norImage.size.height * 0.5;
    // 生成可以拉伸指定位置的图片
    UIImage *newImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];

    return newImage;
}

@end
