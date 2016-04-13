//
//  fenleiViewController.h
//  飞扬FM
//
//  Created by Mac os on 16/1/12.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fenleizhiboViewController.h"

@protocol fenleiDelegate <NSObject>

-(void)TomoreView:(UIViewController *)fenleiview;
-(void)MusicView:(UIViewController *)tuijianview;

@end

@interface fenleiViewController : UIViewController


@property(nonatomic,assign)id delegate;

@end
