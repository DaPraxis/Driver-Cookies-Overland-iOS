#import "TripDetailsViewController.h"

@interface TripDetailsViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TripDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Call a method to create the UI for trip details
    [self createUI];
}

- (void)createUI {
    // Title Label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 30)];
    self.titleLabel.text = self.tripTitle;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self.view addSubview:self.titleLabel];
    
    // Back Button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(10, 50, 80, 30);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)backButtonTapped {
    // Handle back button tap event (pop the view controller)
    [self.navigationController popViewControllerAnimated:YES];
}

@end
