//
//  zhiboTableViewCell.m
//  飞扬FM
//
//  Created by Mac os on 16/1/27.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "zhiboTableViewCell.h"
#import "UIImageView+header.h"
#import "ZYJWeekModel.h"
#import "MJExtension.h"
#import "Statics.h"

@interface zhiboTableViewCell (){
    
     NSDate *currenttime;
}

@property (weak, nonatomic) IBOutlet UILabel *mainLab;
@property (weak, nonatomic) IBOutlet UIImageView *BacImg;
@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;

@end

@implementation zhiboTableViewCell


+(instancetype)shoucangCellWithTabView:(UITableView*)tableView
{
    static NSString *reuseId = @"gb";
    zhiboTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"zhiboTableViewCell" owner:nil options:nil] lastObject];
        
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

-(void)setModel:(scModel *)model{
    [self.BacImg zyj_setHeader:model.img];
    self.mainLab.text = model.name;
    
    for (NSDictionary *wee in model.jiemu){
        
        ZYJWeekModel *week = [ZYJWeekModel mj_objectWithKeyValues:wee];
        
        NSLog(@"%@",week.starttime);
      
        long long starttime = [week.starttime doubleValue];
        NSDate *starttime1 = [Statics zoneChange:starttime];
        
        long long  endtime = [week.endtime doubleValue];
        NSDate *endtime1 = [Statics zoneChange:endtime];
        
        currenttime = [Statics getCurrentTime];
    
        if ([Statics date:currenttime isBetweenDate:starttime1 andDate:endtime1] == 1){
            self.startTime.text = starttime1;
            self.endTime.text = endtime1;
            self.subLab.text = week.name;
        }

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
