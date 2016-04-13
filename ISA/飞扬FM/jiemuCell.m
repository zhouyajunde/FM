//
//  jiemuCell.m
//  飞扬FM
//
//  Created by Mac os on 16/2/22.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "jiemuCell.h"
#import "ZYJWeekModel.h"
#import "MJExtension.h"
#import "Statics.h"

@interface jiemuCell()

{
      NSDate *currenttime;
}
@property (weak, nonatomic) IBOutlet UILabel *jiemuLab;
@property (weak, nonatomic) IBOutlet UILabel *startLab;
@property (weak, nonatomic) IBOutlet UILabel *endLab;

@end


@implementation jiemuCell


+(instancetype)shoucangCellWithTabView:(UITableView*)tableView
{
    static NSString *reuseId = @"gb";
    jiemuCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"jiemuCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setModel:(jiemuD *)model
{
    self.jiemuLab.text = model.name;
        
        long long starttime = [model.starttime doubleValue];
        NSDate *starttime1 = [Statics zoneChange:starttime];
        
        long long  endtime = [model.endtime doubleValue];
        NSDate *endtime1 = [Statics zoneChange:endtime];
    
            self.startLab.text = starttime1;
            self.endLab.text = endtime1;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
