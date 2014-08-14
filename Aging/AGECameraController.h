//
//  AGECameraController.h
//  Aging
//
//  Created by Lukas Bischofberger on 7/7/14.
//  Copyright (c) 2014 UW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFNetworking/AFNetworking.h"
#import "AGESettings.h"
#import "AGECollectionViewController.h"
#import "AGEAgedViewController.h"

@interface AGECameraController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *liveImage;
@property (weak, nonatomic) IBOutlet UILabel *uploadText;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

- (IBAction)takePictureAction:(id)sender;
- (IBAction)selectPictureAction:(id)sender;
- (IBAction)uploadPictureAction:(id)sender;
- (IBAction)logoutAction:(id)sender;

@property bool picSet;
@property bool newMedia;
@property UIImage * uploadImage;
@property (nonatomic) int faceId;
@property (nonatomic) int userId;
@property (nonatomic) int cluster;
@property (nonatomic) int targetCluster;

// chose values
@property (nonatomic) NSString* age;
@property (nonatomic) NSString* gender;
@property (nonatomic) NSString* ethnicity;
@property (nonatomic) NSString* expression;
@property (nonatomic) NSString* targetAge;

//picker arrays
@property (strong, nonatomic) NSArray *ageArray;
@property (strong, nonatomic) NSArray *genderArray;
@property (strong, nonatomic) NSArray *ethnicityArray;
@property (strong, nonatomic) NSArray *expressionArray;
@property (strong, nonatomic) NSArray *targetAgeArray;

//picker overlays
@property (weak, nonatomic) IBOutlet UIView *darkOver;
@property (weak, nonatomic) IBOutlet UIView *genderOverlay;
@property (weak, nonatomic) IBOutlet UIView *ethnicityOverlay;
@property (weak, nonatomic) IBOutlet UIView *ageOverlay;
@property (weak, nonatomic) IBOutlet UIView *expressionOverlay;
@property (weak, nonatomic) IBOutlet UIView *targetAgeOverlay;

@property (weak, nonatomic) IBOutlet UIPickerView *ethnicityPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *genderPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *agePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *expressionPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *targetAgePicker;

@property UIActivityIndicatorView *spinner;
- (IBAction)ageNext:(id)sender;
- (IBAction)genderNext:(id)sender;
- (IBAction)ethnicityNext:(id)sender;
- (IBAction)expressionNext:(id)sender;
- (IBAction)targetAgeNext:(id)sender;

@end
