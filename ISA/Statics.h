//
//  Statics.h
//  XmppDemo
//
//  Created by 夏 华 on 12-7-13.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//static NSString *USERID = @"userId";
//static NSString *PASS= @"pass";
//static NSString *SERVER = @"server";

@interface Statics : NSObject

+(NSString *)getCurrentTime;
+(NSDate*)zoneChange:(long long)spString;

+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;

+(BOOL)IsChinese:(NSString *)str;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

+ (int) changeHexStringToDecimal:(NSString *)hexString;

+ (NSString *)changeISO88591StringToUnicodeString:(NSString *)iso88591String;


+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

+(long long)currenTime;

@end
