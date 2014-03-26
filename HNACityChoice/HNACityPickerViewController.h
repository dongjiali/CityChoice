//
//  HNACityPickerViewController.h
//  HNACityChoice
//
//  Created by curry on 14-3-9.
//  Copyright (c) 2014年 HNACityChoice. All rights reserved.
//

typedef enum SectionTypeMode {
    SectionMylocation = 0,
    SectionHotCity,
    SectionDefault,
}SectionTypeMode;

typedef void (^ResultCityBolck)(NSString *cityName);

#import <UIKit/UIKit.h>
@interface HNACityPickerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
//反回选择的热门城市
- (void)resultCityName:(ResultCityBolck)block;

//搜索
@property (nonatomic, strong)UISearchBar *searchBarView;
//选项卡
@property (nonatomic, strong)UISegmentedControl *segmentedView;
//城市列表
@property (nonatomic ,strong)UITableView *tableview;
//热门城市
@property (nonatomic ,strong)NSArray *HotCityArray;
//分个group的headtext
@property (nonatomic ,strong)NSString *headerText;
//定位文本
@property (nonatomic, strong)NSString *locationText;
//搜索控制
@property (nonatomic, strong) UISearchDisplayController *searchDisplay;
//城市数据
@property (nonatomic, strong) NSMutableArray *dataArray;
//搜索数据
@property (nonatomic, strong) NSMutableArray *searchResults;
//英文提示数据
@property (nonatomic, strong) NSMutableArray *indexArray;
//国内城市
@property (nonatomic,strong) NSArray *handleDomesticCity;
//国际城市
@property (nonatomic,strong) NSArray *handleInternationalCity;
@end
