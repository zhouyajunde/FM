//
//  scTableViewCell.m
//  飞扬FM
//
//  Created by Mac os on 16/1/21.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "scTableViewCell.h"
#import "UIImageView+header.h"
#import "scModel.h"
#import "MJExtension.h"
#import "ZYJWeekModel.h"
#import "NSDictionary+Extension.h"

@interface scTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *touxiangImg;
@property (weak, nonatomic) IBOutlet UILabel *mainLab;
@property (weak, nonatomic) IBOutlet UILabel *twoLab;
@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;

@end

@implementation scTableViewCell

+(instancetype)shoucangCellWithTabView:(UITableView*)tableView
{
    static NSString *reuseId = @"gb";
    scTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"scTableViewCell" owner:nil options:nil] lastObject];
        
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

-(void)setScdeMedel:(scModel *)scdeMedel{
    
    _scdeMedel = scdeMedel;
    
    self.mainLab.text = scdeMedel.name;
    
    [self.touxiangImg zyj_setHeader:scdeMedel.img];
    
    for (NSDictionary *wee in scdeMedel.jiemu){
        
        ZYJWeekModel *week = [ZYJWeekModel mj_objectWithKeyValues:wee];
        
        NSLog(@"%@",week.starttime);
        
        long long starttime = [week.starttime doubleValue];
        NSDate *starttime1 = [self zoneChange:starttime];
        
        long long  endtime = [week.endtime doubleValue];
        NSDate *endtime1 = [self zoneChange:endtime];
        
        currenttime = [self getCurrentTime];
        
        if ([self date:currenttime isBetweenDate:starttime1 andDate:endtime1] == 1){
            self.startTime.text = endtime1;
            self.endTime.text = starttime1;
            self.subLab.text = week.name;
        }
   }
}

- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}
- (NSDate*)zoneChange:(long long)spString{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setTimeZone:formatter.timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:spString/1000];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    return confromTimespStr;
}

-(NSString *)getCurrentTime{
    NSDate *senddate=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *DT = [formatter stringFromDate:senddate];
    currenttime = DT;
    return currenttime;
}
- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
