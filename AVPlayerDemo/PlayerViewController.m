//
//  PlayerViewController.m
//  AVPlayer
//
//  Created by apple on 2/27/14.
//  Copyright (c) 2014 iMoreApps Inc. All rights reserved.
//

#import "PlayerViewController.h"
#import "UIAlertView+Blocks.h"
#import "AdjustSpeedView.h"
#import "VideoEffectView.h"

#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerViewController () <FFAVPlayerControllerDelegate> {
  FFAVPlayerController *_avplayController;

  BOOL _prevStatusBarHidden;
  UIStatusBarStyle _prevStatusBarStyle;

  UINavigationBar *_topBar;
  UIView *_topHUD;
  UIView *_bottomHUD;
  UISlider *_progressSlider;
  UISlider *_volumeSlider;
  UIButton *_playButton;
  UIButton *_rewindButton;
  UIButton *_forwardButton;
  UIButton *_muteButton;
  UILabel *_progressLabel;
  UILabel *_leftLabel;
  
  // Aspect ratio
  UIBarButtonItem *_fullscreenButton;
  NSArray *_videoAspectRatios;
  NSInteger _videoAspectRatioIndex;

  AdjustSpeedView *_adjustSpeedView;
  VideoEffectView *_videoEffectView;

  BOOL _hudVisible;
  UIView *_glView;
  UIImageView *_coverImageView;
  UITapGestureRecognizer *_tapGestureRecognizer;
  UIActivityIndicatorView *_loadingIndicatorView;

  // Interruption handler
  BOOL _isPlayingBeforeInterrupted;
  
  // Muted handler
  BOOL _isMuted;
}
@end

@implementation PlayerViewController

// Initialize self

- (void)commonInit {
  // Hold status bar infos
  _prevStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
  _prevStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;

  // Other initalization
  _hudVisible = YES;
  _isPlayingBeforeInterrupted = NO;
  _isMuted = NO;
  
  _videoAspectRatioIndex = 0;
  _videoAspectRatios = @[ @(0),       // Default
                          @(-1),      // FULL Screen
                          @(4/3.0f),  // 4:3
                          @(5/4.0f),  // 5:4
                          @(16/9.0f), // 16:9
                          @(16/10.0f),// 16:10
                          @(2.21/1.0f)// 2.21:1
                          ];
}

- (id)init {
  self = [super init];
  if (self) {
    // Initialize self
    [self commonInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    // Initialize self
    [self commonInit];
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Initialize self
    [self commonInit];
  }
  return self;
}

- (void)dealloc {
  // Unregister all notifications
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
  // Reset now playing media info center
  [self resetNowPlayingMediaInfoCenter];
}

// Load root view
- (void)loadView {
  CGRect bounds = [[UIScreen mainScreen] applicationFrame];

  self.view = [[UIView alloc] initWithFrame:bounds];
  self.view.backgroundColor = [UIColor blackColor];
  self.view.autoresizesSubviews = YES;
}

// Build up sub-views

- (void)buildViews {
  CGRect bounds = self.view.bounds;

  CGFloat width = bounds.size.width;
  CGFloat height = bounds.size.height;

  CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
  CGFloat statusbarHeight = fminf(statusBarSize.width, statusBarSize.height);

  // Top HUD
  _topBar = [[UINavigationBar alloc]
      initWithFrame:CGRectMake(0, statusbarHeight, width, 44)];
  _topBar.barStyle = UIBarStyleBlackTranslucent;
  _topBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [self.view addSubview:_topBar];

  UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
  [_topBar pushNavigationItem:navigationItem animated:NO];

  navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                           target:self
                           action:@selector(doneDidTouch:)];
  navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"avplayer.bundle/zoomin"]
              style:UIBarButtonItemStyleBordered
             target:self
             action:@selector(fullscreenDidTouch:)];
  _fullscreenButton = navigationItem.rightBarButtonItem;

  CGFloat titleViewWidth = width - 120;
  UIView *titleView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleViewWidth, 44)];
  titleView.backgroundColor = [UIColor clearColor];
  titleView.autoresizesSubviews = YES;
  titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

  navigationItem.titleView = titleView;

  _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 50, 20)];
  _progressLabel.backgroundColor = [UIColor clearColor];
  _progressLabel.adjustsFontSizeToFitWidth = NO;
  _progressLabel.textAlignment = NSTextAlignmentRight;
  _progressLabel.textColor = [UIColor whiteColor];
  _progressLabel.text = @"00:00:00";
  _progressLabel.font = [UIFont systemFontOfSize:12];
  [titleView addSubview:_progressLabel];

  _progressSlider = [[UISlider alloc]
      initWithFrame:CGRectMake(52, 7, titleViewWidth - 100 - 4, 32)];
  _progressSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  _progressSlider.continuous = YES;
  _progressSlider.value = 0;
  [_progressSlider addTarget:self
                      action:@selector(progressSliderChanged:)
            forControlEvents:UIControlEventValueChanged];
  [titleView addSubview:_progressSlider];

  _leftLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(titleViewWidth - 50, 13, 50, 20)];
  _leftLabel.backgroundColor = [UIColor clearColor];
  _leftLabel.adjustsFontSizeToFitWidth = NO;
  _leftLabel.textAlignment = NSTextAlignmentLeft;
  _leftLabel.textColor = [UIColor whiteColor];
  _leftLabel.text = @"-99:59:59";
  _leftLabel.font = [UIFont systemFontOfSize:12];
  _leftLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
  [titleView addSubview:_leftLabel];

  // Top HUD
  _topHUD = [[UIView alloc] init];
  _topHUD.frame = CGRectMake(
      0, _topBar.frame.origin.y + _topBar.bounds.size.height, width, 64);
  _topHUD.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
  _topHUD.autoresizesSubviews = YES;
  _topHUD.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
  [self.view addSubview:_topHUD];

  UIButton *buttonPlaybackSpeed;
  buttonPlaybackSpeed = [UIButton buttonWithType:UIButtonTypeCustom];
  buttonPlaybackSpeed.frame = CGRectMake(24, 16, 32, 32);
  buttonPlaybackSpeed.backgroundColor = [UIColor clearColor];
  buttonPlaybackSpeed.showsTouchWhenHighlighted = YES;
  [buttonPlaybackSpeed
      setImage:[UIImage imageNamed:@"avplayer.bundle/speedIcon"]
      forState:UIControlStateNormal];
  [buttonPlaybackSpeed addTarget:self
                          action:@selector(adjustSpeedDidTouch:)
                forControlEvents:UIControlEventTouchUpInside];
  [_topHUD addSubview:buttonPlaybackSpeed];

  UIButton *buttonAudioTracker;
  buttonAudioTracker = [UIButton buttonWithType:UIButtonTypeCustom];
  buttonAudioTracker.frame = CGRectMake(104, 16, 32, 32);
  buttonAudioTracker.backgroundColor = [UIColor clearColor];
  buttonAudioTracker.showsTouchWhenHighlighted = YES;
  [buttonAudioTracker
      setImage:[UIImage imageNamed:@"avplayer.bundle/audioTrackIcon"]
      forState:UIControlStateNormal];
  [buttonAudioTracker addTarget:self
                         action:@selector(selectAudioTrackDidTouch:)
               forControlEvents:UIControlEventTouchUpInside];
  [_topHUD addSubview:buttonAudioTracker];

  UIButton *buttonSubtitleStream;
  buttonSubtitleStream = [UIButton buttonWithType:UIButtonTypeCustom];
  buttonSubtitleStream.frame = CGRectMake(184, 16, 32, 32);
  buttonSubtitleStream.backgroundColor = [UIColor clearColor];
  buttonSubtitleStream.showsTouchWhenHighlighted = YES;
  [buttonSubtitleStream
      setImage:[UIImage imageNamed:@"avplayer.bundle/subtitleIcon"]
      forState:UIControlStateNormal];
  [buttonSubtitleStream addTarget:self
                           action:@selector(selectSubtitleDidTouch:)
                 forControlEvents:UIControlEventTouchUpInside];
  [_topHUD addSubview:buttonSubtitleStream];

  UIButton *buttonVideoEffect;
  buttonVideoEffect = [UIButton buttonWithType:UIButtonTypeCustom];
  buttonVideoEffect.frame = CGRectMake(264, 16, 32, 32);
  buttonVideoEffect.backgroundColor = [UIColor clearColor];
  buttonVideoEffect.showsTouchWhenHighlighted = YES;
  [buttonVideoEffect
      setImage:[UIImage imageNamed:@"avplayer.bundle/videoEffectsIcon"]
      forState:UIControlStateNormal];
  [buttonVideoEffect addTarget:self
                        action:@selector(videoEffectDidTouch:)
              forControlEvents:UIControlEventTouchUpInside];
  [_topHUD addSubview:buttonVideoEffect];

  // Bottom HUD
  UIImage *backgroundImage;
  CGSize bottomHUDSize = CGSizeZero;

  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    backgroundImage =
        [UIImage imageNamed:@"avplayer.bundle/hudbackground_iphone"];
    bottomHUDSize = CGSizeMake(314, 93);
  } else {
    backgroundImage =
        [UIImage imageNamed:@"avplayer.bundle/hudbackground_ipad"];
    bottomHUDSize = CGSizeMake(431, 91);
  }

  CGFloat yoffset =
      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 15 : 48);
  CGRect bottomHUDRect = CGRectMake((width - bottomHUDSize.width) / 2,
                                    height - (bottomHUDSize.height + yoffset),
                                    bottomHUDSize.width, bottomHUDSize.height);

  _bottomHUD = [[UIView alloc] initWithFrame:bottomHUDRect];
  _bottomHUD.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
  _bottomHUD.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
                                UIViewAutoresizingFlexibleRightMargin |
                                UIViewAutoresizingFlexibleLeftMargin;
  [self.view addSubview:_bottomHUD];

  width = _bottomHUD.bounds.size.width;

  _rewindButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _rewindButton.frame = CGRectMake(width * 0.5 - 75, 8, 40, 40);
  _rewindButton.backgroundColor = [UIColor clearColor];
  _rewindButton.showsTouchWhenHighlighted = YES;
  [_rewindButton setImage:[UIImage imageNamed:@"avplayer.bundle/playback_prev"]
                 forState:UIControlStateNormal];
  [_rewindButton addTarget:self
                    action:@selector(rewindDidTouch:)
          forControlEvents:UIControlEventTouchUpInside];
  [_bottomHUD addSubview:_rewindButton];

  _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _playButton.frame = CGRectMake(width * 0.5 - 20, 8, 40, 40);
  _playButton.backgroundColor = [UIColor clearColor];
  _playButton.showsTouchWhenHighlighted = YES;
  [_playButton setImage:[UIImage imageNamed:@"avplayer.bundle/playback_play"]
               forState:UIControlStateNormal];
  [_playButton addTarget:self
                  action:@selector(playDidTouch:)
        forControlEvents:UIControlEventTouchUpInside];
  [_bottomHUD addSubview:_playButton];

  _forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _forwardButton.frame = CGRectMake(width * 0.5 + 35, 8, 40, 40);
  _forwardButton.backgroundColor = [UIColor clearColor];
  _forwardButton.showsTouchWhenHighlighted = YES;
  [_forwardButton setImage:[UIImage imageNamed:@"avplayer.bundle/playback_ff"]
                  forState:UIControlStateNormal];
  [_forwardButton addTarget:self
                     action:@selector(forwardDidTouch:)
           forControlEvents:UIControlEventTouchUpInside];
  [_bottomHUD addSubview:_forwardButton];
  
  _muteButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _muteButton.frame = CGRectMake(width - 48, 8, 40, 40);
  _muteButton.backgroundColor = [UIColor clearColor];
  _muteButton.showsTouchWhenHighlighted = YES;
  [_muteButton setImage:[UIImage imageNamed:@"avplayer.bundle/unmuted"]
               forState:UIControlStateNormal];
  [_muteButton addTarget:self
                  action:@selector(mutedDidTouch:)
        forControlEvents:UIControlEventTouchUpInside];
  [_bottomHUD addSubview:_muteButton];

  _volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 55, width - (10 * 2), 20)];
  _volumeSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [_volumeSlider addTarget:self
                    action:@selector(volumeDidChange:)
          forControlEvents:UIControlEventValueChanged];
  [_bottomHUD addSubview:_volumeSlider];
  
  // Loading Indicator View
  _loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  _loadingIndicatorView.hidesWhenStopped = YES;
  [self.view addSubview:_loadingIndicatorView];
}

- (UIImageView *)coverImageView {
  if (_coverImageView == nil) {
    // Cover image view
    CGRect r = self.view.bounds;
    UIImage *image = [UIImage imageNamed:@"avplayer.bundle/music_icon"];

    _coverImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    _coverImageView.hidden = YES;
    _coverImageView.contentMode = UIViewContentModeCenter;
    _coverImageView.backgroundColor = [UIColor clearColor];
    _coverImageView.image = image;
    _coverImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
                                       UIViewAutoresizingFlexibleBottomMargin |
                                       UIViewAutoresizingFlexibleRightMargin |
                                       UIViewAutoresizingFlexibleLeftMargin;

    [self.view addSubview:_coverImageView];
    _coverImageView.center = CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r));
  }

  return _coverImageView;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Build sub-views
  [self buildViews];
  
  // Listen audio session interruption notification
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(handleAudioSessionInterruption:)
   name:AVAudioSessionInterruptionNotification
   object:[AVAudioSession sharedInstance]];

  // Re-active audio session
  [self toggleAudioSession:YES];

  // Sync the volume slider with current system volume
  _volumeSlider.value = [FFAVPlayerController currentVolume];

  // New and initialize FFAVPlayerController instance to prepare for playback
  _avplayController = [[FFAVPlayerController alloc] init];
  _avplayController.delegate = self;
  _avplayController.allowBackgroundPlayback = YES;
  _avplayController.shouldAutoPlay = (_getStartTime == nil ? YES : NO);
  
  // You can disable audio or video stream of av resource, default is kAVStreamDiscardOptionNone.
  // Uncomment below line code, avplayer will only play audio stream.
  // _avplayController.streamDiscardOption = kAVStreamDiscardOptionVideo;

  NSMutableDictionary *options = [NSMutableDictionary new];
  
  if (!self.mediaURL.isFileURL) {
    options[AVOptionNameAVProbeSize] = @(256*1024); // 256kb, default is 5Mb
    options[AVOptionNameAVAnalyzeduration] = @(1);  // default is 5 seconds
    options[AVOptionNameHttpUserAgent] = @"Mozilla/5.0";
  }
  
  if (self.avFormatName) {
    options[AVOptionNameAVFormatName] = self.avFormatName;
  }
  
  [_avplayController openMedia:self.mediaURL withOptions:options];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [[UIApplication sharedApplication]
      setStatusBarHidden:NO
           withAnimation:UIStatusBarAnimationFade];
  [[UIApplication sharedApplication]
      setStatusBarStyle:UIStatusBarStyleLightContent
               animated:YES];
  [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

  _volumeSlider.value = [FFAVPlayerController currentVolume];
}

- (void)viewWillDisappear:(BOOL)animated {
  [UIApplication sharedApplication].idleTimerDisabled = NO;
  [[UIApplication sharedApplication]
      setStatusBarHidden:_prevStatusBarHidden
           withAnimation:UIStatusBarAnimationFade];
  [[UIApplication sharedApplication] setStatusBarStyle:_prevStatusBarStyle
                                              animated:YES];
  [[UIApplication sharedApplication] endReceivingRemoteControlEvents];

  // Notify user to save current playback progress
  if (_saveProgress) {
    _saveProgress(_avplayController);
  }
  [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  float x = CGRectGetMidX(self.view.bounds);
  float y = CGRectGetMidY(self.view.bounds);

  _adjustSpeedView.center = _videoEffectView.center = CGPointMake(x, y);
  _loadingIndicatorView.center = CGPointMake(x, y);
}

#pragma mark - Device Interface Rotation Handler

- (BOOL)shouldAutorotateToInterfaceOrientation:
        (UIInterfaceOrientation)toInterfaceOrientation {
  return (toInterfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
}

- (BOOL)shouldAutorotate {
  return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll &
         (~UIInterfaceOrientationMaskPortraitUpsideDown);
}

#pragma mark - FFAVPlayerControllerDelegate

- (void)FFAVPlayerControllerWillLoad:(FFAVPlayerController *)controller {
  // show a loading indicator...

  // reset ui(s)
  _progressSlider.maximumValue = 0;
}

- (void)FFAVPlayerControllerDidLoad:(FFAVPlayerController *)controller error:(NSError *)error {
  if (error == nil) {
    if ([_avplayController hasVideo]) {
      _glView = [_avplayController drawableView];
      _glView.frame = self.view.bounds;
      _glView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      [self.view insertSubview:_glView atIndex:0];
      
      // Setup user interaction (gestures)
      [self setupUserInteraction:_glView];
    } else {
      // Setup user interaction (gestures)
      [self setupUserInteraction:self.view];
      
      if ([_avplayController hasAudio]) {
        [self coverImageView].hidden = NO;
      }
    }
    
    _progressSlider.maximumValue = [controller duration];
    
    if (_didLoadVideo) {
      _didLoadVideo(_avplayController);
    }
    
    if (_getStartTime) {
      NSNumber *initCurTime =
      _getStartTime(_avplayController, self.mediaURL);
      if (initCurTime.floatValue != CGFLOAT_MAX) {
        [self startPlaybackAt:initCurTime];
      }
    }
    
    // Initialize the now playing media info center
    [self initializeNowPlayingMediaInfoCenter];
  } else {
    [self resetNowPlayingMediaInfoCenter];
    
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:@"Failed to load video!"
                               message:nil
                              delegate:nil
                     cancelButtonTitle:@"Close"
                     otherButtonTitles:nil];
    [alertView show];
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
    _progressSlider.value = _progressSlider.maximumValue;

    if (_didFinishPlayback) {
      _didFinishPlayback(controller);
    }
  }

  if (state == kAVPlayerStatePlaying) {
    _isPlayingBeforeInterrupted = YES;
    
    // Active audio session
    [self toggleAudioSession:YES];
    
    // Enable idle timer
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    // Update UI
    [_playButton setImage:[UIImage imageNamed:@"avplayer.bundle/playback_pause"]
                 forState:UIControlStateNormal];

    // Hide HUD(s) after 8 seconds
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(hideHUD)
                                               object:nil];
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:8.0f];
  } else {
    _isPlayingBeforeInterrupted = NO;
    
    if (state == kAVPlayerStatePaused) {
      // De-active audio session
      [self toggleAudioSession:NO];
    }
    
    // Disable idle timer
    [UIApplication sharedApplication].idleTimerDisabled = NO;

    // Update UI
    [_playButton setImage:[UIImage imageNamed:@"avplayer.bundle/playback_play"]
                 forState:UIControlStateNormal];
  }

  // Notify user to save current playback progress
  if (state == kAVPlayerStatePaused || state == kAVPlayerStateStoped ||
      state == kAVPlayerStateFinishedPlayback) {

    if (_saveProgress) {
      _saveProgress(controller);
    }
  }
}

// AVPlayer current play time was changed
- (void)FFAVPlayerControllerDidCurTimeChange:(FFAVPlayerController *)controller
                                    position:(NSTimeInterval)position {
  [self updateProgressViewsWithTimePosition:position];
  [self updateNowPlayingMediaInfoCenterElapsedTimeInfo:position];
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
//  [_fullscreenButton setImage:[UIImage imageNamed:@"avplayer.bundle/zoomout"]];
}

- (void)FFAVPlayerControllerDidExitFullscreenMode:
        (FFAVPlayerController *)controller {
  // Update full screen bar button
//  [_fullscreenButton setImage:[UIImage imageNamed:@"avplayer.bundle/zoomin"]];
}

- (void)FFAVPlayerControllerDidBufferingProgressChange:(FFAVPlayerController *)controller progress:(double)progress {
  // progress is in range [0 ~ 1]
  // Buffering progress changed (total buffer is 5Mb)
}

- (void)FFAVPlayerControllerDidBitrateChange:(FFAVPlayerController *)controller bitrate:(NSInteger)bitrate {
  // Bitrate changed
}

// real framerate was changed
- (void)FFAVPlayerControllerDidFramerateChange:(FFAVPlayerController *)controller framerate:(NSInteger)framerate {
  // Log the bitrate info
  // NSLog(@"framerate : %ld", framerate);
  
#if 0
  /*
   * below codes are just for network playback situation.
   * so you can discard below codes for local playback situation.
   */
  if (framerate > controller.avFramerate/2) {
    if (_loadingIndicatorView.isAnimating) {
      [_loadingIndicatorView stopAnimating];
    }
  } else if ([controller realtimeBitrate] < controller.avBitrate/2 ||
             [controller bufferingProgress] < DBL_EPSILON) {
    if (!_loadingIndicatorView.isAnimating) {
      [self.view bringSubviewToFront:_loadingIndicatorView];
      [_loadingIndicatorView startAnimating];
    }
  }
#endif
}

// error handler
- (void)FFAVPlayerControllerDidOccurError:(FFAVPlayerController *)controller error:(NSError *)error {
  NSInteger errcode = error.code;
  if (errcode == EIO ||
      errcode == ENETDOWN ||
      errcode == ENETUNREACH ||
      errcode == ENETRESET ||
      errcode == ECONNABORTED ||
      errcode == ECONNRESET ||
      errcode == ENOTCONN ||
      errcode == ETIMEDOUT) {
    NSLog(@"SOME NETWORK ERRORs OCCURED, you can do some recover work here...");
  }
}

#pragma mark - AVAudioSession Manager

// Active or de-active audio session with playback category
- (void)toggleAudioSession:(BOOL)enable {
  NSError *error = nil;
  AVAudioSession *audioSession = [AVAudioSession sharedInstance];

  if (enable) {
    /* Set audio session to mediaplayback */
    if (![audioSession setCategory:AVAudioSessionCategoryPlayback
                             error:&error]) {
      NSLog(@"AVAudioSession (failed to setCategory (%@))", error);
    }

    /* active audio session */
    if (![audioSession setActive:YES error:&error]) {
      NSLog(@"AVAudioSession (failed to setActive (YES) (%@))", error);
    }
  } else {
    /* deactive audio session */
    if (![audioSession setActive:NO error:&error]) {
      NSLog(@"AVAudioSession (failed to setActive (NO) (%@))", error);
    }
  }
}

#pragma mark - Audio Session Interruption Handle

- (void)handleAudioSessionInterruption:(NSNotification *)notification {
  NSDictionary *userinfo = [notification userInfo];
  NSUInteger interruptionState = [userinfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
  
  switch (interruptionState) {
    case AVAudioSessionInterruptionTypeBegan: {
      BOOL previousFlag = _isPlayingBeforeInterrupted;
      
      // Player began interruption
      [_avplayController beganInterruption];
      
      // Restore flag
      _isPlayingBeforeInterrupted = previousFlag;
      
      // de-active the audio session when the interruption began
      [self toggleAudioSession:NO];
      break;
    }
    case AVAudioSessionInterruptionTypeEnded: {
      // re-active the audio session for playback
      [self toggleAudioSession:YES];
      
      // Player ends interruption
      [_avplayController endedInterruption];
      
      // Resume the player
      if (_isPlayingBeforeInterrupted) {
        [_avplayController resume];
      }
      break;
    }
  }
}

#pragma mark - Remote Control Event Handle

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
  AVPlayerState currentState = _avplayController.playerState;
  
  if (receivedEvent.type == UIEventTypeRemoteControl) {
    switch (receivedEvent.subtype) {
      case UIEventSubtypeRemoteControlPlay:
        if (currentState == kAVPlayerStatePaused) {
          [_avplayController resume];
        }
        break;
      case UIEventSubtypeRemoteControlPause:
        if (currentState == kAVPlayerStatePlaying) {
          [_avplayController pause];
        }
        break;
      case UIEventSubtypeRemoteControlStop:
        _avplayController = nil;
        break;
      case UIEventSubtypeRemoteControlTogglePlayPause:
        if (currentState == kAVPlayerStatePlaying) {
          [_avplayController pause];
        } else {
          [_avplayController resume];
        }
        break;
      case UIEventSubtypeRemoteControlPreviousTrack:
        // play previous track...
        break;
      case UIEventSubtypeRemoteControlNextTrack:
        // play next track...
        break;
      default:
        break;
    }
  }
}

- (BOOL)canBecomeFirstResponder {
  return YES;
}

#pragma mark - Media Infos Center

- (void)initializeNowPlayingMediaInfoCenter {
  NSMutableDictionary *currentTrackInfo = [[NSMutableDictionary alloc] init];
  
  NSString *title = [[self.mediaURL lastPathComponent] stringByDeletingPathExtension];
  title = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  [currentTrackInfo setObject:title forKey:MPMediaItemPropertyArtist];
  [currentTrackInfo setObject:title forKey:MPMediaItemPropertyTitle];
  [currentTrackInfo setObject:@(_avplayController.duration) forKey:MPMediaItemPropertyPlaybackDuration];
  
  [currentTrackInfo setObject:@(0) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
  [currentTrackInfo setObject:@(0) forKey:MPNowPlayingInfoPropertyPlaybackRate];
  
  [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:currentTrackInfo];
}

- (void)resetNowPlayingMediaInfoCenter {
  [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
}

- (void)updateNowPlayingMediaInfoCenterElapsedTimeInfo:(NSTimeInterval)elapsedTime {
  NSMutableDictionary *currentTrackInfo =
  [[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo] mutableCopy];
  
  currentTrackInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(elapsedTime);
  
  [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:currentTrackInfo];
}

#pragma mark - Private

// Setup user interaction
// Add single tap gesture to video render view

- (void)setupUserInteraction:(UIView *)v {
  UIView *view = v;
  view.userInteractionEnabled = YES;

  _tapGestureRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleTap:)];
  _tapGestureRecognizer.numberOfTapsRequired = 1;

  [view addGestureRecognizer:_tapGestureRecognizer];
}

// Show or hide top and bottom HUDs

- (void)toggleHUD:(BOOL)hudVisible {
  _hudVisible = hudVisible;

  [[UIApplication sharedApplication]
      setStatusBarHidden:!_hudVisible
           withAnimation:UIStatusBarAnimationNone];

  [UIView animateWithDuration:0.2
      delay:0.0
      options:UIViewAnimationOptionCurveEaseInOut |
              UIViewAnimationOptionTransitionNone
      animations:^{

        _topBar.alpha = _topHUD.alpha = _bottomHUD.alpha =
            _hudVisible ? 1.0f : 0;
      }
      completion:^(BOOL finished){
      }];
}

- (void)hideHUD {
  [self toggleHUD:NO];
}

// Update progress views with special time position
- (void)updateProgressViewsWithTimePosition:(NSTimeInterval)timePosition {
  // Update time labels & progress slider
  NSTimeInterval duration = [_avplayController duration];

  _leftLabel.text =
      [FFAVPlayerController formatTimeInterval:duration - timePosition
                                        isLeft:YES];
  _progressLabel.text =
      [FFAVPlayerController formatTimeInterval:timePosition isLeft:NO];

  if (_progressSlider.state == UIControlStateNormal)
    _progressSlider.value = timePosition;
}

#pragma mark - gesture recognizer

- (void)handleTap:(UITapGestureRecognizer *)sender {
  _adjustSpeedView.hidden = _videoEffectView.hidden = YES;

  if (sender.state == UIGestureRecognizerStateEnded) {

    if (sender == _tapGestureRecognizer) {

      [self toggleHUD:!_hudVisible];
    }
  }
}

#pragma mark - Actions

- (void)doneDidTouch:(id)sender {
  [NSObject cancelPreviousPerformRequestsWithTarget:self];

  if (_willDismiss) {
    _willDismiss();
  }

  _avplayController.delegate = nil;
  [_avplayController stop];

  [self dismissViewControllerAnimated:YES
                           completion:^{
                             _avplayController = nil;
                           }];
}

- (void)fullscreenDidTouch:(id)sender {
  if ([_avplayController hasVideo]) {
//    BOOL isFullscreen = ![_avplayController isFullscreen];
//    [_avplayController fullScreen:isFullscreen];
    
    _videoAspectRatioIndex++;
    if (_videoAspectRatioIndex >= _videoAspectRatios.count) {
      _videoAspectRatioIndex = 0;
    }
    
    CGFloat aspectRatio = [_videoAspectRatios[_videoAspectRatioIndex] floatValue];
    if (aspectRatio < 0) {
      [_avplayController fullScreen:YES];
    } else {
      [_avplayController fullScreen:NO];
      _avplayController.videoAspectRatio = aspectRatio;
    }
  }
}

- (void)progressSliderChanged:(id)sender {
  [_avplayController seekto:_progressSlider.value];
  [self updateProgressViewsWithTimePosition:_progressSlider.value];
}

- (void)playDidTouch:(id)sender {
  AVPlayerState playerState = [_avplayController playerState];

  if (playerState == kAVPlayerStatePlaying)
    [_avplayController pause];
  else
    [_avplayController resume];
}

- (void)forwardDidTouch:(id)sender {
  NSTimeInterval current_time = [_avplayController currentPlaybackTime];
  NSTimeInterval duration = [_avplayController duration];

  [_avplayController seekto:(current_time / duration + 0.05) * duration];
}

- (void)rewindDidTouch:(id)sender {
  NSTimeInterval current_time = [_avplayController currentPlaybackTime];
  NSTimeInterval duration = [_avplayController duration];

  [_avplayController seekto:(current_time / duration - 0.05) * duration];
}

- (void)mutedDidTouch:(id)sender {
  _isMuted = !_isMuted;
  [_avplayController setMuted:_isMuted];
  
  [_muteButton setImage:[UIImage imageNamed:_isMuted?@"avplayer.bundle/muted":@"avplayer.bundle/unmuted"]
               forState:UIControlStateNormal];
}

- (void)adjustSpeedDidTouch:(id)sender {
  if (!_adjustSpeedView) {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PlaybackSpeedView"
                                                   owner:nil
                                                 options:nil];
    _adjustSpeedView = views[0];

    [self.view addSubview:_adjustSpeedView];
    _adjustSpeedView.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                          CGRectGetMidY(self.view.bounds));

    [_adjustSpeedView.speedStepper addTarget:self
                                      action:@selector(speedDidChange:)
                            forControlEvents:UIControlEventValueChanged];
  }

  _adjustSpeedView.hidden = NO;
  _videoEffectView.hidden = YES;
}

- (void)speedDidChange:(UIStepper *)sender {
  _avplayController.playbackSpeed = sender.value;
  _adjustSpeedView.speedLabel.text =
      [NSString stringWithFormat:@"%.1fx", sender.value];
}

- (void)selectAudioTrackDidTouch:(id)sender {
  NSMutableArray *buttonTitles = [NSMutableArray array];

  NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];

  [_avplayController.audioTracks enumerateObjectsUsingBlock:^(NSDictionary *obj,
                                                              NSUInteger idx,
                                                              BOOL *stop) {
    NSString *streamTitle = obj[@"title"];
    NSString *langCode = obj[@"language"];

    streamTitle = [streamTitle stringByTrimmingCharactersInSet:cs];
    langCode = [langCode stringByTrimmingCharactersInSet:cs];

    NSString *buttonTitle = @"Unknown";
    if ([streamTitle length] > 0) {
      buttonTitle = streamTitle;
    } else if ([langCode length] > 0) {
      NSString *enLangName =
          [FFAVPlayerController convertISO639LanguageCodeToEnName:langCode];
      buttonTitle = enLangName;
    }
    [buttonTitles addObject:[NSString stringWithFormat:@"Track %@ - %@",
                                                       @(idx + 1), buttonTitle]];
  }];

  UIAlertView *alertView = [UIAlertView
          showWithTitle:@"Audio Trackers Picker"
                message:nil
      cancelButtonTitle:@"Cancel"
      otherButtonTitles:buttonTitles
               tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                 NSInteger firstOBIndex = [alertView firstOtherButtonIndex];
                 NSInteger lastOBIndex = firstOBIndex + [buttonTitles count];

                 if (buttonIndex >= firstOBIndex && buttonIndex < lastOBIndex) {
                   [_avplayController
                       switchAudioTracker:(int)(buttonIndex - firstOBIndex)];
                 }
               }];
  [alertView show];
}

- (void)selectSubtitleDidTouch:(id)sender {
  NSMutableArray *buttonTitles = [NSMutableArray array];

  NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];

  [_avplayController.subtitleTracks
      enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx,
                                   BOOL *stop) {
        NSString *streamTitle = obj[@"title"];
        NSString *langCode = obj[@"language"];

        streamTitle = [streamTitle stringByTrimmingCharactersInSet:cs];
        langCode = [langCode stringByTrimmingCharactersInSet:cs];

        NSString *buttonTitle;
        if ([streamTitle length] > 0) {
          buttonTitle = streamTitle;
        } else {
          NSString *enLangName =
              [FFAVPlayerController convertISO639LanguageCodeToEnName:langCode];
          buttonTitle = enLangName;
        }
        [buttonTitles
            addObject:[NSString stringWithFormat:@"Subtitle %@ - %@", @(idx + 1),
                                                 buttonTitle]];
      }];

  [buttonTitles addObject:@"External subtitle file"];

  UIAlertView *alertView = [UIAlertView
          showWithTitle:@"Subtitles Picker"
                message:nil
      cancelButtonTitle:@"Cancel"
      otherButtonTitles:buttonTitles
               tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {

                 NSInteger firstOBIndex = [alertView firstOtherButtonIndex];
                 NSInteger lastOBIndex = firstOBIndex + [buttonTitles count];

                 if (buttonIndex == lastOBIndex - 1) {

                   NSString *subtitlePath;
                   subtitlePath =
                       [[NSBundle mainBundle] pathForResource:@"test"
                                                       ofType:@"ass"];
                   if (![_avplayController
                           openSubtitleFile:subtitlePath
                                   encoding:kCFStringEncodingGB_18030_2000]) {
                     NSLog(@"Open %@ subtitle file failed!",
                           [subtitlePath lastPathComponent]);
                   }
                 } else if (buttonIndex >= firstOBIndex &&
                            buttonIndex < lastOBIndex) {
                   [_avplayController
                       switchSubtitleStream:(int)(buttonIndex - firstOBIndex)];
                 }
               }];
  [alertView show];
}

- (void)videoEffectDidTouch:(id)sender {
  if (!_videoEffectView) {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"VideoEffectView"
                                                   owner:nil
                                                 options:nil];
    _videoEffectView = views[0];

    [self.view addSubview:_videoEffectView];
    _videoEffectView.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                          CGRectGetMidY(self.view.bounds));

    [_videoEffectView.brightnessSlider addTarget:self
                                          action:@selector(brightnessDidChange:)
                                forControlEvents:UIControlEventValueChanged];
    [_videoEffectView.contrastSlider addTarget:self
                                        action:@selector(contrastDidChange:)
                              forControlEvents:UIControlEventValueChanged];
    [_videoEffectView.saturationSlider addTarget:self
                                          action:@selector(saturationDidChange:)
                                forControlEvents:UIControlEventValueChanged];
  }

  _videoEffectView.hidden = NO;
  _adjustSpeedView.hidden = YES;
}

- (void)brightnessDidChange:(UISlider *)sender {
  _avplayController.brightness = sender.value;
}

- (void)contrastDidChange:(UISlider *)sender {
  _avplayController.contrast = sender.value;
}

- (void)saturationDidChange:(UISlider *)sender {
  _avplayController.saturation = sender.value;
}

- (void)volumeDidChange:(UISlider *)sender {
  [FFAVPlayerController setVolume:sender.value];
}

#pragma mark - Public

// Start playback at special time position
- (void)startPlaybackAt:(NSNumber *)startTimePosition {
  if (startTimePosition.floatValue == 0) {
    [_avplayController play:0];
  } else {
    double position = startTimePosition.floatValue;

    if (![_avplayController play:position]) {
      [_avplayController play:0];
    }
  }
}

@end
