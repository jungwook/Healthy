//
//  AddWorkout.h
//  Healthy
//
//  Created by 한정욱 on 2017. 1. 23..
//  Copyright © 2017년 SMARTLY CO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddWorkoutDelegate <NSObject>
@required
- (void)addWorkout:(id)workout;
@end

@interface AddWorkout : UIViewController
@property (weak, nonatomic) id <AddWorkoutDelegate> parent;
@end
