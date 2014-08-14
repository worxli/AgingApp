//
//  AGEAgedViewController.h
//  Aging
//
//  Created by Lukas Bischofberger on 7/28/14.
//  Copyright (c) 2014 UW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGESettings.h"
#import "AFNetworking.h"
#import "AGEDetailImageViewController.h"

@interface AGEAgedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *inputImage;
@property (weak, nonatomic) IBOutlet UIImageView *cropInput;
@property (weak, nonatomic) IBOutlet UIImageView *outImage;
@property (weak, nonatomic) IBOutlet UIImageView *outNonBlendImage;

@property (weak, nonatomic) IBOutlet UITextView *inputAge;
@property (weak, nonatomic) IBOutlet UITextView *agedAge;

@property (weak, nonatomic) UIImage *origImage;
@property (weak, nonatomic) UIImage *cropImage;
@property (weak, nonatomic) UIImage *agedImage;
@property (weak, nonatomic) UIImage *nonblendImage;

@property (weak, nonatomic) UIImage *detailImage;

@property (nonatomic) NSInteger cluster;
@property (nonatomic) NSInteger faceId;
@property (nonatomic) NSString *age;

@property (weak, nonatomic) UIPinchGestureRecognizer *twoFinger;

@end
