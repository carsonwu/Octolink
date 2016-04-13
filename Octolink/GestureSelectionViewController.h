//
//  GestureSelectionViewController.h
//  Octolink
//
//  Created by 邦成 吴 on 12/4/2016.
//  Copyright © 2016 carson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

typedef NS_ENUM(NSInteger, gestureType1)
{
    kSingleTouch = 0,
    kDoubleTouch,
    kLongTouch,
    kSlideDown,
    kSlideUp,
    kSlideLeft,
    kSlideRight,
};

typedef NS_ENUM(NSInteger, gestureType2)
{
    kSingleTouchTwoFinger = 0,
    kDoubleTouchTwoFinger,
    kLongTouchTwoFinger,
    kSlideUpTwoFinger,
};

@interface GestureSelectionViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;

- (IBAction)customGestureBtnClicked:(id)sender;

- (instancetype)initWithGestureData:(Gesture*)gesture;

@end
