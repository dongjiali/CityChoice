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

static float hotCityCellHeight = 0;
@interface HNACityPickerViewController ()
{
    HNAHandleCityData *handleDomesticCity;
    HNAHandleCityData *handleInternationalCity;
    //分组数
    NSInteger numberOfSections;
    //每组数量
    NSInteger numberOfRows;
    //头高
    CGFloat heightForRow;
    //分组头的颜色
    UIColor *tableHeaderColor;
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
    self.searchBarView.placeholder = @"北/北京/bei/beijing";
    [self.view addSubview:self.searchBarView];
    
    [self.searchBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *viewsDictionary = @{@"searchBarView": self.searchBarView};
    NSDictionary *metricsDictionary = @{@"overlayViewHeight": [NSNumber numberWithFloat:SearchBarHeight]};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[searchBarView]|" options:NSLayoutFormatAlignAllTop metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[searchBarView(==overlayViewHeight)]" options:NSLayoutFormatAlignAllTop metrics:metricsDictionary views:viewsDictionary]];
   
    self.searchDisplay = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBarView contentsController:self];
    self.searchDisplay.active = NO;
    self.searchDisplay.searchResultsDataSource = self;
    self.searchDisplay.searchResultsDelegate = self;
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
    [self.tableview registerClass:[UITableViewCell class]forCellReuseIdentifier:@"cell"];
    [self.tableview registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.segmentedView attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    //iOS7 Only: We don't want the calendar to go below the status bar (&navbar if there is one).
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma -mark AddCellView
- (void)addLocationCellView
{
    if (!locationcity) {
        locationcity = [[LocationCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
}

- (void)addHotCityCellView
{
    if (!hotcity) {
        hotcity = [[HotCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        hotcity.cityArray = self.HotCityArray;
        [hotcity requireHotCityname:^(NSString *cityName) {
            NSLog(@"%@",cityName);
            _block(cityName);
        }];
    }
}

#pragma -mark InitCityDataNumber
// 设置每个分组分类的text和反回数据
- (void)setGroupTextAndCount:(UITableView *)tableView section:(NSInteger)section
{
    heightForRow = 44;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        numberOfRows = self.searchResults.count;
        tableHeaderColor = [UIColor blackColor];
        self.headerText = @"结果";
    }else {
        switch (section) {
            case SectionMylocation:
                numberOfRows = 1;
                self.headerText = @"当前城市";
                tableHeaderColor = [UIColor redColor];
                break;
            case SectionHotCity:
//                numberOfRows = self.HotCityArray.count;
                heightForRow = hotCityCellHeight;
                numberOfRows = 1;
                self.headerText = @"热门城市";
                tableHeaderColor = [UIColor redColor];
                break;
            default:
                numberOfRows = [self.dataArray[section - 2]count];
                self.headerText = self.indexArray[section - 2];
                tableHeaderColor = [UIColor blackColor];
                break;
        }
    }
}

# pragma mark- TableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        //搜索结果时 只返回一组
        numberOfSections = 1;
    else
        //回一城市数组+我的位+热门城市
        numberOfSections = self.dataArray.count +2;
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self setGroupTextAndCount:tableView section:section];
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self setGroupTextAndCount:tableView section:indexPath.section];
    return heightForRow;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = self.searchResults[indexPath.row];
    }else
    switch (indexPath.section) {
        case SectionMylocation:{
            //初始化定位CELL
            if (!locationTag) {
                [locationcity requireLocationTexg:^(NSString *locationString, BOOL tag) {
                    locationcity.textLabel.text = locationString;
                    self.locationText = locationString;
                    locationTag = tag;
                }];
            }
            cell =  locationcity;
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
            if (cell == locationcity || cell == hotcity) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            NSArray *currentItems = self.dataArray[indexPath.section - 2];
            NSString *category = ((City *)currentItems[indexPath.row]).cityNAme;
            cell.textLabel.text = category;
        }
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [self setGroupTextAndCount:tableView section:section];
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    headerView.textLabel.textColor = tableHeaderColor;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cityName = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        NSLog(@"%@",self.searchResults[indexPath.section]);
        cityName = self.searchResults[indexPath.section];
    }
    else{
        if (indexPath.section == 0) {
            if (locationTag) {
                cityName = self.locationText;
                NSLog(@"%@",self.locationText);
                _block(cityName);
            }
            return;
        }else
        {
        NSArray *currentItems = self.dataArray[indexPath.section - 2];
        NSString *category = ((City *)currentItems[indexPath.row]).cityNAme;
        NSLog(@"%@",category);
        cityName = category;
        }
    }
    _block(cityName);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.headerText;
}

//设置表格的索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}

#pragma mark- UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchResults = [[NSMutableArray alloc]init];
    searchText = self.searchBarView.text;
    
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
    if (!handleDomesticCity) {
        handleDomesticCity = [[HNAHandleCityData alloc]init];
        [handleDomesticCity cityDataDidHandled:CityTypeModeDomestic];
    }
    self.dataArray = handleDomesticCity.arrayForArrays;
    self.indexArray =  handleDomesticCity.sectionHeadsKeys;
    self.HotCityArray = @[@"北京",@"上海虹桥",@"上海浦东",@"广州",@"海口",@"深圳",@"成都",@"杭州",@"重庆",@"厦门",@"昆明"];
}


- (void)refreshInternationalTableCityDate
{
    if (!handleInternationalCity) {
        handleInternationalCity = [[HNAHandleCityData alloc]init];
        [handleInternationalCity cityDataDidHandled:CityTypeModeInternational];
    }
    self.dataArray = handleInternationalCity.arrayForArrays;
    self.indexArray =  handleInternationalCity.sectionHeadsKeys;
    self.HotCityArray =  @[@"纽约",@"旧金山",@"东京",@"釜山",@"新加坡",@"柏林"];
}

#pragma mark- refresh UITableView
-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            [self refreshDomesticCityTableCityDate];
            break;
        case 1:
            [self refreshInternationalTableCityDate];
            break;
    }
    [self TableviewReloadData];

    [self.tableview reloadData];
    //切换tableViw 添加动画
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.0f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [animation setType:kCATransitionFade];
    [animation setSubtype:kCATransitionFromBottom];
    [self.tableview.layer addAnimation:animation forKey:@"animation"];
}

- (void)TableviewReloadData
{
    
    //根据热门城市个数求高度
    NSInteger cellheightnum = 0;
    CGFloat cellheightsum = 0;
    if (self.HotCityArray.count%3 > 0 ) {
        cellheightnum = self.HotCityArray.count / 3;
        cellheightsum = 5.0 *cellheightnum + 40 * (cellheightnum +1);
    }
    else
    {
        cellheightnum = self.HotCityArray.count / 3;
        cellheightsum = 5.0 *(cellheightnum -1 )+ 40 * cellheightnum;
    }
    hotCityCellHeight = 20 + cellheightsum;
    //刷新定位cell试图
    //creat定位cell试图
    [self addLocationCellView];
    [locationcity locationCityText:locationTag];
    //添加热门城市视图
    [self addHotCityCellView];
    //刷新热门城市视图
    hotcity.cityArray = self.HotCityArray;
    [hotcity refreshHotCiytDatas:hotCityCellHeight];
}

#pragma -mark- block数据
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
