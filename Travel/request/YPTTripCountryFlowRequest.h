//
//  YPTTripCountryFlowRequest.h
//  YoupuTrip
//
//  Created by quzhenyang on 16/3/15.
//  Copyright © 2016年 youputrip.com. All rights reserved.
//

#import "YPTBaseRequest.h"

@interface YPTTripCountryFlowRequest : YPTBaseRequest

@property (strong, nonatomic) NSString *countryId;
@property (strong, nonatomic) NSString *cityId;
@property (nonatomic, strong) NSString *poiId;
@property (strong, nonatomic) NSString *typeName;
@property (strong, nonatomic) NSString *page;

@end
