//
//  NNMusicPlayer.m
//  Motor
//
//  Created by AXAET_APPLE on 15/12/19.
//  Copyright © 2015年 axaet. All rights reserved.
//

#import "NNMusicPlayer.h"

const NSString *kKRMusicPlayerSongerName      = @"songer";
const NSString *kKRMusicPlayerSongIdentifier  = @"songId";
const NSString *kKRMusicPlayerSongName        = @"songName";
const NSString *kKRMusicPlayerSongDuration    = @"songDuration";
const NSString *kKRMusicPlayerSongURL         = @"songURL";
const NSString *kKRMusicPlayerSongArtwork     = @"songArtwork";//歌曲封面
const NSString *kKRMusicPlayerSongAlbums      = @"songAlbums";
#define Timer_Frequency 2.

@interface NNMusicPlayer () <AVAudioPlayerDelegate>
{
    NSTimer *timer;
}
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation NNMusicPlayer

- (float)volume {
    return _audioPlayer.volume;
}

- (float)duration {
    return _audioPlayer.duration;
}

- (float)currentTime {
    return _audioPlayer.currentTime;
}

-(void)setWillPlayTime:(NSTimeInterval)time{
    
    self.audioPlayer.currentTime = time;
}


- (NNMusicPlayerState)state {
    if (_audioPlayer) {
        if (_audioPlayer.playing) {
            return NNMusicPlayerStatePlaying;
        }
        else {
            return NNMusicPlayerStatePase;
        }
    }
    else
        return NNMusicPlayerStateStop;
}

- (float)songPower {
    [_audioPlayer updateMeters];
    float power = [_audioPlayer averagePowerForChannel:0];
    
    return powf(10, 0.05 * power);
}

- (void)changeSliderValue {
    [[NSNotificationCenter defaultCenter] postNotificationName: NNMusicPlayerChangeSliderValue object:nil];
}

+ (NNMusicPlayer *)sharedPlayer {
    static NNMusicPlayer *musicPlayer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        musicPlayer = [[NNMusicPlayer alloc] init];
        musicPlayer.songIndex = 0;
    });
    return musicPlayer;
}


- (void)playerPrepareMusic:(NSDictionary *)musicInfo {
    if (_audioPlayer) {
        _audioPlayer = nil;
    }
    
    NSURL *url = [musicInfo objectForKey:kKRMusicPlayerSongURL];
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audioPlayer.meteringEnabled = YES;
    audioPlayer.delegate = self;
    _audioPlayer = audioPlayer;
}


- (void)playerPlay {
    //
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"aac" ofType:@"mp3"]] error:nil];//使用本地URL创建
    
//    _audioPlayer = player;
    
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NNMusicPlayerSongChanged object:nil];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1/Timer_Frequency target:self selector:@selector(changeSliderValue) userInfo:nil repeats:YES];
}

- (void)playerPause {
    if (_audioPlayer) {
        [_audioPlayer pause];
    }
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)playerStop {
    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

//依照 Query 設定集合來取得所有的歌曲
-(NSArray *)fetchSongsWithQuery:(MPMediaQuery *)_query
{
    NSMutableArray *_songs = [[NSMutableArray alloc] initWithCapacity:0];
    MPMediaQuery *_mediaQuery= nil;
    //取得該 Query 底下的全部歌曲
    if( _query )
    {
        _mediaQuery = _query;
    }
    else
    {
        //取得全部歌曲
        //_mediaQuery = [[MPMediaQuery alloc] init];
        _mediaQuery = [MPMediaQuery songsQuery];
    }
    NSArray *_items = [_mediaQuery items];
    for (MPMediaItem *_eachSong in _items)
    {
        /*
         * @ 屬性說明
         *   - MPMediaItemPropertyAlbumPersistentID       : 專輯 ID       ( NSNumber, longlongValue )
         *   - MPMediaItemPropertyAlbumArtistPersistentID : 專輯的歌手 ID  ( NSNumber, longlongValue )
         */
        NSLog(@"%@",[_eachSong valueForProperty:MPMediaItemPropertyAssetURL]);
        
        
        if ([_eachSong valueForProperty:MPMediaItemPropertyAssetURL]!=NULL) {
            NSDictionary *_songInfo = @{kKRMusicPlayerSongIdentifier  : [_eachSong valueForProperty:MPMediaItemPropertyPersistentID] !=nil?[_eachSong valueForProperty:MPMediaItemPropertyPersistentID] :@"" ,
                                        kKRMusicPlayerSongName        : [_eachSong valueForProperty:MPMediaItemPropertyTitle] !=nil?[_eachSong valueForProperty:MPMediaItemPropertyTitle]:@"",
                                        kKRMusicPlayerSongerName      : [_eachSong valueForProperty:MPMediaItemPropertyAlbumArtist] !=nil ? [_eachSong valueForProperty:MPMediaItemPropertyAlbumArtist] : @"" ,
                                        kKRMusicPlayerSongDuration      : [_eachSong valueForProperty:MPMediaItemPropertyPlaybackDuration] !=nil ?[_eachSong valueForProperty:MPMediaItemPropertyPlaybackDuration] : @"",
                                        kKRMusicPlayerSongURL      : [_eachSong valueForProperty:MPMediaItemPropertyAssetURL] !=nil ?[_eachSong valueForProperty:MPMediaItemPropertyAssetURL] :@"",
                                        kKRMusicPlayerSongArtwork:[_eachSong valueForProperty:MPMediaItemPropertyArtwork] !=nil ?[_eachSong valueForProperty:MPMediaItemPropertyArtwork] :[[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"special_bdefault"]]
                                        ,
                                        kKRMusicPlayerSongAlbums      : [_eachSong valueForProperty:MPMediaItemPropertyAlbumTitle] !=nil ?[_eachSong valueForProperty:MPMediaItemPropertyAlbumTitle] :@""};
            [_songs addObject:_songInfo];
        }
        
    }
    return _songs;
}

//將播放時間轉換成 00:00:00 格式
-(NSString *)_convertToFormatStringWithPlayingTime:(CGFloat)_playingTime
{
    NSString *_formatedTotalDuration = @"";
    NSString *_convertTotalDuration  = [NSString stringWithFormat:@"%.0f", _playingTime];
    NSInteger _hours                 = 0;
    NSInteger _minutes               = [_convertTotalDuration integerValue] / 60;
    NSInteger _seconds               = [_convertTotalDuration integerValue] % 60;
    if( _minutes >= 60 )
    {
        _hours   = _minutes / 60;
        _minutes = _minutes % 60;
        _formatedTotalDuration = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)_hours, (int)_minutes, (int)_seconds];
    }
    else
    {
        _formatedTotalDuration = [NSString stringWithFormat:@"%02d:%02d", (int)_minutes, (int)_seconds];
    }
    return _formatedTotalDuration;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"%s, %d", __func__, flag);
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NNMusicPlayerSongFinished object:@(flag)];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
}

@end
