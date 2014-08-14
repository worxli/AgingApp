//
//  User.h
//  ActingQuiz
//
//  Created by Lukas Bischofberger on 8/14/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * user;
@property (nonatomic, retain) NSManagedObject *has;

@end
