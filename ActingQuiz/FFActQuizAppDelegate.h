//
//  FFActQuizAppDelegate.h
//  ActingQuiz
//
//  Created by Kathleen Tuite on 6/4/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFActQuizAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;


@end
