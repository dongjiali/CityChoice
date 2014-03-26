//
//  CityViewController.m
//  HNACityChoice
//
//  Created by Curry on 14-3-18.
//  Copyright (c) 2014年 HNACityChoice. All rights reserved.
//

#import "CityViewController.h"
#import "HNACityPicker.h"
@interface CityViewController ()
{
    UILabel *citylabel;
    HNACityPicker *HNACity;
}
@end

@implementation CityViewController

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
    self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view.
    HNACity = [[HNACityPicker alloc]init];
    [HNACity selectedCityisName:^(NSString *city) {
        citylabel.text = city;
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setTitle:@"选择城市" forState:0];
    [button setTitleColor:[UIColor blackColor] forState:0];
    button.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(selectdate:) forControlEvents:UIControlEventTouchUpInside];
    
    citylabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 230, 200, 20)];
    citylabel.textColor = [UIColor blackColor];
    [self.view addSubview:citylabel];

}

- (void)selectdate:(id)sender
{
    [self presentViewController:HNACity animated:YES completion:nil];
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
