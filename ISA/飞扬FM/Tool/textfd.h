//
//  textfd.h
//  snctc
//
//  Created by Mac os on 16/2/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface textfd : UITextField

-(CGRect)textRectForBounds:(CGRect)bounds;

- (CGRect)editingRectForBounds:(CGRect)bounds;

@end
