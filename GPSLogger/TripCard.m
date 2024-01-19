#import "TripCard.h"
#import <MapKit/MapKit.h>
@implementation TripCard

- (instancetype)initWithFrame:(CGRect)frame tripData:(NSDictionary *)tripData {
    self = [super initWithFrame:frame];
    if (self) {
        _tripData = tripData;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10.0;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowRadius = 4.0;
        self.layer.shadowOpacity = 0.2;
        _isRated = NO;

        // Create and add subviews (labels and map button)
        [self createSubviews];
    }
    return self;
}

- (void)updateUI {
    // Update UI based on rating status
    self.titleLabel.enabled = !_isRated;
    self.timeLabel.enabled = !_isRated;
    self.distanceLabel.enabled = !_isRated;
    self.durationLabel.enabled = !_isRated;
    self.mapButton.enabled = !_isRated;
}

- (void)createSubviews {
    // Map View (1/3 width)
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 3, self.frame.size.height)];
    mapView.showsUserLocation = YES;

    // Extract coordinates from the route data
    NSArray *routeCoordinates = self.tripData[@"route"];

    // Add blue dots for each coordinate
    for (NSDictionary *coordinate in routeCoordinates) {
        CLLocationCoordinate2D annotationCoordinate = CLLocationCoordinate2DMake([coordinate[@"latitude"] doubleValue], [coordinate[@"longitude"] doubleValue]);

        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = annotationCoordinate;

        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        pin.pinTintColor = [UIColor blueColor]; // Set the pin color to blue

        [mapView addAnnotation:pin.annotation];
    }

    // Set the map region to focus on the entire route
    MKCoordinateRegion region = [self regionForAnnotations:mapView.annotations];

    // Log the calculated region
    NSLog(@"Calculated Region: Center (%f, %f), Span (%f, %f)", region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta);

    // Check if the region is valid
    if (region.center.latitude != 0.0 && region.center.longitude != 0.0 && region.span.latitudeDelta != 0.0 && region.span.longitudeDelta != 0.0) {
        [mapView setRegion:region animated:YES];
    } else {
        // Handle the case where the region is not valid
        NSLog(@"Invalid region. Unable to set the map region.");
    }

    [self addSubview:mapView];

    // Title Label
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(mapView.frame.size.width + 10, 10, self.frame.size.width * 2 / 3 - 20, 20)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self addSubview:_titleLabel];

    // Time Label
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(mapView.frame.size.width + 10, 40, self.frame.size.width * 2 / 3 - 20, 15)];
    _timeLabel.textColor = [UIColor grayColor];
    [self addSubview:_timeLabel];

    // Distance Label
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(mapView.frame.size.width + 10, 60, self.frame.size.width * 2 / 3 - 20, 15)];
    _distanceLabel.textColor = [UIColor grayColor];
    [self addSubview:_distanceLabel];

    // Duration Label
    _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(mapView.frame.size.width + 10, 80, self.frame.size.width * 2 / 3 - 20, 15)];
    _durationLabel.textColor = [UIColor grayColor];
    [self addSubview:_durationLabel];

    // Map Button (placeholder)
    _mapButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _mapButton.frame = CGRectMake(mapView.frame.size.width + 10, 110, self.frame.size.width * 2 / 3 - 20, 30);
    [_mapButton setTitle:@"View Map" forState:UIControlStateNormal];
    [_mapButton addTarget:self action:@selector(mapButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_mapButton];
}

- (MKCoordinateRegion)regionForAnnotations:(NSArray<MKPointAnnotation *> *)annotations {
    // Calculate the bounding box of the route
    MKMapPoint points[[annotations count]];
    for (NSUInteger i = 0; i < [annotations count]; i++) {
        CLLocationCoordinate2D coordinate = annotations[i].coordinate;
        points[i] = MKMapPointForCoordinate(coordinate);
    }

    MKPolygon *polygon = [MKPolygon polygonWithPoints:points count:[annotations count]];
    MKMapRect boundingRect = [polygon boundingMapRect];

    // Add padding to the bounding box for a better view
    MKMapRect paddedRect = [self visibleMapRectThatFits:boundingRect edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)];

    // Convert the padded rectangle back to a region
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(paddedRect);

    return region;
}

- (MKMapRect)visibleMapRectThatFits:(MKMapRect)mapRect edgePadding:(UIEdgeInsets)insets {
    MKMapRect paddedRect = mapRect;

    paddedRect.origin.x -= insets.left;
    paddedRect.origin.y -= insets.top;
    paddedRect.size.width += (insets.left + insets.right);
    paddedRect.size.height += (insets.top + insets.bottom);

    return paddedRect;
}

- (void)mapButtonTapped {
    // Handle map button tap event
    NSLog(@"View Map tapped for trip: %@", _titleLabel.text);
    // Notify the delegate that the map button was tapped
    [self.delegate tripCardDidTapMapButton:self];
//    [self performSegueWithIdentifier:@"ViewTripSegue" sender:self];
}

@end
