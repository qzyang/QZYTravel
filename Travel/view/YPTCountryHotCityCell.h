//
//  YPTCountryHotCityCell.h
//  QZYKit
//
//  Created by quzhenyang on 16/3/1.
//  Copyright © 2016年 qzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPTCountryHotCityCell : UITableViewCell

@property (strong, nonatomic) NSArray *hotArray;
@property (strong, nonatomic) NSString *countryId;

- (void)hotCityCell:(NSArray *)hotCityArray;

@end
