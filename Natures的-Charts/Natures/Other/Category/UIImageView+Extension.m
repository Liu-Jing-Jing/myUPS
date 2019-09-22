//
//  UIImageView+Extension.m
//  EMS
//
//  Created by 柏霖尹 on 2019/6/27.
//  Copyright © 2019 work. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)
- (void)hightlightRedImageView
{
    if([self isKindOfClass:[UIImageView class]])
    {
        // 修改图片的高亮状态
        self.highlighted= YES;
    }
}

- (void)deselectImageView
{
    if([self isKindOfClass:[UIImageView class]])
    {
        // 修改图片的高亮状态
        self.highlighted= NO;
    }
}
@end
