//
//  SIPlayViewController.h
//  SIrico-FlyRadio
//
//  Created by Jin on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SISuperViewController.h"
#import "MyPageLoadingView.h"

@interface SIPlayViewController :SISuperViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIView * shadeView;
    
    UITableView * collectTableView;
    UITableView * commentTableView;
    MyPageLoadingView * loadingView;
    NSMutableArray * allDataArray;
    NSMutableArray * collectDataArray;
    NSMutableArray * commentDataArray1;
    NSMutableArray * commentDataArray2;
    BOOL isKaiCommit;
    BOOL isKaiCommit10;
    BOOL isKaiCommit11;
    BOOL isKaiCommit20;
    BOOL isKaiCommit21;
    BOOL isKaiCommit30;
    BOOL isKaiCommit31;
    BOOL isKaiCommit40;
    BOOL isKaiCommit41;
    BOOL isKaiCommit50;
    BOOL isKaiCommit51;
    
    NSString * isPlay;
    
    NSString * tableViewHeadTitle;
    
    NSString * addOrcancel;
    
    UILabel * tipLabel;
    
}

@property (nonatomic,strong) NSString * isPlay;

- (instancetype)initWithData:(NSMutableArray *)data index:(NSInteger)index;

@end
