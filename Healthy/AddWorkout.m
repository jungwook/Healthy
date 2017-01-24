//
//  AddWorkout.m
//  Healthy
//
//  Created by 한정욱 on 2017. 1. 23..
//  Copyright © 2017년 SMARTLY CO. All rights reserved.
//

#import "AddWorkout.h"
#import "History.h"

@protocol WorkoutCellDelegate <NSObject>
@required
- (void) addWorkout:(id)workout;
@end

@interface WorkoutCell : UITableViewCell
@property (weak, nonatomic) id <WorkoutCellDelegate> parent;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *workoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *primaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstUnitValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondUnitValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightUnitValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondUnitLabel;
@property (weak, nonatomic) IBOutlet UISlider *firstUnitSlider;
@property (weak, nonatomic) IBOutlet UISlider *secondUnitSlider;
@property (weak, nonatomic) IBOutlet UISlider *weightUnitSlider;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@property (weak, nonatomic) NSDictionary    *workout;
@property (strong, nonatomic) NSDictionary  *units;
@property (strong, nonatomic) NSDictionary  *ranges;
@property (strong, nonatomic) NSNumber      *firstUnitValue;
@property (strong, nonatomic) NSNumber      *secondUnitValue;
@property (strong, nonatomic) NSNumber      *weightValue;
@end

@implementation WorkoutCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.units = @{
                   @"Sets" : @"SETS",
                   @"Reps" : @"REPS",
                   @"Minutes" : @"MINS",
                   @"Resistance" : @"LVL",
                   @"Speed" : @"KM/H",
                   @"Height" : @"M",
                   @"Floors" : @"FLRS",
                   };
    
    self.ranges = @{
                    @"Sets" : [NSValue valueWithRange:NSMakeRange(1, 10)],
                    @"Reps" : [NSValue valueWithRange:NSMakeRange(1, 30)],
                    @"Minutes" : [NSValue valueWithRange:NSMakeRange(1, 60)],
                    @"Resistance" : [NSValue valueWithRange:NSMakeRange(1, 20)],
                    @"Speed" : [NSValue valueWithRange:NSMakeRange(1, 25)],
                    @"Height" : [NSValue valueWithRange:NSMakeRange(1, 20)],
                    @"Floors" : [NSValue valueWithRange:NSMakeRange(1, 50)],
                    @"Weights" : [NSValue valueWithRange:NSMakeRange(1, 300)],
                    @"Cardio" : [NSValue valueWithRange:NSMakeRange(1, 120)],
                    };
}

- (void)setWorkout:(NSDictionary *)workout
{
    _workout = workout;

    id firstUnit = self.workout[@"FirstUnit"];
    id secondUnit = self.workout[@"SecondUnit"];
    id weightUnit = self.workout[@"Type"];
    
    id workoutFirstValue = [self.workout[@"Workout"] stringByAppendingString:@"FirstValueUnit"];
    id workoutSecondValue = [self.workout[@"Workout"] stringByAppendingString:@"SecondValueUnit"];
    id workoutWeightValue = [([self.workout[@"Type"] isEqualToString:@"Weights" ] ? self.workout[@"Workout"] : self.workout[@"Type"]) stringByAppendingString:@"WeightValueUnit"];
    
    self.workoutLabel.text = [self.workout[@"Workout"] uppercaseString];
    self.primaryLabel.text = [self.workout[@"Primary"] uppercaseString];
    self.secondaryLabel.text = [self.workout[@"Secondary"] uppercaseString];
    self.descriptionLabel.text = [self.workout[@"Description"] uppercaseString];
    self.firstLabel.text = [self.workout[@"FirstUnit"] uppercaseString];
    self.secondLabel.text = [self.workout[@"SecondUnit"] uppercaseString];
    self.weightLabel.text = [self.workout[@"Type"] uppercaseString];
    
    self.firstUnitLabel.text = self.units[firstUnit];
    self.secondUnitLabel.text = self.units[secondUnit];

    // Min Max Values
    self.firstUnitSlider.minimumValue = (CGFloat) [self.ranges[firstUnit] rangeValue].location;
    self.firstUnitSlider.maximumValue = (CGFloat) [self.ranges[firstUnit] rangeValue].length;

    self.secondUnitSlider.minimumValue = (CGFloat) [self.ranges[secondUnit] rangeValue].location;
    self.secondUnitSlider.maximumValue = (CGFloat) [self.ranges[secondUnit] rangeValue].length;
    
    self.weightUnitSlider.minimumValue = (CGFloat) [self.ranges[weightUnit] rangeValue].location;
    self.weightUnitSlider.maximumValue = (CGFloat) [self.ranges[weightUnit] rangeValue].length;

    // Values from standards
    self.firstUnitValue = [[NSUserDefaults standardUserDefaults] valueForKey:workoutFirstValue];
    self.secondUnitValue = [[NSUserDefaults standardUserDefaults] valueForKey:workoutSecondValue];
    self.weightValue = [[NSUserDefaults standardUserDefaults] valueForKey:workoutWeightValue];
}

- (void)setFirstUnitValue:(NSNumber *)firstUnitValue
{
    id firstUnit = self.workout[@"FirstUnit"];

    NSUInteger min = [self.ranges[firstUnit] rangeValue].location;
    NSUInteger max = [self.ranges[firstUnit] rangeValue].length;

    _firstUnitValue = firstUnitValue ? firstUnitValue : @((NSUInteger) ((min + max) / 2.0f));
    self.firstUnitSlider.value = self.firstUnitValue.integerValue;
    self.firstUnitValueLabel.text = self.firstUnitValue.stringValue;
}

- (void)setSecondUnitValue:(NSNumber *)secondUnitValue
{
    id secondUnit = self.workout[@"SecondUnit"];
    
    NSUInteger min = [self.ranges[secondUnit] rangeValue].location;
    NSUInteger max = [self.ranges[secondUnit] rangeValue].length;
    
    _secondUnitValue = secondUnitValue ? secondUnitValue : @((NSUInteger) ((min + max) / 2.0f));
    self.secondUnitSlider.value = self.secondUnitValue.integerValue;
    self.secondUnitValueLabel.text = self.secondUnitValue.stringValue;
}

- (void)setWeightValue:(NSNumber *)weightValue
{
    id weightUnit = self.workout[@"Type"];
    
    NSUInteger min = [self.ranges[weightUnit] rangeValue].location;
    NSUInteger max = [self.ranges[weightUnit] rangeValue].length;
    
    _weightValue = weightValue ? weightValue : @((NSUInteger)((min + max) / 2.0f));
    self.weightUnitSlider.value = self.weightValue.integerValue;
    self.weightUnitValueLabel.text = self.weightValue.stringValue;
}

- (IBAction)proceedWithWorkout:(id)sender
{
    if (self.parent && [self.parent respondsToSelector:@selector(addWorkout:)]) {
        id workout = @{
                       @"Workout" : self.workout[@"Workout"],
                       @"FirstUnitValue" : self.firstUnitValue,
                       @"SecondUnitValue" : self.secondUnitValue,
                       @"Date" : [NSDate date],
                       @"FirstUnit" : self.workout[@"FirstUnit"],
                       @"SecondUnit" : self.workout[@"SecondUnit"],
                       @"Type" : self.workout[@"Type"],
                       @"Weight" : self.weightValue,
                       };
        [self.parent addWorkout:workout];
    }
}

- (IBAction)valueChanged:(id)sender
{
    if (sender == self.firstUnitSlider) {
        id key = [self.workout[@"Workout"] stringByAppendingString:@"FirstValueUnit"];
        self.firstUnitValue = @((NSUInteger)self.firstUnitSlider.value);
        [[NSUserDefaults standardUserDefaults] setObject:self.firstUnitValue forKey:key];
    }
    else if (sender == self.secondUnitSlider){
        id key = [self.workout[@"Workout"] stringByAppendingString:@"SecondValueUnit"];
        self.secondUnitValue = @((NSUInteger)self.secondUnitSlider.value);
        [[NSUserDefaults standardUserDefaults] setObject:self.secondUnitValue forKey:key];
    }
    else { // self.weightUnitSlider
        // depending on Type, if Weights then load from standards specific added weight to workout types else load a default cardio weight
        // this is done by selected the appropriate standards load key
        
        id key = [([self.workout[@"Type"] isEqualToString:@"Weights" ] ? self.workout[@"Workout"] : self.workout[@"Type"]) stringByAppendingString:@"WeightValueUnit"];

        float increment = [self.workout[@"Type"] isEqualToString:@"Cardio"] ? 1.0f : 5.0f;
        self.weightValue = @(((NSUInteger)((NSUInteger)(self.weightUnitSlider.value / increment))*increment));
        [[NSUserDefaults standardUserDefaults] setObject:self.weightValue forKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end


#pragma mark AddWorkout

@interface AddWorkout () <UITableViewDelegate, UITableViewDataSource, WorkoutCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *workouts;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) CGFloat descriptionLabelWidth;
@property (strong, nonatomic) UIFont *descriptionLabelFont;
@end

@implementation AddWorkout

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeWorkouts];
    [self initializeTableViewAttributes];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.workouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell" forIndexPath:indexPath];
    cell.workout = [self.workouts objectAtIndex:indexPath.row];
    cell.parent = self;
    
    return cell;
}

CGRect rectForString(NSString *string, UIFont *font, CGFloat maxWidth)
{
    //    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    CGRect rect = CGRectIntegral([string boundingRectWithSize:CGSizeMake(maxWidth, 0)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{
                                                                NSFontAttributeName: font,
                                                                } context:nil]);
    
    rect = CGRectMake(0, 0, floor(rect.size.width), floor(rect.size.height));
    return rect;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == self.selectedIndexPath) {
        id workout = self.workouts[indexPath.row];
        NSString *desc = [workout[@"Description"] uppercaseString];
        CGRect rect = rectForString(desc, self.descriptionLabelFont, self.descriptionLabelWidth);
        NSLog(@"Description Height: %f", rect.size.height);
        return 80+rect.size.height+180;
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = (self.selectedIndexPath == indexPath) ? nil : indexPath;
    
    WorkoutCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.descriptionLabelWidth = CGRectGetWidth(cell.descriptionLabel.frame);
    self.descriptionLabelFont = cell.descriptionLabel.font;
    
    [tableView beginUpdates];
    [tableView endUpdates];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeWorkout:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tappedOutside:(id)sender {
    [self closeWorkout:nil];
}

- (void)addWorkout:(id)workout
{
    if (self.parent && [self.parent respondsToSelector:@selector(addWorkout:)]) {
        [self.parent addWorkout:workout];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) initializeTableViewAttributes
{
//    [self.tableView registerClass:[WorkoutCell class] forCellReuseIdentifier:@"WorkoutCell"];
}

- (void) initializeWorkouts
{
    self.workouts = [History workouts];
}
@end
