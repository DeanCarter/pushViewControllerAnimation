//
//  UINavigationController+PanNavigationController.h
//  
//
//  Created by luo lisheng on 13-9-11.
//  
//

#import <UIKit/UIKit.h>

@interface UINavigationController (PanNavigationController)

@property(strong, nonatomic)NSMutableArray *screenShots;

- (id)initWithRootViewControllerAddGesture:(UIViewController *)rootViewController;
- (void)pushViewController:(UIViewController *)viewController effect:(BOOL)effect;
- (void)popViewControllerWithEffect:(BOOL)effect;

@end

