//
//  YPTCountryHotCityCell.m
//  QZYKit
//
//  Created by quzhenyang on 16/3/1.
//  Copyright © 2016年 qzy. All rights reserved.
//

#import "YPTCountryHotCityCell.h"
#import "YPTTripCountryList.h"
#import <YYWebImage.h>
#import "YPTCurrentCityController.h"
#import "YPTDBDao.h"

@implementation YPTCountryHotCityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    for (int i = 0; i < 3; i++) {
        UIImageView *cityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + i * (screenWidth / 3) + (i * 1), 10, screenWidth / 3, screenWidth / 3)];
        cityImageView.tag = i + 50;
        cityImageView.hidden = YES;
        cityImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:cityImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cityButtonTapped:)];
        [cityImageView addGestureRecognizer:tap];
        
        UILabel *cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(cityImageView.frame.origin.x, CGRectGetMaxY(cityImageView.frame) + 10, screenWidth / 3, 15)];
        cityNameLabel.textColor = UIColorFromRGB(0x333333);
        cityNameLabel.font = UIFontBoldSize(15);
        cityNameLabel.textAlignment = NSTextAlignmentCenter;
        cityNameLabel.tag = i + 100;
        cityNameLabel.hidden = YES;
        [self.contentView addSubview:cityNameLabel];
    }
}
- (void)hotCityCell:(NSArray *)hotCityArray {
    
    _hotArray = hotCityArray;
    [hotCityArray enumerateObjectsUsingBlock:^(YPTTripCountryList *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *cityImageView = (UIImageView *)[self.contentView viewWithTag:50 + idx];
        cityImageView.hidden = NO;
        [cityImageView yy_setImageWithURL:[NSURL URLWithString:obj.picPath] placeholder:placeholderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
        UILabel *cityNameLabel = (UILabel *)[self.contentView viewWithTag:100 + idx];
        cityNameLabel.hidden = NO;
        cityNameLabel.text = obj.cnName;
        if (hotCityArray.count < 3) {
            cityImageView.frame = CGRectMake((screenWidth - screenWidth / 3 * hotCityArray.count) / 2 + (idx * (screenWidth / 3) + (idx * 1)), 10, screenWidth / 3, screenWidth / 3);
            cityNameLabel.frame = CGRectMake(cityImageView.frame.origin.x, CGRectGetMaxY(cityImageView.frame) + 10, screenWidth / 3, 15);
        }
    }];
}
- (void)cityButtonTapped:(UITapGestureRecognizer *)tap {
    YPTTripCountryList *model = _hotArray[tap.view.tag - 50];
    YPTCurrentCityController *controller = [YPTCurrentCityController instance];
    controller.cityId = model.cityId;
    [[self viewController].navigationController pushViewController:controller animated:YES];
    
    NSArray *array = @[_countryId, model.cityId];
    NSString *jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    [[YPTDBDao sharedInstance] recordClickEvent:[YPTDBDao splitContent:@"hot_city" name:@"countryId,cityId" value:jsonString index:-1 viewType:@"i2.destination"] type:0 url:0];
}

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
