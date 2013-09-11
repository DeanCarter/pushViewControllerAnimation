//
//  UINavigationController+PanNavigationController.h
//  
//
//  Created by luo lisheng on 13-9-11.
//  Copyright (c) 2013年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (PanNavigationController)

- (void)pushViewController:(UIViewController *)viewController withEffect:(BOOL)needEffect;
- (void)popViewController;

@end
