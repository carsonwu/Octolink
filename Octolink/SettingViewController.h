//
//  SettingViewController.h
//  Octolink
//
//  Created by 邦成 吴 on 11/4/2016.
//  Copyright © 2016 carson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationSelectionViewController.h"
#import "Gesture.h"
#import "HomeViewController.h"

@interface SettingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
