//
//  YPTTripCountryTips.h
//  YoupuTrip
//
//  Created by quzhenyang on 16/3/16.
//  Copyright © 2016年 youputrip.com. All rights reserved.
//

#import "YPTModel.h"
#import "YPTTripCountryList.h"
//#import "YPTCurrentCityModel.h"

@interface YPTTripCountryTips : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSArray * list;

@end
