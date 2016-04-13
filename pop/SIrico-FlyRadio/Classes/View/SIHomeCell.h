//
//  SIHomeCell.h
//  SIrico-FlyRadio
//
//  Created by Jin on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SIClassifyEntity;

@interface SIHomeCell : UICollectionViewCell
{
    @private
    UIImageView *_imageView;
}

- (void)setHomeCell:(SIClassifyEntity *)entity;

@end
