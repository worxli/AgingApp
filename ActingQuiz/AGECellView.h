//
//  AGECellView.h
//  Aging
//
//  Created by Lukas Bischofberger on 7/8/14.
//  Copyright (c) 2014 UW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGECellView : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *age;
@property (weak, nonatomic) IBOutlet UIImageView *aged;

@end
