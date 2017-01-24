//
//  History.h
//  Healthy
//
//  Created by 한정욱 on 2017. 1. 24..
//  Copyright © 2017년 SMARTLY CO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject
+ (NSArray*) workouts;
+ (void) addWorkoutToHistory:(id)workout;
@end
