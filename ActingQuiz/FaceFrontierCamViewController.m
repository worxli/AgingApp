//
//  FaceFrontierCamViewController.m
//  Face Frontier
//
//  Created by Kathleen Tuite on 4/11/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import "FaceFrontierCamViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


#import "FaceFrontierPreviewView.h"

#import "AFNetworking.h"

static void * CapturingStillImageContext = &CapturingStillImageContext;
static void * RecordingContext = &RecordingContext;
static void * SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

@interface FaceFrontierCamViewController () <AVCaptureFileOutputRecordingDelegate>

// For use in the storyboards.
@property (nonatomic, weak) IBOutlet FaceFrontierPreviewView *previewView;
@property (nonatomic, weak) IBOutlet UIButton *stillButton;
@property (weak, nonatomic) IBOutlet UIButton *expressionButton;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgress;

- (IBAction)snapStillImage:(id)sender;
- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer;

// Session management.
@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;

// Utilities.
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic) BOOL lockInterfaceRotation;
@property (nonatomic) id runtimeErrorHandlingObserver;

// Data.
@property (weak, nonatomic) IBOutlet UIImageView *photoPreview;
@property NSString *serverUrl;
@property int user_id;
@property int current_face_id;
@property NSString *current_face_url;
@property int user_face_id;

@property (weak, nonatomic) IBOutlet UIImageView *promptFace;
@property (weak, nonatomic) IBOutlet UIImageView *userBestFace;
@property (weak, nonatomic) IBOutlet UILabel *userBestFaceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userLatestFace;
@property (weak, nonatomic) IBOutlet UILabel *userLatestFaceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *globalBestFace;
@property (weak, nonatomic) IBOutlet UILabel *globalBestFaceLabel;

@property float userBestFaceScore;
@property float userLatestFaceScore;
@property float globalBestFaceScore;


@end

@implementation FaceFrontierCamViewController

- (BOOL)isSessionRunningAndDeviceAuthorized
{
	return [[self session] isRunning] && [self isDeviceAuthorized];
}

+ (NSSet *)keyPathsForValuesAffectingSessionRunningAndDeviceAuthorized
{
	return [NSSet setWithObjects:@"session.running", @"deviceAuthorized", nil];
}

- (void)loadInitialData {
    self.serverUrl = @"http://katfaces.facefrontier.com:8080/";
    //self.serverUrl = @"http://localhost:8080/";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.user_id = (int)[defaults integerForKey:@"user_id"];
    self.userBestFaceScore = FLT_MAX;
    self.globalBestFaceScore = FLT_MAX;
    
    [self loadFaceToImitate];
}
- (IBAction)changeFace:(id)sender {
    [self loadFaceToImitate];
}

- (void)loadFaceToImitate {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@iphone/acting/random_face", self.serverUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.current_face_id = [responseObject[@"face_id"] intValue];
        self.current_face_url = responseObject[@"face_url"];
        
        [self loadFaceStats];
        [self updatePromptFace];
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)loadFaceStats {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@iphone/acting/face_stats?user_id=%d&face_id=%d", self.serverUrl, self.user_id, self.current_face_id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);

        
        if ([responseObject[@"user_best_score"] floatValue] != 0){
            NSLog(@"Some user best score to show...");
            self.userBestFaceScore = [responseObject[@"user_best_score"] floatValue];
            self.userBestFaceLabel.text = [NSString stringWithFormat:@"%f", self.userBestFaceScore];
            int userBestFaceId = [responseObject[@"user_best_face_id"] intValue];
            NSString *userBestFaceUrl = [NSString stringWithFormat:@"http://katfaces.facefrontier.com:8080/image/%d_cropped", userBestFaceId];
            [self downloadFaceImageInBackground:userBestFaceUrl :self.userBestFace];
        }
        else {
            self.userBestFace.image = nil;
            self.userBestFaceLabel.text = @"";
        }
        
        if ([responseObject[@"global_best_score"] floatValue] != 0){
            self.globalBestFaceScore = [responseObject[@"global_best_score"] floatValue];
            self.globalBestFaceLabel.text = [NSString stringWithFormat:@"%f", self.globalBestFaceScore];
            int globalBestFaceId = [responseObject[@"global_best_face_id"] intValue];
            NSString *globalBestFaceUrl = [NSString stringWithFormat:@"http://katfaces.facefrontier.com:8080/image/%d_cropped", globalBestFaceId];
            [self downloadFaceImageInBackground:globalBestFaceUrl :self.globalBestFace];
        }
        else {
            self.globalBestFace.image = nil;
            self.globalBestFaceLabel.text = @"";
        }
        
        self.userLatestFace.image = nil;
        self.userLatestFaceLabel.text = @"";
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)judgeActing{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"user_id": [NSNumber numberWithInt:self.user_id], @"face1": [NSNumber numberWithInt:self.user_face_id], @"face2": [NSNumber numberWithInt:self.current_face_id]};
    
    
    [manager POST:[NSString stringWithFormat:@"%@iphone/acting/compare_faces_game", self.serverUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"done with post");
        NSLog(@"JSON: %@", responseObject);
        
        //NSString *servermsg = responseObject[@"message"];
        self.userLatestFaceScore = [responseObject[@"lbp_score"] floatValue];
        
        NSString *userImageUrl = [NSString stringWithFormat:@"http://katfaces.facefrontier.com:8080/image/%d_cropped", self.user_face_id];
        [self downloadFaceImageInBackground:userImageUrl :self.userLatestFace];
        
        self.userLatestFaceLabel.text = [NSString stringWithFormat:@"%f", self.userLatestFaceScore];
        
        if (self.userLatestFaceScore < self.userBestFaceScore){
            NSLog(@"got a better score");
            self.userBestFaceScore = self.userLatestFaceScore;
            self.userBestFaceLabel.text = [NSString stringWithFormat:@"%f", self.userBestFaceScore];
            
            [self downloadFaceImageInBackground:userImageUrl :self.userBestFace];
            
            if (self.userLatestFaceScore < self.globalBestFaceScore){
                NSString *msg = @"You got the BEST score for this expression!";
                [self alertStatus:msg :@"Fantastic!" :0];
                self.globalBestFaceScore = self.userLatestFaceScore;
                self.globalBestFaceLabel.text = [NSString stringWithFormat:@"%f", self.userBestFaceScore];
                
                [self downloadFaceImageInBackground:userImageUrl :self.globalBestFace];
            }
            else {
                NSString *msg = @"You beat your best score for this expression!";
                [self alertStatus:msg :@"Excellent!" :0];
            }
        }


        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self alertStatus:@"Couldn't reach server" :@"Quiz Failed" :0];
    }];
}

- (void)updatePromptFace {
    NSLog(@"updaing prompt face");
    [self downloadFaceImageInBackground:self.current_face_url :self.promptFace];
}

- (void)downloadFaceImageInBackground:(NSString *)imageUrl :(UIImageView*) imageBox{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        imageBox.image = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
    
}

- (void)viewDidLoad
{
	[super viewDidLoad];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.user_id = (int)[defaults integerForKey:@"user_id"];
    
    
    [self loadInitialData];
    
    
    //[self updateExpressionButtonWithRandomExpression];
    self.uploadProgress.progress = 0;
    self.uploadProgress.hidden = YES;
	
	// Create the AVCaptureSession
	AVCaptureSession *session = [[AVCaptureSession alloc] init];
	[self setSession:session];
	
	// Setup the preview view
	[[self previewView] setSession:session];
	
	// Check for device authorization
	[self checkDeviceAuthorizationStatus];
	
	// In general it is not safe to mutate an AVCaptureSession or any of its inputs, outputs, or connections from multiple threads at the same time.
	// Why not do all of this on the main queue?
	// -[AVCaptureSession startRunning] is a blocking call which can take a long time. We dispatch session setup to the sessionQueue so that the main queue isn't blocked (which keeps the UI responsive).
	
	dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
	[self setSessionQueue:sessionQueue];
	
	dispatch_async(sessionQueue, ^{
		[self setBackgroundRecordingID:UIBackgroundTaskInvalid];
		
		NSError *error = nil;
		
		AVCaptureDevice *videoDevice = [FaceFrontierCamViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionFront];
		AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
		
		if (error)
		{
			NSLog(@"%@", error);
		}
		
		if ([session canAddInput:videoDeviceInput])
		{
			[session addInput:videoDeviceInput];
			[self setVideoDeviceInput:videoDeviceInput];
            
			dispatch_async(dispatch_get_main_queue(), ^{
				// Why are we dispatching this to the main queue?
				// Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView can only be manipulated on main thread.
				// Note: As an exception to the above rule, it is not necessary to serialize video orientation changes on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
                
				[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)[self interfaceOrientation]];
			});
		}
	
	
		
		AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
		if ([session canAddOutput:movieFileOutput])
		{
			[session addOutput:movieFileOutput];
			AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
			if ([connection isVideoStabilizationSupported])
				[connection setEnablesVideoStabilizationWhenAvailable:YES];
			[self setMovieFileOutput:movieFileOutput];
		}
		
		AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
		if ([session canAddOutput:stillImageOutput])
		{
			[stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
			[session addOutput:stillImageOutput];
			[self setStillImageOutput:stillImageOutput];
		}
	});
}

- (void)viewWillAppear:(BOOL)animated
{
	dispatch_async([self sessionQueue], ^{
		[self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:SessionRunningAndDeviceAuthorizedContext];
		[self addObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:CapturingStillImageContext];
		[self addObserver:self forKeyPath:@"movieFileOutput.recording" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:RecordingContext];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
		
		__weak FaceFrontierCamViewController *weakSelf = self;
		[self setRuntimeErrorHandlingObserver:[[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionRuntimeErrorNotification object:[self session] queue:nil usingBlock:^(NSNotification *note) {
			FaceFrontierCamViewController *strongSelf = weakSelf;
			dispatch_async([strongSelf sessionQueue], ^{
				// Manually restarting the session since it must have been stopped due to an error.
				[[strongSelf session] startRunning];
			});
		}]];
		[[self session] startRunning];
	});
}

- (void)viewDidDisappear:(BOOL)animated
{
	dispatch_async([self sessionQueue], ^{
		[[self session] stopRunning];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
		[[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
		
		[self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
		[self removeObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" context:CapturingStillImageContext];
		[self removeObserver:self forKeyPath:@"movieFileOutput.recording" context:RecordingContext];
	});
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (BOOL)shouldAutorotate
{
	// Disable autorotation of the interface when recording is in progress.
	return ![self lockInterfaceRotation];
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)toInterfaceOrientation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = (NSProgress *)object;
        NSLog(@"Progress… %f", progress.fractionCompleted);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self uploadProgress] setProgress:progress.fractionCompleted];
        });
    }
	else if (context == CapturingStillImageContext)
	{
		BOOL isCapturingStillImage = [change[NSKeyValueChangeNewKey] boolValue];
		
		if (isCapturingStillImage)
		{
			[self runStillImageCaptureAnimation];
		}
	}
    /*
	else if (context == RecordingContext)
	{
		BOOL isRecording = [change[NSKeyValueChangeNewKey] boolValue];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			if (isRecording)
			{
				[[self cameraButton] setEnabled:NO];
				[[self recordButton] setTitle:NSLocalizedString(@"Stop", @"Recording button stop title") forState:UIControlStateNormal];
				[[self recordButton] setEnabled:YES];
			}
			else
			{
				[[self cameraButton] setEnabled:YES];
				[[self recordButton] setTitle:NSLocalizedString(@"Record", @"Recording button record title") forState:UIControlStateNormal];
				[[self recordButton] setEnabled:YES];
			}
		});
	}*/
	else if (context == SessionRunningAndDeviceAuthorizedContext)
	{
		BOOL isRunning = [change[NSKeyValueChangeNewKey] boolValue];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			if (isRunning)
			{
				[[self stillButton] setEnabled:YES];
			}
			else
			{
				[[self stillButton] setEnabled:NO];
			}
		});
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark Actions

- (IBAction)changeExpression:(id)sender {
    [self loadFaceToImitate];
}


- (IBAction)snapStillImage:(id)sender
{
	dispatch_async([self sessionQueue], ^{
		// Update the orientation on the still image output video connection before capturing.
		[[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] videoOrientation]];
		
        
		// Capture a still image.
		[[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
			
			if (imageDataSampleBuffer)
			{
				NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
				UIImage *image = [[UIImage alloc] initWithData:imageData];
				//[[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
                
                
                UIImage *flippedImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationLeftMirrored];
                
                // TODO: DONT FORGET THIS PARTT
                flippedImage = [self scaleAndRotateImage:flippedImage];
                
                [[self photoPreview] setImage:flippedImage];
                [[self photoPreview] setHidden:NO];
                
                //TODO maybe this hiding of things and disabling of buttons should be its own thing...
                // like those otehr event things
                
                [self uploadImage:flippedImage];
                
                
			}
		}];
	});
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    
    int kMaxResolution = 720; // Or whatever
    
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
    NSLog(@"the exif orientation is... %d", orient);
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


- (void)uploadImage:(UIImage*)image
{
    self.uploadProgress.hidden = NO;
    self.stillButton.enabled = NO;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 90);
    
    NSDictionary *parameters = @{@"source": @"iphone_acting", @"source_version": @"1", @"user_id": [NSNumber numberWithInt:self.user_id]};

    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@iphone/add", self.serverUrl] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"file_data" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            
            NSLog(@"%@ %@", response, responseObject);
            int detected = [responseObject[@"detected"] intValue];
            if (detected == 0){
                [self alertStatus:@"The face detector has trouble with faces that are titled, poorly lit, or take up too much of the screen." :@"Face Not Detected" :0];
                NSLog(@"not detected");
            }
            else {
                self.user_face_id = [responseObject[@"face_id"] intValue];
                [self judgeActing];
            }
        }
        self.uploadProgress.hidden = YES;
        self.photoPreview.hidden = YES;
        self.stillButton.enabled = YES;
        
        
        
    }];
    
    [uploadTask resume];
    
    [progress addObserver:self
               forKeyPath:@"fractionCompleted"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
}


- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer
{
	CGPoint devicePoint = [(AVCaptureVideoPreviewLayer *)[[self previewView] layer] captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:[gestureRecognizer view]]];
	[self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)subjectAreaDidChange:(NSNotification *)notification
{
	CGPoint devicePoint = CGPointMake(.5, .5);
	[self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

#pragma mark File Output Delegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
	if (error)
		NSLog(@"%@", error);
	
	[self setLockInterfaceRotation:NO];
	
	// Note the backgroundRecordingID for use in the ALAssetsLibrary completion handler to end the background task associated with this recording. This allows a new recording to be started, associated with a new UIBackgroundTaskIdentifier, once the movie file output's -isRecording is back to NO — which happens sometime after this method returns.
	UIBackgroundTaskIdentifier backgroundRecordingID = [self backgroundRecordingID];
	[self setBackgroundRecordingID:UIBackgroundTaskInvalid];
	
	[[[ALAssetsLibrary alloc] init] writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
		if (error)
			NSLog(@"%@", error);
		
		[[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
		
		if (backgroundRecordingID != UIBackgroundTaskInvalid)
			[[UIApplication sharedApplication] endBackgroundTask:backgroundRecordingID];
	}];
}

#pragma mark Device Configuration

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
	dispatch_async([self sessionQueue], ^{
		AVCaptureDevice *device = [[self videoDeviceInput] device];
		NSError *error = nil;
		if ([device lockForConfiguration:&error])
		{
			if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
			{
				[device setFocusMode:focusMode];
				[device setFocusPointOfInterest:point];
			}
			if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
			{
				[device setExposureMode:exposureMode];
				[device setExposurePointOfInterest:point];
			}
			[device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
			[device unlockForConfiguration];
		}
		else
		{
			NSLog(@"%@", error);
		}
	});
}

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
	if ([device hasFlash] && [device isFlashModeSupported:flashMode])
	{
		NSError *error = nil;
		if ([device lockForConfiguration:&error])
		{
			[device setFlashMode:flashMode];
			[device unlockForConfiguration];
		}
		else
		{
			NSLog(@"%@", error);
		}
	}
}

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
	AVCaptureDevice *captureDevice = [devices firstObject];
	
	for (AVCaptureDevice *device in devices)
	{
		if ([device position] == position)
		{
			captureDevice = device;
			break;
		}
	}
	
	return captureDevice;
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

#pragma mark UI

- (void)runStillImageCaptureAnimation
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[[[self previewView] layer] setOpacity:0.0];
		[UIView animateWithDuration:.25 animations:^{
			[[[self previewView] layer] setOpacity:1.0];
		}];
	});
}

- (void)checkDeviceAuthorizationStatus
{
	NSString *mediaType = AVMediaTypeVideo;
	
	[AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
		if (granted)
		{
			//Granted access to mediaType
			[self setDeviceAuthorized:YES];
		}
		else
		{
			//Not granted access to mediaType
			dispatch_async(dispatch_get_main_queue(), ^{
				[[[UIAlertView alloc] initWithTitle:@"AVCam!"
											message:@"AVCam doesn't have permission to use Camera, please change privacy settings"
										   delegate:self
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil] show];
				[self setDeviceAuthorized:NO];
			});
		}
	}];
}


@end

