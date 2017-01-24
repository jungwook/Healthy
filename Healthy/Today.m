//
//  Today.m
//  Healthy
//
//  Created by 한정욱 on 2017. 1. 23..
//  Copyright © 2017년 SMARTLY CO. All rights reserved.
//

#import "Today.h"
#import "History.h"

@interface Today ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@end

@implementation Today

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeViewComponents];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeViewComponents
{
    // Month String
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:self.today];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setCalendar:[NSCalendar currentCalendar]];
    [df setLocale:[NSLocale currentLocale]];
    
    NSString *monthString = [[df monthSymbols] objectAtIndex:dateComponents.month-1];
    
    self.monthLabel.text = [[monthString uppercaseString] substringToIndex:3];
    
    // Navigation Bar Button Items
    
//    NSShadow *shadow = [NSShadow new];
//    shadow.shadowColor = [UIColor blackColor];
//    shadow.shadowOffset = CGSizeMake(0, -1);
//    
//    [[UINavigationBar appearance] setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
//      shadow, NSShadowAttributeName,
//      [UIFont fontWithName:@"Arial-Bold" size:8.0], NSFontAttributeName,
//      nil]];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWorkout)];
    [rightItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void) addWorkout
{
    AddWorkout *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddWorkout"];
    
    [self presentViewController:vc animated:YES completion:^{
        vc.parent = self;
    }];
}

#pragma mark AddWorkoutDelegate

- (void)addWorkout:(id)workout
{
    NSLog(@"ADDING WORKOUT:%@", workout);
    [History addWorkoutToHistory:workout];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- YSLTransitionAnimatorDataSource

- (void)viewWillDisappear:(BOOL)animated
{
    [self ysl_removeTransitionDelegate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self ysl_addTransitionDelegate:self];
    [self ysl_popTransitionAnimationWithCurrentScrollView:nil
                                    cancelAnimationPointY:0
                                        animationDuration:0.3
                                  isInteractiveTransition:YES];
    
    __weak Today *weakself = self;
    [self ysl_setUpReturnBtnWithColor:[UIColor lightGrayColor]
                      callBackHandler:^{
                          [weakself.navigationController popViewControllerAnimated:YES];
                      }];
    
}

- (UIView *)popTransitionImageView
{
    return self.iconImageView;
}

- (UIView *)pushTransitionImageView
{
    return nil;
}

@end
