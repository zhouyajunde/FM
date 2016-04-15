//
//  xiugaidexinxinViewController.h
//  飞扬FM
//
//  Created by Mac os on 16/2/24.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "textfd.h"

@protocol diaoboDelegate <NSObject>

-(void)xiugai:(NSString *)message gundan:(NSUInteger)section indexPath:(NSUInteger)row;

@end


@interface xiugaidexinxinViewController : UIViewController

@property (weak, nonatomic) IBOutlet textfd *contentLab;
@property (nonatomic,assign)NSUInteger section;
@property (nonatomic,assign)NSUInteger row;


@property (nonatomic , assign) id<diaoboDelegate> delegate;

@property (weak, nonatomic) NSString *content;
@end
