//
//  ViewController.m
//  QZYKit
//
//  Created by quzhenyang on 16/1/21.
//  Copyright © 2016年 qzy. All rights reserved.
//

#import "YPTTripCountryController.h"
#import "YPTCountryHeaderView.h"
#import "YPTCountryHotCityCell.h"
#import "YPTCountryRecommendCell.h"
#import "YPTCountryBeenCell.h"
#import "YPTCountryProductCell.h"
#import "YPTHTTPClient.h"
#import "YPTTripCountryRequest.h"
#import "YPTCurrentCityController.h"
#import "YPTLineDetailController.h"
#import "YPTWebController.h"
#import "YPTPayController.h"
#import "YPTTripCountryFlowController.h"
#import "YPTNewCityListController.h"
#import "YPTCustomBarView.h"
#import "YPTSearchTripController.h"
#import "YPTShineDestController.h"
#import "YPTEndLabel.h"
#import "YPTTopicDetailController.h"
#import "YPTGuideCityController.h"
#import "YPTHistoryArchiveTool.h"
#import "YPTDiscWhitherDestjump.h"
#import "NSString+YP.h"
#import "YPTDBDao.h"
#import "YPTPicBrowserController.h"
#import "YPTCityListMapController.h"
#import "YPTCurrentTripCell.h"
#import "YPTCurrentTopicCell.h"
#import "YPTShare.h"

static NSString *const CountryHotCityCell = @"YPTCountryHotCityCell";
static NSString *const CountryRecommendCell = @"YPTCountryRecommendCell";
static NSString *const CountryBeenCell = @"YPTCountryBeenCell";
static NSString *const CountryProductCell = @"YPTCountryProductCell";
static NSString *const CountryTopicCell = @"CountryTopicCell";

@interface YPTTripCountryController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _loadSuccess;
}
@property (weak, nonatomic) IBOutlet UITableView *countryTableView;
@property (strong, nonatomic) YPTCustomBarView *customNaviagtionBar;
@property (strong, nonatomic) UIButton *backButton, *searchButton, *shareButton;
@property (strong, nonatomic) CABasicAnimation* opacityAnimation;
@property (strong, nonatomic) CALayer* customBarLayer;
@property (strong, nonatomic) CAKeyframeAnimation* tripButtonAnimation;
@property (strong, nonatomic) YPTCountryHeaderView *headerView;
@property (assign, nonatomic) NSInteger topScaleHeight;
@property (strong, nonatomic) UIButton *tripButton;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation YPTTripCountryController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([YPTHTTPClient shareClient].reachabilityManager.isReachable) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

+(instancetype)instance{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Destination" bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:@"YPTTripCountryController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _loadSuccess = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view, typically from a nib.
    _dataArray = [NSMutableArray array];
    [self loadUI];
    [self customNavigationBarView];
    [self getData];
}

- (void)customNavigationBarView {
    self.customNaviagtionBar = [[YPTCustomBarView alloc] init];
    [self.customNaviagtionBar initUI];
    self.customNaviagtionBar.hidden = YES;
    [self.view addSubview:self.customNaviagtionBar];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(kDistanceToLeft, kDistanceToTop, kButtonWidth, kButtonHeight)];
    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImage:[UIImage imageNamed:@"popImage"] forState:UIControlStateNormal];
    [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [self.customNaviagtionBar addSubview:_backButton];
    
    _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 60, kDistanceToTop, kButtonWidth, kButtonHeight)];
    [_shareButton setImage:[UIImage imageNamed:@"ShareWhite"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNaviagtionBar addSubview:_shareButton];
    
    _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 100, kDistanceToTop, kButtonWidth, kButtonHeight)];
    [_searchButton setImage:[UIImage imageNamed:@"HomeSearch"] forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(tripSearchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNaviagtionBar addSubview:_searchButton];
}
- (void)back:(id)sender {
    [super back:sender];
}
- (void)tripSearchButtonTapped:(id)sender {
    YPTSearchTripController *controller = [[YPTSearchTripController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)shareButtonTapped:(id)sender {
    if (_model && _model.share) {
        OSMessage* message = ({
            OSMessage* result = [[OSMessage alloc] init];
            
            result.title = _model.share.title;
            result.desc = _model.share.desc;
            result.link = _model.share.url;
            
            result;
        });
        
        NSString* imageUrl = _model.share.pic;
        
        YPTShare* share = [[YPTShare alloc] init];
        share.sharedType = @"countryinfo";
        [share shareMessage:message imageURL:imageUrl completion:nil];
    }
}

- (void)loadUI {
    
    [_countryTableView registerClass:[YPTCountryHotCityCell class] forCellReuseIdentifier:CountryHotCityCell];
    [_countryTableView registerClass:[YPTCountryRecommendCell class] forCellReuseIdentifier:CountryRecommendCell];
    [_countryTableView registerClass:[YPTCountryBeenCell class] forCellReuseIdentifier:CountryBeenCell];
    [_countryTableView registerClass:[YPTCountryProductCell class] forCellReuseIdentifier:CountryProductCell];
    [_countryTableView registerClass:[YPTCountryRecommendCell class] forCellReuseIdentifier:CountryTopicCell];
}

- (void)loadTableHeaderView {
    _headerView = [[YPTCountryHeaderView alloc] init];
    _headerView.headerModel = _model;
    [_headerView loadUI];
    _topScaleHeight = _headerView.countryImage.height;
    _countryTableView.tableHeaderView = _headerView;
}
- (void)getData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    YPTTripCountryRequest *request = [[YPTTripCountryRequest alloc] init];
    request.countryId = _countryId;
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        _loadSuccess = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        _model = [MTLJSONAdapter modelOfClass:YPTTripCountryRootClass.class fromJSONDictionary:request.responseJSONObject[@"data"] error:nil];
        if (_model.hotCities.list.count) {
            _model.hotCities.typeName = @"hotCity";
            [_dataArray addObject:_model.hotCities];
        }
        if (_model.superj.list.count) {
            [_dataArray addObject:_model.superj];
        }
        if (_model.line.list.count) {
            [_dataArray addObject:_model.line];
        }
        if (_model.topic.list.count) {
            [_dataArray addObject:_model.topic];
        }
        if (_model.product.list.count) {
            _model.product.typeName = @"product";
            [_dataArray addObject:_model.product];
        }
        if (_model.shinePic.list.count) {
            _model.shinePic.typeName = @"shinePic";
            [_dataArray addObject:_model.shinePic];
        }
        
        [self archiveHistory];
        [self loadTableHeaderView];
        _customNaviagtionBar.hidden = NO;
        [_countryTableView reloadData];
        
        _countryTableView.tableFooterView = [YPTEndLabel endLabel];
        
    } failure:^(YTKBaseRequest *request) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)archiveHistory{
    YPTDiscWhitherDestjump *object = [[YPTDiscWhitherDestjump alloc] init];
    object.type = @"country";
    object.destId = self.countryId;
    object.destName = self.model.cnName.length?self.model.cnName:self.model.enName;
    [YPTHistoryArchiveTool archiveObject:object toPath:[NSString filePathWithPathComponent:@"DiscWhitherHistory.data"] duplicate:NO limit:7];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewDestionLoaded" object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < _dataArray.count) {
        YPTTripCountryHotCity *data = _dataArray[section];
        if ([data.typeName isEqualToString:@"hotCity"]||[data.typeName isEqualToString:@"shinePic"]) {
            return 1;
        } else if ([data.typeName isEqualToString:@"superj"] || [data.typeName isEqualToString:@"line"] || [data.typeName isEqualToString:@"topic"] || [data.typeName isEqualToString:@"product"]){
            return data.list.count;
        }
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < _dataArray.count) {
        YPTTripCountryHotCity *data = _dataArray[indexPath.section];
        if ([data.typeName isEqualToString:@"hotCity"]) {
            YPTCountryHotCityCell *cell = [tableView dequeueReusableCellWithIdentifier:CountryHotCityCell ];
            cell.countryId = _model.countryId;
            [cell hotCityCell:_model.hotCities.list];
            return cell;
        }else if ([data.typeName isEqualToString:@"superj"]){
            YPTCurrentTripCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YPTCurrentTripCell"];
            cell.model = data.list[indexPath.row];
            return cell;
        }else if ([data.typeName isEqualToString:@"line"]){
            YPTCountryRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:CountryRecommendCell ];
            [cell countryRecommendCell:_model.line.list[indexPath.row]];
            return cell;
        }else if([data.typeName isEqualToString:@"topic"]){
            YPTCurrentTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YPTCurrentTopicCell"];
            cell.model = data.list[indexPath.row];
            return cell;
        } else if ([data.typeName isEqualToString:@"product"]){
            YPTCountryProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CountryProductCell];
            [cell countryProductCell:_model.product.list[indexPath.row]];
            return cell;
        }else if ([data.typeName isEqualToString:@"shinePic"]){
            YPTCountryBeenCell *cell = [tableView dequeueReusableCellWithIdentifier:CountryBeenCell];
            cell.countryId = _countryId;
            [cell countryBeenCell:_model.shinePic.list];
            __weak typeof(self) weakSelf = self;
            cell.hotButtonTapBlock = ^ (YPTTripCountryList *model) {
                [weakSelf countryBeenButtonClickEvent:model];
            };
            return cell;
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
}

- (void)countryBeenButtonClickEvent:(YPTTripCountryList *)model {
    YPTPicBrowserController* controller = [YPTPicBrowserController instance];
    controller.picIdArray = [NSMutableArray arrayWithObject:model.picId];
    controller.currentIndex = 1;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < _dataArray.count) {
        YPTTripCountryHotCity *data = _dataArray[indexPath.section];
        if ([data.typeName isEqualToString:@"line"]) {
            YPTTripCountryList *model = _model.line.list[indexPath.row];
            YPTLineDetailController* controller = [YPTLineDetailController instance:model.idField];
            [self.navigationController pushViewController:controller animated:YES];
        } else if ([data.typeName isEqualToString:@"superj"] && indexPath.row < data.list.count){
            YPTTripCountryList *model = data.list[indexPath.row];
            YPTPayController *controller = [YPTPayController instance];
            controller.component = @"productDetail";
            controller.productId = model.idField;
            [self.navigationController pushViewController:controller animated:YES];
        }else if ([data.typeName isEqualToString:@"topic"] && indexPath.row < data.list.count){
            YPTTripCountryList *model = _model.topic.list[indexPath.row];
            if ([model.type isEqualToString:TRIP_TOPIC]) {
                YPTWebController *controller = [YPTWebController instance];
                controller.webURL = [NSURL URLWithString:model.url];
                controller.controllerType = YPTWebControllerTypeTehuiTopic;
                controller.topicId = model.idField;
                
                [self.navigationController pushViewController:controller animated:YES];
                
            } else if ([model.type isEqualToString:TRIP_SHINE_TOPIC]) {
                YPTTopicDetailController* controller = [YPTTopicDetailController instance];
                controller.topicId = model.idField;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else if ([data.typeName isEqualToString:@"product"] && indexPath.row < data.list.count){
            YPTTripCountryList *model = _model.product.list[indexPath.row];
            YPTPayController *controller = [[YPTPayController alloc] init];
            controller.component = @"productDetail";
            controller.productId = model.productId;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    [self tripCountryTableView:tableView didSelectRowAtIndexPath:indexPath];
}

//点击事件
- (void)tripCountryTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < _dataArray.count) {
        YPTTripCountryHotCity *data = _dataArray[indexPath.section];
        if ([data.typeName isEqualToString:@"hotCity"]) {
            return (screenWidth / 3) + 45;
        }else if ([data.typeName isEqualToString:@"shinePic"]){
            return (screenWidth / 3) + 20;
        }else if ([data.typeName isEqualToString:@"superj"]){
            return 64 + 172.5*screenWidth/375;
        }else{
            return 105;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < _dataArray.count) {
        YPTTripCountryHotCity *data = _dataArray[section];
        if ([data.typeName isEqualToString:@"hotCity"]) {
            return 57 + 50;
        } else if ([data.typeName isEqualToString:@"line"]) {
            return 132;
        }else{
            return 57;
        }
    }
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section < _dataArray.count) {
        YPTTripCountryHotCity *data = _dataArray[section];
        if ([data.typeName isEqualToString:@"line"]) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 132)];
            headerView.backgroundColor = [UIColor whiteColor];
            UIView *backColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 5)];
            backColorView.backgroundColor = UIColorFromRGB(0xeeeeee);
            [headerView addSubview:backColorView];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backColorView.frame) + 25, screenWidth, 20)];
            titleLabel.text = _model.line.title;
            titleLabel.textColor = UIColorFromRGB(0x333333);
            titleLabel.font = UIFontBoldSize(18);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:titleLabel];
            if (!_tripButton) {
                _tripButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) + 25, screenWidth - 30, 50)];
                _tripButton.hidden = YES;
            }
            [_tripButton setTitle:_model.line.desc forState:UIControlStateNormal];
            [_tripButton setTitleColor:UIColorFromRGB(0xf7632a) forState:UIControlStateNormal];
            _tripButton.titleLabel.font = UIFontFromSize(17);
            _tripButton.layer.borderColor = UIColorFromRGB(0xf7632a).CGColor;
            _tripButton.layer.borderWidth = 0.5;
            _tripButton.layer.cornerRadius = 5;
            [_tripButton addTarget:self action:@selector(tripButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:_tripButton];
            
            return headerView;
        }
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 57)];
        headerView.backgroundColor = [UIColor whiteColor];
        UIView *backColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 5)];
        backColorView.backgroundColor = UIColorFromRGB(0xeeeeee);
        [headerView addSubview:backColorView];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backColorView.frame) + 25, screenWidth, 20)];
        titleLabel.textColor = UIColorFromRGB(0x333333);
        titleLabel.font = UIFontBoldSize(17);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:titleLabel];
        
        if ([data.typeName isEqualToString:@"hotCity"]) {
            if (![headerView viewWithTag:1000]) {
                UIButton *mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 15, screenWidth, 50)];
                mapBtn.tag = 1000;
                [mapBtn setBackgroundImage:[UIImage imageNamed:@"Guide_City_Default_Map"] forState:UIControlStateNormal];
                [mapBtn setTitle:@"城市地图 >" forState:UIControlStateNormal];
                mapBtn.titleLabel.font = UIFontFromSize(18);
                [mapBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                [mapBtn addTarget:self action:@selector(mapBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                CALayer *layer = [[CALayer alloc] init];
                layer.frame = mapBtn.bounds;
                layer.backgroundColor = UIColorFromRGBA(0x000000, 0.3).CGColor;
                [mapBtn.layer insertSublayer:layer below:mapBtn.titleLabel.layer];
                [headerView addSubview:mapBtn];
            }
            titleLabel.text = _model.hotCities.title;
        } else {
            titleLabel.text = data.title;
        }
        return headerView;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section < _dataArray.count) {
        YPTTripCountryHotCity *data = _dataArray[section];
        if ([data.isShowMore boolValue]) {
            return 45;
        }
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIButton *footerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 45)];
    footerButton.backgroundColor = [UIColor whiteColor];
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.textColor = UIColorFromRGB(0x999999);
    footerLabel.font = UIFontFromSize(12);
    [footerButton addSubview:footerLabel];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    backView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 9.5, screenWidth, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [backView addSubview:lineView];
    if (section < _dataArray.count) {
        YPTTripCountryHotCity *data = _dataArray[section];
        if ([data.isShowMore boolValue]) {
            footerButton.tag = section;
            [footerButton addTarget:self action:@selector(footerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            footerLabel.text = data.moreTitle;
        }else{
            return backView;
        }
    }
   if (footerLabel.text.length > 0) {
    CGSize textSize = [footerLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:footerLabel.font} context:nil].size;
    footerLabel.frame = CGRectMake((screenWidth - textSize.width - 14) / 2, 10, textSize.width, 15);
    UIImageView *footerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(footerLabel.frame) + 5, 9, 15, 15)];
    [footerImageView setImage:[UIImage imageNamed:@"tripCountryMore"]];
    [footerButton addSubview:footerImageView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, screenWidth, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [footerButton addSubview:lineView];
    return footerButton;
    }
    return [[UIView alloc] init];
}

-(void)footerBtnClick:(UIButton *)sender{
    if (sender.tag < _dataArray.count) {
        YPTTripCountryHotCity *data = _dataArray[sender.tag];
        if ([data.typeName isEqualToString:@"hotCity"]) {
            [self hotCityButtonTapped:sender];
        }else if ([data.typeName isEqualToString:@"superj"] || [data.typeName isEqualToString:@"line"]){
            [self lineButtonTapped:sender];
        }else if ([data.typeName isEqualToString:@"topic"]){
            [self topicButtonTapped:sender];
        }else if ([data.typeName isEqualToString:@"shinePic"]){
            [self shineButtonTapped:sender];
        }else if ([data.typeName isEqualToString:@"product"]){
            [self tripProductButtonTapped:sender];
        }
    }
}

- (void)hotCityButtonTapped:(id)sender {
    YPTNewCityListController *controller = [[YPTNewCityListController alloc] init];
    controller.countryId = _model.countryId;
    [controller setNavigationTitle:_model.hotCities.title];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)lineButtonTapped:(UIButton*)sender {
    YPTTripCountryFlowController *controller = [[YPTTripCountryFlowController alloc] init];
    controller.countryId = _model.countryId;
    if (_model.cityId.length) {
        controller.cityId = _model.cityId;
    }
    if (sender.tag < _dataArray.count) {
        YPTTripCountryHotCity *data = _dataArray[sender.tag];
        controller.typeName = data.typeName;
        controller.titleStr = data.title;
        controller.typeName = data.typeName;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)topicButtonTapped:(id)sender {
    YPTTripCountryFlowController *controller = [[YPTTripCountryFlowController alloc] init];
    controller.countryId = _model.countryId;
    controller.cityId = _model.cityId;
    controller.typeName = _model.topic.typeName;
    controller.title = _model.topic.title;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)shineButtonTapped:(id)sender {
    YPTShineDestController *controller = [YPTShineDestController instance];
    controller.destId = _model.countryId;
    controller.destType = @"country";
    [controller setNavigationTitle:_model.cnName];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)tripProductButtonTapped:(id)sender {
    YPTPayController *controller = [YPTPayController instance];
    controller.component = @"productList";
    controller.otherInfo = @{@"toCity":_model.jumptehui?:@"",@"tripType":_model.tripType?:@""};
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)tripButtonTapped:(id)sender {

    YPTGuideCityController *controller = [[YPTGuideCityController alloc] init];
    controller.countryId = _model.countryId;
    controller.countryName = _model.cnName;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (!_loadSuccess) {
        return;
    }
    CGFloat y = scrollView.contentOffset.y; //根据实际选择加不加上NavigationBarHight（44、64 或者没有导航条）
    
    CGRect rect = [_countryTableView rectForHeaderInSection:1];
    CGRect foo = [_countryTableView rectForHeaderInSection:0];
    if (_model.hotCities.list.count == 0) {
        rect = [_countryTableView rectForHeaderInSection:0];
        foo = CGRectMake(0, screenHeight - 150, 0, 0);
    }
    if (y >= rect.origin.y - foo.origin.y - 50) {
            if (! _tripButtonAnimation  || _tripButton.hidden) {
                if (! _tripButtonAnimation) {
                    _tripButtonAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
                    _tripButtonAnimation.removedOnCompletion = NO;
                    _tripButtonAnimation.fillMode = kCAFillModeForwards;
                    _tripButtonAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
                    _tripButtonAnimation.duration = 2;
                    NSMutableArray* values = [NSMutableArray array];
                    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
                    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
                    _tripButtonAnimation.values = values;
                    [_tripButton.layer addAnimation:_tripButtonAnimation forKey:nil];
                } else {
                    
                    _tripButton.hidden = NO;
                }
            }
    }
    if (y >= screenHeight / 2) {
        return;
    }
    if (y < 0) {
        CGFloat factor = ((ABS(y) + _topScaleHeight) * screenWidth) / _topScaleHeight;
        
        CGRect f = CGRectMake((-(factor - screenWidth) / 2), 0, screenWidth, _topScaleHeight);
        f.size.height = _topScaleHeight + ABS(y);
        f.size.width = factor;
        _headerView.countryImage.frame = f;
        
        CGRect frame = _headerView.countryImage.frame;
        frame.origin.y = _countryTableView.contentOffset.y;
        frame.size.height = - (_countryTableView.contentOffset.y) + _topScaleHeight;
        _headerView.countryImage.frame = frame;
        frame.origin.x = 0;
        _headerView.backView.frame = frame;
    }
    
    if (y > 0 && y < screenHeight / 2) {
        [self customBarAlphaChange:y];
    }
    else {
        [self customBarAlphaFixed];
    }
}

- (void)customBarAlphaChange:(CGFloat)offset
{
    self.customNaviagtionBar.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [_backButton setImage:[UIImage imageNamed:@"GrayBack"] forState:UIControlStateNormal];
    [_searchButton setImage:[UIImage imageNamed:@"MasterSearch"] forState:UIControlStateNormal];
    [_shareButton setImage:[UIImage imageNamed:@"ShareBlack"] forState:UIControlStateNormal];
    if (!_opacityAnimation) {
        _opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        _opacityAnimation.toValue = [NSNumber numberWithFloat:0.98];
        _opacityAnimation.duration = 0.5;
        [self.customNaviagtionBar.layer addAnimation:_opacityAnimation forKey:nil];
    }
    if (self.customBarLayer == nil) {
        
        self.customBarLayer = [CALayer layer];
        self.customBarLayer.frame = CGRectMake(0, self.customNaviagtionBar.height - 0.5, screenWidth, 0.5);
        self.customBarLayer.backgroundColor = UIColorFromRGB(0xcccccc).CGColor;
        [self.customNaviagtionBar.layer addSublayer:self.customBarLayer];
    }
}

- (void)customBarAlphaFixed
{
    self.customNaviagtionBar.backgroundColor = [UIColor clearColor];
    self.customNaviagtionBar.alpha = 1;
    [_backButton setImage:[UIImage imageNamed:@"popImage"] forState:UIControlStateNormal];
    [_searchButton setImage:[UIImage imageNamed:@"HomeSearch"] forState:UIControlStateNormal];
    [_shareButton setImage:[UIImage imageNamed:@"ShareWhite"] forState:UIControlStateNormal];

    if (self.customBarLayer) {
        [self.customBarLayer removeFromSuperlayer];
        self.customBarLayer = nil;
    }
    if (_opacityAnimation) {
        _opacityAnimation = nil;
    }
}

-(void)mapBtnClicked{
    YPTCityListMapController *controller = [[YPTCityListMapController alloc] init];
    controller.countryId = self.countryId;
    [self.navigationController  pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
