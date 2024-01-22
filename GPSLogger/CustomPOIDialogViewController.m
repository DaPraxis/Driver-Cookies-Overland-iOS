// CustomPOIDialogViewController.m

#import "CustomPOIDialogViewController.h"

@interface CustomPOIDialogViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *checkBox;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UIStepper *ratingStepper;
@property (nonatomic, strong) UITextField *checkboxStatusTextField;
@property (nonatomic, strong) UITextField *ratingValueTextField;

@end

@implementation CustomPOIDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set up your UI components and layout based on poiData
    [self createUI];
}

- (void)createUI {
    // Customize this method to create your UI components
    // For example:
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 10.0;
    self.view.clipsToBounds = YES;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 10, 30)];
    self.titleLabel.text = [NSString stringWithFormat:@"📍 %@", self.poiData[@"name"]];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.titleLabel sizeToFit];
    [self.view addSubview:self.titleLabel];

    UILabel *seenLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, self.view.frame.size.width - 10, 30)];
    seenLabel.text = @"🚙 Have you seen this place in your drive?";
    seenLabel.numberOfLines = 0;
    seenLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [seenLabel sizeToFit];
    [self.view addSubview:seenLabel];

    // UITextField for checkbox status
    self.checkboxStatusTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 120, 50, 30)];
    self.checkboxStatusTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.checkboxStatusTextField.textAlignment = NSTextAlignmentCenter;
    self.checkboxStatusTextField.enabled = NO; // Make it read-only
    self.checkboxStatusTextField.text = @"No"; // Default value
    [self.view addSubview:self.checkboxStatusTextField];

    self.checkBox = [[UISwitch alloc] initWithFrame:CGRectMake(80, 120, 50, 30)];
    [self.checkBox addTarget:self action:@selector(checkboxValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.checkBox];

    // UITextField for rating value
    self.ratingValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 220, 50, 30)];
    self.ratingValueTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.ratingValueTextField.textAlignment = NSTextAlignmentCenter;
    self.ratingValueTextField.enabled = NO; // Make it read-only
    self.ratingValueTextField.text = @"3"; // Default value
    [self.view addSubview:self.ratingValueTextField];

    self.ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, self.view.frame.size.width - 10, 30)];
    self.ratingLabel.text = @"⭐️ Rate your interest in this location (1-5)";
    self.ratingLabel.numberOfLines = 0;
    self.ratingLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.ratingLabel sizeToFit];
    [self.view addSubview:self.ratingLabel];

    self.ratingStepper = [[UIStepper alloc] initWithFrame:CGRectMake(80, 220, 50, 30)];
    self.ratingStepper.minimumValue = 1;
    self.ratingStepper.maximumValue = 5;
    self.ratingStepper.stepValue = 1;
    self.ratingStepper.value = 3; // Set the initial value to 3
    [self.ratingStepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.ratingStepper];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(20, 270, 100, 30);
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
}

- (void)checkboxValueChanged:(UISwitch *)checkBox {
    // Update the checkbox status text field based on the checkbox state
    self.checkboxStatusTextField.text = checkBox.isOn ? @"Yes" : @"No";
}

- (void)stepperValueChanged:(UIStepper *)stepper {
    // Update the rating value text field based on the stepper value
    self.ratingValueTextField.text = [NSString stringWithFormat:@"%d", (int)stepper.value];
}


- (void)closeButtonTapped {
    // Handle close button action
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
