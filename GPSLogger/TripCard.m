#import "TripCard.h"

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
    // Title Label
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 20)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self addSubview:_titleLabel];

    // Time Label
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, self.frame.size.width - 20, 15)];
    _timeLabel.textColor = [UIColor grayColor];
    [self addSubview:_timeLabel];

    // Distance Label
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, self.frame.size.width - 20, 15)];
    _distanceLabel.textColor = [UIColor grayColor];
    [self addSubview:_distanceLabel];

    // Duration Label
    _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, self.frame.size.width - 20, 15)];
    _durationLabel.textColor = [UIColor grayColor];
    [self addSubview:_durationLabel];

    // Map Button (placeholder)
    _mapButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _mapButton.frame = CGRectMake(10, 110, self.frame.size.width - 20, 30);
    [_mapButton setTitle:@"View Map" forState:UIControlStateNormal];
    [_mapButton addTarget:self action:@selector(mapButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_mapButton];
}

- (void)mapButtonTapped {
    // Handle map button tap event
    NSLog(@"View Map tapped for trip: %@", _titleLabel.text);
    // Notify the delegate that the map button was tapped
    [self.delegate tripCardDidTapMapButton:self];
}

@end
