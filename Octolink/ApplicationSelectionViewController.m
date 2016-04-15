//
//  ApplicationSelectionViewController.m
//  Octolink
//
//  Created by 邦成 吴 on 11/4/2016.
//  Copyright © 2016 carson. All rights reserved.
//

#import "ApplicationSelectionViewController.h"
#import <Contacts/CNContactStore.h>

@interface ApplicationSelectionViewController (){
    NSMutableArray *appIcons;
    Gesture *gesture;
}

@end

@implementation ApplicationSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *cellNib = [UINib nibWithNibName:@"appliactionItem" bundle:nil];
    [self.myCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"cell"];
    [self createDataSource];
    gesture = [[Gesture alloc] init];
    self.title = @"Applications";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createDataSource{
    appIcons = [[NSMutableArray alloc] initWithObjects:@"phone_icon",@"message_icon",@"email_icon",@"location_icon",@"wechat_icon",@"Calendar_icon",@"fantastical_icon",@"facebook_icon",@"instagram_icon",@"twitter_icon",@"qq_icon",@"weibo_icon",@"gmail_icon",@"google_calendar_icon",@"word_icon",@"1",@"2",@"3",@"emergency_icon",@"outlook_icon",@"weather_icon",@"whatsapp_icon", nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UICollectionview DataSource & Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return appIcons.count;
}

#define IMAGE_VIEW ((UIImageView*)[cell viewWithTag:1])
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    IMAGE_VIEW.image = [UIImage imageNamed:appIcons[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            CNContactStore *contactStore = [CNContactStore new];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
                NSLog(@"Access to contacts %@ by user", granted ? @"granted" : @"denied");
                if (granted) {
                    gesture.appType = kPhone;
                    _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
                    [_addressBookController setPeoplePickerDelegate:self];
                    [self presentViewController:_addressBookController animated:YES completion:nil];
                }
            }];
        }
            break;
        case 1:
        {
            //SMS
            CNContactStore *contactStore = [CNContactStore new];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
                NSLog(@"Access to contacts %@ by user", granted ? @"granted" : @"denied");
                if (granted) {
                    gesture.appType = kSMS;
                    _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
                    [_addressBookController setPeoplePickerDelegate:self];
                    [self presentViewController:_addressBookController animated:YES completion:nil];
                }
            }];
        }
            break;
        case 2:
        {
            //EMAIL
            gesture.appType = kEmail;
            gesture.title = @"Send Email";
            GestureSelectionViewController *vc = [[GestureSelectionViewController alloc] initWithGestureData:gesture];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - ABPeoplePickerNavigationControllerDelegate
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person{
    NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc]
                                            initWithObjects:@[@"", @"", @"", @""]
                                            forKeys:@[@"firstName", @"lastName", @"mobileNumber", @"homeNumber"]];
    
    
    CFTypeRef generalCFObject;
    generalCFObject = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"firstName"];
        NSLog(@"first name:%@",(__bridge NSString *)generalCFObject);
        CFRelease(generalCFObject);
    }
    
    generalCFObject = ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"lastName"];
        NSLog(@"first name:%@",(__bridge NSString *)generalCFObject);
        CFRelease(generalCFObject);
    }
    
    ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);

    for (int i=0; i < ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"mobileNumber"];
        }
        
        if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"homeNumber"];
        }
        
        CFRelease(currentPhoneLabel);
        CFRelease(currentPhoneValue);
    }
    CFRelease(phonesRef);
    
    gesture.relatedData = contactInfoDict;
    gesture.title = gesture.appType==kPhone? [NSString stringWithFormat:@"Call %@ %@", [contactInfoDict objectForKey:@"firstName"], [contactInfoDict objectForKey:@"lastName"]]:[NSString stringWithFormat:@"Text %@ %@", [contactInfoDict objectForKey:@"firstName"], [contactInfoDict objectForKey:@"lastName"]];
    
    [_addressBookController dismissViewControllerAnimated:YES completion:^{
        GestureSelectionViewController *vc = [[GestureSelectionViewController alloc] initWithGestureData:gesture];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

@end
