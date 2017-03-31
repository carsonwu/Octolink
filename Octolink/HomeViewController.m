//
//  HomeViewController.m
//  Octolink
//
//  Created by 邦成 吴 on 11/4/2016.
//  Copyright © 2016 carson. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController (){
    NSMutableArray *addedGestres;
    
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Octolink";
    [self setupRightBarButton];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_main_interface"]]];
    addedGestres = [NSMutableArray arrayWithArray:[[GestureManager sharedInstance] getAddedGesture]];
    if (addedGestres.count>0) {
        for (Gesture *g in addedGestres){
            UIGestureRecognizer *gsds = g.gesture;
            [gsds addTarget:self action:@selector(gestureHandler:)];
            [gsds setDelegate:self];
            [self.view addGestureRecognizer:gsds];
        }
    }
    [[GestureManager sharedInstance] sameTypeRecognizerHandlingInView:self.view];
}

- (void)setupRightBarButton{
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 25)];
    [menuBtn setImage:[UIImage imageNamed:@"mtripad_topbar_icon_setting"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [menuBtn setContentMode:UIViewContentModeScaleAspectFit];
    UIBarButtonItem* menuBarBtn = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.rightBarButtonItems = @[menuBarBtn];
}

- (void)settingBtnClick:(id)sender{
    SettingViewController *settingVC = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gestureHandler:(UIGestureRecognizer*)sender{
     NSLog(@"touched");
    NSMutableArray *addedGesture = [[GestureManager sharedInstance] getAddedGesture];

    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {//tap
        for (Gesture *g in addedGesture){
            if ([g.gesture isKindOfClass:[sender class]]) {
                UITapGestureRecognizer *savedTap = (UITapGestureRecognizer*)g.gesture;
                UITapGestureRecognizer *senderTap = (UITapGestureRecognizer*)sender;
                if (savedTap.numberOfTouchesRequired == senderTap.numberOfTouchesRequired&&
                    savedTap.numberOfTapsRequired == senderTap.numberOfTapsRequired) {
                    [self performActionForGesture:g];
                }
            }
        }
    }else if ([sender isKindOfClass:[UILongPressGestureRecognizer class]]){//press
        for (Gesture *g in addedGesture){
            if ([g.gesture isKindOfClass:[sender class]]) {
                UILongPressGestureRecognizer *savedTap = (UILongPressGestureRecognizer*)g.gesture;
                UILongPressGestureRecognizer *senderTap = (UILongPressGestureRecognizer*)sender;
                if (savedTap.numberOfTouchesRequired == senderTap.numberOfTouchesRequired) {
                    [self performActionForGesture:g];
                }
            }
        }
    }else if ([sender isKindOfClass:[UISwipeGestureRecognizer class]]){//swipe
        for (Gesture *g in addedGesture){
            if ([g.gesture isKindOfClass:[sender class]]) {
                UISwipeGestureRecognizer *savedTap = (UISwipeGestureRecognizer*)g.gesture;
                UISwipeGestureRecognizer *senderTap = (UISwipeGestureRecognizer*)sender;
                if (savedTap.direction == senderTap.direction) {
                    [self performActionForGesture:g];
                }
            }
        }
    }
}

- (void)performActionForGesture:(Gesture*)gesture{
    
    switch (gesture.appType) {
        case kPhone:{
            NSString *cleanedString = [[[[gesture.relatedData objectForKey:@"mobileNumber"] length]>0? [gesture.relatedData objectForKey:@"mobileNumber"]:[gesture.relatedData objectForKey:@"homeNumber"] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
            NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", escapedPhoneNumber];
            NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
            
            if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
                [[UIApplication sharedApplication] openURL:phoneURL];
            }
            
//            NSString *phoneNumber = [@"tel:" stringByAppendingString:[[gesture.relatedData objectForKey:@"mobileNumber"] length]>0? [gesture.relatedData objectForKey:@"mobileNumber"]:[gesture.relatedData objectForKey:@"homeNumber"]];
//            NSLog(@"tel:%@",phoneNumber);
//            phoneNumber  = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
            break;
        case kSMS:{
            if(![MFMessageComposeViewController canSendText]) {
                [self showAlertViewWithTitle:@"Error" andMessage:@"Your device doesn't support SMS."];
                return;
            }
            NSString *phoneNumber = [@"tel:" stringByAppendingString:[[gesture.relatedData objectForKey:@"mobileNumber"] length]>0? [gesture.relatedData objectForKey:@"mobileNumber"]:[gesture.relatedData objectForKey:@"homeNumber"]];
            NSArray *recipents = @[phoneNumber];
//            NSString *message = [NSString stringWithFormat:@"Just sent the %@ file to your email. Please check!"];
            
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            messageController.messageComposeDelegate = self;
            [messageController setRecipients:recipents];
//            [messageController setBody:message];
            
            [self presentViewController:messageController animated:YES completion:nil];
        }
            break;
        case kEmail:{
            if ([MFMailComposeViewController canSendMail]){
                MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
                mailComposer.mailComposeDelegate = self;
                [self presentViewController:mailComposer animated:YES completion:nil];
            }else{
                [self showAlertViewWithTitle:@"Error" andMessage:@"Please setup your Email account first."];
            }
        }
            break;
        case kLocation:
            
            break;
        case kWechat:
            
            break;
        case kCalendar:
            
            break;
        case kFacebook:
            
            break;

            
        default:
            break;
    }
}

#pragma mark - Touch events detection
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    if (result) {
        //result handling;
    }
    if (error) {
        [self showAlertViewWithTitle:@"Error" andMessage:error.localizedDescription];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{

    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            [self showAlertViewWithTitle:@"Error" andMessage:@"Fail to send SMS."];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)showAlertViewWithTitle:(NSString*)title andMessage:(NSString*)message{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
