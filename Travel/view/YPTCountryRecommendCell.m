//
//  YPTCountryRecommendCell.m
//  QZYKit
//
//  Created by quzhenyang on 16/3/1.
//  Copyright © 2016年 qzy. All rights reserved.
//

#import "YPTCountryRecommendCell.h"
#import "UIImageView+YYWebImage.h"
#import "UIButton+YYWebImage.h"
#import "UIImage+YYWebImage.h"

@implementation YPTCountryRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}
- (void)initUI {
    _tripImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 85, 85)];
    [self.contentView addSubview:_tripImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tripImageView.frame) + 15, 20, screenWidth - CGRectGetMaxX(_tripImageView.frame) - 30, 30)];
    _titleLabel.textColor = UIColorFromRGB(0x333333);
    _titleLabel.font = UIFontBoldSize(14);
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    _designerButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tripImageView.frame) + 15, CGRectGetMaxY(_tripImageView.frame) - 32, 25, 25)];
    _designerButton.layer.cornerRadius = 12.5;
    _designerButton.layer.masksToBounds = YES;
    [_designerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.contentView addSubview:_designerButton];
    
    _designNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_designerButton.frame) + 5, CGRectGetMaxY(_tripImageView.frame) - 25, screenWidth / 2, 13)];
    _designNameLabel.textColor = UIColorFromRGB(0x666666);
    _designNameLabel.font = UIFontFromSize(12);
    [self.contentView addSubview:_designNameLabel];
    
    _browButton = [[UIButton alloc] init];
    [_browButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    _browButton.titleLabel.font = UIFontFromSize(12);
    _browButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.contentView addSubview:_browButton];
}
- (void)countryRecommendCell:(YPTTripCountryList *)model {
    [_tripImageView yy_setImageWithURL:[NSURL URLWithString:model.pic] placeholder:placeholderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    _titleLabel.text = model.title;
    CGSize textSize = [_titleLabel.text boundingRectWithSize:CGSizeMake(screenWidth - CGRectGetMaxX(_tripImageView.frame) - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_titleLabel.font} context:nil].size;
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_tripImageView.frame) + 15, 20, screenWidth - CGRectGetMaxX(_tripImageView.frame) - 30, textSize.height + 3);
    [_designerButton yy_setImageWithURL:[NSURL URLWithString:model.memberIcon] forState:UIControlStateNormal placeholder:placeholderAvatar];
    _designNameLabel.text = [NSString stringWithFormat:@"%@ %@",model.roleName,model.memberName];
}
- (void)thdetailCell:(YPTProductDetailRecommendData *)model {
    [_tripImageView yy_setImageWithURL:[NSURL URLWithString:model.pic] placeholder:placeholderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    _titleLabel.text = model.title;
    _titleLabel.numberOfLines = 2;
    CGSize textSize = [_titleLabel.text boundingRectWithSize:CGSizeMake(screenWidth - CGRectGetMaxX(_tripImageView.frame) - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_titleLabel.font} context:nil].size;
    if (textSize.height >= 30) {
        textSize.height = 30;
    }
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_tripImageView.frame) + 15, 20, screenWidth - CGRectGetMaxX(_tripImageView.frame) - 30, textSize.height + 3);
    [_designerButton yy_setImageWithURL:[NSURL URLWithString:model.memberIcon] forState:UIControlStateNormal placeholder:placeholderAvatar];
    _designNameLabel.text = [NSString stringWithFormat:@"%@ %@",model.roleName,model.memberName];
}

- (void)countryTopicCell:(YPTTripCountryList *)model {
    [_tripImageView yy_setImageWithURL:[NSURL URLWithString:model.pic] placeholder:placeholderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    _titleLabel.text = model.title;
    CGSize titleSize = [_titleLabel.text boundingRectWithSize:CGSizeMake(screenWidth - CGRectGetMaxX(_tripImageView.frame) - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_titleLabel.font} context:nil].size;
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_tripImageView.frame) + 15, 20, screenWidth - CGRectGetMaxX(_tripImageView.frame) - 30, titleSize.height + 3);
    if ([model.type isEqualToString:TRIP_TOPIC]) {
        [_designNameLabel setText:model.author];
    } else if ([model.type isEqualToString:TRIP_SHINE_TOPIC]) {
        [_designNameLabel setText:model.memberName];
    }
    
    if (! [model.viewCount isEqualToString:@""]) {
        [_browButton setTitle:model.viewCount forState:UIControlStateNormal];
        [_browButton setImage:[UIImage imageNamed:@"MasterBrowse"] forState:UIControlStateNormal];
    }
    [_browButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    CGSize textSize = [_browButton.currentTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontFromSize(12)} context:nil].size;
    
    if (! [model.memberIcon isEqualToString:@""]) {
        [_designerButton yy_setImageWithURL:[NSURL URLWithString:model.memberIcon] forState:UIControlStateNormal placeholder:placeholderAvatar];
        _designerButton.hidden = NO;
        _designNameLabel.frame = CGRectMake(CGRectGetMaxX(_designerButton.frame) + 5, CGRectGetMaxY(_tripImageView.frame) - 25, screenWidth / 2, 13);
        _browButton.frame = CGRectMake(screenWidth - 15 - textSize.width - 21, CGRectGetMaxY(_tripImageView.frame) - 25, textSize.width + 22, 12);
    } else {
        _designerButton.hidden = YES;
        _designNameLabel.frame = CGRectMake(CGRectGetMaxX(_tripImageView.frame) + 15, CGRectGetMaxY(_tripImageView.frame) - 20, screenWidth / 2, 13);
        _browButton.frame = CGRectMake(screenWidth - 15 - textSize.width - 21, CGRectGetMaxY(_tripImageView.frame) - 20, textSize.width + 22, 12);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
