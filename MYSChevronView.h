//
//  MYSChevronView.h
//  Pods
//
//  Created by Matt Bettinson on 2014-06-25.
//
//

#import <UIKit/UIKit.h>
#import "MYSDynamicAlertView.h"

@interface MYSChevronView : UIView
@property (nonatomic, assign) CGFloat topChevronWhite;
@property (nonatomic, assign) CGFloat bottomChevronWhite;
@property (nonatomic, assign) MYSDynamicAlertViewDirection *direction;
@end
