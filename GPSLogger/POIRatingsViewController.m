#import "POIRatingsViewController.h"
#import "TripCard.h"
#import "TripDetailsViewController.h"
#import "TripDetailsViewControllerDelegate.h"

@interface POIRatingsViewController () <TripCardDelegate, TripDetailsViewControllerDelegate>

@end

@implementation POIRatingsViewController

//@synthesize scrollView = _scrollView;
//@synthesize tripObjects = _tripObjects;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Set up the array of trip objects with sample data
    self.tripObjects = [NSMutableArray arrayWithArray:@[
        @{@"title": @"Trip 1", @"time": @"Departure time: 10:00 AM", @"distance": @"Distance: 20 km", @"duration": @"Duration: 1h 30m", @"isRated": @NO},
        @{@"title": @"Trip 2", @"time": @"Departure time: 11:00 AM", @"distance": @"Distance: 15 km", @"duration": @"Duration: 1h 15m", @"isRated": @NO},
        // Add more trips as needed
    ]];

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
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.tripObjects.count * 160);
    [self.view addSubview:self.scrollView];
}

- (void)createTripCards {
    CGFloat cardHeight = 150.0;

    for (NSInteger i = 0; i < self.tripObjects.count; i++) {
        NSDictionary *tripObject = self.tripObjects[i];

        TripCard *tripCard = [[TripCard alloc] initWithFrame:CGRectMake(10, i * (cardHeight + 10), self.view.frame.size.width - 20, cardHeight)];
        tripCard.titleLabel.text = tripObject[@"title"];
        tripCard.timeLabel.text = tripObject[@"time"];
        tripCard.distanceLabel.text = tripObject[@"distance"];
        tripCard.durationLabel.text = tripObject[@"duration"];

        // Set rating status
        tripCard.isRated = [tripObject[@"isRated"] boolValue];

        // Update UI based on rating status
        [tripCard updateUI];

        tripCard.tripData = tripObject; // Store trip data in the TripCard
        tripCard.delegate = self; // Set the delegate to self

        [self.scrollView addSubview:tripCard];
    }
}

- (void)tripCardDidTapMapButton:(TripCard *)tripCard {
    // Create an instance of TripDetailsViewController
    TripDetailsViewController *tripDetailsViewController = [[TripDetailsViewController alloc] init];

    // Set the properties with the information from the tapped TripCard
    tripDetailsViewController.tripTitle = tripCard.titleLabel.text;
    tripDetailsViewController.departureTime = tripCard.timeLabel.text;
    tripDetailsViewController.distance = tripCard.distanceLabel.text;
    tripDetailsViewController.duration = tripCard.durationLabel.text;

    // Set the modal presentation style to UIModalPresentationOverFullScreen
    tripDetailsViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;

    // Store the selected trip's index
    NSInteger selectedTripIndex = [self.tripObjects indexOfObject:tripCard.tripData];

    // Pass the selected trip index to the TripDetailsViewController
    tripDetailsViewController.selectedTripIndex = selectedTripIndex;

    // Set the delegate for handling dismissal
    tripDetailsViewController.delegate = self;

    // Present the TripDetailsViewController
    [self presentViewController:tripDetailsViewController animated:YES completion:nil];
}

#pragma mark - TripDetailsViewControllerDelegate
- (void)tripDetailsViewController:(TripDetailsViewController *)tripDetailsViewController didFinishRating:(BOOL)finishedRating {
    // Handle the completion of rating
    if (finishedRating) {
        // Remove the corresponding trip from the array or update its rating status
        if (tripDetailsViewController.selectedTripIndex != NSNotFound && tripDetailsViewController.selectedTripIndex < self.tripObjects.count) {
            NSLog(@"Removing trip at index: %ld", (long)tripDetailsViewController.selectedTripIndex);
            [self.tripObjects removeObjectAtIndex:tripDetailsViewController.selectedTripIndex];

            // Reload trip cards after removing the trip
            [self reloadTripCards];
        } else {
            NSLog(@"Invalid selectedTripIndex: %ld", (long)tripDetailsViewController.selectedTripIndex);
        }
    }
}

- (void)reloadTripCards {
    // Remove existing trip cards
    for (UIView *subview in self.scrollView.subviews) {
        [subview removeFromSuperview];
    }

    // Recreate trip cards based on the updated array
    [self createTripCards];
}

@end
