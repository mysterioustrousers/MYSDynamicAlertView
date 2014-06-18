//
//  MYSDynamicContentView.h
//  Pods
//
//  Created by Dan Willoughby on 6/16/14.
//
//

#import <UIKit/UIKit.h>
#import "MYSContentView.h"
@protocol MYSTouchScrollViewDelegate <NSObject>
- (void)contentViewPressed:(id)sender;
- (void)contentViewEndTap:(id)sender;
@end

@interface MYSTouchScrollView : UIScrollView
@property (nonatomic, strong) MYSContentView                 *contentView;
@property (nonatomic, strong) id<MYSTouchScrollViewDelegate> touchDelegate;
@end
