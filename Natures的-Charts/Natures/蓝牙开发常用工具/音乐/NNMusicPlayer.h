//
//  NNMusicPlayer.h
//  Motor
//
//  Created by AXAET_APPLE on 15/12/19.
//  Copyright © 2015年 axaet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define playerSelf [NNMusicPlayer sharedPlayer]
#define NNMusicPlayerChangeSliderValue @"changeSliderValue"
#define NNMusicPlayerSongFinished      @"songFinished"
#define NNMusicPlayerSongChanged       @"songChanged"

extern const NSString *kKRMusicPlayerSongerName;
//  NSString
extern const NSString *kKRMusicPlayerSongIdentifier;
//  NSNumber
extern const NSString *kKRMusicPlayerSongName;        //
//  NSNumber
extern const NSString *kKRMusicPlayerSongDuration;
//  NSURL
extern const NSString *kKRMusicPlayerSongURL;

extern const NSString *kKRMusicPlayerSongArtwork;

extern const NSString *kKRMusicPlayerSongAlbums;

typedef enum : NSUInteger {
    NNMusicPlayerStateStop,
    NNMusicPlayerStatePase,
    NNMusicPlayerStatePlaying,
} NNMusicPlayerState;

@interface NNMusicPlayer : NSObject
@property (nonatomic, assign) float volume;
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) float currentTime;
@property (nonatomic, assign) NNMusicPlayerState state;
@property (nonatomic, assign) int songIndex;

+ (NNMusicPlayer *)sharedPlayer;

- (void)playerPrepareMusic:(NSDictionary *)musicInfo;

- (void)playerPlay;

- (void)playerPause;

- (void)playerStop;

- (float)songPower;

-(void)setWillPlayTime:(NSTimeInterval)time;

- (NSArray *)fetchSongsWithQuery:(MPMediaQuery *)_query;

- (NSString *)_convertToFormatStringWithPlayingTime:(CGFloat)_playingTime;


@end
