//
//  PagingTopButtonView.h
//  myWheel
//
//  Created by xujiangtao on 2018/12/4.
//  Copyright © 2018年 xujiangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagingTopButtonView : UIView

//buttonView上的标题按钮 可以自定义
@property (weak, nonatomic) IBOutlet UIButton *pagingButton;
//标题按钮点击回调
@property (nonatomic, copy) void(^pagingButtonClickBlock)(UIButton *sender);

@end
