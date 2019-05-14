//
//	YPTTripCountryRootClass.m


#import "YPTTripCountryRootClass.h"

@implementation YPTTripCountryRootClass





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
	return mapping;

}


#pragma mark - 自定义类型转换

+ (NSValueTransformer*)productTypesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:YPTTripCountryPoiTypes.class];
}

+ (NSValueTransformer*)poiTypesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:YPTTripCountryPoiTypes.class];
}
+ (NSValueTransformer*)guideJSONTransformer
{
	return [MTLJSONAdapter dictionaryTransformerWithModelClass:YPTTripCountryGuide.class];
}
+ (NSValueTransformer*)hotCitiesJSONTransformer
{
	return [MTLJSONAdapter dictionaryTransformerWithModelClass:YPTTripCountryHotCity.class];
}
+ (NSValueTransformer*)knowDestJSONTransformer
{
	return [MTLJSONAdapter dictionaryTransformerWithModelClass:YPTTripCountryHotCity.class];
}
+ (NSValueTransformer*)lineJSONTransformer
{
	return [MTLJSONAdapter dictionaryTransformerWithModelClass:YPTTripCountryLine.class];
}

+ (NSValueTransformer*)superjJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:YPTTripCountryLine.class];
}
+ (NSValueTransformer*)productJSONTransformer
{
	return [MTLJSONAdapter dictionaryTransformerWithModelClass:YPTTripCountryHotCity.class];
}
+ (NSValueTransformer*)shareJSONTransformer
{
	return [MTLJSONAdapter dictionaryTransformerWithModelClass:YPTTripCountryShare.class];
}
+ (NSValueTransformer*)shinePicJSONTransformer
{
	return [MTLJSONAdapter dictionaryTransformerWithModelClass:YPTTripCountryHotCity.class];
}
+ (NSValueTransformer*)topicJSONTransformer
{
	return [MTLJSONAdapter dictionaryTransformerWithModelClass:YPTTripCountryTopic.class];
}
+ (NSValueTransformer*)topxJSONTransformer
{
	return [MTLJSONAdapter dictionaryTransformerWithModelClass:YPTTripCountryTopx.class];
}

@end
