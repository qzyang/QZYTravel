//
//  YPTCountryBeenCell.h
//  QZYKit
//
//  Created by quzhenyang on 16/3/1.
//  Copyright © 2016年 qzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPTTripCountryList.h"

@interface YPTCountryBeenCell : UITableViewCell

@property (strong, nonatomic) NSArray *shineArray;
@property (strong, nonatomic) NSString *countryId;
@property (strong, nonatomic) NSString *cityId;
@property (copy, nonatomic) void (^ hotButtonTapBlock)(YPTTripCountryList *);

- (void)countryBeenCell:(NSArray *)poiArray;

@end
