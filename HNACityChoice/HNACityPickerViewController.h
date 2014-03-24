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

typedef void (^SelectedCityBolck)(NSString *cityName);

#import <UIKit/UIKit.h>
@interface HNACityPickerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    SelectedCityBolck _block;
}
//反回选择的热门城市
- (void)selectedCityName:(SelectedCityBolck)block;
//tabview头view
@property (nonatomic, strong)UIView *tableHeaderView;
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

@property (nonatomic,strong) NSArray *handleDomesticCity;

@property (nonatomic,strong) NSArray *handleInternationalCity;
@end
