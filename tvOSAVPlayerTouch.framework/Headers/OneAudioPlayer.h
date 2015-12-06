/*
 *  OneAudioPlayer.h
 *  This file is part of AVPlayerTouch framework.
 *
 *  Audio Player obj-c wrapper class.
 *
 *  Created by iMoreApps on 15/9/2015.
 *  Copyright (C) 2015 iMoreApps Inc. All rights reserved.
 *  Author: imoreapps <imoreapps@gmail.com>
 */

#import <Foundation/Foundation.h>

@protocol OneAudioPlayerDelegate;

@interface OneAudioPlayer : NSObject

/*
 * The delegate of OneAudioPlayer interface.
 * monitor states change of the player.
 */
@property (nonatomic, weak) NSObject<OneAudioPlayerDelegate> *delegate;

/*
 * The URL of av resource, now supports file, http and smb protocols.
 */
@property (nonatomic, strong, readonly) NSURL *mediaURL;

/*
 * Is av loaded or not?
 */
@property (nonatomic, readonly) BOOL isLoaded;

/*
 * Is it playing or not?
 */
@property (nonatomic, readonly) BOOL isPlaying;

/*
 * Query media total duration in seconds.
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/*
 * The current time of playback in seconds.
 * user can use the property to achieve the seek feature.
 */
@property (nonatomic) NSTimeInterval currentPlaybackTime;

/*
 * Is audio file format?
 * YES: an audio file format, NO otherwise.
 */
+ (BOOL)isAudioFormatWithURL:(NSURL *)url;

/*
 * Open media file.
 * @url: url of the media file.
 * YES - success; NO - failure.
 */
- (void)openMediaAtURL:(NSURL *)url;

/*
 * Control methods
 */
- (void)play;
- (void)resume;
- (void)pause;

/*
 * Audio session interruption handle.
 * began/ended interruption.
 * @This function does not return a value.
 */
- (void)beganInterruption;
- (void)endedInterruption;
@end


@protocol OneAudioPlayerDelegate
@optional
// will load av resource
- (void)OneAudioPlayerWillLoad:(OneAudioPlayer *)player;

// did load av resource
- (void)OneAudioPlayerDidLoad:(OneAudioPlayer *)player;

// state change
- (void)OneAudioPlayerDidStateChange:(OneAudioPlayer *)player;

// current play time was changed
- (void)OneAudioPlayer:(OneAudioPlayer *)player currentTimeChanged:(NSTimeInterval)currentTime;

// did finish plaback
- (void)OneAudioPlayerDidFinishPlayback:(OneAudioPlayer *)player;

// did occur error
- (void)OneAudioPlayer:(OneAudioPlayer *)player occuredError:(NSError *)error;
@end