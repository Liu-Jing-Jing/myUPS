//
//  OWMPermissionProtocol.h
//  openweather-ios
//
//  Created by Harry Singh on 19/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PermissionGranted,
    PermissionDenied
} Permission;

typedef void (^PermissionCompletionHandler)(Permission permission);

@protocol OWMPermissionProtocol
@required
-(NSAttributedString *)message;
-(void)requestPermissionWithCompletion:(PermissionCompletionHandler)completion;
@end
