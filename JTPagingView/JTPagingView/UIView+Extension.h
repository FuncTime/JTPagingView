//
//  UIView+Extension.h
//  myWheel
//
//  Created by xujiangtao on 2018/12/5.
//  Copyright © 2018年 xujiangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

/**
 控件左上角 x 坐标
 */
@property (nonatomic, assign) CGFloat x;

/**
 控件左上角 y 坐标
 */
@property (nonatomic, assign) CGFloat y;

/**
 控件右上角 x 坐标
 */
@property (nonatomic, assign) CGFloat maxX;

/**
 控件右上角 y 坐标
 */
@property (nonatomic, assign) CGFloat maxY;

/**
 控件的中心点 x 坐标
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 控件的中心点 y 坐标
 */
@property (nonatomic, assign) CGFloat centerY;

/**
 控件的宽度
 */
@property (nonatomic, assign) CGFloat width;

/**
 控件高度
 */
@property (nonatomic, assign) CGFloat height;

/**
 控件size
 */
@property (nonatomic, assign) CGSize size;


/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;

/**
 加载xib 创建的 View
 */
+ (instancetype)viewFromXib;

@end
