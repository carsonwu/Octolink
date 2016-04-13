//
//  SettingViewController.m
//  Octolink
//
//  Created by 邦成 吴 on 11/4/2016.
//  Copyright © 2016 carson. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController{
    NSArray* gestureDataSource;
    NSArray* langDataSource;
    NSArray* dayNightModeDataSource;
    NSArray* gestureImages;
    NSMutableArray *dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Setting";
    [self createDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createDataSource{
    NSMutableArray *gestures = [[NSMutableArray alloc] initWithObjects:@"New action", nil];
    [gestures addObjectsFromArray:[[GestureManager sharedInstance] getAddedGesture]];
    gestureDataSource = [NSArray arrayWithArray:gestures];
//    gestureImages = @[@"double_click", @"hold", @"two_fingers_double_click", @"two_fingers_swipe_up"];
    langDataSource = @[@"English", @"中文"];
    dayNightModeDataSource = @[@"Day Mode", @"Night Mode"];
    dataSource = [[NSMutableArray alloc] initWithObjects:langDataSource, dayNightModeDataSource, gestureDataSource, nil];
}

#pragma mark - UITableview DataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *headerTitle;
    switch (section) {
        case 0:
            headerTitle = @"Language";
            break;
        case 1:
            headerTitle = @"Mode";
            break;
        case 2:
            headerTitle = @"Gesture";
            break;
            
        default:
            break;
    }
    return headerTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row != 0) {
            Gesture *g = [[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.imageView.image = g.icon;
            cell.textLabel.text = g.title;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
    }else{
        cell.textLabel.text = [[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 0) {
        //
        ApplicationSelectionViewController *selectionVC = [[ApplicationSelectionViewController alloc] initWithNibName:@"ApplicationSelectionViewController" bundle:nil];
        [self.navigationController pushViewController:selectionVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return YES - we will be able to delete all rows
    if (indexPath.section == 2 && indexPath.row!=0) {
        return YES;
    }else{
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    NSLog(@"Deleted row.");
    if (indexPath.section == 2 && indexPath.row!=0) {
        Gesture *g = [[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [[GestureManager sharedInstance] removeGesture:g];
        [self createDataSource];
        [tableView reloadData];
    }
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
