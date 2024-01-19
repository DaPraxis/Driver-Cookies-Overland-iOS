#import <UIKit/UIKit.h>
#import "TripDetailsViewControllerDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface TripDetailsViewController : UIViewController

@property (nonatomic, strong) NSString *tripTitle;
@property (nonatomic, strong) NSString *departureTime;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, assign) NSInteger selectedTripIndex;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, weak) id<TripDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDictionary *tripData;

- (void)fetchPOIsForCoordinate:(CLLocationCoordinate2D)coordinate completion:(void (^)(NSArray<NSDictionary *> *))completion;
- (void)createPOICardsForPOIs:(NSArray<NSDictionary *> *)pois;


@end
