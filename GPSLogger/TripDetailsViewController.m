#import "TripDetailsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomPOIDialogViewController.h"

@interface TripDetailsViewController (){
    NSMutableSet *uniquePOIIdentifiers;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *departureTimeLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, assign) NSInteger selectedCardIndex;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *poiData;


@end

@implementation TripDetailsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialize the set in the class's initializer
        uniquePOIIdentifiers = [NSMutableSet set];
        _selectedCardIndex = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Initialize poiData array
    self.poiData = [NSMutableArray array];

    // Call a method to create the UI for trip details and fetch POIs
    [self createUI];
    [self fetchPOIsForCoordinates];
}

@synthesize selectedTripIndex;

- (void)createUI {
    // Set the view's background color to white
    self.view.backgroundColor = [UIColor whiteColor];

    // Title Label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 10, 30)];
    self.titleLabel.text = self.tripTitle;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self.view addSubview:self.titleLabel];

    // Departure Time Label
    self.departureTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, self.view.frame.size.width - 10, 20)];
    self.departureTimeLabel.text = self.departureTime;
    [self.view addSubview:self.departureTimeLabel];

    // Distance Label
    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, self.view.frame.size.width - 10, 20)];
    self.distanceLabel.text = self.distance;
    [self.view addSubview:self.distanceLabel];

    // Duration Label
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, self.view.frame.size.width - 10, 20)];
    self.durationLabel.text = self.duration;
    [self.view addSubview:self.durationLabel];

    // Back Button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(10, 50, 80, 30);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

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

    for (NSInteger i = 0; i < routeCoordinates.count; i++) {
        NSDictionary *coordinate = routeCoordinates[i];
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake([coordinate[@"latitude"] doubleValue], [coordinate[@"longitude"] doubleValue]);

        // Determine the index of the next coordinate
        NSInteger nextIndex = i + 1;
        if (nextIndex >= routeCoordinates.count) {
            nextIndex = i-2; // Use the current index if it's the last coordinate
        }

        NSDictionary *nextCoordinate = routeCoordinates[nextIndex];
        CLLocationCoordinate2D locationCoordinate2 = CLLocationCoordinate2DMake([nextCoordinate[@"latitude"] doubleValue], [nextCoordinate[@"longitude"] doubleValue]);

        dispatch_group_enter(group);
        [self fetchPOIsForCoordinate:locationCoordinate nextCoordinate:locationCoordinate2 completion:^(NSArray<NSDictionary *> *pois) {
            // Associate each POI with its corresponding coordinate
            for (NSDictionary *poi in pois) {
                NSMutableDictionary *mutablePoi = [poi mutableCopy];
                mutablePoi[@"coordinate"] = coordinate;
                [self.poiData addObject:[mutablePoi copy]];
            }
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
    CGFloat cardWidth = (self.view.frame.size.width - 30) / 2;
    CGFloat cardHeight = 250; // Increase the card height
    CGFloat horizontalSpacing = 10;
    CGFloat verticalSpacing = 10;

    CGFloat yOffset = CGRectGetMaxY(self.durationLabel.frame) + verticalSpacing - cardHeight;

    for (NSInteger i = 0; i < pois.count; i++) {
        NSDictionary *poi = pois[i];

        CGFloat xOffset = (i % 2) * (cardWidth + horizontalSpacing) + 10;

        if (i % 2 == 0 && i != 0) {
            yOffset += cardHeight + verticalSpacing;
        }

        UIView *poiCard = [[UIView alloc] initWithFrame:CGRectMake(xOffset, yOffset, cardWidth, cardHeight)];
        poiCard.backgroundColor = [UIColor whiteColor];
        poiCard.layer.cornerRadius = 8.0;
        poiCard.layer.borderWidth = 1.0;
        poiCard.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        // Add tap gesture recognizer to each POI card
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(poiCardTapped:)];
        [poiCard addGestureRecognizer:tapGesture];

        // Update the appearance of the POI card based on the selectedCardIndex
        if (i == self.selectedCardIndex) {
            poiCard.alpha = 0.7; // Set the alpha value as desired (0.7 for a bit greyed out)
        } else {
            poiCard.alpha = 1.0;
        }
        
        [self.scrollView addSubview:poiCard];

        UIImageView *streetViewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cardWidth, cardHeight * 2/3)];
        [poiCard addSubview:streetViewImageView];

        // Load the street view image using SDWebImage or any other image loading library
        [streetViewImageView sd_setImageWithURL:[NSURL URLWithString:poi[@"streetViewURL"]] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, cardHeight * 2/3, cardWidth - 20, cardHeight * 1/3)];
        nameLabel.text = poi[@"name"];
        nameLabel.numberOfLines = 2;
        [poiCard addSubview:nameLabel];
    }

    CGFloat maxY = yOffset + cardHeight;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, maxY);
}

- (void)poiCardTapped:(UITapGestureRecognizer *)gestureRecognizer {
    // Get the tapped POI card view
    UIView *tappedCard = gestureRecognizer.view;

    // Get the index of the tapped card
    NSInteger tappedIndex = [self.scrollView.subviews indexOfObject:tappedCard];

    // Update the selectedCardIndex
    self.selectedCardIndex = tappedIndex;

    // Ensure the tappedIndex is valid and corresponds to a POI in the poiData array
    if (tappedIndex >= 0 && tappedIndex < self.poiData.count) {
        // Update the appearance of the tapped POI card
        [self updateAppearanceForTappedPOICard];

        NSDictionary *tappedPOI = self.poiData[tappedIndex];

        // Instantiate the view controller from storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil]; // Use your storyboard name
        CustomPOIDialogViewController *poiDialogVC = [storyboard instantiateViewControllerWithIdentifier:@"CustomPOIDialogViewController"];
        
        // Set properties or pass data to the view controller if needed
        poiDialogVC.poiData = tappedPOI; // Adjust this line based on your data structure
        
        // Present the view controller
        [self presentViewController:poiDialogVC animated:YES completion:nil];
    }
}

- (void)updateAppearanceForTappedPOICard {
    // Identify the tapped POI card (based on your logic, e.g., the selectedCardIndex)
    // For illustration, let's assume you have a property to track the selected index
    NSInteger tappedCardIndex = self.selectedCardIndex;

    // Loop through subviews of the scrollView to find the tapped POI card
    for (NSInteger i = 0; i < self.scrollView.subviews.count; i++) {
        UIView *poiCard = self.scrollView.subviews[i];

        // Check if this is the tapped POI card
        if (i == tappedCardIndex) {
            // Update the appearance of the tapped POI card (grey it out)
            poiCard.alpha = 0.7; // Set the alpha value as desired (0.7 for a bit greyed out)
        } else {
            // Reset the appearance of other POI cards
            poiCard.alpha = 1.0;
        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPOIDialog"]) {
        CustomPOIDialogViewController *dialogVC = segue.destinationViewController;
        dialogVC.poiData = sender;
    }
}

- (void)showPOIDialogForPOI:(NSDictionary *)poi {
    UIAlertController *poiDialog = [UIAlertController alertControllerWithTitle:poi[@"name"]
                                                                       message:poi[@"description"]
                                                                preferredStyle:UIAlertControllerStyleAlert];

    // Create a custom view for additional information
    UIView *additionalInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 350)]; // Increased height

    // Add label for checkbox
    UILabel *checkboxLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 30)];
    checkboxLabel.text = @"Have you seen this location?";
    [additionalInfoView addSubview:checkboxLabel];

    // Add actual checkbox
    UISwitch *checkBox = [[UISwitch alloc] initWithFrame:CGRectMake(10, 40, 50, 30)];
    [additionalInfoView addSubview:checkBox];

    // Add label for rating scale
    UILabel *ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 280, 30)];
    ratingLabel.text = @"Rate your interest in this location (1-5)";
    [additionalInfoView addSubview:ratingLabel];

    // Add actual UIStepper
    UIStepper *ratingStepper = [[UIStepper alloc] initWithFrame:CGRectMake(10, 120, 50, 30)];
    ratingStepper.minimumValue = 1;
    ratingStepper.maximumValue = 5;
    ratingStepper.stepValue = 1;
    [additionalInfoView addSubview:ratingStepper];

    // Set custom view as the accessory view for the alert controller
    [poiDialog.view addSubview:additionalInfoView];

    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Update the appearance of the selected POI card when the dialog is closed
        [self updateAppearanceForSelectedPOICard];
    }];

    [poiDialog addAction:closeAction];

    // Adjust the frame of the alert controller's view
    poiDialog.view.frame = CGRectMake(0, 0, 340, 400); // Adjust the width and height as needed

    [self presentViewController:poiDialog animated:YES completion:nil];
}



- (void)checkBoxValueChanged:(UISwitch *)checkBox {
    // Handle checkbox value change (if needed)
    NSLog(@"Checkbox value changed to: %@", checkBox.on ? @"YES" : @"NO");
}

- (void)updateAppearanceForSelectedPOICard {
    // Identify the selected POI card (based on your logic, e.g., the selectedCardIndex)
    // For illustration, let's assume you have a property to track the selected index
    NSInteger selectedCardIndex = self.selectedCardIndex;

    // Loop through subviews of the scrollView to find the selected POI card
    for (NSInteger i = 0; i < self.scrollView.subviews.count; i++) {
        UIView *poiCard = self.scrollView.subviews[i];

        // Check if this is the selected POI card
        if (i == selectedCardIndex) {
            // Update the appearance of the selected POI card
            poiCard.alpha = 0.7; // Set the alpha value as desired (0.7 for a bit greyed out)
        } else {
            // Reset the appearance of other POI cards
            poiCard.alpha = 1.0;
        }
    }
}

- (void)fetchPOIsForCoordinate:(CLLocationCoordinate2D)currentCoordinate nextCoordinate:(CLLocationCoordinate2D)nextCoordinate completion:(void (^)(NSArray<NSDictionary *> *))completion {
    NSString *apiKey = @"AIzaSyB3K41CGZ8jdSFqYaqRwVqnAPbqi0N9mQE";
    
    // Set up the Google Places API URL with the required parameters
    NSString *googlePlacesURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%lf,%lf&radius=70&type=point_of_interest&key=%@", currentCoordinate.latitude, currentCoordinate.longitude, apiKey];
    
    // Create a mutable array to store the results
    NSMutableArray<NSDictionary *> *poiResults = [NSMutableArray array];
    
    // Create a URL session task to fetch data from the Google Places API
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:googlePlacesURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError) {
                // Process the JSON response and extract relevant information
                NSArray *results = jsonResponse[@"results"];
                
                for (NSDictionary *result in results) {
                    NSString *name = result[@"name"] ? result[@"name"] : @"";
                    NSString *address = result[@"vicinity"] ? result[@"vicinity"] : @"";
                    NSString *description = [NSString stringWithFormat:@"%@\n%@", name, address];
                    
                    // Use the actual coordinate of the place
                    NSDictionary *location = result[@"geometry"][@"location"];
                    CLLocationCoordinate2D placeCoordinate = CLLocationCoordinate2DMake([location[@"lat"] doubleValue], [location[@"lng"] doubleValue]);
                    NSLog(@"POI Name %@, location (%lf, %lf)", name, placeCoordinate.longitude, placeCoordinate.latitude);
                    
                    NSString *poiIdentifier = [NSString stringWithFormat:@"%@",name];
                    // Check if the identifier is already in the set (indicating a duplicate POI)
                    if (![uniquePOIIdentifiers containsObject:poiIdentifier]) {
                        // Add the POI to the set and the results array
                        [uniquePOIIdentifiers addObject:poiIdentifier];
                        
                        NSString *streetViewURL = [self streetViewImageURLForCoordinate:placeCoordinate routeCoordinate:currentCoordinate nextRouteCoordinate:nextCoordinate];

                        NSDictionary *poi = @{@"name": name, @"description": description, @"streetViewURL": streetViewURL};
                        [poiResults addObject:poi];
                    }
                }
                
                completion(poiResults);
            } else {
                NSLog(@"Error parsing JSON response: %@", jsonError.localizedDescription);
                completion(@[]);
            }
        } else {
            NSLog(@"Error fetching POIs: %@", error.localizedDescription);
            completion(@[]);
        }
    }];
    
    [task resume];
}


- (NSString *)streetViewImageURLForCoordinate:(CLLocationCoordinate2D)placeCoordinate routeCoordinate:(CLLocationCoordinate2D)routeCoordinate nextRouteCoordinate:(CLLocationCoordinate2D)nextRouteCoordinate {
    NSString *apiKey = @"AIzaSyB3K41CGZ8jdSFqYaqRwVqnAPbqi0N9mQE";

    // Find the point P on line (routeCoordinate, netRouteCoordinate) closest to placeCoordinate
    CLLocationCoordinate2D pointP = [self pointOnLineClosestToCoordinate:placeCoordinate lineStart:routeCoordinate lineEnd:nextRouteCoordinate];

    // Calculate the angle from P to placeCoordinate
//    double angle = [self calculateAngleFromCoordinate:placeCoordinate toCoordinate:pointP];
    double angle = [self calculateAngleFromCoordinate:pointP toCoordinate:placeCoordinate];
    
    CLLocationCoordinate2D lookUpCoor;
    lookUpCoor.longitude = (placeCoordinate.longitude + pointP.longitude)/2.0;
    lookUpCoor.latitude = (placeCoordinate.latitude + pointP.latitude)/2.0;
    
    // Set up the Google Street View API URL with the required parameters
    NSString *streetViewURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/streetview?size=400x400&location=%lf,%lf&fov=60&heading=%f&pitch=0&key=%@", lookUpCoor.latitude, lookUpCoor.longitude, angle, apiKey];

    return streetViewURL;
}



- (CLLocationCoordinate2D)pointOnLineClosestToCoordinate:(CLLocationCoordinate2D)point lineStart:(CLLocationCoordinate2D)lineStart lineEnd:(CLLocationCoordinate2D)lineEnd {

    double x1 = lineStart.longitude;
    double x2 = lineEnd.longitude;
    double x3 = point.longitude;
    double y1 = lineStart.latitude;
    double y2 = lineEnd.latitude;
    double y3 = point.latitude;
    double k = ((y2-y1) * (x3-x1) - (x2-x1) * (y3-y1)) / (pow((y2-y1),2.0) + pow((x2-x1),2.0));
    double x4 = x3 - k * (y2-y1);
    double y4 = y3 + k * (x2-x1);
    
    double deltaLongitude = x1-x2;
    double deltaLatitude = y1-y2;
    double street_angle = atan2(deltaLongitude, deltaLatitude) * (180.0 / M_PI);
    NSLog(@"POI (%lf,%lf) street angle: %lf", x4,y4,street_angle);
    
    
    CLLocationCoordinate2D result;
    result.longitude = x4;
    result.latitude = y4;
    
    return result;
}

- (double)calculateAngleFromCoordinate:(CLLocationCoordinate2D)fromCoordinate toCoordinate:(CLLocationCoordinate2D)toCoordinate {
    double deltaLongitude = toCoordinate.longitude - fromCoordinate.longitude;
    double deltaLatitude = toCoordinate.latitude - fromCoordinate.latitude;
    double angle = atan2(deltaLongitude, deltaLatitude) * (180.0 / M_PI);

    // Ensure the angle is within [0, 360] degrees
    if (angle < 0) {
        angle += 360.0;
    }
    
    NSLog(@"POI (%lf,%lf) POI angle: %lf", toCoordinate.longitude,toCoordinate.latitude,angle);

    return angle;
}

- (void)backButtonTapped {
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
    [self.delegate tripDetailsViewController:self didFinishRating:finishedRating];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
