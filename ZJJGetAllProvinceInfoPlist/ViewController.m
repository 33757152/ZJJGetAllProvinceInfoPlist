//
//  ViewController.m
//  ZJJGetAllProvinceInfoPlist
//
//  Created by 张锦江 on 2018/4/26.
//  Copyright © 2018年 xtayqria. All rights reserved.
//

#import "ViewController.h"
#import "ZJJCustomPickerView.h"
#import "Header.h"

@interface ViewController () {
    UILabel *_label;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 100, SCREEN_WIDTH, 40);
    label.backgroundColor = [UIColor yellowColor];
    label.text = @"";
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    _label = label;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, 100, 50);
    button.backgroundColor = [UIColor yellowColor];
    [button setTitle:@"出现" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(comeOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)comeOut {
    
    ZJJCustomPickerView *picker = [[ZJJCustomPickerView alloc] init];
    picker.passString = ^(NSString *string) {
        _label.text = string;
    };
    [self.view addSubview:picker];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
