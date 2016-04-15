//
//  MyXMPP.m
//  xmpp
//
//  Created by In8 on 14-4-23.
//  Copyright (c) 2014年 zjj. All rights reserved.
//

#import "MyXMPP.h"
#import "XMPPPresence.h"
#import "UserDefine.h"
#import <UIKit/UIKit.h>
#import "XMPPRoster.h"
#import "Statics.h"
#import "HMMusicTool.h"

@interface MyXMPP()
{
    NSString *_userId;

}
@end

@implementation MyXMPP
@synthesize messageDelegate;

+ (MyXMPP *)sharedMyXMPP {
    static MyXMPP *sharedMyXMPP = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyXMPP = [[self alloc] init];
    });
    return sharedMyXMPP;
}

#pragma mark - self

- (void)setupStream {
    self.xmppStream = [[XMPPStream alloc] init];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

#pragma mark - out

- (BOOL)connect {
    
    if (!self.xmppStream) {
        [self setupStream];
    }
    
    NSString *jabberID = [[NSUserDefaults standardUserDefaults] stringForKey:kUserName];
    NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kPassword];
    NSString *server = [[NSUserDefaults standardUserDefaults] stringForKey:kServerHost];
    
    
    
    if (![self.xmppStream isDisconnected]) {
        return YES;
    }
    
    if (jabberID == nil || myPassword == nil) {
        
        return NO;
    }
    jabberID = [jabberID copy];
    server = [server copy];
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:jabberID]];
    [self.xmppStream setHostName:server];
    
    // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    NSDictionary *_dic = [defaults objectForKey:@"dic"];
    
    //用mj 字典转模型
    _userId = [_dic objectForKey:@"id"];

    
    NSError *error = nil;
    if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                            message:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
        
        return NO;
    }
    
    return YES;
}

- (void)disconnect {
    
    [self goOffline];
    [self.xmppStream disconnect];
    
}

#pragma mark - XMPP Delegate

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"%@",[error description]);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    NSError *error = nil;
    [self.xmppStream authenticateWithPassword:[[NSUserDefaults standardUserDefaults] objectForKey:kPassword] error:&error];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    
//    [xmppRoom joinRoomUsingNickname:@"quack" history:nil];  
    
    [self goOnline];
    
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
    NSString *presenceType = [presence type]; // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    
#warning 根据自己设置修改kDomain
    if (![presenceFromUser isEqualToString:myUsername]) {
        
        if ([presenceType isEqualToString:@"available"]) {
//           [self.delegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, kDomain]];
            
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            
//        [self.delegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, kDomain]];
            
        }
        
    }
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    
}
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    NSLog(@"%@",presence)
    ;
//    XMPPJID *jid=[XMPPJID jidWithString:[presence stringValue]];
//    [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
//    NSMutableArray *array = [NSMutableArray array];
//    
//    NSLog(@"%@",message.type);
//    
//    NSMutableDictionary *dic = [NSMutableDictionary new];
//    if (!message)
//        return;
//    
//     if (![message.type isEqualToString:@"error"]) {
//        NSString *msg = [[message elementForName:@"body"] stringValue];
//        NSString *from = [[message attributeForName:@"from"] stringValue];
//        NSString *sender = [[message attributeForName:@"to"] stringValue];
//        NSString *msgStr = [NSString stringWithFormat:@"%@:%@",from,msg];
//         
////        NSRange range = [from rangeOfString:@"/"];//匹配得到的下标
////        
////        sender = [sender substringFromIndex:range.location];//截取范围类的字符串
//
//         if ([[NSString stringWithFormat:@"%@",_userId] isEqualToString: sender]) {
//             NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//             dic[@"text"] = msg;
//             dic[@"time"] = [Statics getCurrentTime];
//             dic[@""] = @0;
//             [array addObject:dic];
//         }else
//         {
//             NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//             dic[@"text"] = msg;
//             dic[@"time"] = [Statics getCurrentTime];
//             dic[@""] = @1;
//             [array addObject:dic];
//         }
//         
//           [HMMusicTool setAllliaotianMessage:array];
//    }
}

@end
