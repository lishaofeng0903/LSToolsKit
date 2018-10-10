//
//  LSFormatUtils.m
//  LSToolsKit
//
//  Created by dev on 2018/10/9.
//  Copyright © 2018 dev. All rights reserved.
//

#import "LSFormatUtils.h"

@interface LSFormatUtils ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation LSFormatUtils

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return self;
}

+ (instancetype)sharedFormatUtils{
    static dispatch_once_t onceToken;
    static LSFormatUtils *formatUtils;
    dispatch_once(&onceToken, ^{
        formatUtils = [[LSFormatUtils alloc] init];
    });
    return formatUtils;
}

@end


#pragma mark - 数字格式化分类
@implementation LSFormatUtils (LSNumberFormatCategory)
#pragma mark 格式化
/**
 格式化数字：###,###,###,###,###,##(不含小数点)
 
 @param num 需要格式化的数字
 @return 格式化后的字符串
 */
+ (NSString *)formatNumber:(NSNumber *)num{
    return [LSFormatUtils formatNumber:num decimal:0];
}

/**
 格式化数字：###,###,###,###,###,##

 @param num 需要格式化的数字
 @param decimal 小数位数
 @return 格式化后的字符串
 */
+ (NSString *)formatNumber:(NSNumber *)num decimal:(int)decimal{
    CFLocaleRef currentLocale = CFLocaleCreate(kCFAllocatorDefault, CFSTR("zh-cn"));
    CFNumberFormatterRef formatter = CFNumberFormatterCreate(NULL, currentLocale, kCFNumberFormatterDecimalStyle);
    
    NSString *prefixFormat = @"###,###,###,###,###,##";
    NSString *suffixFormat = [LSFormatUtils formatDecimalStringWithDecimal:decimal];
    
    NSString *formatStr = [NSString stringWithFormat:@"%@%@",prefixFormat,suffixFormat];
    CFNumberFormatterSetFormat(formatter, (__bridge CFStringRef)formatStr);
    
    double n = [num doubleValue];
    CFNumberRef numRef = CFNumberCreate(NULL, kCFNumberDoubleType, &n);
    CFStringRef stringRef = CFNumberFormatterCreateStringWithNumber(NULL, formatter, numRef);
    CFRelease(currentLocale);
    CFRelease(formatter);
    CFRelease(numRef);
    return (__bridge_transfer NSString *)stringRef;
}

#pragma mark 反格式化
/**
 反格式化数量
 
 @param numStr 数字字符串
 @return 返回number
 */
+ (NSNumber *)unFormatNumberStringToNumber:(NSString *)numStr{
    NSNumber *f2Number = @0;
    if(numStr){
        NSString *textStr = [numStr stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        
        f2Number = [f numberFromString:textStr];
    }
    return f2Number;
}


#pragma mark 私有方法
+ (NSString *)formatDecimalStringWithDecimal:(int)decimal{
    NSString *str = @"0";
    if (decimal != 0) {
        str = @"0.";
        for (int i = 0; i < decimal; i++)
            str = [str stringByAppendingString:@"0"];
    }
    return str;
}

@end


#pragma mark - 日期格式化分类
@implementation LSFormatUtils (LSDateFormatCategory)

#pragma mark 日期转字符串
/**
 格式化 日期：yyyy-MM-dd HH:mm:ss
 
 @param date 传入日期
 @return 格式化后的字符串，格式化错误则返回空字符串
 */
+ (NSString *)formatDateToString:(NSDate *)date{
    return [self formatDateToString:date dateFormatString:@"yyyy-MM-dd HH:mm:ss"];
}

/**
 格式化 日期：yyyy-MM-dd HH:mm:ss（与默认格式一样）
 
 @param date 传入日期
 @return 格式化后的字符串，格式化错误则返回空字符串
 */
+ (NSString *)formatDateToLongString:(NSDate *)date{
    return [self formatDateToString:date dateFormatString:@"yyyy-MM-dd HH:mm:ss"];
}

/**
 格式化 年月日：yyyy-MM-dd
 
 @param date 传入日期
 @return 格式化后的字符串，格式化错误则返回空字符串
 */
+ (NSString *)formatDateToShortString:(NSDate *)date{
    return [self formatDateToString:date dateFormatString:@"yyyy-MM-dd"];
}

/**
 格式化 时间：HH:mm:ss
 
 @param date 传入日期
 @return 格式化后的字符串，格式化错误则返回空字符串
 */
+ (NSString *)formatDateTimeToString:(NSDate *)date{
    return [self formatDateToString:date dateFormatString:@"HH:mm:ss"];
}

/**
 根据自定义格式，格式化日期
 
 @param date 传入日期
 @param dateFormatStr 自定义格式 如yyyy-MM-dd
 @return 格式化后的日期字符串
 */
+ (NSString *)formatDateToString:(NSDate *)date dateFormatString:(NSString *)dateFormatStr{
    NSString *str = [LSFormatUtils emptyString];
    if ([self checkDate:date] && [self checkDateFormatStr:dateFormatStr]){
        LSFormatUtils *util = [LSFormatUtils sharedFormatUtils];
        util.dateFormatter.dateFormat = dateFormatStr;
        util.dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        str = [util.dateFormatter stringFromDate:date];
    }
    return str;
}

#pragma mark 字符串转日期
/**
 将字符串格式化为日期：原格式yyyy-MM-dd HH:mm:ss
 
 @param dateString 日期字符串
 @return 日期
 */
+ (NSDate *)formatStringToDate:(NSString *)dateString{
    return [self formatStringToDate:dateString dateFormatString:@"yyyy-MM-dd HH:mm:ss"];
}

/**
 根据自定义格式,格式化字符串成日期
 
 @param dateString 日期字符串
 @param dateFormatStr 自定义格式 如yyyy-MM-dd
 @return 日期
 */
+ (NSDate *)formatStringToDate:(NSString *)dateString dateFormatString:(NSString *)dateFormatStr{
    NSDate *date = nil;
    if ([self checkDateFormatStr:dateFormatStr]) {
        LSFormatUtils *util = [LSFormatUtils sharedFormatUtils];
        util.dateFormatter.dateFormat = dateFormatStr;
        date = [util.dateFormatter dateFromString:dateString];
    }
    return date;
}


#pragma mark - 私有方法
/**
 生成空白字符串
 */
+ (NSString *)emptyString{
    return @"";
}

/**
 校验日期是否可用
 */
+ (BOOL)checkDate:(NSDate *)date{
    BOOL result = NO;
    if (date != nil && [date isKindOfClass:[NSDate class]]) {
        result = YES;
    }
    return result;
}

/**
 校验日期格式化字符串是否可用
 */
+ (BOOL)checkDateFormatStr:(NSString *)str{
    BOOL result = NO;
    if (str != nil && str.length > 0) {
        result = YES;
    }
    return result;
}

@end
