//
//  UINavigationController+PanNavigationController.m
//  
//
//  Created by luo lisheng on 13-9-11.
//  Copyright (c) 2013年 ryan. All rights reserved.
//

#import "UINavigationController+PanNavigationController.h"
#import <QuartzCore/QuartzCore.h>

#define PREVPAGE_SCALE .95f
#define PREVPAGE_ALPHA .6f
#define GRAG_MAXIMUM 100
#define ANIMATE_DURATION .3f
#define BACK_DURATION .2f
#define KEYWINDOW [[UIApplication sharedApplication] keyWindow]
#define KEYWINDOW_BOUNDS [[UIApplication sharedApplication] keyWindow].bounds

@implementation UINavigationController (PanNavigationController)

- (void)addPanGestureToView{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(handlePanGesture:)];
    panRecognizer.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:panRecognizer];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer{
    if (self.viewControllers.count <= 1) {
        return;
    }
    UIView * prevPageView = [KEYWINDOW.subviews objectAtIndex:0];
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    if (translation.x > 0) {
        [self.view setTransform:CGAffineTransformMakeTranslation(translation.x, 0)];
        double scale =
            MIN(1.0f, PREVPAGE_SCALE + translation.x/CGRectGetWidth(KEYWINDOW_BOUNDS)*(1-PREVPAGE_SCALE));
        [prevPageView setTransform:CGAffineTransformMakeScale(scale, scale)];
        double alpha =
            MIN(1.0f, PREVPAGE_ALPHA + translation.x/CGRectGetWidth(KEYWINDOW_BOUNDS)*(1-PREVPAGE_ALPHA));
        prevPageView.alpha = alpha;
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (translation.x > GRAG_MAXIMUM) {
            [self popViewController];
        } else {
            [UIView animateWithDuration:BACK_DURATION
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [self.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
                                 prevPageView.alpha = PREVPAGE_ALPHA;
                                 [prevPageView setTransform:CGAffineTransformMakeScale(PREVPAGE_SCALE, PREVPAGE_SCALE)];
                             }
                             completion:^(BOOL finished){
                             }];
        }
    }
}

- (UIImage *)getPrevPageScreenShot{
    if (UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(KEYWINDOW_BOUNDS.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(KEYWINDOW_BOUNDS.size);
    }
    [KEYWINDOW.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (void)pushViewController:(UIViewController *)viewController withEffect:(BOOL)needEffect{
    [self addPanGestureToView];
    UIImageView *prevPageView = [[UIImageView alloc] initWithImage:[self getPrevPageScreenShot]];
    [KEYWINDOW insertSubview:prevPageView atIndex:0];
    [self.view setTransform:CGAffineTransformMakeTranslation(CGRectGetWidth(KEYWINDOW_BOUNDS), 0)];
    [self pushViewController:viewController animated:NO];
    [UIView animateWithDuration:ANIMATE_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
                         if (needEffect) {
                             prevPageView.alpha = PREVPAGE_ALPHA;
                             [prevPageView setTransform:CGAffineTransformMakeScale(PREVPAGE_SCALE, PREVPAGE_SCALE)];
                         }
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)popViewController{
    UIView * prevPageView = [KEYWINDOW.subviews objectAtIndex:0];
    [UIView animateWithDuration:ANIMATE_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view setTransform:CGAffineTransformMakeTranslation(CGRectGetWidth(KEYWINDOW_BOUNDS), 0)];
                         prevPageView.alpha = 1.0f;
                         [prevPageView setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
                     }
                     completion:^(BOOL finished){
                         [self popViewControllerAnimated:NO];
                         [self.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
                         [prevPageView removeFromSuperview];
                     }];
}

@end
