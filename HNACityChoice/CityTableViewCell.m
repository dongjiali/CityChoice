//
//  CityTableViewCell.m
//  HNACityChoice
//
//  Created by Curry on 14-3-10.
//  Copyright (c) 2014年 HNACityChoice. All rights reserved.
//

#import "CityTableViewCell.h"


const CGFloat LayoutMinInterItemSpacing = 5.0f;
const CGFloat LayoutMinLineSpacing = 5.0f;
const CGFloat LayoutInsetTop = 10.0f;
const CGFloat LayoutInsetLeft = 10.0f;
const CGFloat LayoutInsetBottom = 10.0f;
const CGFloat LayoutInsetRight = 20.0f;
const CGFloat LayoutHeaderHeight = 5.0f;
const CGFloat CityButtonWidth = 85.0f;
const CGFloat CityButtonHeight = 40.0f;
#pragma mark- 热门城市

//*********热门城市cell******************************************************
@implementation HotCityTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //试着自动布局
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = LayoutMinLineSpacing;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(LayoutInsetTop,
                                             LayoutInsetLeft,
                                             LayoutInsetBottom,
                                             LayoutInsetRight);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        self.collectionView.dataSource=self;
        self.collectionView.delegate=self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.scrollEnabled = NO;
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewIdentifier"];
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (void)refreshHotCiytDatas:(CGFloat)cellHeight
{
    self.frame = CGRectMake(0, 0, self.frame.size.width, cellHeight);
    self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, cellHeight);
    [self.collectionView reloadData];
}

#pragma mark- CollectionView Delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for(UIView*subview in subviews) {
        [subview removeFromSuperview];
    }
    UILabel *hotCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CityButtonWidth, CityButtonHeight)];
    hotCityLabel.textAlignment = NSTextAlignmentCenter;
    hotCityLabel.font = [UIFont systemFontOfSize:13];
    hotCityLabel.text = self.cityArray[indexPath.row];
    hotCityLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:hotCityLabel];
    //给cell 加边框
    cell.layer.borderColor = [UIColor redColor].CGColor;
    cell.layer.borderWidth =1.0f;
    cell.layer.cornerRadius = 6.0;
    return cell;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cityArray.count;
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CityButtonWidth, CityButtonHeight);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _hotcityblock(self.cityArray[indexPath.row]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)requireHotCityname:(hotCityNameBlock)block
{
    _hotcityblock = [block copy];
}

@end








#pragma mark- 所在城市定位
//*********所在城市cell******************************************************
//*********所在城市cell******************************************************
@interface LocationCityTableViewCell()
{
   UIButton *reloadButton;
}

@end
@implementation LocationCityTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self startLocationManager];
        //添加BUTTON
        [self addReloadButton];
    }
    return self;
}

- (void)locationCityText;
{
        [self startLocationManager];
}

- (void)startLocationManager
{
    self.textLabel.text = @"开始定位...";
    reloadButton.hidden = YES;
    if (!self.locationManager) {
        //开始定位
        if([CLLocationManager locationServicesEnabled])
        {
            self.locationManager = [[CLLocationManager alloc]init];
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
        }
    }
    if (!self.activityIndicatorView) {
        self.activityIndicatorView=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 0, 30, self.frame.size.height)];
        self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.contentView addSubview:self.activityIndicatorView];
    }
    //预定计时器
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(stop) userInfo:nil repeats:NO];
    }
    
    //菊花开始转
    [self.activityIndicatorView startAnimating];
}

- (void)stop
{
    _blocklocation(@"定位失败,请重试",NO);
    self.textLabel.text = @"定位失败,请重试";
    reloadButton.hidden = NO;
    [self stopLocationService];
}

- (void)stopLocationService
{
    if (self.locationManager) {
        [self.locationManager stopUpdatingLocation];
        [self.locationManager stopUpdatingHeading];
        self.locationManager = nil;
    }
    //停菊花
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView = nil;
    }
    //停定时
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)requireLocationTexg:(blockLocation)block
{
    _blocklocation = [block copy];
}

- (void)addReloadButton
{
    reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton setTitle:@"重 试" forState:UIControlStateNormal];
    [reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    reloadButton.frame = CGRectMake(230, 0, 60, self.frame.size.height);
    reloadButton.hidden = YES;
    [reloadButton addTarget:self action:@selector(startLocationManager) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:reloadButton];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     {
         //定位完成获取城市
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             NSString *city = placemark.locality;
             if (!city) {
                 city = placemark.administrativeArea;
             }
             self.textLabel.text = city;
             _blocklocation(city,YES);
             reloadButton.hidden = YES;
         }
         if (error == nil && [array count] == 0)
         {
             NSString *locationText = @"定位失败,请重试";
             _blocklocation(locationText,NO);
             self.textLabel.text = locationText;
             reloadButton.hidden = NO;
         }
         //停止菊花和定位
         [self stopLocationService];
     }];
}
@end

