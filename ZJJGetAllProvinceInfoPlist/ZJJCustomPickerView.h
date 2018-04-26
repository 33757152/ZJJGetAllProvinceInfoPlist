//
//  ZJJCustomPickerView.h
//  huashi
//
//  Created by 张锦江 on 2018/3/27.
//  Copyright © 2018年 ZJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PassPickSelected)(NSString *string);

@interface ZJJCustomPickerView : UIView

/**
 初始化用这个方法就够了
 */
- (instancetype)init;

@property (nonatomic, copy) PassPickSelected passString;




@end

