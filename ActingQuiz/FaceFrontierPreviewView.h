//
//  FaceFrontierPreviewView.h
//  Face Frontier
//
//  Created by Kathleen Tuite on 4/11/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface FaceFrontierPreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end