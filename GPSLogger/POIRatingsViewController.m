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
        @{
            @"title": @"Trip 1",
            @"time": @"Departure time: 10:00 AM",
            @"distance": @"Distance: 20 km",
            @"duration": @"Duration: 1h 30m",
            @"isRated": @NO,
//            @"route": @[
//                @{@"latitude": @43.6680405, @"longitude": @-79.4035016}, // Sample coordinates for the route
//                @{@"latitude": @43.667827, @"longitude": @-79.403296}, // Add more coordinates as needed
//                @{@"latitude": @43.6676598, @"longitude": @-79.404575},
//                // ...
//            ]
            @"route": @[
                            @{@"latitude": @37.7749, @"longitude": @-122.4194},
                            @{@"latitude": @37.7753, @"longitude": @-122.4196},
                            // ...
                        ]
        },
        @{
            @"title": @"Trip 2",
            @"time": @"Departure time: 11:00 AM",
            @"distance": @"Distance: 15 km",
            @"duration": @"Duration: 1h 15m",
            @"isRated": @NO,
            @"route": @[
                @{@"latitude": @43.6488233, @"longitude": @-79.4204366},
                @{@"latitude": @43.6471951999999, @"longitude": @-79.4201452},
                @{@"latitude": @43.6483274, @"longitude": @-79.4201452},
                // ...
            ]
        },
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

        // Use a local variable for the loop counter
        NSInteger localIndex = i;

        TripCard *tripCard = [[TripCard alloc] initWithFrame:CGRectMake(10, localIndex * (cardHeight + 10), self.view.frame.size.width - 20, cardHeight) tripData:tripObject];
        
        tripCard.tripData = tripObject; // Store trip data in the TripCard
        
        tripCard.titleLabel.text = tripObject[@"title"];
        tripCard.timeLabel.text = tripObject[@"time"];
        tripCard.distanceLabel.text = tripObject[@"distance"];
        tripCard.durationLabel.text = tripObject[@"duration"];

        // Set rating status
        tripCard.isRated = [tripObject[@"isRated"] boolValue];

        // Update UI based on rating status
        [tripCard updateUI];

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
    tripDetailsViewController.tripData = tripCard.tripData;
    NSLog(@"Segue Trip Route: %@", tripCard.tripData);

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
        // Update the rating status for the corresponding trip
        if (tripDetailsViewController.selectedTripIndex != NSNotFound && tripDetailsViewController.selectedTripIndex < self.tripObjects.count) {
            NSLog(@"Updating rating status for trip at index: %ld", (long)tripDetailsViewController.selectedTripIndex);

            NSMutableDictionary *tripObject = [self.tripObjects[tripDetailsViewController.selectedTripIndex] mutableCopy];
            tripObject[@"isRated"] = @YES; // Update isRated to YES

            [self.tripObjects replaceObjectAtIndex:tripDetailsViewController.selectedTripIndex withObject:tripObject];

            // Reload trip cards after updating the rating status
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
