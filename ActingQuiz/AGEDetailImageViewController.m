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
    
    
    if (self.imageId) {
        
        NSString *address = [NSString stringWithFormat:@"%@getMorph?face_id=%@", serverUrl, self.imageId];
        
        NSURL *url = [NSURL URLWithString: address];
        
        NSLog(self.imageId);
        [self playMovieAtURL: address];
        
    } else {

        self.AgedView.contentMode = UIViewContentModeScaleAspectFit;
        self.AgedView.clipsToBounds = YES;
        [self.AgedView setImage: self.Aged];
    
        self.AgeView.text = self.Age;
    }

}

-(void) playMovieAtURL: (NSString*) theURL {
  
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *moviePath = [bundle pathForResource:theURL ofType:@"mp4"];
    
    MPMoviePlayerController* theMoviPlayer = [[MPMoviePlayerController alloc] initWithContentURL:moviePath];
    theMoviPlayer.controlStyle = MPMovieControlStyleFullscreen;
    theMoviPlayer.view.transform = CGAffineTransformConcat(theMoviPlayer.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    UIWindow *backgroundWindow = [[UIApplication sharedApplication] keyWindow];
    [theMoviPlayer.view setFrame:backgroundWindow.frame];
    [backgroundWindow addSubview:theMoviPlayer.view];
    [theMoviPlayer play];
    
}

// When the movie is done, release the controller.
-(void) myMovieFinishedCallback: (NSNotification*) aNotification
{
    MPMoviePlayerController* theMovie = [aNotification object];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name: MPMoviePlayerPlaybackDidFinishNotification
     object: theMovie];

}

- (void) movieFinishedCallback:(NSNotification*) aNotification {
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
