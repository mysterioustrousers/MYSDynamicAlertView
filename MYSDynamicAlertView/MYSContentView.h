//
//  MYSContentView.h
//  Pods
//
//  Created by Dan Willoughby on 6/17/14.
//
//

#import <UIKit/UIKit.h>

@class MYSContentView;

@protocol MYSContentViewDelegate <NSObject>
- (void)contentViewPressed:(id)sender;
- (void)contentViewEndTap:(id)sender;
@end

@interface MYSContentView : UIView
@property (nonatomic, strong) id<MYSContentViewDelegate> delegate;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong)UILabel *upLabel;
@property (nonatomic, strong)UILabel *downLabel;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, assign) CGFloat offset;
- (void)launch:(CGFloat)offset;
- (void)snapIn;
- (void)snapOut;

@end
