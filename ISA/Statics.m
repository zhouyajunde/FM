//
//  Statics.m
//  XmppDemo
//
//  Created by 夏 华 on 12-7-13.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Statics.h"
#import "MBProgressHUD+NJ.h"
#import "UserDefine.h"

@implementation Statics

 // 获取当前时间
+(NSString *)getCurrentTime{
    
//    NSDate *nowUTC = [NSDate date];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
//    
//    return [dateFormatter stringFromDate:nowUTC];
    
    NSDate *senddate=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *DT = [formatter stringFromDate:senddate];
    return DT;

    
}

+(long long)currenTime
{
    NSDate *datenow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    
    NSData *localeDate = [datenow dateByAddingTimeInterval:interval];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    long long a = [[dateString substringToIndex:2]longLongValue];
    long long  c = [[dateString substringWithRange:NSMakeRange(3,2)]longLongValue];
    long long b = [[dateString substringFromIndex:6]longLongValue];
    
    long long  time = (a*60*60 + c*60 + b)*1000;
    return time;
}

+ (NSDate*)zoneChange:(long long)spString{
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setTimeZone:formatter.timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:spString/1000];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    return confromTimespStr;
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+ (NSString *)encodeToPercentEscapeString: (NSString *) input

{
    
    NSString *outputStr = (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            
                                            (CFStringRef)input,
                                            
                                            NULL,
                                            
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            
                                            kCFStringEncodingUTF8));
    
    return outputStr;
    
}
//判断为数字或者字母
+(BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
    
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

//json转字典

+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

// 判断为电话号码
+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1001) {
        
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11){
            return NO;
        }
        
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest) {
            
            [MBProgressHUD showError:@"请输入电话号码"];
            
            [MBProgressHUD hideHUD];
            
            //            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
            //                                                            message:@"请输入电话号码"
            //                                                           delegate:nil
            //                                                  cancelButtonTitle:@"确定"
            //                                                  otherButtonTitles:nil];
            //
            //            [alert show];
            return NO;
        }
    }
    return YES;
}
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}
+ (NSString *)changeISO88591StringToUnicodeString:(NSString *)iso88591String
{
    NSMutableString *srcString = [[NSMutableString alloc]initWithString:[self _859ToUTF8:iso88591String]];
    
    [srcString replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, [srcString length])];
    [srcString replaceOccurrencesOfString:@"&#x" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [srcString length])];
    
    NSMutableString *desString = [[NSMutableString alloc]init];
    
    NSArray *arr = [srcString componentsSeparatedByString:@";"];
    
    for(int i=0;i<[arr count]-1;i++){
        
        NSString *v = [arr objectAtIndex:i];
        char *c = malloc(3);
        int value = [self changeHexStringToDecimal:v];
        c[1] = value  &0x00FF;
        c[0] = value >>8 &0x00FF;
        c[2] = '\0';
        [desString appendString:[NSString stringWithCString:c encoding:NSUnicodeStringEncoding]];
        free(c);
    }
    
    return desString;
}
+ (NSString *)_859ToUTF8:(NSString *)oldStr
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
    
    return [NSString stringWithUTF8String:[oldStr cStringUsingEncoding:enc]];
}
+ (const char *)UnicodeToISO88591:(NSString *)src
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
    return [src cStringUsingEncoding:enc];
}
+ (int) changeHexStringToDecimal:(NSString *)hexString{
    NSData *data = [hexString dataUsingEncoding:NSUTF8StringEncoding];
    unsigned long value = 0;
    size_t dataLen = data.length;
    const Byte *bytes = data.bytes;
    for (size_t i = 0; i < dataLen; ++i) {
        Byte ch = bytes[i];
        Byte num;
        if ('0' <= ch && ch <= '9')
            num = ch - '0';
        else if ('a' <= ch && ch <= 'f')
            num = ch - 'a' + 10;
        else if ('A' <= ch && ch <= 'F')
            num = ch - 'A' + 10;
        else ;
        //非法字符;在这里写上你的错误处理代码 
        value = value * 16 + num; 
    } 
    
    return value;
    
}

@end
