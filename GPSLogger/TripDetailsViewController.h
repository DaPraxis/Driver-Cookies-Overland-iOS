#import <UIKit/UIKit.h>
#import "TripDetailsViewControllerDelegate.h"

@interface TripDetailsViewController : UIViewController

@property (nonatomic, strong) NSString *tripTitle;
@property (nonatomic, strong) NSString *departureTime;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, assign) NSInteger selectedTripIndex;

@property (nonatomic, weak) id<TripDetailsViewControllerDelegate> delegate;

@end
