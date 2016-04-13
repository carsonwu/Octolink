//
//  GestureManager.m
//  Octolink
//
//  Created by 邦成 吴 on 11/4/2016.
//  Copyright © 2016 carson. All rights reserved.
//

#import "GestureManager.h"

@implementation GestureManager

+ (instancetype)sharedInstance
{
    static GestureManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        addedGestures = [[self getAddedGesture] count]>0? [self getAddedGesture]:[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addGesture:(Gesture*)gesture{
    [addedGestures addObject:gesture];
    
    [self saveAddedGestureToUserDefaults:addedGestures];
}

- (NSMutableArray*)getAddedGesture{
    NSMutableArray *encodedArrData = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADDED_GESTURE];
    NSMutableArray *decodedArr = [NSMutableArray array];
    for (NSData* data in encodedArrData){
        Gesture *g = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [decodedArr addObject:g];
    }
    return decodedArr;
}

- (void)removeGesture:(Gesture*)gest{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (Gesture* g in addedGestures){
        if ([g.title isEqualToString:gest.title]) {
            [tempArr addObject:g];
        }
    }
    [addedGestures removeObjectsInArray:tempArr];
    [self saveAddedGestureToUserDefaults:addedGestures];
}

- (void)saveAddedGestureToUserDefaults:(NSMutableArray*)addedGest{
    NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:addedGest.count];
    for (Gesture *g in addedGest) {
        NSData *EncodedObject = [NSKeyedArchiver archivedDataWithRootObject:g];
        [archiveArray addObject:EncodedObject];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:archiveArray forKey:KEY_ADDED_GESTURE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
