#import <UIKit/UIKit.h>

@class TripCard;

@protocol TripCardDelegate <NSObject>

- (void)tripCardDidTapMapButton:(TripCard *)tripCard;

@end

@interface TripCard : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, weak) id<TripCardDelegate> delegate;

// Add a property for tripData
@property (nonatomic, strong) NSDictionary *tripData;

// Add a property for isRated
@property (nonatomic, assign) BOOL isRated;

// Declare the updateUI method
- (void)updateUI;

@end
