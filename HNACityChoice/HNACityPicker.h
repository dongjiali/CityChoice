//
//  HNACityPicker.h
//  HNACityChoice
//
//  Created by curry on 14-3-9.
//  Copyright (c) 2014年 HNACityChoice. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CityPickerDelegate;
@interface HNACityPicker : UINavigationController

@property (nonatomic,weak)id<CityPickerDelegate>cityDelegate;
@property (nonatomic,strong)UIColor *backgroundColor;
@property (nonatomic,strong)NSMutableArray *collectionDats;
@end


@protocol CityPickerDelegate
- (void)selectedCityisName:(NSString *)cityName;
@end