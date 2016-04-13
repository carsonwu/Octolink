//
//  HomeViewController.h
//  Octolink
//
//  Created by 邦成 吴 on 11/4/2016.
//  Copyright © 2016 carson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"
#import <MessageUI/MessageUI.h>

@interface HomeViewController : UIViewController<UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate>

- (void)gestureHandler:(UIGestureRecognizer*)sender;

@end
