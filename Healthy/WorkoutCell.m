//
//  WorkoutCell.m
//  Healthy
//
//  Created by 한정욱 on 2017. 1. 20..
//  Copyright © 2017년 SMARTLY CO. All rights reserved.
//

#import "WorkoutCell.h"

@interface WorkoutCell()
@property (weak, nonatomic) IBOutlet UILabel *workoutLabel;
@property (weak, nonatomic) PFObject* workoutObject;

@end

@implementation WorkoutCell

- (void)setWorkoutObject:(PFObject *)workoutObject
{
    _workoutObject = workoutObject;
    self.workoutLabel.text = self.workoutObject[@"Workout"];
}
@end
