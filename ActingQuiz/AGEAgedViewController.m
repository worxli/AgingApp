//
//  AGEAgedViewController.m
//  Aging
//
//  Created by Lukas Bischofberger on 7/28/14.
//  Copyright (c) 2014 UW. All rights reserved.
//

#import "AGEAgedViewController.h"

@interface AGEAgedViewController ()

@end

@implementation AGEAgedViewController

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
    
    _agedAge.text = [self clustertoage: self.cluster];
    NSLog([self clustertoage: self.cluster]);
    
    [self loadAgedImage];
    [self loadCroppedImage];
    
}

-(void) sel0: (UITapGestureRecognizer *) recognizer
{
    self.detailImage = self.origImage;
    [self performSegueWithIdentifier:@"fullImageAction" sender:self];
}

-(void) sel1: (UITapGestureRecognizer *) recognizer
{
    self.detailImage = self.cropImage;
    [self performSegueWithIdentifier:@"fullImageAction" sender:self];
}

-(void) sel2: (UITapGestureRecognizer *) recognizer
{
    self.detailImage = self.agedImage;
    [self performSegueWithIdentifier:@"fullImageAction" sender:self];
}

-(void) sel3: (UITapGestureRecognizer *) recognizer
{
    self.detailImage = self.nonblendImage;
    [self performSegueWithIdentifier:@"fullImageAction" sender:self];
}

-(void) twoFinger:(UIPinchGestureRecognizer *) recognizer
{
    if ( recognizer.scale >1.0f && recognizer.scale <2.5f) {
        CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
        _inputImage.transform = transform;
    }
}

- (void)loadAgedImage
{

    //get image face_id - cluster_id from server
    NSString *requestURL = [NSString stringWithFormat:@"%@getFace?face_id=%d&cluster_id=%d", serverUrl, (int)self.faceId, (int)self.cluster];
            
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
            
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
        _outImage.contentMode = UIViewContentModeScaleAspectFit;
        _outImage.clipsToBounds = YES;
        self.agedImage = responseObject;
        [_outImage setImage: self.agedImage];
        
        //UIImageWriteToSavedPhotosAlbum(responseObject, id completionTarget, SEL completionSelector, void *contextInfo);
        
        UIImageWriteToSavedPhotosAlbum(responseObject,
                                       self, // send the message to 'self' when calling the callback
                                       NULL, // the selector to tell the method to call on completion
                                       NULL);
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
            
    [requestOperation start];
    
}

- (void) loadCroppedImage
{
    
    //get image face_id - cluster_id from server
    NSString *requestURL = [NSString stringWithFormat:@"%@getCroppedFace?face_id=%d", serverUrl, (int)self.faceId];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _cropInput.contentMode = UIViewContentModeScaleAspectFit;
        _cropInput.clipsToBounds = YES;
        self.cropImage = responseObject;
        [_cropInput setImage: self.cropImage];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [requestOperation start];
}

- (void) loadNonBlendImage
{
    
    //get image face_id - cluster_id from server
    NSString *requestURL = [NSString stringWithFormat:@"%@getNonBlendFace?face_id=%d&cluster_id=%d", serverUrl, (int)self.faceId, (int)self.cluster];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _outNonBlendImage.contentMode = UIViewContentModeScaleAspectFit;
        _outNonBlendImage.clipsToBounds = YES;
        self.nonblendImage = responseObject;
        [_outNonBlendImage setImage: self.nonblendImage];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [requestOperation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"fullImageAction"])
    {
        // Get reference to the destination view controller
        AGEDetailImageViewController *vc = [segue destinationViewController];
        
       [vc setDetailImage: self.detailImage];
    }
}


- (NSString*) clustertoage: (int) cluster {
    
    NSString *str;
    
    switch (cluster) {
        case 1:
            str = @"< 1";
            break;
        case 2:
            str = @"between 1 and 2";
            break;
        case 3:
            str = @"between 2 and 4";
            break;
        case 4:
            str = @"between 4 and 6";
            break;
        case 5:
            str = @"between 6 and 9";
            break;
        case 6:
            str = @"between 9 and 12";
            break;
        case 7:
            str = @"between 12 and 15";
            break;
        case 8:
            str = @"between 15 and 24";
            break;
        case 9:
            str = @"between 24 and 34";
            break;
        case 10:
            str = @"between 34 and 44";
            break;
        case 11:
            str = @"between 44 and 56";
            break;
        case 12:
            str = @"between 56 and 67";
            break;
        case 13:
            str = @"between 67 and 79";
            break;
        case 14:
            str = @"between 79 and 101";
            break;
        default:
            str = @"no valid age";
            break;
    }
    return str;
    
}

@end
