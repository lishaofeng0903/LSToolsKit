//
//  ViewController2.m
//  LSToolsKitDemo
//
//  Created by dev on 2018/7/26.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "ViewController2.h"
#import "LSLoopUtils.h"

@interface ViewController2 ()

@property (nonatomic, strong) LSLoopUtils *loopUtil;

@property NSInteger count;

@end

@implementation ViewController2

- (void)dealloc
{
    NSLog(@"ViewController2 dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)myLoopFunction{
    NSLog(@"%s->%ld",__func__,++_count);
}


- (IBAction)begin:(id)sender {
    self.count = 0;
    [self.loopUtil releaseResourse];
    self.loopUtil = [LSLoopUtils loopWithTarget:self sel:@selector(myLoopFunction)
                                       interval:1 timeout:10
                                     startAfter:0
                                      breakLoop:^(NSDictionary *userInfo) {
                                          NSLog(@"%@",userInfo);
                                      } breakWithTimeOut:^{
                                          NSLog(@"timeout");
                                      }];
}
- (IBAction)stop:(id)sender {
    [self.loopUtil endLoop];
}


- (IBAction)stopWithParam:(id)sender {
    [self.loopUtil endLoopWithUserInfo:@{@"UserName":@"abcd"}];
}


@end
