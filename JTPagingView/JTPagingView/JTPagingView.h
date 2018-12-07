//
//  JTPagingView.h
//  myWheel
//
//  Created by xujiangtao on 2018/12/3.
//  Copyright © 2018年 xujiangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTPagingView : UIView

//返回当前即将显示页数
@property (nonatomic, copy) void(^currentPageBlock)(NSInteger currentPage);

//标题数组
@property (nonatomic, strong) NSMutableArray *titles;
//子view数组
@property (nonatomic, strong) NSMutableArray *views;
//当前页数
@property (nonatomic, assign) NSInteger currentPage;
//选中字体颜色 默认红色
@property (nonatomic, strong) UIColor *selectColor;
//未选中字体颜色 默认黑色
@property (nonatomic, strong) UIColor *noSelectColor;
//下划线颜色 默认红色
@property (nonatomic, strong) UIColor *bottomLineColor;
//标题栏居左多少 默认10
@property (nonatomic, assign) float leftSpacing;
//标题栏居右多少 默认10
@property (nonatomic, assign) float rightSpacing;
//标题之间的距离 默认10
@property (nonatomic, assign) float buttonSpacing;
//标题栏高度 默认40
@property (nonatomic, assign) float topViewHeight;
//topView背景色
@property (nonatomic, assign) UIColor *topViewBackgroundColor;
//bottomView背景色
@property (nonatomic, assign) UIColor *bottomViewBackgroundColor;
//下划线的宽度 大于0就是用bottomLineWidth,否则就是用每个button的宽度
@property (nonatomic, assign) float bottomLineWidth;

//页数--可以先不创建view,使用页数来创建scrollView的可滚动页数
@property (nonatomic, assign) NSInteger pages;
//一次添加一个view
- (void)addViewForBottomView:(UIView *)view;
//一次添加多个view
- (void)addViewsForBottomView:(NSMutableArray<UIView *> *)views;
@end
