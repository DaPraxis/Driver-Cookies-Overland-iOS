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
            @"route": @[
                            @{@"latitude": @37.7749, @"longitude": @-122.4194},
                            @{@"latitude": @37.7753, @"longitude": @-122.4196},
                            @{@"latitude": @37.7757, @"longitude": @-122.4198},
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
                @{@"latitude": @43.6640123, @"longitude": @-79.41635450000000},
                @{@"latitude": @43.66403130000000, @"longitude": @-79.41626720000000},
                @{@"latitude": @43.6640486, @"longitude": @-79.41618660000000},
                @{@"latitude": @43.66406830000000, @"longitude": @-79.4160957},
                @{@"latitude": @43.6640869, @"longitude": @-79.41601250000000},
                @{@"latitude": @43.66411400000000, @"longitude": @-79.4159146},
                @{@"latitude": @43.66411689849020, @"longitude": @-79.41582946527990},
                @{@"latitude": @43.66413954648910, @"longitude": @-79.41572678868360},
                @{@"latitude": @43.664154515652100, @"longitude": @-79.41566094793050},
                @{@"latitude": @43.66417453062420, @"longitude": @-79.41557291321240},
                @{@"latitude": @43.664189774582900, @"longitude": @-79.41550586354740},
                @{@"latitude": @43.664206971312000, @"longitude": @-79.41543022488140},
                @{@"latitude": @43.664215899752400, @"longitude": @-79.41539062494290},
                @{@"latitude": @43.6642372, @"longitude": @-79.4153698},
                @{@"latitude": @43.664241500000000, @"longitude": @-79.41534660000000},
                @{@"latitude": @43.66424420000000, @"longitude": @-79.41533390000000},
                @{@"latitude": @43.66424480000000, @"longitude": @-79.41533100000000},
                @{@"latitude": @43.6642476, @"longitude": @-79.41531610000000},
                @{@"latitude": @43.66425390000000, @"longitude": @-79.41528670000000},
                @{@"latitude": @43.6642631, @"longitude": @-79.41524240000000},
                @{@"latitude": @43.6642749, @"longitude": @-79.4151854},
                @{@"latitude": @43.6642901, @"longitude": @-79.4151125},
                @{@"latitude": @43.66430190000000, @"longitude": @-79.4150494},
                @{@"latitude": @43.6643123, @"longitude": @-79.414974},
                @{@"latitude": @43.6643216, @"longitude": @-79.41490610000000},
                @{@"latitude": @43.664335200000000, @"longitude": @-79.4148358},
                @{@"latitude": @43.6643591, @"longitude": @-79.41476520000000},
                @{@"latitude": @43.66436876474310, @"longitude": @-79.41468488994050},
                @{@"latitude": @43.66438679412280, @"longitude": @-79.41460143365900},
                @{@"latitude": @43.664406194674800, @"longitude": @-79.41450983203290},
                @{@"latitude": @43.66442709428330, @"longitude": @-79.4144111524299},
                @{@"latitude": @43.664449153145700, @"longitude": @-79.41430699940990},
                @{@"latitude": @43.664471788680100, @"longitude": @-79.41419945872620},
                @{@"latitude": @43.664490451775900, @"longitude": @-79.41411136176760},
                @{@"latitude": @43.66452930000000, @"longitude": @-79.41400770000000},
                @{@"latitude": @43.66455460000000, @"longitude": @-79.4138876},
                @{@"latitude": @43.66458100000000, @"longitude": @-79.4137694},
                @{@"latitude": @43.66460010000000, @"longitude": @-79.41368470000000},
                @{@"latitude": @43.664609986893400, @"longitude": @-79.41356187150470},
                @{@"latitude": @43.66463531156340, @"longitude": @-79.41344664769340},
                @{@"latitude": @43.66465569478210, @"longitude": @-79.41335390659480},
                @{@"latitude": @43.66468044383680, @"longitude": @-79.41324130147830},
                @{@"latitude": @43.66470021124120, @"longitude": @-79.41315136230930},
                @{@"latitude": @43.66471991520960, @"longitude": @-79.41306193228690},
                @{@"latitude": @43.664745335311100, @"longitude": @-79.41294777165370},
                @{@"latitude": @43.664763065885200, @"longitude": @-79.4128664256583},
                @{@"latitude": @43.66477877308400, @"longitude": @-79.4127943626198},
                @{@"latitude": @43.66479464234430, @"longitude": @-79.41272155612460},
                @{@"latitude": @43.66480208938490, @"longitude": @-79.41268787712960},
                @{@"latitude": @43.664807992739700, @"longitude": @-79.41265829492830},
                @{@"latitude": @43.664810470988900, @"longitude": @-79.41264587602330},
                @{@"latitude": @43.664813084170100, @"longitude": @-79.41263278101450},
                @{@"latitude": @43.66482001354050, @"longitude": @-79.41259805719960},
                @{@"latitude": @43.664827544158800, @"longitude": @-79.41256032025850},
                @{@"latitude": @43.664852, @"longitude": @-79.41251800000000},
                @{@"latitude": @43.6648618, @"longitude": @-79.41246410000000},
                @{@"latitude": @43.664872, @"longitude": @-79.4124067},
                @{@"latitude": @43.6648829, @"longitude": @-79.4123455},
                @{@"latitude": @43.66489540000000, @"longitude": @-79.41227980000000},
                @{@"latitude": @43.664907900000000, @"longitude": @-79.4122196},
                @{@"latitude": @43.6649203, @"longitude": @-79.41216180000000},
                @{@"latitude": @43.664936300000000, @"longitude": @-79.41209040000000},
                @{@"latitude": @43.6649473, @"longitude": @-79.4120415},
                @{@"latitude": @43.66495690000000, @"longitude": @-79.4119995},
                @{@"latitude": @43.6649662, @"longitude": @-79.41195810000000},
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
