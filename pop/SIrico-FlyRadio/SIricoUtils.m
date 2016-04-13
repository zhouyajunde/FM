//
//  BetaTownUtils.m
//  betatown-ios-bhg
//
//  Created by Zhengjun wu on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SIricoUtils.h"
#import "NSDate+Helper.h"

#define ZI_PAI_IMAGE_PATH @"ZHI_PAI_IMAGE.png"


@implementation SIricoUtils


#pragma UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:APP_APPSTORE_URL]];
    }
}

//获得当前的APP版本号
+ (NSString *) getAppClientVersion{
    NSString * bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*) kCFBundleVersionKey];
    return bundleVersion;
}


//获得服务器的APP版本号
+ (NSString *) getAppServerVersion{
//    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//    return (NSString *)[userDefaults valueForKey:APP_SERVER_VERSION];
    return nil;
}

//弹出APP更新页面
- (void) showAppVersionAlertView{
    /*
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * appClientVersion = [BetaTownUtils getAppClientVersion];
    NSString * appServerVersion =  (NSString *)[userDefaults valueForKey:APP_SERVER_VERSION];
    NSString * appServerVersionContent =  (NSString *)[userDefaults valueForKey:APP_SERVER_VERSION_CONTENT];
    
//    NSString * alertContent = [NSString stringWithFormat:@"最新版本：(V%@)\n%@ \n\n 当前版本：V%@",appServerVersion,appServerVersionContent,appClientVersion];
    NSString * alertContent = [NSString stringWithFormat:@"掌上阳光 V%@ (New)\n%@",appServerVersion,appServerVersionContent];
    
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"版本更新" message:alertContent delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:@"暂不更新", nil];
    alertView.tag = 8888;
    alertView.delegate = self;
    [alertView show];
    [alertView release];
     */
}


+ (void) storeLastestUpdateTimeInUserDefaults:(NSString *)stringKey withLastestUpdateTime:(NSString * ) lastestUpdateTime{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:lastestUpdateTime forKey:stringKey];
}

+ (NSString *) getLastestUpdateTimeFromUserDefaults:(NSString *)stringKey{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return (NSString *)[userDefaults valueForKey:stringKey];
}

+ (void) storeIntValueInUserDefaults:(NSString *)stringKey integerValue:(int)intValue{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",intValue] forKey:stringKey];
}

+ (int) getIntValueFromUserDefaults:(NSString *)stringKey{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * tempString =  (NSString *)[userDefaults valueForKey:stringKey];
    if(tempString){
        return [tempString intValue];
    }else {
        return 0;
    }
}

+ (void) storeStringInUserDefaults:(NSString *)stringKey string:(NSString*)string{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:string forKey:stringKey];
}

+ (NSString *) getStringFromUserDefaults:(NSString *)stringKey{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return (NSString *)[userDefaults valueForKey:stringKey];
}

+ (void) removeStringFromUserDefaults:(NSString *)stringKey{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:stringKey];
}


+ (NSString *) getPhotoLibrary{
    //取用户目录，有可能是手机上的目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return documentDirectory;
}

+ (UIImage *) getZiPaiImage{
    NSString *fullFileName = [NSString stringWithFormat:@"%@/%@",[SIricoUtils getPhotoLibrary],ZI_PAI_IMAGE_PATH];
	UIImage * result =  [UIImage imageWithContentsOfFile:fullFileName];
    
    return result;
}

+ (void) saveZiPaiImage:(UIImage *)ziPaiImage{
    NSString *diyPhotoPath =[NSString stringWithFormat:@"%@/%@",[SIricoUtils getPhotoLibrary],ZI_PAI_IMAGE_PATH];
    UIImage* okZiPaiImage = [SIricoUtils imageWithImage:ziPaiImage scaledToSize:CGSizeMake(320, 460)];
    NSData * imageData = UIImageJPEGRepresentation(okZiPaiImage, 1.0);
     
    if(imageData &&imageData.length>0){
        //DLog(@"Save zhi pai zhao image success =========%@",diyPhotoPath);
    	[imageData writeToFile:diyPhotoPath atomically:NO];
    }else {
//        DLog(@"Save zi pai zhao image failure =========%@",diyPhotoPath);
    }
}

+ (void) saveDIYImage:(UIImage *)diyImage{
    NSDate *now = [[NSDate alloc]init];
	
    NSTimeInterval interval =  now.timeIntervalSince1970;
    NSString *bigDiyPhotoPath =[NSString stringWithFormat:@"%@/DIY_BIG%f%@",[SIricoUtils getPhotoLibrary],interval,@".png"];
    NSString *smallDiyPhotoPath =[NSString stringWithFormat:@"%@/DIY_SMALL%f%@",[SIricoUtils getPhotoLibrary],interval,@".png"];
    
    NSData * imageData = UIImagePNGRepresentation(diyImage);
    if(imageData &&imageData.length>0){
    	[imageData writeToFile:bigDiyPhotoPath atomically:YES];
    }
    
    UIImage* smallImage = [SIricoUtils imageWithImage:diyImage scaledToSize:CGSizeMake(104, 149)];
    NSData * smallImageData = UIImagePNGRepresentation(smallImage);
    if(smallImageData &&smallImageData.length>0){
    	[smallImageData writeToFile:smallDiyPhotoPath atomically:YES];
    }
}

+ (void) removeDIYImages{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray * imageFileNameList = [fileManager subpathsOfDirectoryAtPath:[SIricoUtils getPhotoLibrary] error:nil];
    
    for(NSString * fileName in imageFileNameList){
        if([fileName hasSuffix:@".png"] && ([fileName hasPrefix:@"DIY_SMALL"] || [fileName hasPrefix:@"DIY_BIG"])){
         	NSString *fullFileName = [NSString stringWithFormat:@"%@/%@",[SIricoUtils getPhotoLibrary],fileName];
            [fileManager removeItemAtPath:fullFileName error:nil];
        }
    }
}

+ (NSMutableArray*) findSmallDiyImageList{
    NSMutableArray * dataArray = [[NSMutableArray alloc]init];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray * imageFileNameList = [fileManager subpathsOfDirectoryAtPath:[SIricoUtils getPhotoLibrary] error:nil];
    
    for(NSString * fileName in imageFileNameList){
        if([fileName hasSuffix:@".png"] && [fileName hasPrefix:@"DIY_SMALL"]){
            NSString *fullFileName = [NSString stringWithFormat:@"%@/%@",[SIricoUtils getPhotoLibrary],fileName];
            [dataArray addObject:fullFileName];
            //DLog(fileName);
        }
    }
    return dataArray;
}

+ (UIImage*)imageWithImage:(UIImage*)image  
              scaledToSize:(CGSize)newSize; 
{  
    UIGraphicsBeginImageContext( newSize ); 
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)]; 
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext(); 
    
    return newImage; 
}

+ (NSString *)getSubString:(NSString *)strSource WithCharCounts:(NSInteger)number {
	// 一个字符以内，不处理
	if (strSource == nil || [strSource length] <= 1) {
		return strSource;
	}
	char *pchSource = (char *)[strSource cStringUsingEncoding:NSUTF8StringEncoding];
	int sourcelen = strlen(pchSource);
	int nCharIndex = 0;		// 字符串中字符个数,取值范围[0, [strSource length]]
	int nCurNum = 0;		// 当前已经统计的字数
	for (int n = 0; n < sourcelen; ) {
		if( *pchSource & 0x80 ) {
			if ((nCurNum + 2) > number * 2) {
				break;
			}
			pchSource += 3;		// NSUTF8StringEncoding编码汉字占３字节
			n += 3;
			nCurNum += 2;
		}
		else {
			if ((nCurNum + 1) > number * 2) {
				break;
			}
			pchSource++;
			n += 1;
			nCurNum += 1;
		}
		nCharIndex++;
	}
	assert(nCharIndex > 0);
	return [strSource substringToIndex:nCharIndex];
}


// 字数统计
/*
+ (int)calcStrWordCount:(NSString *)str {
	int nResult = 0;
	NSString *strSourceCpy = [str copy];
	NSMutableString *strCopy =[[NSMutableString alloc] initWithString: strSourceCpy];
    NSArray *array = [strCopy componentsMatchedByRegex:@"((news|telnet|nttp|file|http|ftp|https)://){1}(([-A-Za-z0-9]+(\\.[-A-Za-z0-9]+)*(\\.[-A-Za-z]{2,5}))|([0-9]{1,3}(\\.[0-9]{1,3}){3}))(:[0-9]*)?(/[-A-Za-z0-9_\\$\\.\\+\\!\\*\\(\\),;:@&=\\?/~\\#\\%]*)*"];
	if ([array count] > 0) {
		for (NSString *itemInfo in array) {
			NSRange searchRange = {0};
			searchRange.location = 0;
			searchRange.length = [strCopy length];
			[strCopy replaceOccurrencesOfString:itemInfo withString:@"aaaaaaaaaaaa" options:NSCaseInsensitiveSearch range:searchRange];
		}
	}
    
	char *pchSource = (char *)[strCopy cStringUsingEncoding:NSUTF8StringEncoding];
	int sourcelen = strlen(pchSource);
	
	int nCurNum = 0;		// 当前已经统计的字数
	for (int n = 0; n < sourcelen; ) {
		if( *pchSource & 0x80 ) {
			pchSource += 3;		// NSUTF8StringEncoding编码汉字占３字节
			n += 3;
			nCurNum += 2;
		}
		else {
			pchSource++;
			n += 1;
			nCurNum += 1;
		}
	}
	// 字数统计规则，不足一个字(比如一个英文字符)，按一个字算
	nResult = nCurNum / 2 + nCurNum % 2;
	
	[strSourceCpy release];
	[strCopy release];
	return nResult;
}
*/


@end
