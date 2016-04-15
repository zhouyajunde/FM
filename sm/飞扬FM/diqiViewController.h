//
//  diqiViewController.h
//  飞扬FM
//
//  Created by Mac os on 15/12/7.
//  Copyright © 2015年 SFware. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol diqiaDelegate <NSObject>

- (void)newMessageReceived:(NSString *)messageContent  gundan:(NSUInteger)section indexPath:(NSUInteger)row;

@end
@interface diqiViewController :  UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic)     NSMutableArray *_nameArray;
@property (nonatomic,assign)NSUInteger section;
@property (nonatomic,assign)NSUInteger row;

@property (nonatomic,strong)UIControl *playerView;
@property (nonatomic , assign) id<diqiaDelegate> delegate;


@end
