//
//  GestureSelectionViewController.m
//  Octolink
//
//  Created by 邦成 吴 on 12/4/2016.
//  Copyright © 2016 carson. All rights reserved.
//

#import "GestureSelectionViewController.h"

@interface GestureSelectionViewController (){
    NSMutableArray *gestureIconsWithOneFinger, *gestureIconsWithTwoFinger, *gestureIconsWithThreeFinger;
    NSMutableArray *gestureIconsWithOneFingerImg, *gestureIconsWithTwoFingerImg, *gestureIconsWithThreeFingerImg;
    NSMutableArray *dataSource, *dataSourceImg;
    Gesture *gest;
    HomeViewController *home;
}

@end

@implementation GestureSelectionViewController

- (instancetype)initWithGestureData:(Gesture*)gesture{
    if (self == [super initWithNibName:@"GestureSelectionViewController" bundle:nil]) {
        gest = gesture;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *cellNib = [UINib nibWithNibName:@"gestureItem" bundle:nil];
    [self.myCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"cell"];

    [self createDataSource];
    home = (HomeViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    self.title = @"Gestures";
}

- (void)createDataSource{
    gestureIconsWithOneFinger = [NSMutableArray arrayWithObjects:@"action_group", @"double_click", @"hold", @"swipe_down", @"swipe_up", @"swipe_left", @"swipe_right", nil];
    gestureIconsWithOneFingerImg = [NSMutableArray arrayWithObjects:@"Single touch", @"Double touch", @"Long touch", @"Slide down", @"Slide up", @"Slide left", @"Slide right", nil];
    
    gestureIconsWithTwoFinger = [NSMutableArray arrayWithObjects:@"two_fingers_click", @"two_fingers_double_click", @"two_fingers_hold", @"two_fingers_swipe_up", nil];
    gestureIconsWithTwoFingerImg = [NSMutableArray arrayWithObjects:@"Single touch two fingers", @"Double touch two fingers", @"Long touch two fingers", @"Slide up two fingers", nil];
    
    gestureIconsWithThreeFinger = [NSMutableArray arrayWithObjects:@"three_fingers_click", @"three_fingers_swipe_up", nil];
    gestureIconsWithThreeFingerImg = [NSMutableArray arrayWithObjects:@"Single touch three fingers", @"Slide up three fingers", nil];
    dataSource = [NSMutableArray arrayWithObjects:gestureIconsWithOneFinger, gestureIconsWithTwoFinger, gestureIconsWithThreeFinger, nil];
    dataSourceImg = [NSMutableArray arrayWithObjects:gestureIconsWithOneFingerImg, gestureIconsWithTwoFingerImg, gestureIconsWithThreeFingerImg, nil];
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
#pragma mark - UICollectionview DataSource & Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [dataSource[section] count];
}

#define IMAGE_VIEW ((UIImageView*)[cell viewWithTag:1])
#define LABEL ((UILabel*)[cell viewWithTag:2])
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableArray *arr = dataSource[indexPath.section];
    NSMutableArray* imgArr = [dataSourceImg objectAtIndex:indexPath.section];
    IMAGE_VIEW.image = [UIImage imageNamed:arr[indexPath.row]];
    LABEL.text = [imgArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case kSingleTouch:
                    gest.gesture = [self createTapGestureWithFingerCount:1 andTapCount:1];
                    break;
                case kDoubleTouch:
                    gest.gesture = [self createTapGestureWithFingerCount:1 andTapCount:2];
                    break;
                case kLongTouch:
                    gest.gesture = [self createLongPressGestureWithFingerCount:1];
                    break;
                case kSlideDown:
                    gest.gesture = [self createSwipeGestureWithFingerCount:1 andDirection:UISwipeGestureRecognizerDirectionDown];
                    break;
                case kSlideUp:
                    gest.gesture = [self createSwipeGestureWithFingerCount:1 andDirection:UISwipeGestureRecognizerDirectionUp];
                    break;
                case kSlideLeft:
                    gest.gesture = [self createSwipeGestureWithFingerCount:1 andDirection:UISwipeGestureRecognizerDirectionLeft];
                    break;
                case kSlideRight:
                    gest.gesture = [self createSwipeGestureWithFingerCount:1 andDirection:UISwipeGestureRecognizerDirectionRight];
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case kSingleTouchTwoFinger:
                    gest.gesture = [self createTapGestureWithFingerCount:2 andTapCount:1];
                    break;
                case kDoubleTouchTwoFinger:
                    gest.gesture = [self createTapGestureWithFingerCount:2 andTapCount:2];
                    break;
                case kLongTouchTwoFinger:
                    gest.gesture = [self createLongPressGestureWithFingerCount:2];
                    break;
                case kSlideUpTwoFinger:
                    gest.gesture = [self createSwipeGestureWithFingerCount:2 andDirection:UISwipeGestureRecognizerDirectionUp];
                    break;
                    
                default:
                    break;
            }
            break;
        case 2:
            //TODO: Three finger gesture
            break;
            
        default:
            break;
    }
    gest.icon = [UIImage imageNamed:[dataSource[indexPath.section] objectAtIndex:indexPath.row]];
    [[GestureManager sharedInstance] addGesture:gest];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"Your gesture is successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (UITapGestureRecognizer *)createTapGestureWithFingerCount:(int)numberOfFingers andTapCount:(int)numberOfTabs{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:home action:@selector(gestureHandler:)];
    tap.delegate = home;
    tap.numberOfTapsRequired = numberOfTabs;
    tap.numberOfTouchesRequired = numberOfFingers;
    [home.view addGestureRecognizer:tap];
    return tap;
}

- (UILongPressGestureRecognizer *)createLongPressGestureWithFingerCount:(int)numberOfFingers{
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:home action:@selector(gestureHandler:)];
    longGesture.delegate = home;
    longGesture.numberOfTouchesRequired = numberOfFingers;
    [home.view addGestureRecognizer:longGesture];
    return longGesture;
}

- (UISwipeGestureRecognizer *)createSwipeGestureWithFingerCount:(int)numberOfFingers andDirection:(UISwipeGestureRecognizerDirection)direction{
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:home action:@selector(gestureHandler:)];
    swipeGesture.delegate = home;
    swipeGesture.numberOfTouchesRequired = numberOfFingers;
    swipeGesture.direction = direction;
    [home.view addGestureRecognizer:swipeGesture];
    return swipeGesture;
}

- (IBAction)customGestureBtnClicked:(id)sender {
    CustomGestureViewController *customVC = [[CustomGestureViewController alloc] initWithNibName:@"CustomGestureViewController" bundle:nil];
    [self.navigationController pushViewController:customVC animated:YES];
}
@end
