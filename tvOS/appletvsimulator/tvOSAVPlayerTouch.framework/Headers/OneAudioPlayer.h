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
 * Toggle the universal mode, default is YES.
 * YES - indicate that player always uses FFmpeg to decode, no matter what format it is.
 */
@property (nonatomic) BOOL enableUniversalMode;

/*
 * Auto play switcher.
 * YES - auto play when loaded av resource.
 * NO  - you should manually invoke "play" method to start playback when loaded av resource.
 * The default value is YES.
 */
@property(nonatomic, assign) BOOL shouldAutoPlay;

/*
 * The URL of av resource, now supports file, http and smb protocols.
 */
@property (nonatomic, strong, readonly) NSURL *mediaURL;

/*
 * Is iOS native av format?
 */
@property (nonatomic, readonly) BOOL isiOSNativeFormat;

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
 * Get/Set the minmum playable buffer size, default size is 0. [Just for FFmpeg player]
 * @size - the minmum playable buffer size.
 * @value 0 indicates that minimum playable buffer size feature is disabled.
 */
@property (nonatomic) unsigned long long minPlayableBufferSize;


/*
 * Open media file.
 * @url: url of the media file.
 * @isiOSNativeFormat - is iOS native format?
 * @options: open options, user can pass customized http headers via AVOptionNameHttpHeader option key.
 * YES - success; NO - failure.
 */
- (void)openMediaAtURL:(NSURL *)url
     isiOSNativeFormat:(BOOL)isiOSNativeFormat
               options:(NSDictionary *)options;

/*
 * Control methods
 */
- (void)play:(NSTimeInterval)position;
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