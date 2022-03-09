//
//  SWPEmailViewControllerViewModel.m
//  SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/9.
//  Copyright © 2022 LLLLLayer. All rights reserved.
//

#import "SWPEmailModel.h"
#import "SWPEmailViewControllerViewModel.h"

#import <SwiperKit/SWPSwipeOptions.h>
#import <SwiperKit/SWPSwipeExpansionStyle.h>

@interface SWPEmailViewControllerViewModel ()

@property (nonatomic, strong) SWPSwipeOptions *options;
@property (nonatomic, strong) SWPSwipeOptions *leftOptions;

@end

@implementation SWPEmailViewControllerViewModel

#pragma mark - Public Methond

- (void)showMore
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"SwiperKit"
                                                                             message:@"Swipe Transition Style"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    SWPEmailViewControllerViewModel * __weak weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"Border" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SWPEmailViewControllerViewModel *strongSelf = weakSelf;
        strongSelf.options.transitionStyle = SWPSwipeTransitionStyleBorder;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Drag" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SWPEmailViewControllerViewModel *strongSelf = weakSelf;
        strongSelf.options.transitionStyle = SWPSwipeTransitionStyleDrag;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Reveal" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SWPEmailViewControllerViewModel *strongSelf = weakSelf;
        strongSelf.options.transitionStyle = SWPSwipeTransitionStyleReveal;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Destructive" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SWPEmailViewControllerViewModel *strongSelf = weakSelf;
        strongSelf.options.expansionStyle = [SWPSwipeExpansionStyle destructive];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Destructive After Fill" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SWPEmailViewControllerViewModel *strongSelf = weakSelf;
        strongSelf.options.expansionStyle = [SWPSwipeExpansionStyle destructiveAfterFill];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Destructive Second Confirmation" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SWPEmailViewControllerViewModel *strongSelf = weakSelf;
        strongSelf.options.expansionStyle = [SWPSwipeExpansionStyle destructiveSecondConfirmation];
    }]];
    [[UIApplication sharedApplication].windows.firstObject.rootViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Getter

- (SWPSwipeOptions *)options
{
    if (!_options) {
        _options = [[SWPSwipeOptions alloc] init];
        _options.backgroundColor = [UIColor clearColor];
        _options.expansionStyle = [SWPSwipeExpansionStyle destructiveAfterFill];
    }
    return _options;
}

- (SWPSwipeOptions *)leftOptions
{
    if (!_leftOptions) {
        _leftOptions = [[SWPSwipeOptions alloc] init];
        _leftOptions.backgroundColor = [UIColor clearColor];
        _leftOptions.expansionStyle = [SWPSwipeExpansionStyle selection];
    }
    return _leftOptions;
}

- (NSArray<NSArray<SWPEmailModel *> *> *)sections
{
    if (!_sections) {
        _sections = @[@[
            [[SWPEmailModel alloc] initWithTitle:@"Realm"
                                        subtitle:@"Video: Operators and Strong Opinions with Erica Sadun"
                                            body:@"Swift operators are flexible and powerful. They’re symbols that behave like functions, adopting a natural mathematical syntax, for example 1 + 2 versus add(1, 2). So why is it so important that you treat them like potential Swift Kryptonite? Erica Sadun discusses why your operators should be few, well-chosen, and heavily used. There’s even a fun interactive quiz! Play along with “Name That Operator!” and learn about an essential Swift best practice."
                                            date:[NSDate date]
                                            read:false],
            [[SWPEmailModel alloc] initWithTitle:@"The Pragmatic Bookstore"
                                        subtitle:@"[Pragmatic Bookstore] Your eBook 'Swift Style' is ready for download"
                                            body:@"Hello, The gerbils at the Pragmatic Bookstore have just finished hand-crafting your eBook of Swift Style. It's available for download at the following URL:"
                                            date:[NSDate date]
                                            read:false],
            [[SWPEmailModel alloc] initWithTitle:@"Instagram"
                                        subtitle:@"mrx, go live and send disappearing photos and videos"
                                            body:@"Go Live and Send Disappearing Photos and Videos. We recently announced two updates: live video on Instagram Stories and disappearing photos and videos for groups and friends in Instagram Direct."
                                            date:[NSDate date]
                                            read:false],
            [[SWPEmailModel alloc] initWithTitle:@"Smithsonian Magazine"
                                        subtitle:@"Exclusive Sneak Peek Inside | Untold Stories of the Civil War"
                                            body:@"For the very first time, the Smithsonian showcases the treasures of its Civil War collections in Smithsonian Civil War. This 384-page, hardcover book takes readers inside the museum storerooms and vaults to learn the untold stories behind the Smithsonian's most fascinating and significant pieces, including many previously unseen relics and artifacts. With over 500 photographs and text from forty-nine curators, the Civil War comes alive."
                                            date:[NSDate date]
                                            read:false],
            [[SWPEmailModel alloc] initWithTitle:@"Apple News"
                                        subtitle:@"How to Change Your Personality in 90 Days"
                                            body:@"How to Change Your Personality. You are not stuck with yourself. New research shows that you can troubleshoot personality traits — in therapy."
                                            date:[NSDate date]
                                            read:false],
            [[SWPEmailModel alloc] initWithTitle:@"Wordpress"
                                        subtitle:@"New WordPress Site"
                                            body:@"Your new WordPress site has been successfully set up at: http://example.com. You can log in to the administrator account with the following information:"
                                            date:[NSDate date]
                                            read:false],
            [[SWPEmailModel alloc] initWithTitle:@"IFTTT"
                                        subtitle:@"See what’s new & notable on IFTTT"
                                            body:@"See what’s new & notable on IFTTT. To disable these emails, sign in to manage your settings or unsubscribe."
                                            date:[NSDate date]
                                            read:false],
            [[SWPEmailModel alloc] initWithTitle:@"Westin Vacations"
                                        subtitle:@"Your Westin exclusive expires January 11"
                                            body:@"Last chance to book a captivating 5-day, 4-night vacation in Rancho Mirage for just $389. Learn more. No images? CLICK HERE"
                                            date:[NSDate date]
                                            read:false],
            [[SWPEmailModel alloc] initWithTitle:@"Nugget Markets"
                                        subtitle:@"Nugget Markets Weekly Specials Starting February 15, 2017"
                                            body:@"Scan & Save. For this week’s Secret Special, let’s “brioche” the subject of breakfast. This Friday and Saturday, February 24–25, buy one loaf of Euro Classic Brioche and get one free! This light, soft, hand-braided buttery brioche loaf from France is perfect for an authentic French toast feast. Make Christmas morning extra special with our Signature Recipe for Crème Brûlée French Toast Soufflé!"
                                            date:[NSDate date]
                                            read:false],
            [[SWPEmailModel alloc] initWithTitle:@"GeekDesk"
                                        subtitle:@"We have some exciting things happening at GeekDesk!"
                                            body:@"Wouldn't everyone be so much happier if we all owned GeekDesks?"
                                            date:[NSDate date]
                                            read:false]
        ]];
    }
    return _sections;
}

@end
