//
//  PictureSet.h
//  ActingQuiz
//
//  Created by Lukas Bischofberger on 8/14/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface PictureSet : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSData * aged;
@property (nonatomic, retain) NSNumber * cluster;
@property (nonatomic, retain) NSNumber * imageid;
@property (nonatomic, retain) NSNumber * set;
@property (nonatomic, retain) User *belongsto;

@end
