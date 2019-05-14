#import "YPTModel.h"

@interface YPTTripCountryList : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * option;
@property (strong, nonatomic) NSString * desc;
@property (nonatomic, strong) NSString * url;
@property (strong, nonatomic) NSString * cityId;
@property (strong, nonatomic) NSString * picPath;
@property (strong, nonatomic) NSString * cnName;
@property (strong, nonatomic) NSString * enName;
@property (strong, nonatomic) NSString * lineId;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * memberId;
@property (strong, nonatomic) NSString * memberName;
@property (strong, nonatomic) NSString * memberIcon;
@property (strong, nonatomic) NSString * author;
@property (strong, nonatomic) NSString * roleName;
@property (strong, nonatomic) NSString * picId;
@property (strong, nonatomic) NSArray * path;
@property (strong, nonatomic) NSString * countryCnName;
@property (strong, nonatomic) NSString * cityCnName;
@property (strong, nonatomic) NSString * poiCnName;
@property (strong, nonatomic) NSString * productId;
@property (strong, nonatomic) NSString * pic;
@property (strong, nonatomic) NSString * price;
@property (strong, nonatomic) NSString * viewCount;
@property (strong, nonatomic) NSString * basePrice;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * data;
@property (strong, nonatomic) NSString * icon;



@end