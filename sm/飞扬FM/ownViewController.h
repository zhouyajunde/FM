//
//  ownViewController.h
//  飞扬FM
//
//  Created by Mac os on 16/1/12.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYJMineViewController.h"
#import "ZYJdic.h"
#import "CZFooterView.h"

@interface ownViewController :ZYJMineViewController<logOutDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIActionSheet *myActionSheet;
   
}


@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,strong)ZYJdic *ZYJdic;


@end
