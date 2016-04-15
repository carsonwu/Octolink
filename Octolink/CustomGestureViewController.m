//
//  CustomGestureViewController.m
//  Octolink
//
//  Created by 邦成 吴 on 13/4/2016.
//  Copyright © 2016 carson. All rights reserved.
//

#import "CustomGestureViewController.h"

@interface CustomGestureViewController ()

@end

@implementation CustomGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Customization";
    
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 25)];
//    [menuBtn setImage:[UIImage imageNamed:@"mtripad_topbar_icon_setting"] forState:UIControlStateNormal];
    [menuBtn setTitle:@"Save" forState:UIControlStateNormal];
//    [menuBtn addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [menuBtn setContentMode:UIViewContentModeScaleAspectFit];
    UIBarButtonItem* menuBarBtn = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.rightBarButtonItems = @[menuBarBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
