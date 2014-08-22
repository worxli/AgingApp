//
//  Queue.m
//  ActingQuiz
//
//  Created by Lukas Bischofberger on 8/15/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import "NSMutableArray+Queue.h"

@implementation NSMutableArray (Queue)

- (void) enqueue: (id)item {
    [self addObject:item];
}

- (id) dequeue {
    id item = nil;
    if ([self count] != 0) {
        item = [self objectAtIndex:0];
        [self removeObjectAtIndex:0];
    }
    return item;
}

- (id) peek {
    id item = nil;
    if ([self count] != 0) {
        item = [self objectAtIndex:0];
    }
    return item;
}

@end