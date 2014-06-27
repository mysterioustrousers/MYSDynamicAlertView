//
//  MYSContentView.h
//  Pods
//
//  Created by Dan Willoughby on 6/17/14.
//
//

#import <UIKit/UIKit.h>
#import "MYSDynamicAlertView.h"

@interface MYSContentView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, assign) CGFloat scrollViewOffset;

- (void)bounceChevron:(MYSDynamicAlertViewDirection)direction;
@end
