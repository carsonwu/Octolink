//
//  Gesture.h
//  Octolink
//
//  Created by 邦成 吴 on 11/4/2016.
//  Copyright © 2016 carson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, appType)
{
    kPhone = 0,
    kSMS,
    kEmail,
    kLocation,
    kWechat,
    kCalendar,
    kFacebook
};

@interface Gesture : NSObject<NSCoding>

@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIGestureRecognizer *gesture;
@property (strong, nonatomic) NSDictionary *relatedData;
@property appType appType;

- (id)initWithCoder:(NSCoder *)decoder;

@end
