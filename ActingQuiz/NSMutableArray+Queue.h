//
//  Queue.h
//  ActingQuiz
//
//  Created by Lukas Bischofberger on 8/15/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Queue)

- (void) enqueue: (id)item;
- (id) dequeue;
- (id) peek;

@end