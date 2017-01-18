//
//  Calendar.m
//  Healthy
//
//  Created by 한정욱 on 2017. 1. 5..
//  Copyright © 2017년 SMARTLY CO. All rights reserved.
//

#import "Calendar.h"

@interface MonthBar : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@end

@implementation MonthBar


@end

@interface DayCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@end

@implementation DayCell


@end

@interface Calendar ()
{
    
}
@property unsigned long monthsPassed;
@property (nonatomic, strong) NSDate* firstRunDay;
@property (nonatomic, weak) NSIndexPath *selectedIndexPath;
@property CGSize smallCellSize;
@end

@implementation Calendar

static NSString * const reuseIdentifier = @"DayCell";


CGFloat widthForNumberOfCells(UICollectionView* cv, UICollectionViewFlowLayout *flowLayout, CGFloat cpr)
{
    CGFloat width = (CGRectGetWidth(cv.bounds) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (cpr - 1))/cpr;
    
    NSLog(@"CELL WIDTH:%f", floor(width));
    return floor(width);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeCollectionViewItemSizes];
    [self initializeFirstRunDay];
    [self initializeMonthsPassed];
    [self.collectionView reloadData];
    [self scrollToBottom];
}

- (void)viewDidAppear:(BOOL)animated
{
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    [self ysl_addTransitionDelegate:self];
    [self ysl_pushTransitionAnimationWithToViewControllerImagePointY:statusHeight + navigationHeight
                                                   animationDuration:0.3];
}

- (void)scrollToBottom {
    NSIndexPath *todayIndex = [self indexPathForToday];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:todayIndex atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    });
}

- (NSIndexPath *) indexPathForToday
{
    NSUInteger monthIndex = self.monthsPassed - 1;
    NSDateComponents *todayComponents = [self dateComponentsForDate:[NSDate date]];
    NSUInteger todayOffset = todayComponents.day;
    
    NSDate *firstDayOfIndexMonth = [self firstDayOfMonthForIndex:monthIndex];
    NSDateComponents *firstDayOfIndexMonthComponents = [self dateComponentsForDate:firstDayOfIndexMonth];
    NSUInteger startOffset = firstDayOfIndexMonthComponents.weekday - 1;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:startOffset + todayOffset - 1 inSection:monthIndex];
    return indexPath;
}

- (void) initializeCollectionViewItemSizes
{
    UICollectionViewFlowLayout *layout = (id) self.collectionView.collectionViewLayout;
    CGFloat w = widthForNumberOfCells(self.collectionView, layout, 7);
    CGFloat h = w;
    NSLog(@"SIZE:%@", NSStringFromCGSize(CGSizeMake(w, h)));
    self.smallCellSize = CGSizeMake(w, h);
    layout.itemSize = self.smallCellSize;
}

- (void) initializeFirstRunDay
{
    self.firstRunDay = [[NSUserDefaults standardUserDefaults] valueForKey:@"FirstRunDate"];
    
    if (self.firstRunDay) {
        NSLog(@"First Run Date: %@", [NSDateFormatter localizedStringFromDate:self.firstRunDay dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle]);
        
        NSDateComponents *fc = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        
        fc.year = 2016;
        fc.month = 3;
        fc.day = 14;
        
        NSDate *fDate = [[NSCalendar currentCalendar] dateFromComponents: fc];
        NSLog(@"fDATE :%@", [fDate descriptionWithLocale:[NSLocale currentLocale]]);
        
        self.firstRunDay = fDate;
    }
    else {
        self.firstRunDay = [NSDate new];
        NSLog(@"First Time Running:%@", [NSDateFormatter localizedStringFromDate:self.firstRunDay dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle]);
        [[NSUserDefaults standardUserDefaults] setValue:self.firstRunDay forKey:@"FirstRunDate"];
    }
}

- (void) initializeMonthsPassed
{
    NSDateComponents *lastDayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate new]];
    
    [lastDayComponents setMonth:[lastDayComponents month]+1];
    [lastDayComponents setDay:0];
    NSDate *lastDayOfCurrentMonth = [[NSCalendar currentCalendar] dateFromComponents:lastDayComponents];
    self.monthsPassed = [[[NSCalendar currentCalendar] components: NSCalendarUnitMonth
                                                              fromDate: self.firstRunDay
                                                                toDate: lastDayOfCurrentMonth
                                                               options: 0] month] + 1;
}

- (NSUInteger) numberOfDaysInTheMonthForDate:(NSDate*)date
{
    NSRange rng = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return rng.length;
}

- (NSDate*) firstDayOfMonthForIndex:(NSUInteger)index
{
    NSDateComponents *currentMonthComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:self.firstRunDay];
    
    currentMonthComponents.month = currentMonthComponents.month + index;
    currentMonthComponents.day = 1;
    
    return [[NSCalendar currentCalendar] dateFromComponents:currentMonthComponents];
}

- (NSDate*) lastDayOfMonthForIndex:(NSUInteger)index
{
    NSDate* firstDayOfMonthForIndex = [self firstDayOfMonthForIndex:index];
    
    NSDateComponents *currentMonthComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:firstDayOfMonthForIndex];
    
    currentMonthComponents.month = currentMonthComponents.month + 1;
    currentMonthComponents.day = 0;
    
    return [[NSCalendar currentCalendar] dateFromComponents:currentMonthComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"AddSession"]) {
        NSDateComponents *todayComponents = [self dateComponentsForDate:[NSDate date]];
    }
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSDateComponents*)dateComponentsForDate:(NSDate*) date
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:date];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSLog(@"Returning months passed:%ld", self.monthsPassed);
    return self.monthsPassed;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)monthIndex
{
    NSDate *firstDayOfIndexMonth = [self firstDayOfMonthForIndex:monthIndex];
    NSDate *lastDayOfIndexMonth = [self lastDayOfMonthForIndex:monthIndex];
    NSUInteger numberOfDaysInIndexMonth = [self numberOfDaysInTheMonthForDate:lastDayOfIndexMonth];
    NSDateComponents *firstDayOfIndexMonthComponents = [self dateComponentsForDate:firstDayOfIndexMonth];
    NSDateComponents *lastDayOfIndexMonthComponents = [self dateComponentsForDate:lastDayOfIndexMonth];
    NSUInteger startOffset = firstDayOfIndexMonthComponents.weekday - 1;
    NSUInteger endOffset = 7-lastDayOfIndexMonthComponents.weekday;
    NSUInteger numberOfCells = startOffset + numberOfDaysInIndexMonth + endOffset;
    return numberOfCells;
//    return 42;
}

- (UICollectionReusableView*) collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.section;
    NSDate *firstDayOfIndexMonth = [self firstDayOfMonthForIndex:index];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MonthBar *bar = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MonthBar" forIndexPath:indexPath];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM, yyyy"];
        bar.monthLabel.text = [dateFormatter stringFromDate:firstDayOfIndexMonth];
        return bar;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.layer.cornerRadius = 4.0;
    cell.layer.masksToBounds = YES;

    NSUInteger monthIndex = indexPath.section;
    
    NSDate *firstDayOfIndexMonth = [self firstDayOfMonthForIndex:monthIndex];
    NSDate *lastDayOfIndexMonth = [self lastDayOfMonthForIndex:monthIndex];
    NSUInteger numberOfDaysInIndexMonth = [self numberOfDaysInTheMonthForDate:lastDayOfIndexMonth];
    NSDateComponents *firstDayOfIndexMonthComponents = [self dateComponentsForDate:firstDayOfIndexMonth];
    NSUInteger startOffset = firstDayOfIndexMonthComponents.weekday - 1;
    NSDate *startDate = [firstDayOfIndexMonth dateByAddingTimeInterval:-60.f*60.f*24.f*startOffset];
    NSDate *currDate = [startDate dateByAddingTimeInterval:60.f*60.f*24.f*indexPath.row];
    NSDateComponents *currDateComponents = [self dateComponentsForDate:currDate];
    NSDateComponents *todayComponents = [self dateComponentsForDate:[NSDate date]];
    
    BOOL inRange = (indexPath.row >= startOffset) && (indexPath.row < startOffset + numberOfDaysInIndexMonth);
    cell.dayLabel.text = [NSString stringWithFormat:@"%ld", currDateComponents.day];
    cell.dayLabel.font = inRange ? [UIFont boldSystemFontOfSize:18] : [UIFont boldSystemFontOfSize:16];
    
    if (currDateComponents.year == todayComponents.year && currDateComponents.month == todayComponents.month && currDateComponents.day== todayComponents.day) {
        cell.dayLabel.backgroundColor = [UIColor colorWithRed:240/255.f green:82/255.f blue:44/255.f alpha:1.0];
        cell.dayLabel.textColor = [UIColor whiteColor];
    }
    else {
        cell.dayLabel.backgroundColor = [UIColor colorWithRed:174/255.f green:205/255.f blue:241/255.f alpha:inRange ? 1.0 : 0.8];
        cell.dayLabel.textColor = inRange ? [UIColor blackColor] : [UIColor darkGrayColor];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.smallCellSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionDetailViewController *vc = [[CollectionDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    return;
}

- (UIImage*)imageCell:(UIView*)label
{
    CGRect frame = label.bounds;
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    [label drawViewHierarchyInRect:frame afterScreenUpdates:NO];
    UIImage *screengrab = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screengrab;
}

#pragma mark -- YSLTransitionAnimatorDataSource

- (UIImageView *)pushTransitionImageView
{
    NSIndexPath *todayIndex = [[self.collectionView indexPathsForSelectedItems] firstObject];
    
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:todayIndex];
    CGRect cellFrameInSuperview = [self.collectionView convertRect:attributes.frame toView:[self.collectionView superview]];
    
    DayCell *cell = (DayCell *)[self.collectionView cellForItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] firstObject]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cellFrameInSuperview];
    [imageView setImage:[self imageCell:cell]];
    return imageView;
}

- (UIImageView *)popTransitionImageView
{
    return nil;
}


- (IBAction)gotoToday:(id)sender {
    [self scrollToBottom];
}

#pragma mark <UICollectionViewDelegate>
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSIndexPath *todayIndex = [self indexPathForToday];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:todayIndex];
    CGRect cellFrameInSuperview = [self.collectionView convertRect:attributes.frame toView:[self.collectionView superview]];
    
    NSLog(@"CELL <%ld,%ld> AT:%@", todayIndex.section, todayIndex.row, NSStringFromCGRect(cellFrameInSuperview));
}
*/

@end
