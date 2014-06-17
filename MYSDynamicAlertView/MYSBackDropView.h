//
//  MYSBackDropView.h
//  Pods
//
//  Created by Dan Willoughby on 6/16/14.
//
//

#import <UIKit/UIKit.h>

@interface MYSBackDropView : UIView
@property (nonatomic, strong)UILabel *leftLabel;
@property (nonatomic, strong)UILabel *rightLabel;
@property (nonatomic, strong)UILabel *upLabel;
@property (nonatomic, strong)UILabel *downLabel;
@property (nonatomic, weak) UIDynamicAnimator *animator;

- (void)snapOut;
- (void)snapIn;
@end
