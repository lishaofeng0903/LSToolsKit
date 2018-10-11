//
//  LSToolsKitDemoTests.m
//  LSToolsKitDemoTests
//
//  Created by dev on 2018/10/9.
//  Copyright © 2018 dev. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <LSToolsKit/LSFormatUtils.h>
#import <LSToolsKit/LSCalcUtils.h>

@interface LSToolsKitDemoTests : XCTestCase

@end

@implementation LSToolsKitDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}


- (void)testNumber{
    NSLog(@"-----------\n");
    NSString *num = [LSFormatUtils formatNumber:@12345678.40019 decimal:4];
    NSLog(@"num = %@",num);
    NSLog(@"-----------\n");
}


- (void)testCalc{
    NSLog(@"------testCalc-----\n");
    LSCalcUtils *calc = [[LSCalcUtils alloc] init];
    [calc divide:[NSDecimalNumber one] num:[NSDecimalNumber zero]];
//    NSLog(@"%@",dec.stringValue);
//    BOOL b = [LSCalcUtils isNaN:[NSDecimalNumber notANumber]];
//    NSAssert(b == YES, @"aa");
    
    
    NSLog(@"------testCalc-----\n");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
