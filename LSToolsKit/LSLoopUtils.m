//
//  LSLoopUtils.m
//  LoopTest
//
//  Created by dev on 2018/4/25.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "LSLoopUtils.h"

typedef void(^BreakWithTimeOut)(void);

@interface LSLoopUtils ()
#pragma mark - timer
//全局timer
@property (nonatomic, strong)NSTimer *timer;

#pragma mark - 循环条件
///开始循环的时间
@property (nonatomic, strong)NSDate *fireDate;
///超时时间
@property (nonatomic, strong) NSDate *timeOutDate;
///外部要循环的对象
@property (nonatomic, weak) id target;
///外部要循环的方法
@property (nonatomic, assign) SEL selecter;

#pragma mark - 跳出循环回调
///跳出循环回调
@property (nonatomic, copy) BreakLoopBlock breakLoopBlock;
///超时跳出循环回调
@property (nonatomic, copy) BreakWithTimeOut breakWithTimeOut;

@end

@implementation LSLoopUtils

-(void)dealloc{
    NSLog(@"LoopUtils dealloc");
}

/**
 开启循环

 @param target 调用selector参数的对象
 @param selector 方法@selector
 @param interval 间隔多少秒调用一次
 @param timeout 超时时间
 @param startAfter 什么时候开始
 @param breakLoopBlock 跳出循环时回调
 @param breakWithTimeOut 超时时回调
 @return 返回当前对象，全局属性保存
 */
+ (instancetype)loopWithTarget:(id)target sel:(SEL)selector interval:(NSTimeInterval)interval timeout:(NSTimeInterval)timeout startAfter:(NSTimeInterval)startAfter breakLoop:(BreakLoopBlock)breakLoopBlock breakWithTimeOut:(void(^)(void))breakWithTimeOut{
    LSLoopUtils *util = [[LSLoopUtils alloc] init];
    util.breakLoopBlock = breakLoopBlock;
    util.breakWithTimeOut = breakWithTimeOut;
    
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:startAfter];
    NSDate *timeOutDate = [fireDate dateByAddingTimeInterval:timeout];
    
    util.fireDate = fireDate;
    util.timeOutDate = timeOutDate;
    
    util.target = target;
    util.selecter = selector;
    
    util.timer = [[NSTimer alloc] initWithFireDate:fireDate interval:interval target:util selector:@selector(loopMethod) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:util.timer forMode:NSRunLoopCommonModes];
    return util;
}

/**
 内部循环方法
 */
- (void)loopMethod{
    if (self.target == nil){
        [self releaseResourse];
        return;
    }
    NSDate *currentDate = [NSDate date];
    NSComparisonResult result = [currentDate compare:self.timeOutDate];
    if (result == NSOrderedDescending) {
        if (self.breakWithTimeOut != nil) {
            self.breakWithTimeOut();
        }
        [self releaseResourse];
    }else{
        @try{
            [self.target performSelectorOnMainThread:self.selecter withObject:nil waitUntilDone:NO];
        }@catch(NSException *e){
            NSLog(@"%@",e);
        }
    }
}

/**
 结束循环
 */
- (void)endLoop{
    [self endLoopWithUserInfo:nil];
}

/**
 带返回参数的结束循环
 */
- (void)endLoopWithUserInfo:(NSDictionary *)userInfo{
    @synchronized(self){
        if (self.breakLoopBlock != nil) {
            self.breakLoopBlock(userInfo);
        }
        [self releaseResourse];
    }
}

/**
 释放资源
 */
- (void)releaseResourse{
    [self resetTimer];
    self.fireDate = nil;
    self.timeOutDate = nil;
    self.breakWithTimeOut = nil;
    self.breakLoopBlock = nil;
}

/**
 重置Timer
 */
- (void)resetTimer{
    [self.timer invalidate];
    self.timer = nil;
}

@end
