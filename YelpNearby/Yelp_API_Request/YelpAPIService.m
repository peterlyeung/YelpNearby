//
//  YelpAPIService.m
//  YelpNearby
//
//  Created by Behera, Subhransu on 8/14/13.
//  Copyright (c) 2013 Behera, Subhransu. All rights reserved.
//

#import "YelpAPIService.h"
#import "OAuthAPIConstants.h"
#import "Restaurant.h"

#define SEARCH_RESULT_LIMIT 10

@implementation YelpAPIService

-(void)searchNearByRestaurantsByFilter:(NSString *)categoryFilter atLatitude:(CLLocationDegrees)latitude
                          andLongitude:(CLLocationDegrees)longitude {
    
    NSString *urlString = [NSString stringWithFormat:@"%@?term=%@&category_filter=%@&ll=%f,%f",
                           YELP_SEARCH_URL,
                           @"restaurants",
                           categoryFilter,
                           latitude, longitude];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
                                                    secret:OAUTH_CONSUMER_SECRET];
    
    OAToken *token = [[OAToken alloc] initWithKey:OAUTH_TOKEN
                                           secret:OAUTH_TOKEN_SECRET];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    
    [request prepare];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn) {
        self.urlRespondData = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.urlRespondData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [self.urlRespondData appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {    
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Failed to connect to speech server"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *e = nil;
    
    NSDictionary *resultResponseDict = [NSJSONSerialization JSONObjectWithData:self.urlRespondData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&e];
    if (self.resultArray && [self.resultArray count] > 0) {
        [self.resultArray removeAllObjects];
    }
    
    if (!self.resultArray) {
        self.resultArray = [[NSMutableArray alloc] init];
    }
    
    if (resultResponseDict && [resultResponseDict count] > 0) {        
        if ([resultResponseDict objectForKey:@"businesses"] &&
            [[resultResponseDict objectForKey:@"businesses"] count] > 0) {
            for (NSDictionary *restaurantDict in [resultResponseDict objectForKey:@"businesses"]) {
                Restaurant *restaurantObj = [[Restaurant alloc] init];
                restaurantObj.name = [restaurantDict objectForKey:@"name"];
                restaurantObj.thumbURL = [restaurantDict objectForKey:@"image_url"];
                restaurantObj.ratingURL = [restaurantDict objectForKey:@"rating_img_url"];
                restaurantObj.yelpURL = [restaurantDict objectForKey:@"url"];
                restaurantObj.address = [[[restaurantDict objectForKey:@"location"] objectForKey:@"address"] componentsJoinedByString:@", "];
                
                [self.resultArray addObject:restaurantObj];
            }
        }
    }
    
    [self.delegate loadResultWithDataArray:self.resultArray];
}



@end
