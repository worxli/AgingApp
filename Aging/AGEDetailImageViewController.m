//
//  AGEDetailImageViewController.m
//  Aging
//
//  Created by Lukas Bischofberger on 7/8/14.
//  Copyright (c) 2014 UW. All rights reserved.
//

#import "AGEDetailImageViewController.h"

@interface AGEDetailImageViewController ()

@end

@implementation AGEDetailImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _ImageView.contentMode = UIViewContentModeScaleAspectFit;
    _ImageView.clipsToBounds = YES;
    [_ImageView setImage: self.detailImage];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *) scrollView
{
    return self.ImageView;
}



-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView
{
    CGSize imgViewSize = self.ImageView.frame.size;
    CGSize imageSize = self.ImageView.image.size;
    
    CGSize realImgSize;
    if(imageSize.width / imageSize.height > imgViewSize.width / imgViewSize.height) {
        realImgSize = CGSizeMake(imgViewSize.width, imgViewSize.width / imageSize.width * imageSize.height);
    }
    else {
        realImgSize = CGSizeMake(imgViewSize.height / imageSize.height * imageSize.width, imgViewSize.height);
    }
    
    //CGRect fr = CGRectMake(0, 0, 0, 0);
    //fr.size = realImgSize;
    //self.ImageView.frame = fr;
    
    CGSize scrSize = scrollView.frame.size;
    //float offx = (scrSize.width > realImgSize.width ? (scrSize.width - realImgSize.width) / 2 : 0);
    //float offy = (scrSize.height > realImgSize.height ? (scrSize.height - realImgSize.height) / 2 : 0);
    float offx = 0;
    float offy = 0;
    
    // don't animate the change.
    self.scrollView.contentInset = UIEdgeInsetsMake(offy, offx, offy, offx);
    //NSLog(@"centered");
}

@end
