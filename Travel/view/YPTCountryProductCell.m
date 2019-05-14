//
//  YPTCountryProductCell.m
//  QZYKit
//
//  Created by quzhenyang on 16/3/1.
//  Copyright © 2016年 qzy. All rights reserved.
//

#import "YPTCountryProductCell.h"
#import "UIImageView+YYWebImage.h"

@implementation YPTCountryProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _travelNoteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 85, 85)];
    [self.contentView addSubview:_travelNoteImageView];
    
    _travelNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_travelNoteImageView.frame) + 10, 15, screenWidth - 125, 35)];
    _travelNoteLabel.textColor = UIColorFromRGB(0x333333);
    _travelNoteLabel.font = UIFontBoldSize(14);
    _travelNoteLabel.numberOfLines = 0;
    [self.contentView addSubview:_travelNoteLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = UIColorFromRGB(0xf7632a);
    _priceLabel.font = UIFontFromSize(16);
    [self.contentView addSubview:_priceLabel];
    
    _marketPriceLabel = [[UILabel alloc] init];
    _marketPriceLabel.textColor = UIColorFromRGB(0x999999);
    _marketPriceLabel.font = UIFontFromSize(12);
    [self.contentView addSubview:_marketPriceLabel];

}

- (void)countryProductCell:(YPTTripCountryList *)model {
    [_travelNoteImageView yy_setImageWithURL:[NSURL URLWithString:model.pic] placeholder:placeholderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    _travelNoteLabel.text = model.title;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    CGSize priceSize = [_priceLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_priceLabel.font} context:nil].size;
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:_priceLabel.text];
    [priceAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];
    _priceLabel.attributedText = priceAtt;
    _priceLabel.frame = CGRectMake(screenWidth - 15 - priceSize.width, CGRectGetMaxY(_travelNoteLabel.frame) + 20, priceSize.width + 5, 16);
    if ([model.basePrice integerValue] > 0) {
        _marketPriceLabel.text = [NSString stringWithFormat:@"原价¥%@",model.basePrice];
        CGSize marketSize = [_marketPriceLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_marketPriceLabel.font} context:nil].size;
        NSMutableAttributedString *marketAtt = [[NSMutableAttributedString alloc] initWithString:_marketPriceLabel.text];
        [marketAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(2, 1)];
        [marketAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(2, 1)];
        [marketAtt addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, _marketPriceLabel.text.length)];
        [marketAtt addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(0xcccccc) range:NSMakeRange(0,_marketPriceLabel.text.length)];
        _marketPriceLabel.attributedText = marketAtt;
        _marketPriceLabel.frame = CGRectMake(screenWidth - 15 - _priceLabel.width - 10 - marketSize.width, CGRectGetMaxY(_travelNoteLabel.frame) + 20 + (_priceLabel.height - 12), marketSize.width + 2, 12);
        
        if ([model.basePrice integerValue] <= [model.price integerValue]) {
            _marketPriceLabel.text = nil;
        }
    } else {
        _marketPriceLabel.text = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
