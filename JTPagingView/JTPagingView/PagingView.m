//
//  PagingView.m
//  myWheel
//
//  Created by xujiangtao on 2018/12/3.
//  Copyright © 2018年 xujiangtao. All rights reserved.
//

#import "PagingView.h"
#import "PagingTopView.h"
#import "PagingBottomView.h"
#import <Masonry.h>

@interface PagingView ()

@property (nonatomic, strong) PagingTopView *pagingTop;

@property (nonatomic, strong) PagingBottomView *pagingBottom;

@end

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation PagingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self createViews];
    }
    return self;
}

- (void)initData {
    
}

- (void)createViews {
    
}

- (void)setTitles:(NSMutableArray *)titles {
    _titles = titles;
    if (titles.count == 0) {
        return;
    }
    
    if (!self.pagingTop) {
        self.pagingTop = [[PagingTopView alloc] initWithTitles:titles];
        [self addSubview:self.pagingTop];
        [self.pagingTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(45);
        }];
        
        __weak typeof(self) weakSelf = self;
        self.pagingTop.pagingButtonClickBlock = ^(UIButton *sender) {
            [weakSelf.pagingBottom scrollToTheSpecifiedPageWithNumber:sender.tag];
            if (weakSelf.currentPageBlock) {
                weakSelf.currentPageBlock(sender.tag);
            }
            weakSelf.currentPage = sender.tag;
        };
    }
}

- (void)setViews:(NSMutableArray *)views {
    _views = views;
    if (views.count == 0) {
        return;
    }
    
    if (!self.pagingBottom) {
        
        self.pagingBottom = [[PagingBottomView alloc] initWithNumberOfView:views.count];
        [self.pagingBottom setCustomViews:views];
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
    }
}

- (void)setPages:(NSInteger)pages {
    _pages = pages;
    
    if (!self.pagingBottom) {
        
        self.pagingBottom = [[PagingBottomView alloc] initWithNumberOfView:pages];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end