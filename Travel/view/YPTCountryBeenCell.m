//
//  YPTCountryBeenCell.m
//  QZYKit
//
//  Created by quzhenyang on 16/3/1.
//  Copyright © 2016年 qzy. All rights reserved.
//

#import "YPTCountryBeenCell.h"
#import <YYWebImage.h>
#import "YPTPicBrowserController.h"
#import "YPTDBDao.h"

@implementation YPTCountryBeenCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    for (int i = 0; i < 3; i ++) {
        UIImageView *hotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + i * (screenWidth / 3) + (i * 1), 10, screenWidth / 3, screenWidth / 3)];
        hotImageView.tag = i + 100;
        hotImageView.hidden = YES;
        hotImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:hotImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotButtonClick:)];
        [hotImageView addGestureRecognizer:tap];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, hotImageView.frame.size.width, hotImageView.frame.size.height)];
        backView.backgroundColor = UIColorFromRGBA(0x000000,0.3);
        backView.tag = i + 100;
        [hotImageView addSubview:backView];
        
        [backView addGestureRecognizer:tap];
        
        UIButton *desButton = [[UIButton alloc] initWithFrame:CGRectMake(5, hotImageView.frame.size.height - 20, hotImageView.frame.size.width - 10, 17)];
        [desButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [desButton.titleLabel setFont:UIFontFromSize(10)];
        [desButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [desButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        desButton.tag = i + 200;
        desButton.hidden = YES;
        [hotImageView addSubview:desButton];
    }
}

- (void)hotButtonClick:(UITapGestureRecognizer *)tap {
    if ( tap.view.tag - 100 < _shineArray.count && _hotButtonTapBlock) {
        YPTTripCountryList *model = _shineArray[tap.view.tag - 100];
        _hotButtonTapBlock(model);
    }
}

- (void)countryBeenCell:(NSArray *)poiArray {
    _shineArray = poiArray;
    [poiArray enumerateObjectsUsingBlock:^(YPTTripCountryList *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *hotImageView = (UIImageView *)[self.contentView viewWithTag:idx + 100];
        hotImageView.hidden = NO;
        [hotImageView yy_setImageWithURL:[NSURL URLWithString:[obj.path firstObject]] placeholder:placeholderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
        UIButton *desButton = (UIButton *)[hotImageView viewWithTag:idx + 200];
        desButton.hidden = NO;
        if (! [obj.poiCnName isEqualToString:@""]) {
            [desButton setTitle:obj.poiCnName forState:UIControlStateNormal];
            [desButton setImage:[UIImage imageNamed:@"MasterLocation"] forState:UIControlStateNormal];
        }
    }];
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
