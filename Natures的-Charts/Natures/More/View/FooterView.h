//
//  FooterView.h
//  Natures
//
//  Created by 柏霖尹 on 2019/8/5.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FooterView;
@protocol FooterViewDelegate <NSObject>
- (void)footerViewSaveButtonClicked:(FooterView *)sender;
- (void)footerViewLogoutButtonClicked:(FooterView *)sender;
@end
@interface FooterView : UIView
@property (nonatomic, weak) id<FooterViewDelegate> footerDelegate;
+ (instancetype)footerView;
@end

NS_ASSUME_NONNULL_END
