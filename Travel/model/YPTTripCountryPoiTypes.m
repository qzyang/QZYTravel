//
//  YPTTripCounrtyPoiTypes.m
//  YoupuTrip
//
//  Created by quzhenyang on 16/3/16.
//  Copyright © 2016年 youputrip.com. All rights reserved.
//

#import "YPTTripCountryPoiTypes.h"

@implementation YPTTripCountryPoiTypes

/**
 * Mantle 必须实现的方法，如何属性和 JSON 中的 key 一一对应，用下面的方法则是最方便的。
 如果是 JSON 中没有的属性，要排除掉，加入这句话 [mapping removeObjectForKey:@"JSON中没有的属性"];
 如果是想改变对应关系，用这句话
 [mapping addEntriesFromDictionary:@{
 @"属性" : @"JSON字典中的key"
 }];
 */
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary* mapping = [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    [mapping removeObjectForKey:@"id"];
    [mapping addEntriesFromDictionary:@{
                                        @"idField" : @"id"
                                        }];
    return mapping;
    
}



#pragma mark - 自定义类型转换

@end
