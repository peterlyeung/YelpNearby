//
//  ResultTableViewCell.h
//  YelpNearby
//
//  Created by Behera, Subhransu on 8/13/13.
//  Copyright (c) 2013 Behera, Subhransu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;

@end
