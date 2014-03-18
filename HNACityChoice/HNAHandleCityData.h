//
//  HNAHandleCityData.h
//  HNACityChoice
//
//  Created by Curry on 14-3-12.
//  Copyright (c) 2014年 HNACityChoice. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum CityTypeMode
{
    CityTypeModeDomestic = 0,
    CityTypeModeInternational,
}CityTypeMode;

@interface HNAHandleCityData : NSObject

@property (nonatomic ,strong)NSMutableArray *storeCities;  //存放所有封装好的城市信息
@property (nonatomic ,strong)NSMutableArray * sectionHeadsKeys;//存放所有城市的开头字母，相同剔除
@property (nonatomic ,strong)NSMutableArray *arrayForArrays;   //存放所有按字母分组好的城市信息
- (void)cityDataDidHandled:(CityTypeMode)cityTypeMode;//数组存三个数组，第一个存放所有的字母，第二个存分类数组,第三个数组存放所有城市信息
@end



@interface City : NSObject
@property(nonatomic,strong) NSString * cityNAme;//城市名称
@property(nonatomic,strong) NSString * cityCode;//城市代码名称
@property(nonatomic,strong) NSString * cityHot;//热门城市名称
@property(nonatomic,strong) NSString * cityPinyin;//城市拼音
@property(nonatomic, assign) float latitude;//纬度
@property(nonatomic, assign) float longtitde;//经度
@end

