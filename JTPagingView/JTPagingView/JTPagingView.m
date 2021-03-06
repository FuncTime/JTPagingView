//
//  JTPagingView.m
//  myWheel
//
//  Created by xujiangtao on 2018/12/3.
//  Copyright © 2018年 xujiangtao. All rights reserved.
//

#import "JTPagingView.h"
#import "JTPagingTopView.h"
#import "JTPagingBottomView.h"

@interface JTPagingView ()

@property (nonatomic, strong) JTPagingTopView *pagingTop;

@property (nonatomic, strong) JTPagingBottomView *pagingBottom;

@end

@implementation JTPagingView

+ (instancetype)pagingWithTitles:(NSMutableArray *)titles views:(NSMutableArray *)views {
    
    JTPagingView *paging = [[JTPagingView alloc] init];
    paging.titles = titles;
    paging.views = views;
    return paging;
}

- (void)setTitles:(NSMutableArray *)titles {
    _titles = titles;
    if (_pagingTop) {
        [self.pagingTop addTitlesForTopView:titles];
    }else {
        [self pagingTop];
    }
}

- (void)setViews:(NSMutableArray *)views {
    _views = views;
    [self pagingBottom];
}

- (void)setPages:(NSInteger)pages {
    _pages = pages;
    
    if (!_pagingBottom) {
        
        [self addSubview:self.pagingBottom];
        [self.pagingBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pagingTop.mas_bottom);
            make.left.right.bottom.equalTo(self);
        }];
        __weak typeof(self) weakSelf = self;
        self.pagingBottom.scrollViewDidEndDeceleratingBlock = ^(UIScrollView *scrollView) {
            NSInteger currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
            [weakSelf.pagingTop selectTheSpecifiedCellWithNumber:currentPage];
            if (weakSelf.currentPageBlock) {
                weakSelf.currentPageBlock(currentPage);
            }
            weakSelf.currentPage = currentPage;
        };
        self.pagingBottom.scrollViewDidScrollBlock = ^(UIScrollView *scrollView) {
            [weakSelf.pagingTop pagingBottomScrollViewDidScroll:scrollView];
        };
        self.pagingBottom.scrollViewWillBeginDraggingBlock = ^(UIScrollView *scrollView) {
            [weakSelf.pagingTop pagingBottomscrollViewWillBeginDragging:scrollView];
        };
    }else {
        
        self.pagingBottom.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * pages, 0);
    }
}
//手动选择某页
- (void)selectPageWithNumber:(NSInteger)number {
    [self.pagingTop selectTheSpecifiedCellWithNumber:number];
    for (int i = 0; i < number + 1; i ++) {
        
        [self.pagingBottom scrollToTheSpecifiedPageWithNumber:i];
    }
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;
    
    self.pagingTop.bottomLineColor = bottomLineColor;
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    
    self.pagingTop.selectColor = selectColor;
}

- (void)setNoSelectColor:(UIColor *)noSelectColor {
    _noSelectColor = noSelectColor;
    
    self.pagingTop.noSelectColor = noSelectColor;
}

//一次添加一个view
- (void)addViewForBottomView:(UIView *)view {
    [self.pagingBottom addViewForBottomView:view];
}
//一次添加多个view
- (void)addViewsForBottomView:(NSMutableArray<UIView *> *)views {
    [self.pagingBottom addViewsForBottomView:views];
}
//移除所有view
- (void)removeAllViews {
    [self.pagingBottom removeAllViews];
}

//一次添加一个标题
- (void)addTitleForTopView:(NSString *)title {
    [self.pagingTop addTitleForTopView:title];
}
//一次添加多个标题
- (void)addTitlesForTopView:(NSMutableArray *)titles {
    [self.pagingTop addTitlesForTopView:titles];
}
//移除所有标题
- (void)removeAllTitles {
    [self.pagingTop removeAllTitles];
}

- (void)setLeftSpacing:(float)leftSpacing {
    _leftSpacing = leftSpacing;
    
    self.pagingTop.leftSpacing = leftSpacing;
}

- (void)setRightSpacing:(float)rightSpacing {
    _rightSpacing = rightSpacing;
    
    self.pagingTop.rightSpacing = rightSpacing;
}

- (void)setButtonSpacing:(float)buttonSpacing {
    _buttonSpacing = buttonSpacing;
    
    self.pagingTop.buttonSpacing = buttonSpacing;
}

- (void)setTopViewHeight:(float)topViewHeight {
    _topViewHeight = topViewHeight;
    
    [self.pagingTop mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(topViewHeight);
    }];
    
    [self.pagingTop updateBottomLineFrame];
}

- (void)setTopViewBackgroundColor:(UIColor *)topViewBackgroundColor {
    _topViewBackgroundColor = topViewBackgroundColor;
    
    self.pagingTop.backgroundColor = topViewBackgroundColor;
}

- (void)setBottomViewBackgroundColor:(UIColor *)bottomViewBackgroundColor {
    _bottomViewBackgroundColor = bottomViewBackgroundColor;
    
    self.pagingBottom.backgroundColor = bottomViewBackgroundColor;
}

- (void)setBottomLineWidth:(float)bottomLineWidth {
    _bottomLineWidth = bottomLineWidth;
    
    self.pagingTop.bottomLineWidth = bottomLineWidth;
}

- (void)setAnimationType:(PaingAnimationType)animationType {
    _animationType = animationType;
    
    switch (animationType) {
        case paingAnimationAlpha:
            self.pagingBottom.animationType = bottomAnimationAlpha;
            break;
        case paingAnimationZoom:
            self.pagingBottom.animationType = bottomAnimationZoom;
            break;
        case paingAnimationAlphaAndZoom:
            self.pagingBottom.animationType = bottomAnimationAlphaAndZoom;
            break;
        default:
            self.pagingBottom.animationType = bottomAnimationNone;
            break;
    }
}

- (JTPagingTopView *)pagingTop {
    if (!_pagingTop) {
        if (_titles == nil || _titles.count == 0) {
            _pagingTop = [[JTPagingTopView alloc] init];
        }else {
            _pagingTop = [[JTPagingTopView alloc] initWithTitles:_titles];
        }
        [self addSubview:_pagingTop];
        [_pagingTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(PagingTopHeight);
        }];
        
        __weak typeof(self) weakSelf = self;
        _pagingTop.pagingButtonClickBlock = ^(UIButton *sender) {
            [weakSelf.pagingBottom scrollToTheSpecifiedPageWithNumber:sender.tag];
            if (weakSelf.currentPageBlock) {
                weakSelf.currentPageBlock(sender.tag);
            }
            weakSelf.currentPage = sender.tag;
        };
    }
    return _pagingTop;
}

- (JTPagingBottomView *)pagingBottom {
    if (!_pagingBottom) {
        if (_pages) {
            _pagingBottom = [[JTPagingBottomView alloc] initWithNumberOfView:_pages];
        }else {
            
            _pagingBottom = [[JTPagingBottomView alloc] initWithNumberOfView:_views.count];
            [_pagingBottom setCustomViews:_views];
        }
        [self addSubview:_pagingBottom];
        [_pagingBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pagingTop.mas_bottom);
            make.left.right.bottom.equalTo(self);
        }];
        
        __weak typeof(self) weakSelf = self;
        _pagingBottom.scrollViewDidEndDeceleratingBlock = ^(UIScrollView *scrollView) {
            NSInteger currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
            [weakSelf.pagingTop selectTheSpecifiedCellWithNumber:currentPage];
            if (weakSelf.currentPageBlock) {
                weakSelf.currentPageBlock(currentPage);
            }
            weakSelf.currentPage = currentPage;
        };
        _pagingBottom.scrollViewDidScrollBlock = ^(UIScrollView *scrollView) {
            [weakSelf.pagingTop pagingBottomScrollViewDidScroll:scrollView];
        };
        _pagingBottom.scrollViewWillBeginDraggingBlock = ^(UIScrollView *scrollView) {
            [weakSelf.pagingTop pagingBottomscrollViewWillBeginDragging:scrollView];
        };
    }
    return _pagingBottom;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
