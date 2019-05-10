//
//  PagingViewController.m
//  myWheel
//
//  Created by xujiangtao on 2018/12/3.
//  Copyright © 2018年 xujiangtao. All rights reserved.
//

#import "PagingViewController.h"
#import "JTPagingView.h"

@interface PagingViewController ()

@property (nonatomic, strong) JTPagingView *paging;

@end

@implementation PagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
}

- (void)createViews {
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
    UIBarButtonItem *rightBarWinConstraints = [[UIBarButtonItem alloc] initWithTitle:@"约束" style:UIBarButtonItemStylePlain target:self action:@selector(constraintsButtonClick:)];
    self.navigationItem.rightBarButtonItems = @[rightBar,rightBarWinConstraints];
    
    
    
    NSMutableArray *titles = (NSMutableArray *)@[@"哈哈哈哈",@"哈哈哈哈",@"哈哈哈哈",@"哈哈哈哈",@"哈哈哈哈"];
//    self.paging.bottomLineWidth = 80;
    NSMutableArray *views = [NSMutableArray array];
    
    
    
    
    if ([self.title isEqualToString:@"分页"]) {
        
        for (int i = 0; i < titles.count; i ++) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = RANDOM_COLOR;
            [views addObject:view];
            
            if (i == 1) {
                UILabel *label = [[UILabel alloc] init];
                label.text = @"哈哈哈哈";
                label.font = [UIFont systemFontOfSize:20];
                [view addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(view);
                }];
            }
        }
        
        
//        self.paging.views = views;
//        self.paging.titles = titles;
        self.paging = [JTPagingView pagingWithTitles:titles views:views];
//        self.paging.pages = 8;
//        [self.paging selectPageWithNumber:3];
//        self.paging.animationType = paingAnimationAlpha;
        
    }else if ([self.title isEqualToString:@"分页(添加一个)"]) {
        self.paging = [[JTPagingView alloc] init];
        self.paging.titles = titles;
        self.paging.pages = 7;
    }else if ([self.title isEqualToString:@"分页(添加多个,3个为例)"]) {
        self.paging = [[JTPagingView alloc] init];
        self.paging.titles = titles;
        self.paging.pages = 10;
    }
    
    
    
    [self.view addSubview:self.paging];
    
    [self.paging mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0,*)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }else{
            make.top.equalTo(self.view.mas_top).offset(64);
        }
        make.left.right.bottom.equalTo(self.view);
    }];
    
    
    self.paging.currentPageBlock = ^(NSInteger currentPage) {
        NSLog(@"currentPage---%ld",currentPage);
    };
    
//    self.paging.bottomLineColor = [UIColor blackColor];
//    self.paging.selectColor = [UIColor blueColor];
//    self.paging.noSelectColor = [UIColor lightGrayColor];
    
}

- (void)rightBarButtonClick:(UIBarButtonItem *)item {
    
    NSMutableArray *views = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        UIView *view = [UIView new];
        [views addObject:view];
        view.backgroundColor = RANDOM_COLOR;
    }

    if ([self.title isEqualToString:@"分页(添加一个)"]) {
        UIView *view = [UIView new];
        view.backgroundColor = RANDOM_COLOR;
        [self.paging addViewForBottomView:view];
    }else if ([self.title isEqualToString:@"分页(添加多个,3个为例)"]) {

        [self.paging addViewsForBottomView:views];
    }else {
        UIView *view = [UIView new];
        view.backgroundColor = RANDOM_COLOR;
        [self.paging addViewForBottomView:view];
    }
//    [self.paging removeAllTitles];
}

- (void)constraintsButtonClick:(UIBarButtonItem *)item {
    
//    self.paging.leftSpacing = 50;
//    self.paging.rightSpacing = 30;
//    self.paging.buttonSpacing = 20;
//    self.paging.topViewHeight = 100;
    
//    self.paging.bottomViewBackgroundColor = [UIColor grayColor];
//    self.paging.topViewBackgroundColor = [UIColor lightGrayColor];
    
//    [self.paging addTitleForTopView:@"呀呀"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
