#import <UIKit/UIKit.h>

@class TripCard;

@protocol TripCardDelegate <NSObject>

- (void)tripCardDidTapMapButton:(TripCard *)tripCard;

@end

@interface TripCard : UIView

@property (nonatomic, weak) id<TripCardDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, assign) BOOL isRated;
@property (nonatomic, strong) NSDictionary *tripData;

- (instancetype)initWithFrame:(CGRect)frame tripData:(NSDictionary *)tripData;
- (void)updateUI;

@end
