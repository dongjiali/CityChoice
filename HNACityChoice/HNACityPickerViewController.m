//
//  HNACityPickerViewController.m
//  HNACityChoice
//
//  Created by curry on 14-3-9.
//  Copyright (c) 2014年 HNACityChoice. All rights reserved.
//

#import "HNACityPickerViewController.h"
#import "CityTableViewCell.h"
#import "HNAHandleCityData.h"

#define SearchBarHeight 44
#define SegmentedHeight 20
#define TABLEVIEWCELLHEIGHT 44
#define TABLEVIEWCELLCOUNT 1

static float hotCityCellHeight = 0;
@interface HNACityPickerViewController ()
{
    //定位城市cell
    LocationCityTableViewCell *locationcity;
    //热门城市cell
    HotCityTableViewCell *hotcity;
    //定位成功标签
    BOOL locationTag;

}
@end

@implementation HNACityPickerViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //添加搜索栏
    self.searchBarView = [[UISearchBar alloc]init];
    self.searchBarView.delegate = self;
    [self.view addSubview:self.searchBarView];
    
    [self.searchBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *viewsDictionary = @{@"searchBarView": self.searchBarView};
    NSDictionary *metricsDictionary = @{@"overlayViewHeight": [NSNumber numberWithFloat:SearchBarHeight]};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[searchBarView]|" options:NSLayoutFormatAlignAllTop metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[searchBarView(==overlayViewHeight)]" options:NSLayoutFormatAlignAllTop metrics:metricsDictionary views:viewsDictionary]];
   
    self.searchDisplay = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBarView contentsController:self];
    self.searchDisplay.active = NO;
    [self.searchDisplay setDelegate:self];
    [self.searchDisplay setSearchResultsDelegate:self];
    [self.searchDisplay setSearchResultsDataSource:self];
    
    //添加选项卡栏
    NSArray *segmentedarray = @[@"国 内",@"国 际"];
    self.segmentedView = [[UISegmentedControl alloc]initWithItems:segmentedarray];
    [self.view addSubview:self.segmentedView];
    
    self.segmentedView.selectedSegmentIndex = 0;
    self.segmentedView.tintColor = [UIColor redColor];
    [self.segmentedView addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self segmentAction:self.segmentedView];
    [self.segmentedView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBarView attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:8]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-8]];
    [self.segmentedView addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SegmentedHeight]];
    
    //添加列表
    self.tableview = [[UITableView alloc]init];
    [self.view addSubview:self.tableview];
    [self.tableview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tableview registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.segmentedView attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    //iOS7 Only: We don't want the calendar to go below the status bar (&navbar if there is one).
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;
    else
        [self respondsToSelector:@selector(edgesForExtendedLayout)];
}

#pragma -mark AddCellView
- (void)addLocationCellView
{
    if (!locationcity) {
        locationcity = [[LocationCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Locationcell"];
        [locationcity requireLocationTexg:^(NSString *locationString, BOOL tag) {
            self.locationText = locationString;
            locationTag = tag;
        }];
    }
}

- (void)addHotCityCellView
{
    if (!hotcity) {
        hotcity = [[HotCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HotCitycell"];
        [hotcity requireHotCityname:^(NSString *cityName) {
            _block(cityName);
        }];
    }
}

- (UITableViewCell *)addSearchTableCellView:(NSString *)CellIdentifier
{
    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSLog(@"%@",CellIdentifier);
    }
    return cell;
}

#pragma -mark InitCityDataNumber
// 设置每个分组分类的text和反回数据
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    UIColor *tableHeaderColor;
    NSString *headerText;
    if ([self changeTableViewSearch:tableView]) {
        tableHeaderColor = [UIColor blackColor];
        headerText = @"结果";
    }else {
        switch (section) {
            case SectionMylocation:
                headerText = @"当前城市";
                tableHeaderColor = [UIColor redColor];
                break;
            case SectionHotCity:
                headerText = @"热门城市";
                tableHeaderColor = [UIColor redColor];
                break;
            default:
                headerText = self.indexArray[section-2];
                tableHeaderColor = [UIColor blackColor];
                break;
        }
    }
    headerView.textLabel.textColor = tableHeaderColor;
    self.headerText = headerText;
    headerView.textLabel.text = headerText;
    return headerView;
}


# pragma mark- TableView datasource methods

#pragma -mark- TableView delegate
//每组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (![self changeTableViewSearch:tableView]) {
        return self.dataArray.count + 2;
    }
    return TABLEVIEWCELLCOUNT;
}
//每组的行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self changeTableViewSearch:tableView]) {
        return self.searchResults.count;
    }
    if (section >= 2) {
        return [self.dataArray[section - 2]count];
    }
    return TABLEVIEWCELLCOUNT;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self changeTableViewSearch:tableView]) {
        if (indexPath.section == 1) {
            return hotCityCellHeight;
        }
    }
    return TABLEVIEWCELLHEIGHT;
}

//设置表格的索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([self changeTableViewSearch:tableView]) {
        return nil;
    }
    return self.indexArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ([self changeTableViewSearch:tableView]) {
        cell = [self addSearchTableCellView:@"SearchCell"];
        cell.textLabel.text = self.searchResults[indexPath.row];
    }else
    switch (indexPath.section) {
        case SectionMylocation:{
            //初始化定位CELL
            if (locationcity) {
                cell = locationcity;
            }
        }
            break;
        case SectionHotCity:{
            if (hotcity) {
                cell = hotcity;
            }
        }
            break;
        default:
        {
            cell = [self addSearchTableCellView:@"Cell"];
            NSArray *currentItems = self.dataArray[indexPath.section - 2];
            NSString *category = ((City *)currentItems[indexPath.row]).cityNAme;
            cell.textLabel.text = category;
        }
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cityName = nil;
    if ([self changeTableViewSearch:tableView])
    {
        cityName = self.searchResults[indexPath.row];
    }
    else{
        if (indexPath.section == 0) {
            if (locationTag) {
                cityName = self.locationText;
                _block(cityName);
            }
            return;
        }else
        {
        NSArray *currentItems = self.dataArray[indexPath.section - 2];
        NSString *category = ((City *)currentItems[indexPath.row]).cityNAme;
        cityName = category;
        }
    }
    //返回选择城市
    _block(cityName);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.headerText;
}

#pragma mark- UISearchDisplayDelegate

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchResults = [NSMutableArray array];
    [self.tableview setContentSize:CGSizeMake(0, 0)];
    if (searchText.length > 0 && ![self isIncludeChineseInString:searchText]) {
        for (NSArray *array in self.dataArray) {
            for (City *city in array) {
                if ([self isIncludeChineseInString:city.cityNAme]) {
                    NSRange titleResult=[city.cityPinyin rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [self.searchResults addObject:city.cityNAme];
                    }
                }else{
                    NSRange titleResult=[city.cityPinyin rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [self.searchResults addObject:city.cityNAme];
                    }
                }
            }
        }
    } else if (searchText.length > 0 && [self isIncludeChineseInString:searchText]) {
        for (NSArray *array in self.dataArray) {
            for (City *city in array) {
            NSRange titleResult=[city.cityNAme rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [self.searchResults addObject:city.cityNAme];
                }
            }
        }
    }
}

//判断输入的是英文还是字母
- (BOOL)isIncludeChineseInString:(NSString*)str {
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}

#pragma mark- get datas
- (void)refreshDomesticCityTableCityDate
{
    if (!self.handleDomesticCity) {
       HNAHandleCityData *domesticdate = [[HNAHandleCityData alloc]init];
        [domesticdate cityDataDidHandled:CityTypeModeDomestic];
        self.handleDomesticCity = [NSArray arrayWithObjects:domesticdate.arrayForArrays,domesticdate.sectionHeadsKeys,domesticdate.arrayHotCity,domesticdate.searchText, nil];
    }
}


- (void)refreshInternationalTableCityDate
{
    if (!self.handleInternationalCity) {
        HNAHandleCityData *internationaldate = [[HNAHandleCityData alloc]init];
        [internationaldate cityDataDidHandled:CityTypeModeInternational];
        self.handleInternationalCity = [NSArray arrayWithObjects:internationaldate.arrayForArrays,internationaldate.sectionHeadsKeys,internationaldate.arrayHotCity,internationaldate.searchText,nil];
    }
}

#pragma mark- refresh UITableView
-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            [self refreshDomesticCityTableCityDate];
            self.dataArray = self.handleDomesticCity[0];
            self.indexArray = self.handleDomesticCity[1];
            self.HotCityArray = self.handleDomesticCity[2];
            self.searchBarView.placeholder = self.handleDomesticCity[3];
            break;
        case 1:
            [self refreshInternationalTableCityDate];
            self.dataArray = self.handleInternationalCity[0];
            self.indexArray = self.handleInternationalCity[1];
            self.HotCityArray = self.handleInternationalCity[2];
            self.searchBarView.placeholder = self.handleInternationalCity[3];
            break;
    }
    [self TableviewReloadData];
    [self.tableview reloadData];
    //切换tableViw 添加动画
    CATransition *animation = [CATransition animation];
    [animation setDuration:.3f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [animation setType:kCATransitionFade];
    [animation setSubtype:kCATransitionFromBottom];
    [self.tableview.layer addAnimation:animation forKey:@"animation"];
}

- (void)TableviewReloadData
{
    
    //根据热门城市个数求高度
    NSInteger cellheightnum = self.HotCityArray.count / 3;
    CGFloat cellheightsum = 0;
    if (self.HotCityArray.count%3 > 0 ) {
        cellheightsum = 5.0 *cellheightnum + 40 * (cellheightnum +1);
    }
    else
    {
        cellheightsum = 5.0 *(cellheightnum -1 )+ 40 * cellheightnum;
    }
    hotCityCellHeight = 20 + cellheightsum;
    //刷新定位cell试图
    [self addLocationCellView];
    //添加热门城市视图
    [self addHotCityCellView];
    //刷新热门城市视图
    hotcity.cityArray = self.HotCityArray;
    [hotcity refreshHotCiytDatas:hotCityCellHeight];
}

#pragma -mark- change TableView Search
- (BOOL)changeTableViewSearch:(UITableView *)tableview
{
    return [tableview isEqual:self.searchDisplayController.searchResultsTableView];
}

#pragma -mark- block
- (void)selectedCityName:(SelectedCityBolck)block
{
    _block = [block copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
