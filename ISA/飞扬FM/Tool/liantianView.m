//
//  liantianView.m
//  飞扬FM
//
//  Created by Mac os on 16/3/11.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "liantianView.h"

@interface liantianView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *voice;
- (IBAction)fasongBtn:(id)sender;

@end


@implementation liantianView

-(id)init
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"liantianView" owner:nil options:nil]firstObject];
    
    if (self) {
        
        // 注册键盘尺寸监听的通知
        [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification  object:nil];
        
        // 给文本输入框添加左边的视图
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        //    view.backgroundColor = [UIColor redColor];
        self.inputTextField.leftView = view;
        // 设置左边视图的显示模式
        self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
        
        // 监听键盘send按钮的点击
        self.inputTextField.delegate = self;
    }    
    return self;
}


- (void)keyboardWillChange:(NSNotification  *)notification
{

    [self.delegate liaotian:notification];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
 
    [self.delegate liantianxinxi:textField];
    
    // 4.清空输入框
    self.inputTextField.text = nil;
    
    return YES;
}

- (IBAction)emonjinBtn:(id)sender {
    
    if (!_bolemojin) {
        [self.delegate emojint];
        _bolemojin = YES;
    }else
    {
         _bolemojin = NO;
         [self.inputTextField becomeFirstResponder];
    }
}
- (IBAction)fasongBtn:(id)sender {
    
    
    [self.delegate liantianxinxi:self.inputTextField];
    
    // 4.清空输入框
    self.inputTextField.text = nil;

}
@end
