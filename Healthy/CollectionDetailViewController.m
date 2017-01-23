//
//  CollectionDetailViewController.m
//  YSLTransitionAnimatorDemo
//
//  Created by yamaguchi on 2015/05/20.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "CollectionDetailViewController.h"
#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"
#import "WorkoutCell.h"

@import Parse;

@interface CollectionDetailViewController () <YSLTransitionAnimatorDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *workouts;
@property (strong, nonatomic) NSArray *history;

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation CollectionDetailViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

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

    __weak CollectionDetailViewController *weakself = self;
    [self ysl_setUpReturnBtnWithColor:[UIColor lightGrayColor]
                      callBackHandler:^{
                          [weakself.navigationController popViewControllerAnimated:YES];
                      }];
    
}

- (void) initializeCollectionView
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"WorkoutCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"WorkoutCell"];
    self.collectionView.backgroundView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundView = nil;
}

- (void) initializeTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HistoryCell"];
}

- (void) initializeHistory
{
    PFQuery *query = [PFQuery queryWithClassName:@"History"];
    
    NSDate *startDate;
    NSDate *endDate;
    
    [query whereKey:@"Date" greaterThanOrEqualTo:startDate];
    [query whereKey:@"Date" lessThanOrEqualTo:endDate];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.history = objects;
        [self.tableView reloadData];
    }];
}

- (void) initializeNavigationBarAndItems
{
    UIBarButtonItem *swivelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(turnCamera)];
    swivelBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = swivelBarButtonItem;
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.tintColor = [UIColor whiteColor];
    }];
}

#define fWORKOUT    @"Workout"
#define fType       @"Type"
#define fUnit       @"Unit"
#define fFirstUnit  @"FirstUnit"
#define fSecondUnit @"SecondUnit"
#define fPrimary    @"Primary"
#define fSecondary  @"Secondary"
#define ASSIGNWORKOUT(__type__) if (workout[__type__]) { workoutObject[__type__] = workout[__type__]; }

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeNavigationBarAndItems];

    [self initCapture];
    [self initializeCollectionView];
    [self initializeWorkouts];
    [self initializeTableView];
    [self initializeHistory];
    
    NSLog(@"TODAY IS:%@", [self.today descriptionWithLocale:[NSLocale currentLocale]]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.history.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    
    return cell;
}

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIView *)popTransitionImageView
{
    return self.iconImageView;
}

- (UIView *)pushTransitionImageView
{
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.workouts.count;
}

- (void)initCapture
{
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];

    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    if (!captureInput) {
        return;
    }
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    /* captureOutput:didOutputSampleBuffer:fromConnection delegate method !*/
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    
    NSString* preset = 0;
    if (!preset) {
        preset = AVCaptureSessionPresetMedium;
    }
    self.captureSession.sessionPreset = preset;
    if ([self.captureSession canAddInput:captureInput]) {
        [self.captureSession addInput:captureInput];
    }
    if ([self.captureSession canAddOutput:captureOutput]) {
        [self.captureSession addOutput:captureOutput];
    }
    
    //handle prevLayer
    if (!self.previewLayer) {
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    
    //if you want to adjust the previewlayer frame, here!
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    [self.captureSession startRunning];
}

- (void) turnCamera
{
    NSLog(@"SWIVEL CAMERA");
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, 120);
}

- (void) initializeWorkouts
{
    PFQuery *q = [PFQuery queryWithClassName:@"Workout"];
    [q findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.workouts = objects;
        if (objects.count) {
            NSLog(@"SUCCESS");
            [self.collectionView reloadData];
        }
        else {
            [self saveData];
        }
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WorkoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WorkoutCell" forIndexPath:indexPath];
    [cell setWorkoutObject:self.workouts[indexPath.row]];
    return cell;
}
- (void) saveData
{
    self.workouts = @[
                      @{ @"Workout" : @"Squat", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Quadriceps, Gluteus, Abdominals", @"Secondary" : @"Calves, Hamstrings, Lower Back", },
                      @{ @"Workout" : @"Leg press", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Quadriceps, Gluteus", @"Secondary" : @"Calves, Hamstrings", },
                      @{ @"Workout" : @"Lunge", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Quadriceps, Hamstrings, Gluteus", },
                      @{ @"Workout" : @"Deadlift", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Quadriceps, Hamstrings, Gluteus, Lower Back", @"Secondary" : @"Lats, Trapezius, Abdominals, Forearms", },
                      @{ @"Workout" : @"Leg extension", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Quadriceps", },
                      @{ @"Workout" : @"Leg curl", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Hamstrings", @"Secondary" : @"Calves", },
                      @{ @"Workout" : @"Standing calf raise", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Calves", },
                      @{ @"Workout" : @"Seated calf raise", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Calves", },
                      @{ @"Workout" : @"Hip adductor", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Gluteus", },
                      @{ @"Workout" : @"Bench press", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Pectorals, Triceps", @"Secondary" : @"Deltoids", },
                      @{ @"Workout" : @"Chest fly", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Pectorals", @"Secondary" : @"Deltoids", },
                      @{ @"Workout" : @"Push-up", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Pectorals, Deltoids, Triceps", @"Secondary" : @"Abdominals", },
                      @{ @"Workout" : @"Pulldown", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Lats", @"Secondary" : @"Deltoids, Biceps, Forearms", },
                      @{ @"Workout" : @"Pull-up", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Lats", @"Secondary" : @"Trapezius, Deltoids, Biceps, Forearms", },
                      @{ @"Workout" : @"Bent-over row", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Lats", @"Secondary" : @"Trapezius, Biceps, Forearms", },
                      @{ @"Workout" : @"Upright row", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Trapezius, Deltoids", @"Secondary" : @"Biceps, Forearms", },
                      @{ @"Workout" : @"Shoulder press", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Deltoids", @"Secondary" : @"Trapezius, Triceps", },
                      @{ @"Workout" : @"Shoulder fly", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Deltoids", @"Secondary" : @"Trapezius, Forearms", },
                      @{ @"Workout" : @"Shoulder shrug", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Trapezius", @"Secondary" : @"Deltoids, Forearms", },
                      @{ @"Workout" : @"Pushdown", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Triceps", },
                      @{ @"Workout" : @"Triceps extension", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Triceps", },
                      @{ @"Workout" : @"Biceps curl", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Biceps", },
                      @{ @"Workout" : @"Crunch", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Abdominals", },
                      @{ @"Workout" : @"Russian twist", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Abdominals", },
                      @{ @"Workout" : @"Leg raise", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Gluteus", @"Secondary" : @"Abdominals", },
                      @{ @"Workout" : @"Back extension", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Gluteus, Lower Back", @"Secondary" : @"Hamstrings", },
                      @{ @"Workout" : @"Stretch", @"Type" : @"Weights", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Calves, Quadriceps, Hamstrings, Gluteus, Lower Back, Lats, Trapezius, Abdominals, Pectorals, Deltoids, Triceps, Biceps, Forearms", },
                      @{ @"Workout" : @"Cross Trainer", @"Type" : @"Cardio", @"Unit" : @"By Time", @"FirstUnit" : @"Minutes", @"SecondUnit" : @"Resistance", @"Primary" : @"Cardio", },
                      @{ @"Workout" : @"Elliptical", @"Type" : @"Cardio", @"Unit" : @"By Time", @"FirstUnit" : @"Minutes", @"SecondUnit" : @"Resistance", @"Primary" : @"Cardio", },
                      @{ @"Workout" : @"Jump Rope", @"Type" : @"Cardio", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Cardio", },
                      @{ @"Workout" : @"Jumping Jacks", @"Type" : @"Cardio", @"Unit" : @"By Sets", @"FirstUnit" : @"No per Set", @"SecondUnit" : @"No of Sets", @"Primary" : @"Cardio", },
                      @{ @"Workout" : @"Recumbent Bike", @"Type" : @"Cardio", @"Unit" : @"By Time", @"FirstUnit" : @"Minutes", @"SecondUnit" : @"Resistance", @"Primary" : @"Cardio", },
                      @{ @"Workout" : @"Wall Climbing", @"Type" : @"Cardio", @"Unit" : @"By Height", @"FirstUnit" : @"Height", @"SecondUnit" : @"No of Times", @"Primary" : @"Cardio", },
                      @{ @"Workout" : @"Rowing", @"Type" : @"Cardio", @"Unit" : @"By Time", @"FirstUnit" : @"Minutes", @"SecondUnit" : @"Speed", @"Primary" : @"Cardio", },
                      @{ @"Workout" : @"Cycling", @"Type" : @"Cardio", @"Unit" : @"By Time", @"FirstUnit" : @"Minutes", @"SecondUnit" : @"Speed", @"Primary" : @"Cardio", },
                      @{ @"Workout" : @"Stair Climbing", @"Type" : @"Cardio", @"Unit" : @"By Floors", @"FirstUnit" : @"Floors", @"SecondUnit" : @"No of Sets", @"Primary" : @"Cardio", },
                      @{ @"Workout" : @"Stair Stepper", @"Type" : @"Cardio", @"Unit" : @"By Time", @"FirstUnit" : @"Minutes", @"SecondUnit" : @"Resistance", @"Primary" : @"Cardio", },
                      @{ @"Workout" : @"Treadmill", @"Type" : @"Cardio", @"Unit" : @"By Time", @"FirstUnit" : @"Minutes", @"SecondUnit" : @"Speed", @"Primary" : @"Cardio", },];
    
    [self.workouts enumerateObjectsUsingBlock:^(id  _Nonnull workout, NSUInteger idx, BOOL * _Nonnull stop) {
        PFObject *workoutObject = [PFObject objectWithClassName:@"Workout"];
        ASSIGNWORKOUT(fWORKOUT)
        ASSIGNWORKOUT(fType)
        ASSIGNWORKOUT(fUnit)
        ASSIGNWORKOUT(fFirstUnit)
        ASSIGNWORKOUT(fSecondUnit)
        ASSIGNWORKOUT(fPrimary)
        ASSIGNWORKOUT(fSecondary)
        
        [workoutObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"WORKOUT:%@", workoutObject);
            }
        }];
    }];
}

@end
