//
//  CityTableViewCell.h
//  HNACityChoice
//
//  Created by Curry on 14-3-10.
//  Copyright (c) 2014年 HNACityChoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


typedef void (^hotCityNameBlock)(NSString *cityName);
//*********热门城市cell*********
@interface HotCityTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    hotCityNameBlock _hotcityblock;
}
//cell中显示的城市数组
@property (nonatomic, strong)NSArray *cityArray;
//热门城市列表
@property (nonatomic, strong)UICollectionView *collectionView;

//刷新cell城市
- (void)refreshHotCiytDatas:(CGFloat)cellHeight;
//反回选择的热门城市
- (void)requireHotCityname:(hotCityNameBlock)block;
@end


//*********所在城市cell*********

typedef void (^blockLocation)(NSString *locationString ,BOOL tag);
@interface LocationCityTableViewCell : UITableViewCell<UIApplicationDelegate,CLLocationManagerDelegate>
{
    blockLocation _blocklocation;
}

- (void)requireLocationTexg:(blockLocation)block;
//定位服务
@property (nonatomic, strong)CLLocationManager *locationManager;
//菊花加载
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicatorView;
//定时服务
@property (nonatomic, strong)NSTimer *timer;
//定位
- (void)locationCityText:(BOOL)location;
@end