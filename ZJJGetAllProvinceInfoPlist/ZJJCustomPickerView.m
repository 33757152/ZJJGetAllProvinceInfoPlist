//
//  ZJJCustomPickerView.m
//  huashi
//
//  Created by 张锦江 on 2018/3/27.
//  Copyright © 2018年 ZJJ. All rights reserved.
//
#define   BOTTOM_HEIGHT       (SCREEN_HEIGHT/3 + 70)
#define   UN_VISABLE_FRAME    CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, BOTTOM_HEIGHT)
#define   VISABLE_FRAME       CGRectMake(0, SCREEN_HEIGHT-BOTTOM_HEIGHT, SCREEN_WIDTH, BOTTOM_HEIGHT)

#import "ZJJCustomPickerView.h"
#import "Header.h"

@interface ZJJCustomPickerView () <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *_addressArray;
}

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *provinceMArray;
@property (nonatomic, strong) NSMutableArray *cityMArray;
@property (nonatomic, strong) NSArray *areaArray;

@end

@implementation ZJJCustomPickerView

- (instancetype)init {
    self = [super initWithFrame:SCREEN_RECT];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self obtainPlistData];
        [self creatView];
    }
    return self;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:UN_VISABLE_FRAME];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.cornerRadius = 10.0f;
        _bottomView.clipsToBounds = YES;
    }
    return _bottomView;
}

- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _finishBtn.frame = CGRectMake(SCREEN_WIDTH-80, 5, 60, 50);
        _finishBtn.backgroundColor = [UIColor whiteColor];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [_finishBtn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, BOTTOM_HEIGHT-40)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (NSMutableArray *)provinceMArray {
    if (!_provinceMArray) {
        _provinceMArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _provinceMArray;
}

- (NSMutableArray *)cityMArray {
    if (!_cityMArray) {
        _cityMArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _cityMArray;
}

- (NSArray *)areaArray {
    if (!_areaArray) {
        _areaArray = [NSArray array];
    }
    return _areaArray;
}

- (void)creatView {
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.finishBtn];
    [self.bottomView addSubview:self.pickerView];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        self.bottomView.frame = VISABLE_FRAME;
    }];
}

- (void)moveAwaySelfView {
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0];
        self.bottomView.frame = UN_VISABLE_FRAME;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark - 完成按钮点击事件
- (void)finishClick {
    [self moveAwaySelfView];
    NSInteger row0 = [_pickerView selectedRowInComponent:0];
    NSInteger row1 = [_pickerView selectedRowInComponent:1];
    NSInteger row2 = [_pickerView selectedRowInComponent:2];
    NSString *string0 = [self.provinceMArray objectAtIndex:row0];
    NSString *string1 = [self.cityMArray objectAtIndex:row1];
    NSString *string2 = [self.areaArray objectAtIndex:row2];
    NSString *string = [NSString stringWithFormat:@"%@-%@-%@",string0,string1,string2];
    if (self.passString) {
        self.passString(string);
    }
}

- (void)giveCityMArrayContent {
    NSInteger row0 = [_pickerView selectedRowInComponent:0];
    NSDictionary *cityDic = [_addressArray objectAtIndex:row0];
    NSArray *cityArray = [cityDic objectForKey:@"sub"];
    [self.cityMArray removeAllObjects];
    for (NSDictionary *everyCityDic in cityArray) {
        [self.cityMArray addObject:everyCityDic[@"name"]];
    }
}

- (void)giveAreaArrayContent {
    NSInteger row0 = [_pickerView selectedRowInComponent:0];
    NSInteger row1 = [_pickerView selectedRowInComponent:1];
    NSDictionary *cityDic = [_addressArray objectAtIndex:row0];
    NSArray *cityArray = [cityDic objectForKey:@"sub"];
    if (row1 >= 0 && row1 < cityArray.count) {
        NSDictionary *areaDic = [cityArray objectAtIndex:row1];
        self.areaArray = [areaDic objectForKey:@"sub"];
    }
}

#pragma mark - pickerView 代理方法
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceMArray.count;
    } else if (component == 1) {
        [self giveCityMArrayContent];
        return self.cityMArray.count;
    } else {
        [self giveAreaArrayContent];
        return self.areaArray.count;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceMArray[row];
    } else if (component == 1) {
        [self giveCityMArrayContent];
        if (row >= 0 && row < self.cityMArray.count) {
            return self.cityMArray[row];
        }
        return @"";
    } else {
        [self giveAreaArrayContent];
        if (row >= 0 && row < self.areaArray.count) {
            return self.areaArray[row];
        }
        return @"";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [pickerView reloadAllComponents];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self moveAwaySelfView];
}

- (void)obtainPlistData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    NSDictionary *pathDict = [NSDictionary dictionaryWithContentsOfFile:path];
    _addressArray = pathDict[@"address"];
    for (NSDictionary *dict in _addressArray) {
        [self.provinceMArray addObject:dict[@"name"]];
    }
}

@end
