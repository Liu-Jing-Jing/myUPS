//
//  WLCopyLabel.m
//  WLCopyLabel
//
//  Created by wangguoliang on 16/6/23.
//  Copyright © 2016年 wangguoliang. All rights reserved.
//

#import "WLCopyLabel.h"

@implementation WLCopyLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}
/**
 *  成为第一响应者
 */
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
/**
 *  这个方法决定了MenuController的菜单项内容
 *  返回YES，就代表MenuController会有action菜单项
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}
#pragma mark - 长按手势事件
- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    [self becomeFirstResponder];
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIMenuController *popMenu = [UIMenuController sharedMenuController];
        //UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copy1:)];
        //[popMenu setMenuItems:[NSArray arrayWithObjects:copyItem, nil]];
        [popMenu setArrowDirection:UIMenuControllerArrowDown];
        CGRect frame = self.frame;
        [popMenu setTargetRect:frame inView:self.superview];
        [popMenu setMenuVisible:YES animated:YES];
    }
}
#pragma mark - 复制
- (void)copy:(nullable id)sender
{
    if (self.text.length > 0 && self.text != nil) {
        [UIPasteboard generalPasteboard].string = self.text;
    }
}

#pragma mark - 剪切
- (void)cut:(nullable id)sender
{
    if (self.text.length > 0 && self.text != nil) {
        [UIPasteboard generalPasteboard].string = self.text;
    }
    self.text = nil;
}

- (void)paste:(nullable id)sender
{
    NSString *pasteboard = [UIPasteboard generalPasteboard].string;
    if (pasteboard.length > 0 && pasteboard) {
        self.text = [self.text stringByAppendingString:pasteboard];
    }
}

#pragma mark - 选择
- (void)select:(nullable id)sender
{
    //
}

#pragma mark - 全选
- (void)selectAll:(nullable id)sender
{
    //
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
