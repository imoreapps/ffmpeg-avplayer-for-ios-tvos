//
//  PlayerViewController.m
//  AVPlayerDemo
//
//  Created by apple on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "PlayerViewController.h"
@import tvOSAVPlayerTouch;

@interface PlayerViewController () <FFAVPlayerControllerDelegate>

@end

@implementation PlayerViewController {
  FFAVPlayerController *_avplayController;
  UIView *_glView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // New and initialize FFAVPlayerController instance to prepare for playback
  _avplayController = [[FFAVPlayerController alloc] init];
  _avplayController.delegate = self;
  _avplayController.allowBackgroundPlayback = YES;
  _avplayController.shouldAutoPlay = YES;
  
  // You can disable audio or video stream of av resource, default is kAVStreamDiscardOptionNone.
  // Uncomment below line code, avplayer will only play audio stream.
  // _avplayController.streamDiscardOption = kAVStreamDiscardOptionSubtitle;
  
  NSMutableDictionary *options = [NSMutableDictionary new];
  
  if (!self.mediaURL.isFileURL) {
    options[AVOptionNameAVProbeSize] = @(256*1024); // 256kb, default is 5Mb
    options[AVOptionNameAVAnalyzeduration] = @(1);  // default is 5 seconds
    options[AVOptionNameHttpUserAgent] = @"Mozilla/5.0";
  }
  
  if (self.avFormatName) {
    options[AVOptionNameAVFormatName] = self.avFormatName;
  }
  
  //  _avplayController.enableBuiltinSubtitleRender = NO;
  [_avplayController openMedia:self.mediaURL withOptions:options];
  
}

#pragma mark - FFAVPlayerControllerDelegate

- (void)FFAVPlayerControllerWillLoad:(FFAVPlayerController *)controller {
  NSLog(@"Loading av resource...");
}

- (void)FFAVPlayerControllerDidLoad:(FFAVPlayerController *)controller error:(NSError *)error {
  if (error) {
    NSLog(@"Unable to load av resource!");
  } else {
    NSLog(@"Loaded av resource!");
  }
  
  if (!error) {
    if ([_avplayController hasVideo]) {
      _glView = [_avplayController drawableView];
      _glView.frame = self.view.bounds;
      _glView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      [self.view addSubview:_glView];
    }
  } else {
    NSLog(@"Failed to load video!");
  }
}

// AVPlayer state was changed
- (void)FFAVPlayerControllerDidStateChange:(FFAVPlayerController *)controller {
  AVPlayerState state = [controller playerState];
  
  if (state == kAVPlayerStateFinishedPlayback) {
    
    // For local media file source
    // If playback reached to end, we return to begin of the media file,
    // and pause the palyer to prepare for next playback.
    
    if ([self.mediaURL isFileURL]) {
      [controller seekto:0];
      [controller pause];
    }
  }
}

// AVPlayer current play time was changed
- (void)FFAVPlayerControllerDidCurTimeChange:(FFAVPlayerController *)controller
                                    position:(NSTimeInterval)position {
}

// AVPlayer current subtitle item was changed
- (void)FFAVPlayerControllerDidSubtitleChange:(FFAVPlayerController *)controller
                                 subtitleItem:(FFAVSubtitleItem *)subtitleItem {
  NSLog(@"%@", subtitleItem);
}

// Enter or exit full screen mode
- (void)FFAVPlayerControllerDidEnterFullscreenMode:
(FFAVPlayerController *)controller {
  // Update full screen bar button
}

- (void)FFAVPlayerControllerDidExitFullscreenMode:
(FFAVPlayerController *)controller {
  // Update full screen bar button
}

- (void)FFAVPlayerControllerDidBufferingProgressChange:(FFAVPlayerController *)controller progress:(double)progress {
  // Log the buffering progress info
  //  NSLog(@">>> BUFFERING : %.3f%%", progress*100);
}

- (void)FFAVPlayerControllerDidBitrateChange:(FFAVPlayerController *)controller bitrate:(NSInteger)bitrate {
  // Log the bitrate info
  //  NSLog(@"bitrate : %ld Kbits/s", bitrate);
}

@end
