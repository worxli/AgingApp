//
//  FaceFrontierGalleryViewController.h
//  Face Frontier
//
//  Created by Kathleen Tuite on 5/8/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceFrontierGalleryViewController : UIViewController  <UIWebViewDelegate>

@property NSString *url;
@property (weak, nonatomic) IBOutlet UINavigationItem *navbarTitle;


@end
