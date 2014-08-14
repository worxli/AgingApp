//
//  FaceFrontierGalleryViewController.m
//  Face Frontier
//
//  Created by Kathleen Tuite on 5/8/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import "FaceFrontierGalleryViewController.h"
#import "FaceFrontierLoginSettings.h"

@interface FaceFrontierGalleryViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *galleryWebpage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation FaceFrontierGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.galleryWebpage.delegate = self;
    
    [self configureWebView];
    [self loadAddressURL];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)loadAddressURL {
    NSURL *requestURL = [NSURL URLWithString: self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    [self.galleryWebpage loadRequest:request];
}


#pragma mark - Configuration

- (void)configureWebView {
    self.galleryWebpage.backgroundColor = [UIColor whiteColor];
    self.galleryWebpage.scalesPageToFit = YES;
    self.galleryWebpage.dataDetectorTypes = UIDataDetectorTypeAll;
}


#pragma mark - Web View Delegate Stuff



- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[self spinner] startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[self spinner] stopAnimating];
   
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // Report the error inside the web view.
    NSString *localizedErrorMessage = NSLocalizedString(@"An error occured: ", nil);
    NSString *errorFormatString = @"<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">%@%@</div></body></html>";
    
    NSString *errorHTML = [NSString stringWithFormat:errorFormatString, localizedErrorMessage, error.localizedDescription];
    [self.galleryWebpage loadHTMLString:errorHTML baseURL:nil];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - link clicking

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        
        NSURL *url = request.URL;
        NSString *word = @"s3";
        if ([[url absoluteString] rangeOfString:word].location != NSNotFound) {
            NSLog(@"link clicked");
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
            [self alertStatus:@"This expression collage has been saved to your camera roll." :@"Saved" :0];
            return NO;
        }
        
        
    }
    
    return YES;
    
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
