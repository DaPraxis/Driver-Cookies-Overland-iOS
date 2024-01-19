#import "TripDetailsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
//#import <SDWebImage/SDWebImage.h>

@interface TripDetailsViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *departureTimeLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *durationLabel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *poiData;

//@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator; // Add this line

@end

@implementation TripDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Initialize poiData array
    self.poiData = [NSMutableArray array];

    // Call a method to create the UI for trip details and fetch POIs
    [self createUI];
    [self fetchPOIsForCoordinates];
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
    [self.view addSubview:backButton]; // Add this line

    // ScrollView for POI Cards
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, self.view.frame.size.height - 250)];
    [self.view addSubview:self.scrollView];

    // Activity Indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.view addSubview:self.activityIndicator];
}

- (void)fetchPOIsForCoordinates {
    NSArray *routeCoordinates = self.tripData[@"route"];
    NSLog(@"TripDetails: %@", self.tripData[@"route"]);
    NSLog(@"TripDurations: %@", self.duration);

    dispatch_group_t group = dispatch_group_create();

    for (NSDictionary *coordinate in routeCoordinates) {
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake([coordinate[@"latitude"] doubleValue], [coordinate[@"longitude"] doubleValue]);

        dispatch_group_enter(group);
        [self fetchPOIsForCoordinate:locationCoordinate completion:^(NSArray<NSDictionary *> *pois) {
            [self.poiData addObjectsFromArray:pois];
            dispatch_group_leave(group);
        }];
    }

    [self.activityIndicator startAnimating]; // Start the spinner
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // All fetches completed
        [self createPOICardsForPOIs:self.poiData];

        [self.activityIndicator stopAnimating]; // Stop the spinner
    });
}

- (void)createPOICardsForPOIs:(NSArray<NSDictionary *> *)pois {
    CGFloat cardWidth = (self.view.frame.size.width - 30) / 2; // Adjust the spacing as needed
    CGFloat cardHeight = 200; // Adjust the card height as needed (doubled)
    CGFloat horizontalSpacing = 10; // Adjust the horizontal spacing between cards
    CGFloat verticalSpacing = 10; // Adjust the vertical spacing between cards

    // Start yOffset from the bottom of the duration label
    CGFloat yOffset = CGRectGetMaxY(self.durationLabel.frame) + verticalSpacing - cardHeight;

    for (NSInteger i = 0; i < pois.count; i++) {
        NSDictionary *poi = pois[i];

        // Calculate the position of the card in the grid
        CGFloat xOffset = (i % 2) * (cardWidth + horizontalSpacing) + 10;

        if (i % 2 == 0 && i != 0) {
            // Move to the next row, but only if it's not the first card in the loop
            yOffset += cardHeight + verticalSpacing;
        }

        // Create a UIView as the card
        UIView *poiCard = [[UIView alloc] initWithFrame:CGRectMake(xOffset, yOffset, cardWidth, cardHeight)];
        poiCard.backgroundColor = [UIColor whiteColor];
        poiCard.layer.cornerRadius = 8.0;
        poiCard.layer.borderWidth = 1.0;
        poiCard.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.scrollView addSubview:poiCard];

        // Add labels or other UI elements to the card
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, cardWidth - 20, 40)];
        nameLabel.text = poi[@"name"];
        nameLabel.numberOfLines = 2; // Allow two lines for the name
        [poiCard addSubview:nameLabel];

        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, cardWidth - 20, cardHeight - 70)];
        descriptionLabel.text = poi[@"description"];
        descriptionLabel.numberOfLines = 0; // Allow any number of lines for description
        [poiCard addSubview:descriptionLabel];
    }

    // Adjust the content size based on the last card
    CGFloat maxY = yOffset + cardHeight;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, maxY);
}





- (void)fetchPOIsForCoordinate:(CLLocationCoordinate2D)coordinate completion:(void (^)(NSArray<NSDictionary *> *))completion {
    // Set up a location for the search
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];

    // Use a more specific query, for example, "restaurant"
    request.naturalLanguageQuery = @"restaurant";

    request.region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100); // Search within a radius of 100 meters

    // Perform the local search
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];

    NSMutableArray<NSDictionary *> *poiResults = [NSMutableArray array];

    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            for (MKMapItem *mapItem in response.mapItems) {
                // Extract relevant information from the map item
                NSString *name = mapItem.name ? mapItem.name : @"";
                NSString *address = mapItem.placemark.title ? mapItem.placemark.title : @"";
                NSString *description = [NSString stringWithFormat:@"%@\n%@", name, address];

                NSDictionary *poi = @{@"name": name, @"description": description};
                [poiResults addObject:poi];
            }

            // Log the fetched POIs
            NSLog(@"Fetched POIs: %@", poiResults);
        } else {
            NSLog(@"Error fetching POIs: %@", error.localizedDescription);
        }

        // Call the completion block with the fetched POIs
        completion(poiResults);
    }];
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
    
    // Dismiss the TripDetailsViewController
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
