# 分页控制器

依赖Masonry

特性:
* 1.可以先不创建每页的view,只指定滑动页数,之后再动态添加;
* 2.标题数组个数可以跟页面页数不相等,之后动态添加;
* 3.可以先创建一部分页数,之后再动态添加页数;
* 4.可以动态添加页数,添加1页或者多页;
* 5.动态修改标题栏高度,间距等;
* 6.支持转屏;
* 7.所有标题的宽度小于屏幕宽度时,平分屏幕宽度;
* 8.支持简单的动画;

```
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

//动画类型
@property (nonatomic, assign) PaingAnimationType animationType;

//页数--可以先不创建view,使用页数来创建scrollView的可滚动页数
@property (nonatomic, assign) NSInteger pages;

//一次添加一个view
- (void)addViewForBottomView:(UIView *)view;
//一次添加多个view
- (void)addViewsForBottomView:(NSMutableArray<UIView *> *)views;
//移除所有view
- (void)removeAllViews;

//一次添加一个标题
- (void)addTitleForTopView:(NSString *)title;
//一次添加多个标题
- (void)addTitlesForTopView:(NSMutableArray *)titles;
//移除所有标题
- (void)removeAllTitles;

//手动选择某页 从0开始
- (void)selectPageWithNumber:(NSInteger)number;
```
