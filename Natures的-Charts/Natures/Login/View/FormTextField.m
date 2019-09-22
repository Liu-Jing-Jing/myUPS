//
//  FormTextField.m
//  Natures
//
//  Created by 柏霖尹 on 2019/7/23.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "FormTextField.h"

@implementation FormTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 初始化那个圆角
    self.layer.cornerRadius = 10.0;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // 初始化那个圆角
        self.layer.cornerRadius = 15.0;
        self.backgroundColor = LLColor(58, 58, 69);
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectInset(bounds, 10, 5);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectInset(bounds, 10, 5);
    return inset;
}

// 重写此方法
-(void)drawPlaceholderInRect:(CGRect)rect
{
    // 计算占位文字的 Size
    CGSize placeholderSize = [self.placeholder sizeWithAttributes:@{NSFontAttributeName :self.font}];
    
    [self.placeholder drawInRect:CGRectMake(0, (rect.size.height - placeholderSize.height)/2, rect.size.width, rect.size.height) withAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor],NSFontAttributeName : self.font}];
}
@end
