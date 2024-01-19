#import "POIRatingsViewController.h"
#import "TripCard.h"

@interface POIRatingsViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation POIRatingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the number of cards to 5
    self.numberOfButtons = 5; // Set as needed
    
    // Call a method to create the header, scroll view, and trip cards
    [self createHeader];
    [self createScrollView];
    [self createTripCards];
}

- (void)createHeader {
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 30)];
    headerLabel.text = @"My Trips";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self.view addSubview:headerLabel];
}

- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100)];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.numberOfButtons * 160); // Assuming each card is 150 points tall with 10 points spacing
    [self.view addSubview:self.scrollView];
}

- (void)createTripCards {
    CGFloat cardHeight = 150.0;
    
    for (NSInteger i = 0; i < self.numberOfButtons; i++) {
        TripCard *tripCard = [[TripCard alloc] initWithFrame:CGRectMake(10, i * (cardHeight + 10), self.view.frame.size.width - 20, cardHeight)];
        tripCard.titleLabel.text = [NSString stringWithFormat:@"Trip %ld", (long)i + 1];
        tripCard.timeLabel.text = @"Departure time: 10:00 AM";
        tripCard.distanceLabel.text = @"Distance: 20 km";
        tripCard.durationLabel.text = @"Duration: 1h 30m";
        
        [self.scrollView addSubview:tripCard];
    }
}

@end
