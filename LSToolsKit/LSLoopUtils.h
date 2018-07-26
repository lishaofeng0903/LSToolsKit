//
//  LSLoopUtils.h
//  LoopTest
//
//  Created by dev on 2018/4/25.
//  Copyright © 2018年 dev. All rights reserved.
//
/**
 *  循环调用方法的工具
 *
 *  @author lsf
 */
#import <Foundation/Foundation.h>
typedef void(^BreakLoopBlock)(NSDictionary *userInfo);

@interface LSLoopUtils : NSObject
/**
 开启循环
 
 @param target 调用selector参数的对象
 @param selector 方法@selector
 @param interval 间隔多少秒调用一次
 @param timeout 超时时间
 @param startAfter 延迟多少秒执行
 @param breakLoopBlock 跳出循环时回调
 @param breakWithTimeOut 超时时回调
 @return 返回当前对象，全局属性保存
 */
+ (instancetype)loopWithTarget:(id)target
                           sel:(SEL)selector
                      interval:(NSTimeInterval)interval
                       timeout:(NSTimeInterval)timeout
                    startAfter:(NSTimeInterval)startAfter
                     breakLoop:(BreakLoopBlock)breakLoopBlock
              breakWithTimeOut:(void(^)(void))breakWithTimeOut;

/**
 提前结束循环
 */
- (void)endLoop;

/**
 提前结束循环，带结束参数
 */
- (void)endLoopWithUserInfo:(NSDictionary *)userInfo;

/**
 释放资源(在一个循环还没结束，又需要重置循环的，需要调用此方法，再进行创建Loop方法)
 */
- (void)releaseResourse;

@end
