//
//  AGEGalleryController.h
//  ActingQuiz
//
//  Created by Lukas Bischofberger on 8/14/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureSet.h"
#import "FFActQuizAppDelegate.h"
#import "AGECellView.h"
#import "AGEDetailImageViewController.h"
#import "AGESettings.h"
#import "AFNetworking.h"

@interface AGEGalleryController : UICollectionViewController  <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSArray* fetchedPictureSetArray;

@property (strong, nonatomic) NSString *Age;
@property (strong, nonatomic) NSNumber *imageId;
@property (strong, nonatomic) UIImage *Aged;
@property (strong, nonatomic) UIImage *Image;
@property (nonatomic) dispatch_queue_t sessionQueue;

@property (nonatomic) int userId;
- (IBAction)save:(id)sender;
- (IBAction)delete:(id)sender;

@end
