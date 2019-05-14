//
//  YPTTripCountryFlowRequest.m
//  YoupuTrip
//
//  Created by quzhenyang on 16/3/15.
//  Copyright © 2016年 youputrip.com. All rights reserved.
//

#import "YPTTripCountryFlowRequest.h"

@implementation YPTTripCountryFlowRequest

- (NSString *)baseUrl {
    return YPTMapiUrlString;
}

- (NSString*)requestUrl
{
    return @"/recommend/getRecommedListByType";
}
- (NSDictionary*)requestYPTArgument {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    if (_countryId) {
        parameter[@"countryId"] = _countryId;
    }
    if (_cityId) {
        parameter[@"cityId"] = _cityId;
    }
    if (_typeName) {
        parameter[@"typeName"] = _typeName;
    }
    if (self.poiId) {
        parameter[@"poiId"] = self.poiId;
    }
    parameter[@"page"] = _page;
    return parameter;
}

- (NSDictionary*)requestHeaderImageFieldValueDictionary
{
    NSString* picSizeValue = [YPTHTTPClient headStringWithtypeArray:@[@"bPic",@"sPic"] widthArray:@[@(screenWidth),@(40)] heightArray:@[@(screenWidth *17/32),@(40)] cornerRadioArray:@[@(0),@(20)]];
    return @{ @"ypimg" : picSizeValue };
}

@end
