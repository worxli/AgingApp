//
//  AGEDetailImageViewController.h
//  Aging
//
//  Created by Lukas Bischofberger on 7/8/14.
//  Copyright (c) 2014 UW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGEDetailImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) UIImage *detailImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
