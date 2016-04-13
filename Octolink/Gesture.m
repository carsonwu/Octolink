//
//  Gesture.m
//  Octolink
//
//  Created by 邦成 吴 on 11/4/2016.
//  Copyright © 2016 carson. All rights reserved.
//

#import "Gesture.h"

@implementation Gesture

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.gesture forKey:@"gesture"];
    [aCoder encodeInteger:self.appType forKey:@"appType"];
    [aCoder encodeObject:self.relatedData forKey:@"relatedData"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.icon = [decoder decodeObjectForKey:@"icon"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.gesture = [decoder decodeObjectForKey:@"gesture"];
        self.appType = [decoder decodeIntegerForKey:@"appType"];
        self.relatedData = [decoder decodeObjectForKey:@"relatedData"];
    }
    return self;
}

@end
