//
//  MyXMPP.h
//  xmpp
//
//  Created by In8 on 14-4-23.
//  Copyright (c) 2014年 zjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPStream.h"

@protocol MyXMPPDelegate <NSObject>


//上线
- (void)newBuddyOnline:(NSString *)buddyName;
- (void)buddyWentOffline:(NSString *)buddyName;
- (void)didDisconnect;
//消息
- (void)newMessageReceived:(NSDictionary *)messageContent;
@end

@interface MyXMPP : NSObject{
    
}


@property (nonatomic , strong) XMPPStream *xmppStream;
@property(nonatomic, retain)id messageDelegate;
@property (nonatomic , assign) id<MyXMPPDelegate> delegate;

+ (MyXMPP *)sharedMyXMPP;

- (BOOL)connect;
- (void)disconnect;
@end
