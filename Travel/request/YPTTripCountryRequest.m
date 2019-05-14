//
//  YPTTripCountryRequest.m
//  YoupuTrip
//
//  Created by quzhenyang on 16/3/14.
//  Copyright © 2016年 youputrip.com. All rights reserved.
//

#import "YPTTripCountryRequest.h"

@implementation YPTTripCountryRequest

- (NSString *)baseUrl {
    return YPTMapiUrlString;
}

- (NSString*)requestUrl
{
    return @"/country/getGeneralInfo";
}
- (NSDictionary*)requestYPTArgument {
    return @{@"id" : _countryId};
}

- (NSDictionary*)requestHeaderImageFieldValueDictionary
{
    NSString* picSizeValue = [YPTHTTPClient headStringWithtypeArray:@[@"bPic",@"mPic",@"sPic"] widthArray:@[@(screenWidth),@(screenWidth / 3),@(85)] heightArray:@[@(screenWidth * 3 / 4),@(screenWidth / 3),@(85)] cornerRadioArray:@[@(0),@(0),@(0)]];
    return @{ @"ypimg" : picSizeValue };
}

@end
