//
//  ViewController.m
//  LSToolsKitDemo
//
//  Created by dev on 2018/5/4.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "ViewController.h"

#import "ViewController2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonDidClick:(id)sender {
    ViewController2 *vc2 = [[ViewController2 alloc] init];
    [self.navigationController pushViewController:vc2 animated:YES];
}

@end
