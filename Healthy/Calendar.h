//
//  Calendar.h
//  Healthy
//
//  Created by 한정욱 on 2017. 1. 5..
//  Copyright © 2017년 SMARTLY CO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"
#import "CollectionDetailViewController.h"

@interface Calendar : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YSLTransitionAnimatorDataSource>

@end
