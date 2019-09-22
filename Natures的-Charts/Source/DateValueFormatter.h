//
//  DateValueFormatter.h
//  ChartsTest
//
//  Created by 柏霖尹 on 2019/7/24.
//  Copyright © 2019 work. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Natures-Bridging-Header.h"


@interface DateValueFormatter : NSObject<IChartValueFormatter>
- (id)initWithArr:(NSArray *)arr;
@end

