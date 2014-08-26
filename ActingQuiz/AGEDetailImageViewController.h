//
//  AGEDetailImageViewController.h
//  Aging
//
//  Created by Lukas Bischofberger on 7/8/14.
//  Copyright (c) 2014 UW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AGESettings.h"

@interface AGEDetailImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *AgedView;
@property (weak, nonatomic) UIImage *Image;
@property (weak, nonatomic) UIImage *Aged;
@property (weak, nonatomic) IBOutlet UITextView *AgeView;
@property (weak, nonatomic) NSString *Age;
@property (weak, nonatomic) NSNumber *imageId;
- (IBAction)watch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *watchButton;

@end
