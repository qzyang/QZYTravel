//
//  YPTTripCounrtyPoiTypes.h
//  YoupuTrip
//
//  Created by quzhenyang on 16/3/16.
//  Copyright © 2016年 youputrip.com. All rights reserved.
//

#import "YPTModel.h"
#import "YPTTripCountryList.h"

@interface YPTTripCountryPoiTypes : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * option;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString *icon;

@end
