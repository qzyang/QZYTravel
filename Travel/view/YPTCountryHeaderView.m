//
//  YPTCountryHeaderView.m
//  QZYKit
//
//  Created by quzhenyang on 16/2/29.
//  Copyright © 2016年 qzy. All rights reserved.
//

#import "YPTCountryHeaderView.h"
#import "UIImageView+YYWebImage.h"
#import <YYWebImage/YYWebImage.h>
#import "YPTWebController.h"
#import "YPTTpxNewController.h"
#import "YPTShineDestController.h"
#import "YPTPOIListController.h"
#import "YPTDBDao.h"
#import "YPTCityProductBtn.h"
#import "YPTPayController.h"

static NSInteger const countryNameLabelY = 90;
static NSInteger const countryNameLabelHeight = 36;
static NSInteger const typeImageViewX = 25;
static NSInteger const typeImageViewY = 18;
static NSInteger const typeImageViewWidth = 30;
static NSInteger const typeImageViewHeight = 30;

@implementation YPTCountryHeaderView

- (void)loadUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    _countryImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth * 3 / 4)];
    [_countryImage yy_setImageWithURL:[NSURL URLWithString:_headerModel.picture] placeholder:placeholderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    _countryImage.userInteractionEnabled = YES;
    [self addSubview:_countryImage];
    
    _backView = [[UIView alloc] initWithFrame:_countryImage.frame];
    _backView.backgroundColor = UIColorFromRGBA(0x000000,0.3);
    _backView.userInteractionEnabled = YES;
    [self addSubview:_backView];
    
    if ([_headerModel.picNum integerValue] > 0) {
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(countryImageTap)];
        [_backView addGestureRecognizer:imageTap];
        
        UIButton *picCountButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth / 2, CGRectGetMaxY(_countryImage.frame) - 31, screenWidth / 2 - 15, 16)];
        [picCountButton setTitle:_headerModel.picNum forState:UIControlStateNormal];
        [picCountButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [picCountButton setImage:[UIImage imageNamed:@"tripCountryShine"] forState:UIControlStateNormal];
        picCountButton.titleLabel.font = UIFontFromSize(16);
        picCountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [picCountButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [self addSubview:picCountButton];
        
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_countryImage.frame) - 30, screenWidth / 2, 16)];
        if (! [_headerModel.picOwner isEqualToString:@""]) {
            userNameLabel.text = [NSString stringWithFormat:@"晒图by @%@",_headerModel.picOwner];
        }
        userNameLabel.textColor = UIColorFromRGB(0xffffff);
        userNameLabel.font = UIFontFromSize(14);
        [self addSubview:userNameLabel];
    }
    
    _countryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, countryNameLabelY, screenWidth, countryNameLabelHeight)];
    [self labelProperty:_countryNameLabel text:_headerModel.cnName fontSize:36];
    [self addSubview:_countryNameLabel];
    
    UILabel *countryEnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_countryNameLabel.frame) + 10, screenWidth, 26)];
    [self labelProperty:countryEnLabel text:_headerModel.enName fontSize:24];
    [self addSubview:countryEnLabel];
    
    [_headerModel.knowDest.list enumerateObjectsUsingBlock:^(YPTTripCountryList *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(0 + idx * (screenWidth / 2), CGRectGetMaxY(_countryImage.frame), screenWidth / 2, 65)];
        [typeButton addTarget:self action:@selector(typeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        typeButton.tag = idx + 10;
        [self addSubview:typeButton];
        
        UIImageView *typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(typeImageViewX, typeImageViewY, typeImageViewWidth, typeImageViewHeight)];
        if (idx == 0) {
            [typeImageView setImage:[UIImage imageNamed:@"tripCountryGuide"]];
        } else {
            [typeImageView setImage:[UIImage imageNamed:@"tripCountryVisa"]];
        }
        [typeButton addSubview:typeImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(typeImageView.frame) + 15, 0, typeButton.frame.size.width - 65, 65)];
        titleLabel.text = [NSString stringWithFormat:@"%@\n%@",obj.option,obj.desc];
        titleLabel.textColor = UIColorFromRGB(0x999999);
        titleLabel.font = UIFontFromSize(12);
        titleLabel.numberOfLines = 2;
        [typeButton addSubview:titleLabel];
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
        para.lineSpacing = 3;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:titleLabel.text attributes:@{NSParagraphStyleAttributeName:para}];
        [att addAttribute:NSFontAttributeName value:UIFontBoldSize(15) range:NSMakeRange(0, obj.option.length)];
        [att addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, obj.option.length)];
        titleLabel.attributedText = att;
        
        if (idx == 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(typeButton.frame) - 0.5, 10, 0.5, 45)];
            lineView.backgroundColor = UIColorFromRGB(0xeeeeee);
            [typeButton addSubview:lineView];
        }
    }];
    UIView *seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY([self viewWithTag:10 + [_headerModel.knowDest.list count] - 1].frame), screenWidth, 0.5)];
    seperateView.backgroundColor = UIColorFromRGB(0xeeeeee);
    seperateView.tag = 1400;
    [self addSubview:seperateView];
    
    if (_headerModel.topx.picture.length) {
        UIButton *backImageButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(seperateView.frame) + 10, screenWidth - 30, 55)];
        [backImageButton yy_setBackgroundImageWithURL:[NSURL URLWithString:_headerModel.topx.picture] forState:UIControlStateNormal options:YYWebImageOptionSetImageWithFadeAnimation];
        
        [backImageButton setTitle:_headerModel.topx.title forState:UIControlStateNormal];
        [backImageButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [backImageButton setImage:[UIImage imageNamed:@"tripCountryTopx"] forState:UIControlStateNormal];
        backImageButton.titleLabel.font = UIFontFromSize(18);
        [backImageButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -backImageButton.width/2)];
        [backImageButton addTarget:self action:@selector(topxButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = UIColorFromRGBA(0x000000, 0.3).CGColor;
        layer.frame = backImageButton.bounds;
        [backImageButton.layer insertSublayer:layer below:backImageButton.imageView.layer];
        
        [self addSubview:backImageButton];
        
        UIView *topxDownLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backImageButton.frame) + 10, screenWidth, 0.5)];
        topxDownLineView.backgroundColor = UIColorFromRGB(0xeeeeee);
        topxDownLineView.tag = 1500;

        [self addSubview:topxDownLineView];
    }
    
    
    NSArray *imageArray = @[@"tripCountryCustom",@"tripCountrySafe",@"tripCountryHealth",@"tripCountryFestival"];
    [_headerModel.guide.list enumerateObjectsUsingBlock:^(YPTTripCountryList *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *kindButton = [[UIButton alloc] initWithFrame:CGRectMake(10 + (idx * (screenWidth - 20) / 4), CGRectGetMaxY([self viewWithTag:1500]?[self viewWithTag:1500].frame:seperateView.frame), (screenWidth - 20) / 4, 75)];
        kindButton.tag = idx + 100;
        [kindButton addTarget:self action:@selector(kindButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:kindButton];
        
        UIImageView *kindImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kindButton.frame.size.width - 30 )/ 2, 10, 30, 30)];
        [kindImageView setImage:[UIImage imageNamed:imageArray[idx]]];
        [kindButton addSubview:kindImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(kindImageView.frame) + 10, kindButton.frame.size.width, 16)];
        titleLabel.text = obj.option;
        titleLabel.textColor = UIColorFromRGB(0x333333);
        titleLabel.font = UIFontBoldSize(14);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [kindButton addSubview:titleLabel];
        
        if (idx < _headerModel.guide.list.count - 1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kindButton.frame.size.width - 0.5, (kindButton.frame.size.height - 54) / 2, 0.5, (screenWidth - 20) / 4 - 40)];
            lineView.backgroundColor = UIColorFromRGB(0xeeeeee);
            [kindButton addSubview:lineView];
        }
    }];
    if (_headerModel.poiTypes.count > 0) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY([self viewWithTag:100].frame), screenWidth, 5)];
        backView.backgroundColor = UIColorFromRGB(0xeeeeee);
        backView.tag = 666;
        [self addSubview:backView];
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:_headerModel.poiTypes];
    [array addObjectsFromArray:_headerModel.productTypes];
    
    [array enumerateObjectsUsingBlock:^(YPTTripCountryPoiTypes *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YPTCityProductBtn *poiTypeButton = [[YPTCityProductBtn alloc] initWithFrame:CGRectMake(10 + (idx%4) * ((screenWidth - 20) / 4), CGRectGetMaxY([self viewWithTag:666].frame) + 100*(idx/4), (screenWidth - 20) / 4, 100)];
        if (idx < _headerModel.poiTypes.count) {
            poiTypeButton.dataType = kDataTypePoi;
        } else{
            poiTypeButton.dataType = kDataTypeProduct;
        }
        [poiTypeButton addTarget:self action:@selector(poiTypeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        poiTypeButton.tag = idx + 1000;
        [self addSubview:poiTypeButton];
        
        UIImageView *poiImageView = [[UIImageView alloc] initWithFrame:CGRectMake((poiTypeButton.frame.size.width - 45) / 2, 20, 45, 45)];
        [poiImageView yy_setImageWithURL:[NSURL URLWithString:obj.icon] placeholder:placeholderImg];
        [poiTypeButton addSubview:poiImageView];
        
        UILabel *poiNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(poiImageView.frame) + 10, poiTypeButton.frame.size.width, 14)];
        poiNameLabel.text = obj.option;
        poiNameLabel.textColor = UIColorFromRGB(0x333333);
        poiNameLabel.font = UIFontFromSize(14);
        poiNameLabel.textAlignment = NSTextAlignmentCenter;
        [poiTypeButton addSubview:poiNameLabel];
    }];
    
    CGFloat headerHeight = CGRectGetMaxY([self viewWithTag:1000 + array.count - 1].frame)? : CGRectGetMaxY([self viewWithTag:100].frame) ? : CGRectGetMaxY([self viewWithTag:1500].frame)?:CGRectGetMaxY(seperateView.frame);
    
    self.frame = CGRectMake(0, 0, screenWidth, headerHeight);
}

- (void)countryImageTap {
    YPTShineDestController *controller = [YPTShineDestController instance];
    controller.destId = _headerModel.countryId;
    controller.destType = @"country";
    [controller setNavigationTitle:_headerModel.cnName];
    [[self viewController].navigationController pushViewController:controller animated:YES];
    
    [[YPTDBDao sharedInstance] recordClickEvent:[YPTDBDao splitContent:@"shine_list" name:@"id" value:_headerModel.countryId index:-1 viewType:@"i2.destination"] type:0 url:0];
}
- (void)poiTypeButtonTapped:(YPTCityProductBtn *)poiButton {
    NSMutableArray *array = [NSMutableArray arrayWithArray:_headerModel.poiTypes];
    [array addObjectsFromArray:_headerModel.productTypes];
    if (poiButton.tag - 1000 >= array.count) {
        return;
    }
    YPTTripCountryPoiTypes *model = array[poiButton.tag - 1000];
    if (poiButton.dataType == kDataTypePoi) {
        YPTPOIListController *controller = [[YPTPOIListController alloc] init];
        controller.typeId = model.idField;
        controller.cityId = _headerModel.cityId;
        controller.modelType = MODEL_TYPE_INTERESTLIST;
        controller.poiListType = POI_LIST_PLACE;
        [[self viewController].navigationController pushViewController:controller animated:YES];
    } else {
        YPTPayController *controller = [YPTPayController instance];
        controller.component = @"productList";
        controller.otherInfo = @{@"toCity":_headerModel.jumptehui?:@"",@"tripType":model.idField?:@""};
        [[self viewController].navigationController pushViewController:controller animated:YES];
    }
}

- (void)topxButtonTapped:(id)sender {
    YPTTpxNewController *controller = [[YPTTpxNewController alloc] init];
    controller.fromNewCountry = YES;
    controller.idString = _headerModel.countryId;
    [[self viewController].navigationController pushViewController:controller animated:YES];
    
    [[YPTDBDao sharedInstance] recordClickEvent:[YPTDBDao splitContent:@"top_experience" name:@"id" value:_headerModel.countryId index:-1 viewType:@"i2.destination"] type:0 url:0];
}

- (void)typeButtonTapped:(UIButton *)typeButton {
    YPTTripCountryList *model = _headerModel.knowDest.list[typeButton.tag - 10];
    YPTWebController *controller = [YPTWebController instance];
    controller.webURL = [NSURL URLWithString:model.url];
    controller.controllerType = YPTWebControllerTypeShare;
    controller.topicGuideId = model.idField;
    [controller setNavigationTitle:model.option];
    if (typeButton.tag == 10) {
        controller.info = @"info";
        [[YPTDBDao sharedInstance] recordClickEvent:[YPTDBDao splitContent:@"overview" name:@"id" value:_headerModel.countryId index:-1 viewType:@"i2.destination"] type:0 url:0];
        
    } else {
        controller.info = nil;
        [[YPTDBDao sharedInstance] recordClickEvent:[YPTDBDao splitContent:@"visa" name:@"id" value:_headerModel.countryId index:-1 viewType:@"i2.destination"] type:0 url:0];
    }
    [[self viewController].navigationController pushViewController:controller animated:YES];
}

- (void)kindButtonTapped:(UIButton *)kindButton {
    YPTTripCountryList *model = _headerModel.guide.list[kindButton.tag - 100];
    YPTWebController *controller = [YPTWebController instance];
    controller.webURL = [NSURL URLWithString:model.url];
    controller.controllerType = YPTWebControllerTypeTehuiTopic;
    controller.topicGuideId = model.idField;
    [controller setNavigationTitle:model.option];
    [[self viewController].navigationController pushViewController:controller animated:YES];
    
    [[YPTDBDao sharedInstance] recordClickEvent:[YPTDBDao splitContent:model.type name:@"id" value:_headerModel.countryId index:-1 viewType:@"i2.destination"] type:0 url:0];
}

- (void)labelProperty:(UILabel *)label text:(NSString *)text fontSize:(NSInteger)fontSize {
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.font = UIFontFromSize(fontSize);
    label.textAlignment = NSTextAlignmentCenter;
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
