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


@interface ITMusicPlayerViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (nonatomic) STKAudioPlayer *player;

@property (nonatomic) BOOL playing;

@end


@implementation ITMusicPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player = [[STKAudioPlayer alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = self.musicItem.itemTitle;
    [self.coverImageView setImageWithURL:self.musicItem.coverImageURL];
    [self.player playURL:self.musicItem.audioURL];
    self.playing = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.player stop];
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

@end
