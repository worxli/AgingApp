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
    
    self.ImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.ImageView.clipsToBounds = YES;
    [self.ImageView setImage: self.Image];

    self.AgedView.contentMode = UIViewContentModeScaleAspectFit;
    self.AgedView.clipsToBounds = YES;
    [self.AgedView setImage: self.Aged];
    
    self.AgeView.text = self.Age;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
