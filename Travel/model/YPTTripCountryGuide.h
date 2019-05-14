#import "YPTModel.h"
#import "YPTTripCountryList.h"

@interface YPTTripCountryGuide : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSArray * list;
@property (nonatomic, strong) NSString * title;


@end