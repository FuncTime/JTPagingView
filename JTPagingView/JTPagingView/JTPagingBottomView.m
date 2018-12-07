//
//  JTPagingBottomView.m
//  myWheel
//
//  Created by xujiangtao on 2018/12/3.
//  Copyright © 2018年 xujiangtao. All rights reserved.
//

#import "JTPagingBottomView.h"

@interface JTPagingBottomView ()<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger viewNumber;

@property (nonatomic, strong) UIView *lastView;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray<UIView *> *views;

@end

@implementation JTPagingBottomView

- (instancetype)initWithNumberOfView:(NSInteger)number {
    self = [super init];
    if (self) {
        self.viewNumber = number;
        self.currentPage = 0;
        self.views = [NSMutableArray array];
        [self createViews];
        [self addNotification];
    }
    return self;
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)orientChange:(NSNotification *)noti {
    
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    switch (orient) {
        case UIDeviceOrientationPortrait:
            NSLog(@"正");
            break;
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"左");
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"倒");
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"右");
            break;
        default:
            break;
    }
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.viewNumber, 0);
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * self.currentPage, 0) animated:YES];
}

- (void)createViews {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.viewNumber, 0);
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

- (void)setCustomViews:(NSMutableArray<UIView *> *)views{
    self.views = views;
    
    if (views.count == 0) {
        return;
    }
    
    //直接把第一页加载出来
    [self.scrollView addSubview:views[0]];
    [views[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView.mas_width);
        make.height.mas_equalTo(self.scrollView.mas_height);
        self.lastView = views[0];
    }];
}

- (void)scrollToTheSpecifiedPageWithNumber:(NSInteger)number {
    
    //超出指定的滚动范围了就不管
    if (self.scrollView.contentSize.width/SCREEN_WIDTH >= number + 1) {
        
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * number, 0) animated:YES];
    }
    
    self.currentPage = number;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollViewDidEndDeceleratingBlock) {
        self.scrollViewDidEndDeceleratingBlock(scrollView);
    }
    
    self.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock(scrollView);
    }
    
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    if (self.views.count > page) {
        
        //加载其他页,不存在再添加
        if (![self.scrollView.subviews containsObject:self.views[page]]) {
            
            [self.scrollView addSubview:self.views[page]];
            [self.views[page] mas_makeConstraints:^(MASConstraintMaker *make) {
                if (self.lastView) {
                    make.left.equalTo(self.lastView.mas_right);
                }else {
                    make.left.equalTo(self.scrollView);
                }
                make.top.equalTo(self.scrollView);
                make.width.mas_equalTo(self.scrollView.mas_width);
                make.height.mas_equalTo(self.scrollView.mas_height);
            }];
            self.lastView = self.views[page];
            [self animationWithView:self.views[page]];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.scrollViewWillBeginDraggingBlock) {
        self.scrollViewWillBeginDraggingBlock(scrollView);
    }
}

//一次添加一个view
- (void)addViewForBottomView:(UIView *)view {
    
    NSLog(@"%ld,  %ld",self.currentPage,self.views.count);
    
    if (self.currentPage >= self.views.count) {
        
        [self.scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.lastView) {
                make.left.equalTo(self.lastView.mas_right);
            }else {
                make.left.equalTo(self.scrollView);
            }
            make.top.equalTo(self.scrollView);
            make.width.mas_equalTo(self.scrollView.mas_width);
            make.height.mas_equalTo(self.scrollView.mas_height);
        }];
        self.lastView = view;
        [self animationWithView:view];
        
    }
    
    [self.views addObject:view];
}

//一次添加多个view
- (void)addViewsForBottomView:(NSMutableArray<UIView *> *)views {
    
    for (UIView *view in views) {
        [self addViewForBottomView:view];
    }
}

- (void)animationWithView:(UIView *)view {
    
    //缩放动画
    CAKeyframeAnimation *zoom = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    zoom.values = values;
    
    // 透明度动画
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @(0.5);
    alpha.toValue = @(1.0);
    
    // 实例化一个动画组
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[zoom,alpha];
    group.duration = 0.3f;
    
    [view.layer addAnimation:group forKey:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
