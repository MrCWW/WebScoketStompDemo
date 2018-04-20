//
//  ViewController.m
//  StompDemo
//
//  Created by aoliliya-cww on 2018/4/20.
//  Copyright © 2018年 aoliliya-cww. All rights reserved.
//

#import "ViewController.h"
#import <WebsocketStompKit/WebsocketStompKit.h>
@interface ViewController ()<STOMPClientDelegate>
@property (nonatomic, strong) STOMPClient *client;
@end

@implementation ViewController
//建立连接
- (IBAction)connectAction:(id)sender {
    NSURL *websocketUrl = [NSURL URLWithString:@"ws://message.aoliliya.com/messages/websocket"];
    STOMPClient *client = [[STOMPClient alloc] initWithURL:websocketUrl webSocketHeaders:@{@"Cookie": @"AOLILIYAID=f42fc449-500a-4c6c-b038-4106c7fe101e"} useHeartbeat:YES];
    //建立连接
    self.client = client;
    [client connectWithHeaders:@{@"Cookie": @"AOLILIYAID=f42fc449-500a-4c6c-b038-4106c7fe101e"} completionHandler:^(STOMPFrame *connectedFrame, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        //注册协议
        [client subscribeTo:@"/user/topic/messages" messageHandler:^(STOMPMessage *message) {
            NSLog(@"body = %@",message.body);
        }];
        // send a message
        [client sendTo:@"/app/content" body:@"{\"type\":1,\"content\":123,\"objId\":90028,\"createDate\":1523502141289}"];

    }];
     client.delegate = self; //添加代理监听连接状态

}
//断开连接
- (IBAction)disconnectAction:(id)sender {
     [self.client disconnect];
}
//与后台断开连接的回调方法 STOMPClientDelegate
- (void)websocketDidDisconnect:(NSError *)error {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
