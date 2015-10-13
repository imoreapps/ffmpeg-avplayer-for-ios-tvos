//
//  PlayerViewController.h
//  AVPlayer
//
//  Created by apple on 13-5-22.
//  Copyright (c) 2013年 iMoreApp Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVPlayerTouch/AVPlayerTouch.h>

@interface PlayerViewController : UIViewController

// audio or video url (local or network)
@property (nonatomic, strong) NSURL *mediaURL;

// input av format name (default is nil)
@property (nonatomic, strong) NSString *avFormatName;

// did load video successfully callback.
@property (nonatomic, copy) void (^didLoadVideo)(FFAVPlayerController *player);

// get start playback time (>= 0 and <= media duration).
// if the property is nil, player will start playback from begining.
// the callback returns a float number value or nil.
@property (nonatomic, copy) NSNumber* (^getStartTime)(FFAVPlayerController *player, NSURL *url);

// required saving progress info, you can save progress here.
@property (nonatomic, copy) void (^saveProgress)(FFAVPlayerController *player);

// on video playback did finish.
@property (nonatomic, copy) void (^didFinishPlayback)(FFAVPlayerController *player);

// on video player controller will be dismissed.
@property (nonatomic, copy) void (^willDismiss)(void);

// Start playback at special time position
- (void)startPlaybackAt:(NSNumber *)startTimePosition;

@end
