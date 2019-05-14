#import "YPTModel.h"
#import "YPTTripCountryGuide.h"
#import "YPTTripCountryHotCity.h"
#import "YPTTripCountryHotCity.h"
#import "YPTTripCountryLine.h"
#import "YPTTripCountryHotCity.h"
#import "YPTTripCountryShare.h"
#import "YPTTripCountryHotCity.h"
#import "YPTTripCountryTopic.h"
#import "YPTTripCountryTopx.h"
#import "YPTTripCountryTips.h"
#import "YPTTripCountryPoiTypes.h"

@interface YPTTripCountryRootClass : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString * cityId;
@property (nonatomic, strong) NSString * cnName;
@property (nonatomic, strong) NSString * countryId;
@property (nonatomic, strong) NSString * enName;
@property (nonatomic, strong) YPTTripCountryGuide * guide;
@property (nonatomic, strong) YPTTripCountryHotCity * knowDest;
@property (nonatomic, strong) NSString * picNum;
@property (nonatomic, strong) NSString * picOwner;
@property (nonatomic, strong) NSString * picture;
@property (nonatomic, strong) NSString * pid;
@property (nonatomic, strong) NSArray * poiTypes;
@property (nonatomic, strong) NSArray *productTypes;
@property (nonatomic, strong) YPTTripCountryShare * share;

@property (nonatomic, strong) YPTTripCountryTopx * topx;
@property (nonatomic, strong) NSString * jumptehui;
@property (strong, nonatomic) NSString * tripType;
@property (nonatomic, strong) YPTTripCountryTips * tips;

@property (nonatomic, strong) YPTTripCountryHotCity * hotCities;
@property (nonatomic, strong) YPTTripCountryHotCity * product;
@property (nonatomic, strong) YPTTripCountryHotCity * shinePic;
@property (nonatomic, strong) YPTTripCountryTopic * topic;
@property (nonatomic, strong) YPTTripCountryLine * line;
@property (nonatomic, strong) YPTTripCountryLine *superj;

@end
