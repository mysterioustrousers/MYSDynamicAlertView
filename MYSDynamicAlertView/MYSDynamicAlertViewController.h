//
//  MYSTossAlertView.h
//  DynamicsPlayground
//
//  Created by Dan Willoughby on 6/4/14.
//  Copyright (c) 2014 Willoughby. All rights reserved.
//

typedef NS_ENUM(NSInteger, MYSDynamicAlertViewDirection) {
    MYSDynamicAlertViewDirectionLeft   = 0,
    MYSDynamicAlertViewDirectionRight  = 1,
    MYSDynamicAlertViewDirectionUp     = 2,
    MYSDynamicAlertViewDirectionDown   = 3,
};

#import <UIKit/UIKit.h>

@interface MYSDynamicAlertViewController : UIViewController
- (void)show;
- (void)setDismissBlock:(void (^)(void))block direction:(MYSDynamicAlertViewDirection)direction;
@end
