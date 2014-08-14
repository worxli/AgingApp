//
//  AGECollectionViewController.h
//  Aging
//
//  Created by Lukas Bischofberger on 7/8/14.
//  Copyright (c) 2014 UW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGECellView.h"
#import "AGESettings.h"
#import "AFNetworking.h"
#import "AGEDetailImageViewController.h"

@interface AGECollectionViewController : UICollectionViewController  <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UIImage *origImage;
@property (weak, nonatomic) UIImage *cropImage;
@property (strong, nonatomic) NSMutableArray *ageImages;
@property (strong, nonatomic) NSMutableArray *cropImages;
@property (strong, nonatomic) NSMutableArray *ageLabels;
@property (strong, nonatomic) NSMutableArray *ageClusters;
@property (nonatomic) NSInteger minCluster;
@property (nonatomic) NSInteger faceId;
@property (nonatomic) NSString *age;
@property (nonatomic) UIImage *detailImage;

@end
