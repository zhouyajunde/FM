//
//  baseHasNoChildController.h
//  飞扬FM
//
//  Created by Mac os on 16/3/3.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hasDiquModel.h"


@interface baseHasNoChildController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

{
    NSMutableArray *_allGroups;
    
}


@property (nonatomic, strong)  UICollectionView *CollectionView;


@property (nonatomic , strong) hasDiquModel *model;

@end
