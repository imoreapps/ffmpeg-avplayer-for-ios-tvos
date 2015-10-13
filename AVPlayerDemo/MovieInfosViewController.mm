//
//  MovieInfosViewController.m
//  AVPlayer
//
//  Created by apple on 13-5-29.
//  Copyright (c) 2013年 iMoreApp Inc. All rights reserved.
//

#import "MovieInfosViewController.h"
#import <AVPlayerTouch/AVPlayerTouch.h>

@implementation MovieInfosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        @autoreleasepool {
            NSTimeInterval duration = 0;
            CGSize frameSize = CGSizeZero;
            UIImage *thumbnails = nil;
            
            FFAVParser *mp = [[FFAVParser alloc] init];
            if ([mp open:self.moviePath]) {
                
                duration = mp.duration;
                frameSize = CGSizeMake(mp.frameWidth, mp.frameHeight);
                thumbnails = [mp thumbnailAtTime:fminf(20, mp.duration/2.0)];
                mp = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.durationLabel.text = [FFAVPlayerController formatTimeInterval:duration isLeft:NO];
                self.videoSizeLabel.text = [NSString stringWithFormat:@"%d * %d", (int)frameSize.width, (int)frameSize.height];
                self.thumbnailsImageView.image = thumbnails;
            });
        }
    });
}


@end
