#import "TripCard.h"
#import "TripDetailsViewController.h"

@implementation TripCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Customize the appearance of the card
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10.0;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowRadius = 4.0;
        self.layer.shadowOpacity = 0.2;

        // Create and add subviews (labels and map button)
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    // Title Label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 20)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self addSubview:self.titleLabel];

    // Time Label
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, self.frame.size.width - 20, 15)];
    self.timeLabel.textColor = [UIColor grayColor];
    [self addSubview:self.timeLabel];

    // Distance Label
    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, self.frame.size.width - 20, 15)];
    self.distanceLabel.textColor = [UIColor grayColor];
    [self addSubview:self.distanceLabel];

    // Duration Label
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, self.frame.size.width - 20, 15)];
    self.durationLabel.textColor = [UIColor grayColor];
    [self addSubview:self.durationLabel];

    // Map Button (placeholder)
    self.mapButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.mapButton.frame = CGRectMake(10, 110, self.frame.size.width - 20, 30);
    [self.mapButton setTitle:@"View Map" forState:UIControlStateNormal];
    [self.mapButton addTarget:self action:@selector(mapButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.mapButton];
}

- (void)mapButtonTapped {
    // Create an instance of TripDetailsViewController
    TripDetailsViewController *tripDetailsViewController = [[TripDetailsViewController alloc] init];
    tripDetailsViewController.tripTitle = self.titleLabel.text;

    // Push the TripDetailsViewController onto the navigation stack
    UINavigationController *navigationController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [navigationController pushViewController:tripDetailsViewController animated:YES];
}

@end
