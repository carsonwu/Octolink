//
//  GestureManager.h
//  Octolink
//
//  Created by 邦成 吴 on 11/4/2016.
//  Copyright © 2016 carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gesture.h"

#define KEY_ADDED_GESTURE @"addedGesture"

@interface GestureManager : NSObject{
    NSMutableArray *addedGestures;
}

+ (instancetype)sharedInstance;

- (void)removeGesture:(Gesture*)gesture;
- (NSMutableArray*)getAddedGesture;
- (void)addGesture:(Gesture*)gesture;

@end
