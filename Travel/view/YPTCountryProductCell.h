//
//  YPTCountryProductCell.h
//  QZYKit
//
//  Created by quzhenyang on 16/3/1.
//  Copyright © 2016年 qzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPTTripCountryList.h"

@interface YPTCountryProductCell : UITableViewCell

@property (strong, nonatomic) UIImageView *travelNoteImageView;
@property (strong, nonatomic) UILabel *travelNoteLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *marketPriceLabel;

- (void)countryProductCell:(YPTTripCountryList *)model;

@end
