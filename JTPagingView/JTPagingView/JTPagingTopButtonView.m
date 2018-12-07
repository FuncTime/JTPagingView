//
//  JTPagingTopButtonView.m
//  myWheel
//
//  Created by xujiangtao on 2018/12/4.
//  Copyright © 2018年 xujiangtao. All rights reserved.
//

#import "JTPagingTopButtonView.h"

@implementation JTPagingTopButtonView
- (IBAction)pagingButtonClick:(UIButton *)sender {
    if (self.pagingButtonClickBlock) {
        self.pagingButtonClickBlock(sender);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
