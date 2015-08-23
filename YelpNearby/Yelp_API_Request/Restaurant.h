//
//  Restaurant.h
//  YelpNearby
//
//  Created by Behera, Subhransu on 8/14/13.
//  Copyright (c) 2013 Behera, Subhransu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *thumbURL;
@property (nonatomic, strong) NSString *ratingURL;
@property (nonatomic, strong) NSString *yelpURL;

@end
