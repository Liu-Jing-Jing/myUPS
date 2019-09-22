//
//  OWMNetworkProtocol.h
//  openweather-ios
//
//  Created by Harry Singh on 19/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NetworkStatusNotReachable = 0,
    NetworkStatusRechable
} NetworkStatus;

typedef void (^NetworkStatusChangeBlock)(NetworkStatus status);

@protocol OWMNetworkProtocol <NSObject>
@required
@property (readonly) NetworkStatus networkStatus;
@property (copy, nonatomic) NetworkStatusChangeBlock _Nonnull networkStatusBlock;

-(instancetype _Nullable)initWithBaseURL:(NSURL * _Nonnull)url;

-(void)performGETCallToEndpoint:(NSString * _Nullable)endpoint
                 withParameters:(NSDictionary * _Nullable)params
                     andSuccess:(void (^ _Nonnull)(id _Nullable responseObject))success
                     andFailure:(void (^ _Nonnull)(NSError * _Nullable error))failure;

-(void)performPOSTCallToEndpoint:(NSString * _Nullable)endpoint
                  withParameters:(NSDictionary * _Nullable)params
                     withSuccess:(void (^ _Nonnull)(id _Nullable responseObject))success
                      andFailure:(void (^ _Nonnull)(NSError * _Nullable error))failure;

-(void)performPUTCallToEndpoint:(NSString * _Nullable)endpoint
                 withParameters:(NSDictionary * _Nullable)params
                     andSuccess:(void (^ _Nonnull)(id _Nullable responseObject))success
                     andFailure:(void (^ _Nonnull)(NSError * _Nullable error))failure;

-(void)performDELETECallToEndpoint:(NSString * _Nullable)endpoint
                    withParameters:(NSDictionary * _Nullable)params
                        andSuccess:(void (^ _Nonnull)(id _Nullable responseObject))success
                        andFailure:(void (^ _Nonnull)(NSError * _Nullable error))failure;
@end

