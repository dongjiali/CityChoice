//
//  HNACityPicker.h
//  HNACityChoice
//
//  Created by curry on 14-3-9.
//  Copyright (c) 2014年 HNACityChoice. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectedCityBolck)(NSString *city);

@interface HNACityPicker : UINavigationController

@property (nonatomic,strong)UIColor *backgroundColor;
@property (nonatomic,strong)NSMutableArray *collectionDats;

- (void)selectedCityisName:(selectedCityBolck)block;
@end