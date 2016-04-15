//
//  bianjiView.m
//  飞扬FM
//
//  Created by Mac os on 16/3/1.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "bianjiView.h"
@interface bianjiView()
@property (weak, nonatomic) IBOutlet UIButton *delteBtn;
- (IBAction)shanchu:(id)sender;
- (IBAction)quanxuan:(id)sender;

@end
@implementation bianjiView

+(instancetype)init;
{
    return [[NSBundle mainBundle] loadNibNamed:@"bianjiView" owner:nil options:nil][0];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
      
    }
    return self;
}

- (IBAction)shanchu:(id)sender {
    
    [_delegate deleteEdit];
}

- (IBAction)quanxuan:(id)sender {
    
    [_delegate all];
}
@end
