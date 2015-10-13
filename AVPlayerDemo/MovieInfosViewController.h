//
//  MovieInfosViewController.h
//  AVPlayer
//
//  Created by apple on 13-5-29.
//  Copyright (c) 2013年 iMoreApp Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieInfosViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
@property (nonatomic, weak) IBOutlet UILabel *videoSizeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailsImageView;

@property (nonatomic, strong) NSString *moviePath;

@end
