#import "TripDetailsViewController.h"

@interface TripDetailsViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *departureTimeLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *durationLabel;

@end

@implementation TripDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Call a method to create the UI for trip details
    [self createUI];
}

@synthesize selectedTripIndex; // Add this line

- (void)createUI {
    // Set the view's background color to white
    self.view.backgroundColor = [UIColor whiteColor];

    // Title Label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 30)];
    self.titleLabel.text = self.tripTitle;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self.view addSubview:self.titleLabel];

    // Departure Time Label
    self.departureTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, self.view.frame.size.width - 20, 20)];
    self.departureTimeLabel.text = self.departureTime;
    [self.view addSubview:self.departureTimeLabel];

    // Distance Label
    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, self.view.frame.size.width - 20, 20)];
    self.distanceLabel.text = self.distance;
    [self.view addSubview:self.distanceLabel];

    // Duration Label
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, self.view.frame.size.width - 20, 20)];
    self.durationLabel.text = self.duration;
    [self.view addSubview:self.durationLabel];

    // Back Button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(10, 50, 80, 30);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)backButtonTapped {
    // Handle back button tap event (dismiss the view controller)
    [self showRatingDialog];
}

- (void)showRatingDialog {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Finish Rating"
                                                                             message:@"Have you finished rating this trip?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self handleFinishRating:YES];
    }];

    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Handle the case where the user selects "No"
        // You can add additional logic here if needed
    }];

    [alertController addAction:yesAction];
    [alertController addAction:noAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)handleFinishRating:(BOOL)finishedRating {
    // Call the delegate method to inform POIRatingsViewController about the finish rating action
    [self.delegate tripDetailsViewController:self didFinishRating:finishedRating];
}

@end
