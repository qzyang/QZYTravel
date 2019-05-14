//
//  YPTCountryRecommendCell.h
//  QZYKit
//
//  Created by quzhenyang on 16/3/1.
//  Copyright © 2016年 qzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPTTripCountryList.h"
#import "YPTProductDetailRecommendData.h"

@interface YPTCountryRecommendCell : UITableViewCell

@property (strong, nonatomic) UIImageView *tripImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *designNameLabel;
@property (strong, nonatomic) UIButton *designerButton;
@property (strong, nonatomic) UIButton *browButton;

- (void)countryRecommendCell:(YPTTripCountryList *)model;
- (void)countryTopicCell:(YPTTripCountryList *)model;
- (void)thdetailCell:(YPTProductDetailRecommendData *)model;

@end
