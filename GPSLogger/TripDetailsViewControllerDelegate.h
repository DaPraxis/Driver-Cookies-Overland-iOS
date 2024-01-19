// TripDetailsViewControllerDelegate.h

#import <Foundation/Foundation.h>

@class TripDetailsViewController;

@protocol TripDetailsViewControllerDelegate <NSObject>

- (void)tripDetailsViewControllerDidClose:(TripDetailsViewController *)tripDetailsViewController;
- (void)tripDetailsViewController:(TripDetailsViewController *)tripDetailsViewController didFinishRating:(BOOL)finishedRating;

@end
