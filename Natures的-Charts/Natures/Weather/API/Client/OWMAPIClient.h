//
//  OWMAPIClient.h
//  openweather-ios
//
//  Created by Harry Singh on 19/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "AFNetworking.h"
#import "OWMNetworkProtocol.h"

@interface OWMAPIClient : AFHTTPSessionManager <OWMNetworkProtocol>

@end
