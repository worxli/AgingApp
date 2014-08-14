//
//  FaceFrontierDemographicViewController.h
//  Face Frontier
//
//  Created by Kathleen Tuite on 4/14/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceFrontierDemographicViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UIPickerView *agePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *genderPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (strong, nonatomic) NSArray *ageArray;
@property (strong, nonatomic) NSArray *genderArray;
@property (strong, nonatomic) NSArray *countryArray;


@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *gender;

@end
