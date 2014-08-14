//
//  AGECameraController.m
//  Aging
//
//  Created by Lukas Bischofberger on 7/7/14.
//  Copyright (c) 2014 UW. All rights reserved.
//

#import "AGECameraController.h"

@interface AGECameraController ()

@end

@implementation AGECameraController

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.userId = (int)[defaults integerForKey:@"user_id"];
    
    //default values
    self.age = @"0"; //(int)[defaults integerForKey:@"age"];
    self.gender = @"f";
    self.ethnicity = @"white";
    self.expression = @"neutral";
    self.targetAge = @"0";
    
    [self setupDropdownPickers];

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
    
    if ([[segue identifier] isEqualToString:@"age_collection"])
    {
        // Get reference to the destination view controller
        AGECollectionViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setMinCluster: self.cluster];
        [vc setFaceId: self.faceId];
        [vc setOrigImage: self.uploadImage];
        [vc setAge: self.age];
        
    }
    
    
    if ([[segue identifier] isEqualToString:@"showAgedAction"])
    {
        // Get reference to the destination view controller
        AGEAgedViewController *vc = [segue destinationViewController];
        
        [vc setCluster: self.targetCluster];
        [vc setFaceId: self.faceId];
        [vc setOrigImage: self.uploadImage];
        [vc setAge: self.age];
        
    }
    
    
}



- (IBAction)takePictureAction:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        _picSet = YES;
        _newMedia = YES;
    }
}

- (IBAction)selectPictureAction:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = NO;
    }
    
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        if (false)//(image.size.width >  image.size.height)
        {
            NSLog(@"Select Image is in Landscape Mode ....");
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Landscape"
                                                                message:@"Picture is in landscape, please choose a portrait picture!"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            NSLog(@"Select Image is in Portrait Mode ...");
        
            image = [self scaleAndRotateImage: image];
            
            _liveImage.contentMode = UIViewContentModeScaleAspectFit;
            _liveImage.clipsToBounds = YES;
            [_liveImage setImage:image];
            
            if (_newMedia)
                UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
            }
        
            self.uploadImage = image;
    }
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    
    int kMaxResolution = 720;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    
    UIImageOrientation orient = image.imageOrientation;
    NSLog(@"the exif orientation is... %ld", orient);
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF =
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
            /*
             // Original version
             case UIImageOrientationLeftMirrored: //EXIF = 6
             boundHeight = bounds.size.height;
             bounds.size.height = bounds.size.width;
             bounds.size.width = boundHeight;
             transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width/2.0);
             transform = CGAffineTransformScale(transform, -1.0, 1.0);
             transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
             break;*/
            
        case UIImageOrientationLeftMirrored: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.height);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF =
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)setupDropdownPickers
{
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < 100; i++) {
        [array addObject: [NSString stringWithFormat:@"%ld",(long)i]];
    }
    
    self.ageArray = [[NSArray alloc] initWithArray:array];
    
    self.genderArray  = [[NSArray alloc] initWithObjects:
                         @"female",
                         @"male", nil];
    
    self.ethnicityArray = [[NSArray alloc] initWithObjects:
                         @"White",
                         @"Black",
                         @"Arab",
                         @"Hispanic",
                         @"Native",
                         @"Asian", nil];
    
    self.expressionArray = [[NSArray alloc] initWithObjects:
                       @"neutral",
                       @"smiling",
                       @"angry",
                       @"surprised", nil];
    
}


#pragma mark - Picker delegate stuff

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.agePicker){
        return self.ageArray.count;
    }
    else if (pickerView == self.genderPicker){
        return self.genderArray.count;
    }
    else if (pickerView == self.ethnicityPicker){
        return self.ethnicityArray.count;
    }
    else if (pickerView == self.expressionPicker){
        return self.expressionArray.count;
    }
    else if (pickerView == self.targetAgePicker){
        return self.targetAgeArray.count;
    }
    
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (pickerView == self.agePicker){
        return [self.ageArray objectAtIndex:row];
    }
    else if (pickerView == self.genderPicker){
        return [self.genderArray objectAtIndex:row];
    }
    else if (pickerView == self.ethnicityPicker){
        return [self.ethnicityArray objectAtIndex:row];
    }
    else if (pickerView == self.expressionPicker){
        return [self.expressionArray objectAtIndex:row];
    }
    else if (pickerView == self.targetAgePicker){
        return [self.targetAgeArray objectAtIndex:row];
    }
    
    return @"???";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    if (pickerView == self.agePicker){
        self.age = [self.ageArray objectAtIndex:row];
    }
    else if (pickerView == self.genderPicker){
        NSString *gender = [self.genderArray objectAtIndex:row];
        if ([gender isEqualToString:@"male"]) {
            self.gender = @"m";
        } else {
            self.gender = @"f";
        }
    }
    else if (pickerView == self.ethnicityPicker){
        self.ethnicity = [self.ethnicityArray objectAtIndex:row];
    }
    else if (pickerView == self.expressionPicker){
        self.expression = [self.expressionArray objectAtIndex:row];
    }
    else if (pickerView == self.targetAgePicker){
        self.targetAge = [self.targetAgeArray objectAtIndex:row];
    }
}


- (IBAction)uploadPictureAction:(id)sender {
    
    UIImage * image = self.uploadImage;
    
    if (image==NULL) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No image"
                                                            message:@"No image selected, please capture or choose an image first!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    ///////////////////////
    // collect meta data //
    
    self.darkOver.hidden = NO;
    self.ageOverlay.hidden = NO;
    
}

- (IBAction)ageNext:(id)sender {
    
    self.ageOverlay.hidden = YES;
    self.genderOverlay.hidden = NO;
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = [self.age intValue]+1; i < 100; i++) {
        [array addObject: [NSString stringWithFormat:@"%ld",(long)i]];
    }
    
    self.targetAgeArray = [[NSArray alloc] initWithArray:array];
    [self.targetAgePicker reloadAllComponents];
}

- (IBAction)genderNext:(id)sender {
    
    self.genderOverlay.hidden = YES;
    self.ethnicityOverlay.hidden = NO;
    
}

- (IBAction)ethnicityNext:(id)sender {
    
    self.ethnicityOverlay.hidden = YES;
    self.expressionOverlay.hidden = NO;
    
}

- (IBAction)expressionNext:(id)sender {
    
    self.expressionOverlay.hidden = YES;
    self.targetAgeOverlay.hidden = NO;
    
}

- (IBAction)targetAgeNext:(id)sender {
    
    self.targetAgeOverlay.hidden = YES;
    
    [self uploadPicture];
}


- (void)uploadPicture {
    
    UIImage * image = self.uploadImage;
    
    ///////////////////////////////////////////////////////
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    
    
    ///////////////////////////
    
    self.progressBar.hidden = NO;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 90);
    
    
    NSDictionary *parameters = @{@"source": @"aging", @"user_id": [NSNumber numberWithInt:self.userId], @"age": self.age, @"gender": self.gender, @"ethnicity": self.ethnicity, @"expression": self.expression, @"targetAge": self.targetAge};
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@add", serverUrl] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"file_data" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [self alertStatus:@"Couldn't reach server, try again later." :@"Sorry" :0];
            self.progressBar.hidden = YES;
            [self.spinner stopAnimating];
            self.darkOver.hidden = YES;
        } else {
            
            NSLog(@"%@ %@", response, responseObject);
            int cluster = [responseObject[@"cluster"] intValue];
            int face_id = [responseObject[@"face_id"] intValue];
            int target = [responseObject[@"target"] intValue];
            
            if (cluster == 0){
                [self alertStatus:@"The face detector has trouble with faces that are titled, poorly lit, or take up too much of the screen." :@"Face Not Detected" :0];
                NSLog(@"not detected");
                self.progressBar.hidden = YES;
                [self.spinner stopAnimating];
                self.darkOver.hidden = YES;
            }
            else {
                //[self alertStatus:@"The face detector has detected your face and may now alter it." :@"Face Detected" :0];
                self.progressBar.hidden = YES;
                
                self.faceId = face_id;
                self.cluster = cluster;
                self.targetCluster = target;
                
                [self ageFace];
                
            }
        }
        
    }];
    
    [uploadTask resume];
    
    [progress addObserver:self
               forKeyPath:@"fractionCompleted"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
}

- (void)ageFace {
    
    NSString *requestURL = [NSString stringWithFormat:@"%@ageFace?face_id=%d&cluster=%d&gender=%@&targetAge=%@", serverUrl, self.faceId, self.cluster, self.gender, self.targetAge];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"done with post");
        NSLog(@"JSON: %@", responseObject);
        [self.spinner stopAnimating];
        self.darkOver.hidden = YES;
        //[self performSegueWithIdentifier:@"age_collection" sender:self];
        [self performSegueWithIdentifier:@"showAgedAction" sender:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self alertStatus:@"Couldn't reach server" :@"Failed" :0];
        [self.spinner stopAnimating];
        self.darkOver.hidden = YES;        
    }];
    
    [requestOperation start];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = (NSProgress *)object;
        NSLog(@"Progress… %f", progress.fractionCompleted);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self progressBar] setProgress:progress.fractionCompleted];
        });
    }
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
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


- (IBAction)logoutAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_id"];
    [self performSegueWithIdentifier:@"logout" sender:self];
}
@end
