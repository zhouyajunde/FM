//
//  SIInitDataViewController.m
//  SIrico-FlyRadio
//
//  Created by fantasee on 14-3-2.
//  Copyright (c) 2014年 Jin. All rights reserved.
//

#import "SIInitDataViewController.h"
#import "SIHomeViewController.h"
#import "SILoginViewController.h"
#import "SIChannelInfoEntity.h"
#import "SIDBManger.h"
#import "SIAreaEntity.h"

@interface SIInitDataViewController ()

@end

@implementation SIInitDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DBLog(@"终于学会了，还有什么问题呢？");
	// Do any additional setup after loading the view.

    //[SIFRDotNetManager shareManager]
    
    SIHomeViewController * homeViewController = [[SIHomeViewController alloc] init];
    [self.navigationController pushViewController:homeViewController animated:YES];
    
    [[SIDBManger shareManger] createChannelDB];
    [[SIDBManger shareManger] createAreaDB];
    
    if (isNetConnected) {
        [self getChannelList];
        [self getAreaList];
    }else{
        DBLog(@"没有网络~");
    }


    //[self getchannelListAndAreaList];
    
}

- (void)goToIndexView
{
    
    if (isLoadAreaFinish && isLoadChannelFinish) {
        SIHomeViewController * homeViewController = [[SIHomeViewController alloc] init];
        [self.navigationController pushViewController:homeViewController animated:YES];
    }

}

- (void)getChannelList
{
    [[HTTPManager shareManager] postPath:CHANNEL_LIST_URI parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        if ([jsonObj isKindOfClass:[NSArray class]])
        {
            
            for (NSDictionary *data in jsonObj) {
                //NSLog(@"data::::%@",data);
                
                //TODO: 其他情况，显示电台列表。
                @autoreleasepool {
                    SIChannelInfoEntity *item = [[SIChannelInfoEntity alloc] initWithData:data];
                    
                    [[SIDBManger shareManger] insertData:item];
                    
                    
                }
            }
            
        }else
        {
            
        }

        
//        isLoadChannelFinish = YES;
//        [self performSelector:@selector(goToIndexView) withObject:nil afterDelay:0.0];
//        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        isLoadChannelFinish = YES;
        [self performSelector:@selector(goToIndexView) withObject:nil afterDelay:0.0];
        
    }];
    

}


- (void)getAreaList
{
    [[HTTPManager shareManager] postPath:AREA_LIST_URI parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *data in jsonObj) {
                NSLog(@"data::::%@",data);
                @autoreleasepool {
                    SIAreaEntity *item = [[SIAreaEntity alloc]initWithData:data];
                    [[SIDBManger shareManger] insertAreaData:item];
                }
            }
            
        }else{
            
        }
//        isLoadAreaFinish = YES;
//        [self performSelector:@selector(goToIndexView) withObject:nil afterDelay:0.0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        isLoadAreaFinish = YES;
        [self performSelector:@selector(goToIndexView) withObject:nil afterDelay:0.0];
        DBError(error);
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
