//
//  YPTCountryHeaderView.h
//  QZYKit
//
//  Created by quzhenyang on 16/2/29.
//  Copyright © 2016年 qzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPTTripCountryRootClass.h"

@interface YPTCountryHeaderView : UIView

@property (strong, nonatomic) YPTTripCountryRootClass *headerModel;

@property (strong, nonatomic) UILabel *countryNameLabel;
@property (strong, nonatomic) UIImageView *countryImage;
@property (strong, nonatomic) UIView *backView;

- (void)loadUI;

@end
