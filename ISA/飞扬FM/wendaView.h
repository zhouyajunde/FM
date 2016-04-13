//
//  wendaView.h
//  飞扬FM
//
//  Created by Mac os on 15/12/21.
//  Copyright © 2015年 SFware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wendaView : UIView<UITextFieldDelegate>{
      NSMutableDictionary *timu,*sas;
    UILabel *title ;
    NSMutableDictionary *dic;
    UITextField *username;
    UITextView *textView;
}
- (id)initWithFrame:(CGRect)frame withTitle:(NSMutableDictionary *)data;

- (id)initWithFrame1:(CGRect)frame withTitle:(NSMutableDictionary *)data1;

- (NSMutableDictionary *) getValue;
- (NSMutableDictionary *) getValuew;
@end
