#import "YPTModel.h"
#import "YPTTripCountryList.h"

@interface YPTTripCountryLine : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * isShowMore;
@property (nonatomic, strong) NSArray * list;
@property (nonatomic, strong) NSString * moreTitle;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * typeName;


@end