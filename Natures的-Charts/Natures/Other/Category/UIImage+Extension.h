//
//  UIImage+Extension.h
//  EMS
//
//  Created by 柏霖尹 on 2019/6/25.
//  Copyright © 2019 work. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
+ (instancetype)circleimageWithIconImage:(UIImage *)icon borderImage:(UIImage *)borderImage border:(int)border;
// 返回对应图标的Image
+ (UIImage *)imageWithEmsName:(NSString *)name;
+ (UIImage *)selectImageWithEmsName:(NSString *)name;



/**
 通过指定的字符数据转为二维码图片

 @param strData 字符串数据
 @param size 注定 size
 @return 对象UIImage
 */
+ (UIImage *)getQRCodeWithString:(NSString *)strData setWidthAndHeigh:(CGFloat)size;
+ (UIImage *)imageWithStringConvertToQRC:(NSString *)strData setWidthAndHeigh:(CGFloat)size;

- (void)showMineForArr;
- (void)hiddenMineForArr;

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
