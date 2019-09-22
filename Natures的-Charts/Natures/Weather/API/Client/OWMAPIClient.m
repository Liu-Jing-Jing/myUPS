//
//  OWMAPIClient.m
//  openweather-ios
//
//  Created by Harry Singh on 19/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "OWMAPIClient.h"

@interface OWMAPIClient()
@property (assign, nonatomic) NetworkStatus networkStatus;

@end

@implementation OWMAPIClient

@synthesize networkStatusBlock;

+ (instancetype _Nullable)client {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"- client is not a valid initializer. Use initWithBaseURL:"
                                 userInfo:nil];
}

-(instancetype)initWithBaseURL:(NSURL *)url{
    if (self = [super initWithBaseURL:url]) {
        [self setupClient];
        [self setupRechability];
    }
    
    return self;
}

-(void)setupClient{
    //Assuming most people will have self signed certs.
    self.securityPolicy.allowInvalidCertificates = YES;
    self.securityPolicy.validatesDomainName = NO;
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[[AFImageResponseSerializer serializer], [AFJSONResponseSerializer serializer]]];
    
    //Set challenge block to allow invalid / self signed certs
    [self setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        return NSURLSessionResponseAllow;
    }];
}

-(void)setupRechability{
    self.reachabilityManager = [AFNetworkReachabilityManager managerForDomain:@"www.google.com"];
    [self.reachabilityManager startMonitoring];
    
    __weak typeof(self) wself = self;
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        __strong typeof(self) sself = wself;
        
        if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
            sself.networkStatus = NetworkStatusRechable;
        } else {
            sself.networkStatus = NetworkStatusNotReachable;
        }
        
        if(sself.networkStatusBlock){
            sself.networkStatusBlock(sself.networkStatus);
        }
    }];
}

-(void)performPOSTCallToEndpoint:(NSString *)endpoint
                  withParameters:(NSDictionary *)params
                     withSuccess:(void (^)(id responseObject))success
                      andFailure:(void (^)(NSError *error))failure{
    [self POST:endpoint parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)performGETCallToEndpoint:(NSString *)endpoint
                 withParameters:(NSDictionary *)params
                     andSuccess:(void (^)(id responseObject))success
                     andFailure:(void (^)(NSError *error))failure{
    [self GET:endpoint parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)performPUTCallToEndpoint:(NSString *)endpoint
                 withParameters:(NSDictionary *)params
                     andSuccess:(void (^)(id responseObject))success
                     andFailure:(void (^)(NSError *))failure{
    [self PUT:endpoint parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)performDELETECallToEndpoint:(NSString *)endpoint
                    withParameters:(NSDictionary *)params
                        andSuccess:(void (^)(id responseObject))success
                        andFailure:(void (^)(NSError *error))failure{
    [self DELETE:endpoint parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
