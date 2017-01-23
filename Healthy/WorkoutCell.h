//
//  WorkoutCell.h
//  Healthy
//
//  Created by 한정욱 on 2017. 1. 20..
//  Copyright © 2017년 SMARTLY CO. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

@interface WorkoutCell : UICollectionViewCell

- (void)setWorkoutObject:(PFObject*)workoutObject;
@end
