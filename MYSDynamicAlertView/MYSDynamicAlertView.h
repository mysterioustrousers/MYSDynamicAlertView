//
//  MYSTossAlertView.h
//  DynamicsPlayground
//
//  Created by Dan Willoughby on 6/4/14.
//  Copyright (c) 2014 Willoughby. All rights reserved.
//

typedef NS_ENUM(NSInteger, MYSTossAlertViewDirection) {
    MYSTossAlertViewDirectionLeft   = 0,
    MYSTossAlertViewDirectionRight  = 1,
    MYSTossAlertViewDirectionUp     = 2,
    MYSTossAlertViewDirectionDown   = 3,
};

#import <UIKit/UIKit.h>

@interface MYSDynamicAlertView : UIViewController
- (void)show;
- (void)setDismissBlock:(void (^)(void))block direction:(MYSTossAlertViewDirection)direction;
@end
