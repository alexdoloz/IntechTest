//
//  ITMusicPlayerViewController.m
//  IntechTest
//
//  Created by Alexander on 31.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import "ITMusicPlayerViewController.h"
#import "ITMusicItem.h"
#import <UIImageView+AFNetworking.h>
#import <STKAudioPlayer.h>


@interface ITMusicPlayerViewController ()<STKAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (nonatomic) STKAudioPlayer *player;

@property (nonatomic) BOOL playing;

@end


@implementation ITMusicPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player = [[STKAudioPlayer alloc] init];
    self.player.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = self.musicItem.itemTitle;
    [self.coverImageView setImageWithURL:self.musicItem.coverImageURL];
    [self.player playURL:self.musicItem.audioURL];
    self.playing = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.player.delegate = nil;
    [self.player stop];
    [self.player clearQueue];
    [super viewWillDisappear:animated];
}

- (IBAction)playPausePressed:(id)sender {
    self.playing = !self.playing;
}

- (void)setPlaying:(BOOL)playing {
    if (playing == _playing) return;
    _playing = playing;
    if (_playing) {
        [self.player resume];
        [self.playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    } else {
        [self.player pause];
        [self.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

#pragma mark - STKAudioPlayerDelegate

- (void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId {

}

- (void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId {

}

- (void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration {
    [self.player queueURL:self.musicItem.audioURL];
}

- (void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {

}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState {
    NSLog(@"State changed from %@ to %@", @(previousState), @(state));
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didCancelQueuedItems:(NSArray *)queuedItems {
    
}



@end
