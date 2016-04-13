//
//  ApplicationSelectionViewController.h
//  Octolink
//
//  Created by 邦成 吴 on 11/4/2016.
//  Copyright © 2016 carson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Gesture.h"
#import "GestureSelectionViewController.h"


@interface ApplicationSelectionViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, ABPeoplePickerNavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;

@end
