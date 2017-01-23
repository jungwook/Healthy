//
//  AddWorkout.m
//  Healthy
//
//  Created by 한정욱 on 2017. 1. 23..
//  Copyright © 2017년 SMARTLY CO. All rights reserved.
//

#import "AddWorkout.h"


@interface WorkoutCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *workoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *primaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstUnitValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondUnitValueLabel;

@property (weak, nonatomic) NSDictionary *workout;
@end

@implementation WorkoutCell

- (void)setWorkout:(NSDictionary *)workout
{
    _workout = workout;
    
    self.workoutLabel.text = [workout[@"Workout"] uppercaseString];
    self.primaryLabel.text = [workout[@"Primary"] uppercaseString];
    self.secondaryLabel.text = [workout[@"Secondary"] uppercaseString];
    self.descriptionLabel.text = [workout[@"Description"] uppercaseString];
    self.firstLabel.text = [workout[@"FirstUnit"] uppercaseString];
    self.secondLabel.text = [workout[@"SecondUnit"] uppercaseString];
}
@end

@interface AddWorkout () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *workouts;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property CGFloat descriptionLabelWidth;
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

- (IBAction)closeWorkout:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
        return 80+rect.size.height+140;
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    
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

- (IBAction)tappedOutside:(id)sender {
    [self closeWorkout:nil];
}

- (void) initializeTableViewAttributes
{
//    [self.tableView registerClass:[WorkoutCell class] forCellReuseIdentifier:@"WorkoutCell"];
}

- (void) initializeWorkouts
{
    self.workouts = @[
  @{ @"Workout" : @"Leg press", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Quadriceps, Gluteus", @"Secondary" : @"Calves, Hamstrings",  @"Description" : @"The leg press is a weight training exercise in which the individual pushes a weight or resistance away from them using their legs. The leg press can be used to evaluate an athlete's overall lower body strength (from knee joint to hip). It has the potential to inflict grave injury: the knees could bend the wrong way if they are locked during a leg press."},
  @{ @"Workout" : @"Lunge", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Quadriceps, Hamstrings, Gluteus",  @"Description" : @"A lunge can refer to any position of the human body where one leg is positioned forward with knee bent and foot flat on the ground while the other leg is positioned behind. It is used by athletes in cross-training for sports, by weight-trainers as a fitness exercise, and by yogis as part of an asana regimen."},
  @{ @"Workout" : @"Deadlift", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Quadriceps, Hamstrings, Gluteus, Lower Back", @"Secondary" : @"Lats, Trapezius, Abdominals, Forearms",  @"Description" : @"The deadlift is a weight training exercise in which a loaded barbell or bar is lifted off the ground to the hips, then lowered back to the ground. It is one of the three powerlifting exercises, along with the squat and bench press."},
  @{ @"Workout" : @"Leg extension", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Quadriceps",  @"Description" : @"The leg extension is a resistance weight training exercise that targets the quadriceps muscle in the legs. The exercise is done using a machine called the Leg Extension Machine. There are various manufacturers of these machines and each one is slightly different. Most gym and weight rooms will have the machine in their facility. The leg extension is an isolated exercise targeting one specific muscle group, the quadriceps. It should not be considered as a total leg workout, such as the squat or deadlift."},
  @{ @"Workout" : @"Leg curl", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Hamstrings", @"Secondary" : @"Calves",  @"Description" : @"The leg curl is an isolation exercise that targets the hamstring muscles. The exercise involves flexing the lower leg against resistance towards the buttocks."},
  @{ @"Workout" : @"Standing calf raise", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Calves",  @"Description" : @"Calf raises are a method of exercising the gastrocnemius, tibialis posterior and soleus muscles of the lower leg. The movement performed is plantar flexion, a.k.a. ankle extension. Calf raises are sometimes done with a flexed knee, usually roughly 90 degrees. This lessens the stretch in the gastrocnemius (a knee flexor), so the movement is done to emphasize the soleus."},
  @{ @"Workout" : @"Seated calf raise", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Calves",  @"Description" : @"Calf raises are a method of exercising the gastrocnemius, tibialis posterior and soleus muscles of the lower leg. The movement performed is plantar flexion, a.k.a. ankle extension. Pushing with the foot with a straighter knee (though for safety it is usually not locked out) stretches the gastrocnemius more, these movements incorporate it better. The soleus still contributes, usually allowing people to lift more weight."},
  @{ @"Workout" : @"Hip adductor", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Gluteus",  @"Description" : @"Abduction and adduction refer to motions that move a structure away from or towards the centre of the body. The centre of the body is defined as the midsagittal plane. These terms come from the Latin words with the same meaning."},
  @{ @"Workout" : @"Bench press", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Pectorals, Triceps", @"Secondary" : @"Deltoids",  @"Description" : @"The bench press is an upper body strength training exercise that consists of pressing a weight upwards from a supine position. The exercise works the pectoralis major as well as supporting chest, arm, and shoulder muscles such as the anterior deltoids, serratus anterior, coracobrachialis, scapulae fixers, trapezii, and the triceps. A barbell is generally used to hold the weight, but a pair of dumbbells can also be used."},
  @{ @"Workout" : @"Chest fly", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Pectorals", @"Secondary" : @"Deltoids",  @"Description" : @"The chest fly or pectoral fly (abbreviated to pec fly) primarily works the pectoralis major muscles to move the arms horizontally forward. If medially (internally) rotated, it is assisted in this by the anterior (front) head of the deltoideus in transverse flexion. If laterally (externally) rotated, the contribution of the deltoid is lessened and the pec major is strongly emphasized as the transverse adductor."},
  @{ @"Workout" : @"Push-up", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Pectorals, Deltoids, Triceps", @"Secondary" : @"Abdominals",  @"Description" : @"A push-up (or press-up) is a common calisthenics exercise performed in a prone position by raising and lowering the body using the arms. Push-ups exercise the pectoral muscles, triceps, and anterior deltoids, with ancillary benefits to the rest of the deltoids, serratus anterior, coracobrachialis and the midsection as a whole. Push-ups are a basic exercise used in civilian athletic training or physical education and commonly in military physical training. They are also a common form of punishment used in the military, school sport, or in some martial arts disciplines."},
  @{ @"Workout" : @"Pulldown", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Lats", @"Secondary" : @"Deltoids, Biceps, Forearms",  @"Description" : @"The pulldown exercise is a strength training exercise designed to develop the latissimus dorsi muscle. It performs the functions of downward rotation and depression of the scapulae combined with adduction and extension of the shoulder joint."},
  @{ @"Workout" : @"Pull-up", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Lats", @"Secondary" : @"Trapezius, Deltoids, Biceps, Forearms",  @"Description" : @"A pull-up is an upper-body compound pulling exercise. Although it can be performed with any grip, in recent years some have used the term to refer more specifically to a pull-up performed with a palms-forward position."},
  @{ @"Workout" : @"Bent-over row", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Lats", @"Secondary" : @"Trapezius, Biceps, Forearms",  @"Description" : @"A bent-over row (or barbell row) is a weight training exercise that targets a variety of back muscles. Which ones are targeted varies on form. The bent over row is often used for both bodybuilding and powerlifting. It is a good exercise for increasing strength and size."},
  @{ @"Workout" : @"Upright row", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Trapezius, Deltoids", @"Secondary" : @"Biceps, Forearms",  @"Description" : @"The upright row is a weight training exercise performed by holding a grips with the overhand grip and lifting it straight up to the collarbone. This is a compound exercise that involves the trapezius, the deltoids and the biceps. The narrower the grip the more the trapezius muscles are exercised, as opposed to the deltoids."},
  @{ @"Workout" : @"Shoulder press", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Deltoids", @"Secondary" : @"Trapezius, Triceps",  @"Description" : @"The press, overhead press or shoulder press is a weight training exercise, typically performed while standing, in which a weight is pressed straight upwards from the shoulders until the arms are locked out overhead."},
  @{ @"Workout" : @"Shoulder fly", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Deltoids", @"Secondary" : @"Trapezius, Forearms",  @"Description" : @"The shoulder fly (also known as a lateral raise) works the deltoid muscle of the shoulder. The movement starts with the arms straight, and the hands holding weights at the sides or in front of the body. Arms are kept straight or slightly bent, and raised through an arc of movement in the coronal plane that terminates when the hands are at approximately shoulder height. Weights are lowered to the starting position, completing one  \"rep \". When using a cable machine the individual stands with the coronal plane in line with the pulley, which is at or near the ground. The exercise can be completed one shoulder at a time (with the other hand used to stabilize the body against the weight moved), or with both hands simultaneously if two parallel pulleys are available."},
  @{ @"Workout" : @"Shoulder shrug", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Trapezius", @"Secondary" : @"Deltoids, Forearms",  @"Description" : @"The shoulder shrug (usually called simply the shrug) is an exercise in weight training used to develop the upper trapezius muscle. The lifter stands erect, hands about shoulder width apart, and raises the shoulders as high as possible, and then lowers them, while not bending the elbows, or moving the body at all. The lifter may not have as large a range of motion as in a normal shrug done for active flexibility. It is usually considered good form if the slope of the shoulders is horizontal in the elevated position."},
  @{ @"Workout" : @"Pushdown", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Triceps",  @"Description" : @"A pushdown is a strength training exercise used for strengthening the triceps muscles in the back of the arm. The exercise is completed by pushing an object downward against resistance. This exercise is an example of the primary function of the triceps, extension of the elbow joint. It is a little-known fact that doing the triceps pushdown also works the biceps muscle as well. This is also vice versa for the bicep curls, which work the triceps."},
  @{ @"Workout" : @"Triceps extension", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Triceps",  @"Description" : @"Lying triceps extensions, also known as skull crushers and French extensions or French presses, are a strength exercise used in many different forms of strength training. Lying triceps extensions are one of the most stimulating exercises to the entire triceps muscle group in the upper arm. It works the triceps from the elbow all the way to the latissimus dorsi. Due to its full use of the Triceps muscle group, the lying triceps extensions are used by many as part of their training regimen."},
  @{ @"Workout" : @"Biceps curl", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Biceps",  @"Description" : @"The term  \"biceps curl \" may refer to any of a number of weight training exercises that target the biceps brachii muscle."},
  @{ @"Workout" : @"Crunch", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Abdominals",  @"Description" : @"The crunch is one of the most common abdominal exercises. It primarily works the rectus abdominis muscle and also works the obliques. A crunch begins with lying face up on the floor with knees bent. The movement begins by curling the shoulders towards the pelvis. The hands can be behind or beside the neck or crossed over the chest. Injury can be caused by pushing against the head or neck with hands."},
  @{ @"Workout" : @"Russian twist", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Abdominals",  @"Description" : @"The Russian Twist is a type of exercise that is used to work the abdominal muscles by performing a twisting motion on the abdomen. The exercise is believed by those who practice it to build explosiveness in the upper torso, which may help in sports such as tennis, swimming, baseball, track & field, hockey, golf, lacrosse, or boxing."},
  @{ @"Workout" : @"Leg raise", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Gluteus", @"Secondary" : @"Abdominals",  @"Description" : @"The leg raise is a strength training exercise which targets the iliopsoas (the interior hip flexors). Because the abdominal muscles are used isometrically to stabilize the body during the motion, leg raises are also often used to strengthen the rectus abdominis muscle and the internal and external oblique muscles."},
  @{ @"Workout" : @"Back extension", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Gluteus, Lower Back", @"Secondary" : @"Hamstrings",  @"Description" : @"A hyperextension or back extension is an exercise that works the lower back as well as the mid and upper back, specifically the erector spinae."},
  @{ @"Workout" : @"Stretch", @"Type" : @"Weights", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Calves, Quadriceps, Hamstrings, Gluteus, Lower Back, Lats, Trapezius, Abdominals, Pectorals, Deltoids, Triceps, Biceps, Forearms",  @"Description" : @"Stretching is a form of physical exercise in which a specific muscle or tendon (or muscle group) is deliberately flexed or stretched in order to improve the muscle's felt elasticity and achieve comfortable muscle tone. The result is a feeling of increased muscle control, flexibility, and range of motion. Stretching is also used therapeutically to alleviate cramps."},
  @{ @"Workout" : @"Cross Trainer", @"Type" : @"Cardio", @"Set" : @"B", @"Unit" : @"By Time", @"FirstUnit" : @"Minutes", @"SecondUnit" : @"Resistance", @"Primary" : @"Cardio",  @"Description" : @"This machine has handles which you can push and pull in order to give your upper body a workout in addition to your lower body workout."},
  @{ @"Workout" : @"Elliptical", @"Type" : @"Cardio", @"Set" : @"B", @"Unit" : @"By Time", @"FirstUnit" : @"Minutes", @"SecondUnit" : @"Resistance", @"Primary" : @"Cardio",  @"Description" : @"This is virtually a non-impact exercise which is similar to running, so is a great way to cross train on your easy days."},
  @{ @"Workout" : @"Jump Rope", @"Type" : @"Cardio", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Cardio",  @"Description" : @"Jumping rope is a hard cardio workout, especially once your coordination with the rope and your legs can keep you jumping continuously."},
  @{ @"Workout" : @"Jumping Jacks", @"Type" : @"Cardio", @"Set" : @"A", @"Unit" : @"By Sets", @"FirstUnit" : @"Reps", @"SecondUnit" : @"Sets", @"Primary" : @"Cardio",  @"Description" : @"Jumping jacks give your heart a workout while strengthening your legs, core, and arms. They also help build bone density from the impact of the jump."},
  @{ @"Workout" : @"Recumbent Bike", @"Type" : @"Cardio", @"Set" : @"B", @"Unit" : @"By Time", @"FirstUnit" : @"Minutes", @"SecondUnit" : @"Resistance", @"Primary" : @"Cardio",  @"Description" : @"This bike supports your upper body with a back pad. Your legs are positioned in front of you instead of underneath you, so it is slightly different than an upright bike or spinning bike."},
  @{ @"Workout" : @"Wall Climbing", @"Type" : @"Cardio", @"Set" : @"C", @"Unit" : @"By Height", @"FirstUnit" : @"Height", @"SecondUnit" : @"Sets", @"Primary" : @"Cardio",  @"Description" : @"A rotating climbing wall can give you practice with climbing and navigating holds when you do not have a full wall available to you."},
  @{ @"Workout" : @"Rowing", @"Type" : @"Cardio", @"Set" : @"D", @"Unit" : @"By Time", @"FirstUnit" : @"Minutes", @"SecondUnit" : @"Speed", @"Primary" : @"Cardio",  @"Description" : @"This machine simulates rowing and works the legs and upper body."},
  @{ @"Workout" : @"Cycling", @"Type" : @"Cardio", @"Set" : @"D", @"Unit" : @"By Time", @"FirstUnit" : @"Minutes", @"SecondUnit" : @"Speed", @"Primary" : @"Cardio",  @"Description" : @"Riding a stationary bike allows you to get a great workout without having to worry about balance, road obstacles, or inclement weather as you may have to work around when cycling outdoors."},
  @{ @"Workout" : @"Stair Climbing", @"Type" : @"Cardio", @"Set" : @"E", @"Unit" : @"By Floors", @"FirstUnit" : @"Floors", @"SecondUnit" : @"Sets", @"Primary" : @"Cardio",  @"Description" : @"A stair climber looks like a mini escalator which rotates so that you have to keep picking up your feet and put them down on the next steps in order to stay on the machine. It is an intense workout for your heart and legs."},
  @{ @"Workout" : @"Stair Stepper", @"Type" : @"Cardio", @"Set" : @"B", @"Unit" : @"By Time", @"FirstUnit" : @"Minutes", @"SecondUnit" : @"Resistance", @"Primary" : @"Cardio",  @"Description" : @"A stair stepper has two small platforms to step on which your feet will remain in contact with throughout your workout. It is a great cardio workout as long as you do not lean on the handrails with your arms."},
  @{ @"Workout" : @"Treadmill", @"Type" : @"Cardio", @"Set" : @"D", @"Unit" : @"By Time", @"FirstUnit" : @"Minutes", @"SecondUnit" : @"Speed", @"Primary" : @"Cardio",  @"Description" : @"Running on a treadmill instead of outside can give you a more even surface, keep you dry on rainy days, and provides more shock absorption than running on a hard surface such as pavement."},
                      ];
}
@end
