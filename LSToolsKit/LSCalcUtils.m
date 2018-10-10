//
//  LSCalcUtils.m
//  LSToolsKit
//
//  Created by dev on 2018/10/10.
//  Copyright © 2018 dev. All rights reserved.
//

#import "LSCalcUtils.h"

@interface LSCalcUtils ()

@property (nonatomic, strong) NSDecimalNumberHandler *numHandler;

@end

@implementation LSCalcUtils

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scale = SHRT_MAX;
    }
    return self;
}

-(void)setScale:(short)scale{
    _scale = scale;
    
    self.numHandler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain
                                                                     scale:_scale
                                                          raiseOnExactness:NO
                                                           raiseOnOverflow:NO
                                                          raiseOnUnderflow:NO
                                                       raiseOnDivideByZero:YES];
}

#pragma mark - 加减乘除
/**
 加法
 */
- (NSDecimalNumber *)add:(NSDecimalNumber *)num1 num:(NSDecimalNumber *)num2{
    NSDecimalNumber *ls_num1 = [LSCalcUtils typeConversion:num1];
    NSDecimalNumber *ls_num2 = [LSCalcUtils typeConversion:num2];
    
    return [ls_num1 decimalNumberByAdding:ls_num2 withBehavior:self.numHandler];
}

/**
 减法
 */
- (NSDecimalNumber *)minus:(NSDecimalNumber *)num1 num:(NSDecimalNumber *)num2{
    NSDecimalNumber *ls_num1 = [LSCalcUtils typeConversion:num1];
    NSDecimalNumber *ls_num2 = [LSCalcUtils typeConversion:num2];
    return [ls_num1 decimalNumberBySubtracting:ls_num2 withBehavior:self.numHandler];
}

/**
 乘法
 */
- (NSDecimalNumber *)multiply:(NSDecimalNumber *)num1 num:(NSDecimalNumber *)num2{
    NSDecimalNumber *ls_num1 = [LSCalcUtils typeConversion:num1];
    NSDecimalNumber *ls_num2 = [LSCalcUtils typeConversion:num2];
    return [ls_num1 decimalNumberByMultiplyingBy:ls_num2 withBehavior:self.numHandler];
}

/**
 除法
 */
- (NSDecimalNumber *)divide:(NSDecimalNumber *)num1 num:(NSDecimalNumber *)num2{
    NSDecimalNumber *ls_num1 = [LSCalcUtils typeConversion:num1];
    NSDecimalNumber *ls_num2 = [LSCalcUtils typeConversion:num2];
    return [ls_num1 decimalNumberByDividingBy:ls_num2 withBehavior:self.numHandler];
}

#pragma mark - 绝对值
/**
 绝对值
 */
- (NSDecimalNumber *)abs:(NSDecimalNumber *)num{
    NSDecimalNumber *ls_num = [LSCalcUtils typeConversion:num];
    NSComparisonResult result = [LSCalcUtils compare:ls_num num:[NSDecimalNumber zero]];
    if (result == NSOrderedAscending) {
        ls_num = [LSCalcUtils reverse:ls_num];
    }
    ls_num = [self rounding:ls_num];
    return ls_num;
}

/**
 绝对值（类方法）
 */
+ (NSDecimalNumber *)abs:(NSDecimalNumber *)num{
    LSCalcUtils *calc = [[LSCalcUtils alloc] init];
    return [calc abs:num];
}

/**
 绝对负数
 */
- (NSDecimalNumber *)negative:(NSDecimalNumber *)num{
    NSDecimalNumber *ls_num = [LSCalcUtils typeConversion:num];
    NSDecimalNumber *negativeOne = [NSDecimalNumber decimalNumberWithString:@"-1"];
    return [self multiply:[self abs:ls_num] num:negativeOne];
}

/**
 绝对负数（类方法）
 */
+ (NSDecimalNumber *)negative:(NSDecimalNumber *)num{
    LSCalcUtils *calc = [[LSCalcUtils alloc] init];
    return [calc negative:num];
}

#pragma mark - 根据小数位数四舍五入
/**
 小数四舍五入，根据scale属性
 */
- (NSDecimalNumber *)rounding:(NSDecimalNumber *)num{
    NSDecimalNumber *ls_num = [LSCalcUtils typeConversion:num];
    return [self multiply:ls_num num:[NSDecimalNumber one]];
}

/**
 小数四舍五入（类方法）
 
 @param num 传入数值
 @param decimal 小数位数
 @return NSDecimalNumber
 */
+ (NSDecimalNumber *)rounding:(NSDecimalNumber *)num decimal:(int)decimal{
    LSCalcUtils *calc = [[LSCalcUtils alloc] init];
    [calc setScale:decimal];
    return [calc rounding:num];
}

#pragma mark - 取反
/**
 取反
 */
- (NSDecimalNumber *)reverse:(NSDecimalNumber *)num{
    NSDecimalNumber *ls_num = [LSCalcUtils typeConversion:num];
    NSDecimalNumber *negativeOne = [NSDecimalNumber decimalNumberWithString:@"-1"];
    return [self multiply:ls_num num:negativeOne];
}

/**
 取反（类方法）
 */
+ (NSDecimalNumber *)reverse:(NSDecimalNumber *)num{
    LSCalcUtils *calc = [[LSCalcUtils alloc] init];
    return [calc reverse:num];
}

#pragma mark - 比较
/**
 比较num1和num2大小
 
 @param num1 第一个参数
 @param num2 第二个参数
 @return 比较结果 NSOrderedAscending(n1>n2)，NSOrderedSame(n1=n2)，NSOrderedDescending(n1<n2)
 */
- (NSComparisonResult)compare:(NSDecimalNumber *)num1 num:(NSDecimalNumber *)num2{
    return [LSCalcUtils compare:num1 num:num2];
}

/**
 比较num1和num2大小（类方法）
 
 @param num1 第一个参数
 @param num2 第二个参数
 @return 比较结果 NSOrderedAscending(n1>n2)，NSOrderedSame(n1=n2)，NSOrderedDescending(n1<n2)
 */
+ (NSComparisonResult)compare:(NSDecimalNumber *)num1 num:(NSDecimalNumber *)num2{
    NSDecimalNumber *ls_num1 = [LSCalcUtils typeConversion:num1];
    NSDecimalNumber *ls_num2 = [LSCalcUtils typeConversion:num2];
    
    return [ls_num1 compare:ls_num2];
}

#pragma mark - 类型转换
/**
 转换为NSDecimalNumber类型
 */
+ (NSDecimalNumber *)typeConversion:(id)obj{
    NSDecimalNumber *num = [NSDecimalNumber zero];
    if(obj != nil) {
        if ([obj isKindOfClass:[NSString class]]) {
            num = [NSDecimalNumber decimalNumberWithString:obj];
        } else if([obj isKindOfClass:[NSNumber class]]) {
            num = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", obj]];
        }
    }
//    if ([self isNaN:num]){
//        num = [NSDecimalNumber zero];
//    }
    
    return num;
}

#pragma mark - 判断
/**
 检测是否为非数字
 */
+ (BOOL)isNaN:(NSDecimalNumber *)num{
    LSCalcUtils *calc = [[LSCalcUtils alloc] init];
    NSDecimalNumber *resultNum = [calc multiply:num num:[NSDecimalNumber one]];
    BOOL isNaN = NO;
    if ([resultNum isEqualToNumber:[NSDecimalNumber notANumber]]){
        isNaN = YES;
    }
    return isNaN;
}


@end
