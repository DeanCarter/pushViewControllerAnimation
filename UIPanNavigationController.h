#import <UIKit/UIKit.h>

@interface UIPanNavigationController : UINavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController addPanGesture:(BOOL)gesture;
- (void)pushViewController:(UIViewController *)viewController effect:(BOOL)effect;
- (void)popViewControllerWithEffect:(BOOL)effect;

@end
