//
//  Today.h
//  Healthy
//
//  Created by 한정욱 on 2017. 1. 23..
//  Copyright © 2017년 SMARTLY CO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"

@interface Today : UIViewController <YSLTransitionAnimatorDataSource>
@property (nonatomic, strong) NSDate* today;
@end
