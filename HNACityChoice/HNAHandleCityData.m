//
//  HNAHandleCityData.m
//  HNACityChoice
//
//  Created by Curry on 14-3-12.
//  Copyright (c) 2014年 HNACityChoice. All rights reserved.
//

#import "HNAHandleCityData.h"

@implementation HNAHandleCityData
- (void)cityDataDidHandled:(CityTypeMode)cityTypeMode
{
    self.storeCities = [NSMutableArray array];
    //读取本地文件
    NSString *cityFileName = nil;
    if (cityTypeMode == 0) {
        cityFileName = @"cityjson";
        self.arrayHotCity = [NSMutableArray arrayWithArray: @[@"北京",@"上海",@"广州",@"海口",@"深圳",@"成都",@"杭州",@"重庆",@"厦门"]];
        self.searchText = @"北/北京/bei/beijing";
    }else
    {
        cityFileName = @"cityjson";
         self.arrayHotCity = [NSMutableArray arrayWithArray: @[@"纽约",@"旧金山",@"东京",@"釜山",@"新加坡",@"柏林"]];
            self.searchText = @"旧/旧金山/San/San Francisco";
    }
    NSString *filePath = [[NSBundle mainBundle]pathForResource:cityFileName ofType:@"txt"];
    //转码
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *textFile  = [NSString stringWithContentsOfFile:filePath encoding:enc error:nil];
    
    //将读取的文件JSON转化为字典
    NSData* data = [textFile dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //取出城市的KEY
    
    NSArray *cityArray=[result objectForKey:@"cities"];
    for (int i = 0; i < [cityArray count]; i++)
    {
        NSDictionary *citydic = [cityArray objectAtIndex:i];
        [self addCityData:citydic];
    }
    
    //排序后的数组初始化
    NSArray * newArr = [NSArray array];
    //排序
    newArr = [self.storeCities sortedArrayUsingFunction:nickNameSort context:NULL];
    //分组数组初始化
    self.arrayForArrays = [NSMutableArray array];
    //开头字母初始化
    self.sectionHeadsKeys = [NSMutableArray array];
    //每个字母分组的城市
    BOOL changeHeader = NO;
    NSMutableArray *TempArrForGrouping = [NSMutableArray array];
    for(int index = 0; index < [newArr count]; index++)
    {
        City *chineseStr = (City *)[newArr objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.cityPinyin];
        //取首字母 转大写
        NSString *headerstr= [[strchar substringToIndex:1] uppercaseString];
        //设置数组中最后一个数字
        changeHeader = NO;
        //检查数组内是否有该首字母，没有就创建
        if(![self.sectionHeadsKeys containsObject:headerstr])
        {
            //不存在就添加进去
            [self.sectionHeadsKeys addObject:headerstr];
            changeHeader = YES;
        }
        if (changeHeader && self.sectionHeadsKeys.count > 1)
        {
            [self.arrayForArrays addObject:TempArrForGrouping];
            TempArrForGrouping = [NSMutableArray array];
        }
        [TempArrForGrouping addObject:[newArr objectAtIndex:index]];
    }
    [self.arrayForArrays addObject:TempArrForGrouping];
}

//
//按字母排序方法
//
NSInteger nickNameSort(id city1, id city2, void *context)
{
    City *firstcity,*secondcity;
    //类型转换
    firstcity = (City*)city1;
    secondcity = (City*)city2;
    return  [firstcity.cityPinyin localizedCompare:secondcity.cityPinyin];
}

//给数据模型添加城市
- (void)addCityData:(NSDictionary *)cityDetail
{
    //解析百度的JSON数据的KEY 分组
    //各省份直辖市的字典封装
    City * city = [[City alloc] init];
    city.cityNAme    = [cityDetail objectForKey:@"name"];
    city.cityCode    = [cityDetail objectForKey:@"code"];
    city.cityPinyin  = [cityDetail objectForKey:@"pinyin"];
    city.cityHot = [cityDetail objectForKey:@"hotcity"];
    //都放在存储数组里
    [self.storeCities addObject:city];
}
@end



@implementation City

@end
