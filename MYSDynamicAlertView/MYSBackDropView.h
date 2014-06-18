//
//  MYSBackDropView.h
//  Pods
//
//  Created by Dan Willoughby on 6/16/14.
//
//

#import <UIKit/UIKit.h>

@interface MYSBackDropView : UIView
@property (nonatomic, strong) UILabel *upLabel;
@property (nonatomic, strong) UILabel *downLabel;
@property (nonatomic, assign) CGFloat scrollViewOffset;
@property (nonatomic, assign) BOOL    isLaunching;
@property (nonatomic, assign) BOOL    isReadyToLaunch;
- (void)snapOut:(BOOL)animated;
- (void)snapIn:(BOOL)animated;
@end
