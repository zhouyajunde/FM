//
//  disanViewController.m
//  飞扬FM
//
//  Created by Mac os on 15/12/7.
//  Copyright © 2015年 SFware. All rights reserved.
//

#import "disanViewController.h"
static disanViewController *_instance;
@interface disanViewController ()

@end

@implementation disanViewController

@synthesize _nameArray,playerView;


+ (id)allocWithZone:(struct _NSZone *)zone
{
    // 里面的代码永远只执行1次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    // 返回对象
    return _instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    playerView = [[UIControl alloc] init];
    playerView.backgroundColor = [UIColor redColor];
    playerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 162+30);
    
    
    [self.view addSubview:playerView];
    
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 162)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [playerView addSubview:self.pickerView];
    
    [self.pickerView reloadAllComponents];//刷新UIPickerView
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, self.view.frame.size.width, 30)];
    lab.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.text = @"完成";
    [playerView addSubview:lab];
    
    _nameArray = [[NSMutableArray alloc]init];
    [_nameArray copy];
    
    [self.playerView addTarget:self action:@selector(touchView) forControlEvents:UIControlEventTouchUpInside];
}

-(void)touchView
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.view.frame= CGRectMake(0, 600, self.view.frame.size.width, 120);
                     }
                     completion:^(BOOL finished){
                         [self.view removeFromSuperview];
                         
                     }];
    //    [_nameArray removeAllObjects];
    
}

#pragma mark pickerview function

//返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return  _nameArray.count;
    } else if(component==1){
        
        return  [_nameArray count];
    }
    return [_nameArray count];
}
//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 20.0f;
}
//返回指定列的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component==0) {//iOS6边框占10+10
        return  self.view.frame.size.width/3;
    } else if(component==1){
        return  self.view.frame.size.width/3;
    }
    return  self.view.frame.size.width/3;
}

// 自定义指定列的每行的视图，即指定列的每行的视图行为一致
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3, 20)];
    text.textAlignment = NSTextAlignmentCenter;
    _nameArray = [_nameArray copy];
    text.text = [_nameArray objectAtIndex:row];
    
    
    [view addSubview:text];
    
    return view;
}
//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = [_nameArray objectAtIndex:row];
    return str;
}
//显示的标题字体、颜色等属性
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = [_nameArray objectAtIndex:row];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
    
    return AttributedString;
}//NS_AVAILABLE_IOS(6_0);

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //    - (void)newMessageReceived:(NSString *)messageContent  gundan:(NSUInteger)jiba;
    [_delegate newMessageReceived:[_nameArray objectAtIndex:row] gundan:_section indexPath:_row];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end