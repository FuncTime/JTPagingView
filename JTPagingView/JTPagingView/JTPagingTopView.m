//
//  JTPagingTopView.m
//  myWheel
//
//  Created by xujiangtao on 2018/12/3.
//  Copyright © 2018年 xujiangtao. All rights reserved.
//

#import "JTPagingTopView.h"
#import "JTPagingTopButtonView.h"
#import "UIView+Extension.h"

@interface JTPagingTopView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) NSMutableArray<JTPagingTopButtonView *> *buttons;

@property (nonatomic, strong) JTPagingTopButtonView *lastButtonView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UIButton *currentSelectButton;

@property (nonatomic, assign) float lastScrollX;

@end

@implementation JTPagingTopView

- (instancetype)initWithTitles:(NSMutableArray *)titles {
    self = [super init];
    if (self) {
        _titles = titles;
        _leftSpacing = 10;
        _buttonSpacing = 10;
        _rightSpacing = 10;
        _bottomLineColor = [UIColor redColor];
        self.buttons = [[NSMutableArray alloc] init];
        [self createViews];
    }
    return self;
}

- (void)createViews {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView = scrollView;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    for (int i = 0; i < self.titles.count; i ++) {
        JTPagingTopButtonView *buttonView = [[[NSBundle mainBundle] loadNibNamed:@"JTPagingTopButtonView" owner:self options:nil] firstObject];
        [buttonView.pagingButton setTitle:self.titles[i] forState:UIControlStateNormal];
        buttonView.pagingButton.tag = i;
        [scrollView addSubview:buttonView];
        
        [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(scrollView).offset(self.leftSpacing);
            }else {
                make.left.equalTo(self.lastButtonView.mas_right).offset(self.buttonSpacing);
            }
            make.centerY.equalTo(scrollView);
            
            if (i == self.titles.count - 1) {
                make.right.equalTo(scrollView).offset(- self.rightSpacing);
            }
        }];
        
        //第一个
        if (i == 0) {
            buttonView.pagingButton.selected = YES;
            self.currentSelectButton = buttonView.pagingButton;
        }
        
        self.lastButtonView = buttonView;
        [self.buttons addObject:buttonView];
        [buttonView setPagingButtonClickBlock:^(UIButton *sender) {
            
            self.currentSelectButton.selected = NO;
            sender.selected = YES;
            self.currentSelectButton = sender;
            
            if (self.pagingButtonClickBlock) {
                self.pagingButtonClickBlock(sender);
            }
            
            [self updateBottomLineFrame];
        }];
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //如果最后一个的最大Y坐标加上右边距的值小于屏幕宽度,就平分
        float maxY = self.buttons.lastObject.x + self.buttons.lastObject.width + self.rightSpacing;
        
        if (maxY < SCREEN_WIDTH) {
            
            for (int i = 0; i < self.buttons.count; i ++) {
                    [self.buttons[i] mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo((SCREEN_WIDTH - maxY)/self.buttons.count + self.buttons[i].width);
                    }];
            }
            [self updateBottomLineFrame];
        }
    });
    
    self.bottomLine.backgroundColor = self.bottomLineColor;
    [self.scrollView addSubview:self.bottomLine];
    [self updateBottomLineFrame];
}

- (void)selectTheSpecifiedCellWithNumber:(NSInteger)number {
    
    if (number > self.buttons.count - 1) {
        return;
    }
    
    self.currentSelectButton.selected = NO;
    self.buttons[number].pagingButton.selected = YES;
    self.currentSelectButton = self.buttons[number].pagingButton;
    
    [self updateBottomLineFrame];
}

- (void)pagingBottomScrollViewDidScroll:(UIScrollView *)scrollView {
    
//    float currentProgress = scrollView.contentOffset.x / scrollView.contentSize.width;
//    NSLog(@"%f",self.buttons.lastObject.frame.origin.x);
//    NSLog(@"%f",self.scrollView.contentOffset.x);
//    NSLog(@"%f",currentProgress);
//    [self.scrollView setContentOffset:CGPointMake(currentProgress/2 * self.scrollView.contentSize.width, 0) animated:YES];
    
//    if (self.buttons.lastObject.x - self.scrollView.contentOffset.x + self.buttons.lastObject.width < SCREEN_WIDTH) {
//
//        NSLog(@"到底了");
//    }
//    if (scrollView.contentOffset.x < self.lastScrollX) {
//
//        NSLog(@"左滑");
//    } else if (scrollView.contentOffset.x > self.lastScrollX) {
//
//        NSLog(@"右滑");
//    }
    
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    if (self.buttons.count - 1 < page) {
        return;
    }
    CGFloat offsetX = self.buttons[page].centerX - SCREEN_WIDTH/2;
    CGFloat maxRight = self.scrollView.contentSize.width - SCREEN_WIDTH;
    //是否在中心的左边
    if (offsetX < 0) {
        offsetX = 0;
    }else if (offsetX > maxRight) { //是否
        offsetX = maxRight;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

- (void)pagingBottomscrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //判断左滑还是右滑
    self.lastScrollX = scrollView.contentOffset.x;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;
    
    self.bottomLine.backgroundColor = bottomLineColor;
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    
    for (JTPagingTopButtonView *view in self.buttons) {
        [view.pagingButton setTitleColor:selectColor forState:UIControlStateSelected];
    }
}

- (void)setNoSelectColor:(UIColor *)noSelectColor {
    _noSelectColor = noSelectColor;
    
    for (JTPagingTopButtonView *view in self.buttons) {
        [view.pagingButton setTitleColor:noSelectColor forState:UIControlStateNormal];
    }
}

- (void)setLeftSpacing:(float)leftSpacing {
    _leftSpacing = leftSpacing;
    
    [self.buttons.firstObject mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(leftSpacing);
    }];
    [self updateBottomLineFrame];
}

- (void)setRightSpacing:(float)rightSpacing {
    _rightSpacing = rightSpacing;
    
    [self.buttons.lastObject mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView).offset(-rightSpacing);
    }];
    [self updateBottomLineFrame];
}

- (void)setButtonSpacing:(float)buttonSpacing {
    _buttonSpacing = buttonSpacing;
    
    for (int i = 1; i < self.buttons.count; i ++) {
        
        [self.buttons[i] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.buttons[i-1].mas_right).offset(buttonSpacing);
        }];
    }
    [self updateBottomLineFrame];
}

- (void)updateBottomLineFrame {
    NSLog(@"updateBottomLineFrame");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.bottomLine.frame = CGRectMake(self.bottomLineWidth > 0 ? self.buttons[self.currentSelectButton.tag].x + (self.buttons[self.currentSelectButton.tag].width - self.bottomLineWidth)/2: self.buttons[self.currentSelectButton.tag].x, self.buttons[self.currentSelectButton.tag].y + self.buttons[self.currentSelectButton.tag].height, self.bottomLineWidth > 0 ? self.bottomLineWidth : self.buttons[self.currentSelectButton.tag].width, 2);
        }];
    });
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = self.bottomLineColor;
        [_scrollView addSubview:self.bottomLine];
    }
    return _bottomLine;
}

- (void)setBottomLineWidth:(float)bottomLineWidth {
    _bottomLineWidth = bottomLineWidth;
    
    [self updateBottomLineFrame];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
