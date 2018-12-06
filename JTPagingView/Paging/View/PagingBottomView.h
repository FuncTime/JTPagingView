//
//  PagingBottomView.h
//  myWheel
//
//  Created by xujiangtao on 2018/12/3.
//  Copyright © 2018年 xujiangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagingBottomView : UIView
//bottom的scrollView
@property (nonatomic, strong) UIScrollView *scrollView;
//上下的个数可以不一样
- (instancetype)initWithNumberOfView:(NSInteger)number;
//设置subview
- (void)setCustomViews:(NSMutableArray<UIView *> *)views;
//滚动到指定页数
- (void)scrollToTheSpecifiedPageWithNumber:(NSInteger)number;
//拖拽scrollView完成回调
@property (nonatomic, copy) void(^scrollViewDidEndDeceleratingBlock)(UIScrollView *scrollView);
//拖拽scrollView回调
@property (nonatomic, copy) void(^scrollViewDidScrollBlock)(UIScrollView *scrollView);
//开始拖拽回调
@property (nonatomic, copy) void(^scrollViewWillBeginDraggingBlock)(UIScrollView *scrollView);

//一次添加一个view
- (void)addViewForBottomView:(UIView *)view;
//一次添加多个view
- (void)addViewsForBottomView:(NSMutableArray<UIView *> *)views;

@end
