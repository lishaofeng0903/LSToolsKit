//
//  LSCalcUtils.h
//  LSToolsKit
//
//  Created by dev on 2018/10/10.
//  Copyright © 2018 dev. All rights reserved.
//
/**
 *  计算工具类
 *
 *  @author lsf
 */
#import <Foundation/Foundation.h>

@interface LSCalcUtils : NSObject

///小数位数，只影响加减乘除
@property (nonatomic, assign) short scale;

#pragma mark - 加减乘除
/**
 加法
 */
- (NSDecimalNumber *)add:(NSDecimalNumber *)num1 num:(NSDecimalNumber *)num2;

/**
 减法
 */
- (NSDecimalNumber *)minus:(NSDecimalNumber *)num1 num:(NSDecimalNumber *)num2;

/**
 乘法
 */
- (NSDecimalNumber *)multiply:(NSDecimalNumber *)num1 num:(NSDecimalNumber *)num2;

/**
 除法
 */
- (NSDecimalNumber *)divide:(NSDecimalNumber *)num1 num:(NSDecimalNumber *)num2;

#pragma mark - 绝对值
/**
 绝对值
 */
- (NSDecimalNumber *)abs:(NSDecimalNumber *)num;

/**
 绝对值（类方法）
 */
+ (NSDecimalNumber *)abs:(NSDecimalNumber *)num;

/**
 绝对负数
 */
- (NSDecimalNumber *)negative:(NSDecimalNumber *)num;

/**
 绝对负数（类方法）
 */
+ (NSDecimalNumber *)negative:(NSDecimalNumber *)num;

#pragma mark - 根据小数位数四舍五入
/**
 小数四舍五入，根据scale属性
 */
- (NSDecimalNumber *)rounding:(NSDecimalNumber *)num;

/**
 小数四舍五入（类方法）

 @param num 传入数值
 @param decimal 小数位数
 @return NSDecimalNumber
 */
+ (NSDecimalNumber *)rounding:(NSDecimalNumber *)num decimal:(int)decimal;

#pragma mark - 取反
/**
 取反
 */
- (NSDecimalNumber *)reverse:(NSDecimalNumber *)num;

/**
 取反（类方法）
 */
+ (NSDecimalNumber *)reverse:(NSDecimalNumber *)num;

#pragma mark - 比较
/**
 比较num1和num2大小

 @param num1 第一个参数
 @param num2 第二个参数
 @return 比较结果 NSOrderedAscending(n1>n2)，NSOrderedSame(n1=n2)，NSOrderedDescending(n1<n2)
 */
- (NSComparisonResult)compare:(NSDecimalNumber *)num1 num:(NSDecimalNumber *)num2;

/**
 比较num1和num2大小（类方法）
 
 @param num1 第一个参数
 @param num2 第二个参数
 @return 比较结果 NSOrderedAscending(n1>n2)，NSOrderedSame(n1=n2)，NSOrderedDescending(n1<n2)
 */
+ (NSComparisonResult)compare:(NSDecimalNumber *)num1 num:(NSDecimalNumber *)num2;

#pragma mark - 判断
/**
 检测是否为非数字
 */
+ (BOOL)isNaN:(NSDecimalNumber *)num;

@end

