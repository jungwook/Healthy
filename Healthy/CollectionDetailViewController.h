//
//  CollectionDetailViewController.h
//  YSLTransitionAnimatorDemo
//
//  Created by yamaguchi on 2015/05/20.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVKit;
@import AVFoundation;


@interface CollectionDetailViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AVCaptureVideoDataOutputSampleBufferDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSDate* today;
@end
