//
//  JTPagingTopView.h
//  myWheel
//
//  Created by xujiangtao on 2018/12/3.
//  Copyright © 2018年 xujiangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTPagingTopView : UIView
//分页的按钮点击回调
@property (nonatomic, copy) void(^pagingButtonClickBlock)(UIButton *sender);
//初始化方法 titles:标题数组
- (instancetype)initWithTitles:(NSMutableArray *)titles;
//选中指定的分页按钮 number:第几个
- (void)selectTheSpecifiedCellWithNumber:(NSInteger)number;
//bottom的scrollView滑动调用,告诉top
- (void)pagingBottomScrollViewDidScroll:(UIScrollView *)scrollView;
//bottom的scrollView滑动完成调用,告诉top
- (void)pagingBottomscrollViewWillBeginDragging:(UIScrollView *)scrollView;
//更新下划线的位置
- (void)updateBottomLineFrame;

//标题栏居左多少 默认10
@property (nonatomic, assign) float leftSpacing;
//标题栏居右多少 默认10
@property (nonatomic, assign) float rightSpacing;
//标题之间的距离 默认10
@property (nonatomic, assign) float buttonSpacing;

//下划线颜色 默认红色
@property (nonatomic, strong) UIColor *bottomLineColor;
//下划线的宽度
@property (nonatomic, assign) float bottomLineWidth;
//选中字体颜色 默认红色
@property (nonatomic, strong) UIColor *selectColor;
//未选中字体颜色 默认黑色
@property (nonatomic, strong) UIColor *noSelectColor;

@end
