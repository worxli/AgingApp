//
//  ImageData.m
//  ActingQuiz
//
//  Created by Lukas Bischofberger on 8/14/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import "ImageData.h"

@implementation ImageData

+ (Class)transformedValueClass
{
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    if (value == nil)
        return nil;
    
    // I pass in raw data when generating the image, save that directly to the database
    if ([value isKindOfClass:[NSData class]])
        return value;
    
    return UIImagePNGRepresentation((UIImage *)value);
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:(NSData *)value];
}

@end
