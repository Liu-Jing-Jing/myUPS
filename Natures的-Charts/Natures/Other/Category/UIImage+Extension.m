//
//  UIImage+Extension.m
//  EMS
//
//  Created by 柏霖尹 on 2019/6/25.
//  Copyright © 2019 work. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+ (instancetype)circleimageWithIconImage:(UIImage *)icon borderImage:(UIImage *)borderImage border:(int)border
{
    
    //头像图片
    
    UIImage * image = icon;
    
    //边框图片
    
    UIImage * borderImg = borderImage;//[UIImage imageNamed:borderImage];
    
    //
    
    CGSize size = CGSizeMake(image.size.width + border, image.size.height + border);
    
    
    
    //创建图片上下文
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    
    
    //绘制边框的圆
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
    
    
    
    //剪切可视范围
    
    CGContextClip(context);
    
    
    
    //绘制边框图片
    
    [borderImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    
    
    //设置头像frame
    
    CGFloat iconX = border / 2;
    
    CGFloat iconY = border / 2;
    
    CGFloat iconW = image.size.width;
    
    CGFloat iconH = image.size.height;
    
    
    
    //绘制圆形头像范围
    
    CGContextAddEllipseInRect(context, CGRectMake(iconX, iconY, iconW, iconH));
    
    
    
    //剪切可视范围
    
    CGContextClip(context);
    
    
    
    //绘制头像
    
    [image drawInRect:CGRectMake(iconX, iconY, iconW, iconH)];
    
    
    
    //取出整个图片上下文的图片
    
    UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
    return iconImage;
    
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
+ (UIImage *)imageWithStringConvertToQRC:(NSString *)strData setWidthAndHeigh:(CGFloat)size
{
    return [self getQRCodeWithString:strData setWidthAndHeigh:size];
}
+ (UIImage *)getQRCodeWithString:(NSString *)strData setWidthAndHeigh:(CGFloat)size
{
    //创建滤镜对象
    CIFilter *fiter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [fiter setDefaults];
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    [fiter setValue:data forKeyPath:@"inputMessage"];
    
    //获取输出结果
    CIImage *outputImage = [fiter outputImage];
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}



+ (UIImage *)imageWithEmsName:(NSString *)name
{
    NSString *str = [NSString stringWithFormat:@"%@2", name];
    return [self imageNamed:str];
}
+ (UIImage *)selectImageWithEmsName:(NSString *)name
{
    NSString *str = [NSString stringWithFormat:@"%@1", name];
    return [self imageNamed:str];
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{

    return [self resizedImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}
@end
