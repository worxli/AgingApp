//
//  FaceFrontierPreviewView.m
//  Face Frontier
//
//  Created by Kathleen Tuite on 4/11/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import "FaceFrontierPreviewView.h"
#import <AVFoundation/AVFoundation.h>

@implementation FaceFrontierPreviewView

+ (Class)layerClass
{
	return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
	return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session
{
	[(AVCaptureVideoPreviewLayer *)[self layer] setSession:session];
}

@end
