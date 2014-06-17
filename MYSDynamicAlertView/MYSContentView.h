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
@end
