//
//  SWPSwipeCollectionViewCell+Display.h
//  SwiperKit
//
//  Created by yangjie.layer on 2022/2/26.
//

#import <SwiperKit/SWPSwipeCollectionViewCell.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SWPSwipeActionsOrientation);

@interface SWPSwipeCollectionViewCell (Display)

- (void)hideSwipeWithAnimated:(BOOL)animated complation:(void(^ _Nullable)(BOOL complete))complation;

- (void)showSwipeWithOrientation:(SWPSwipeActionsOrientation)orientation animated:(BOOL)animated complation:(void(^ _Nullable)(BOOL complete))complation;

- (void)setOffset:(CGFloat)offset animated:(BOOL)animated completion:(void(^ _Nullable)(BOOL completed))completion;

@end

NS_ASSUME_NONNULL_END
