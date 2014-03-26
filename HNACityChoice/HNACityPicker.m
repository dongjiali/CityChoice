//
//  HNACityPicker.m
//  HNACityChoice
//
//  Created by curry on 14-3-9.
//  Copyright (c) 2014年 HNACityChoice. All rights reserved.
//

#import "HNACityPicker.h"
#import "HNACityPickerViewController.h"
@interface HNACityPicker ()
{
    HNACityPickerViewController *CityPicker;
}
@property (readwrite, nonatomic, copy)selectedCityBolck cityBlock;
@end

@implementation HNACityPicker

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    CityPicker = [[HNACityPickerViewController alloc]init];
//    CityPicker.delegate = self;
    if (self = [super initWithRootViewController:CityPicker]) {
        [CityPicker resultCityName:^(NSString *cityName) {
            if (_cityBlock)
            {
                _cityBlock(cityName);
                [self backController];
            }
        }];
        
        CityPicker.title = @"选择城市";
        //返回按钮
        UIBarButtonItem *backController = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backController)];
        backController.tintColor = [UIColor redColor];
        CityPicker.navigationItem.leftBarButtonItem = backController;
    }
    return self;
}

- (void)selectedCityisName:(selectedCityBolck)block
{
    _cityBlock = block;
}

- (void)backController
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.navigationBar.barTintColor = backgroundColor;
}

@end
