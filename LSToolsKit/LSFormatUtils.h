//
//  LSFormatUtils.h
//  LSToolsKit
//
//  Created by dev on 2018/10/9.
//  Copyright © 2018 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 格式化工具
 */
@interface LSFormatUtils : NSObject


@end

#pragma mark - 数字格式化分类
@interface LSFormatUtils (LSNumberFormatCategory)
#pragma mark 格式化
/**
 格式化数字：###,###,###,###,###,##(不含小数点)
 
 @param num 需要格式化的数字
 @return 格式化后的字符串
 */
+ (NSString *)formatNumber:(NSNumber *)num;

/**
 格式化数字：###,###,###,###,###,##
 
 @param num 需要格式化的数字
 @param decimal 小数位数
 @return 格式化后的字符串
 */
+ (NSString *)formatNumber:(NSNumber *)num decimal:(int)decimal;

#pragma mark 反格式化
/**
 反格式化数量
 
 @param numStr 数字字符串
 @return 返回number
 */
+ (NSNumber *)unFormatNumberStringToNumber:(NSString *)numStr;

@end


#pragma mark - 日期格式化分类
/**
 时间格式化分类
 */
@interface LSFormatUtils (LSDateFormatCategory)

#pragma mark 日期转字符串
/**
 格式化 日期：yyyy-MM-dd HH:mm:ss

 @param date 传入日期
 @return 格式化后的字符串，格式化错误则返回空字符串
 */
+ (NSString *)formatDateToString:(NSDate *)date;

/**
 格式化 日期：yyyy-MM-dd HH:mm:ss（与默认格式一样）
 
 @param date 传入日期
 @return 格式化后的字符串，格式化错误则返回空字符串
 */
+ (NSString *)formatDateToLongString:(NSDate *)date;

/**
 格式化 年月日：yyyy-MM-dd
 
 @param date 传入日期
 @return 格式化后的字符串，格式化错误则返回空字符串
 */
+ (NSString *)formatDateToShortString:(NSDate *)date;

/**
 格式化 时间：HH:mm:ss
 
 @param date 传入日期
 @return 格式化后的字符串，格式化错误则返回空字符串
 */
+ (NSString *)formatDateTimeToString:(NSDate *)date;

/**
 根据自定义格式，格式化日期

 @param date 传入日期
 @param dateFormatStr 自定义格式 如yyyy-MM-dd
 @return 格式化后的日期字符串
 */
+ (NSString *)formatDateToString:(NSDate *)date dateFormatString:(NSString *)dateFormatStr;

#pragma mark 字符串转日期
/**
 将字符串格式化为日期：原格式yyyy-MM-dd HH:mm:ss

 @param dateString 日期字符串
 @return 日期
 */
+ (NSDate *)formatStringToDate:(NSString *)dateString;

/**
 根据自定义格式,格式化字符串成日期

 @param dateString 日期字符串
 @param dateFormatStr 自定义格式 如yyyy-MM-dd
 @return 日期
 */
+ (NSDate *)formatStringToDate:(NSString *)dateString dateFormatString:(NSString *)dateFormatStr;


@end
