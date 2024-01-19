#import <UIKit/UIKit.h>

@interface POIRatingsViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *tripObjects;
@property (nonatomic, strong) NSDictionary *selectedTripData;

@end
