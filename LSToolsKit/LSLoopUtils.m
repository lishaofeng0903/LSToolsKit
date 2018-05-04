//
//  LSLoopUtils.m
//  LoopTest
//
//  Created by dev on 2018/4/25.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "LSLoopUtils.h"

@interface LSLoopUtils ()

@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, copy) BreakLoopBlock breakLoopBlock;

@property (nonatomic, strong)NSDate *fireDate;

@end

@implementation LSLoopUtils

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
    
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:startAfter];
    util.fireDate = fireDate;
    __weak __typeof(&*target) weakTarget = target;
    __weak __typeof(&*util) weakUtil = util;
    util.timer = [[NSTimer alloc] initWithFireDate:fireDate interval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSDate *timeOutDate = [weakUtil.fireDate dateByAddingTimeInterval:timeout];
        NSDate *currentDate = [NSDate date];
        NSComparisonResult result = [currentDate compare:timeOutDate];
        if (result == NSOrderedDescending) {
            if (breakWithTimeOut != nil) {
                breakWithTimeOut();
            }
            [weakUtil releaseResourse];
        }else{
            @try{
                [weakTarget performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
            }@catch(NSException *e){
                NSLog(@"%@",e);
            }
        }
    }];
    [[NSRunLoop currentRunLoop] addTimer:util.timer forMode:NSRunLoopCommonModes];
    return util;
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
