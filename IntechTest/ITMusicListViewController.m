//
//  ITMusicListViewController.m
//  IntechTest
//
//  Created by Alexander on 31.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import "ITMusicListViewController.h"
#import "ITMusicItem.h"
#import "ITNetworkManager.h"
#import "ITMusicItemCell.h"
#import <UIImageView+AFNetworking.h>


static NSString *const kCellIdentifier = @"MUSIC_ITEM_CELL";


@interface ITMusicListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray<ITMusicItem *> *items;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation ITMusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMusicItems];
}

- (void)loadMusicItems {
    ITNetworkManager *manager = [ITNetworkManager sharedManager];
    __weak typeof(self) weakSelf = self;
    [manager loadItemsFrom:0 limit:10 completion:^(NSArray<ITMusicItem *> *items, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.items = items;
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ITMusicItemCell *cell = (ITMusicItemCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    ITMusicItem *item = self.items[indexPath.row];
    [cell.coverImageView setImageWithURL:item.coverImageURL];
    cell.artistNameLabel.text = item.artist;
    cell.itemTitleLabel.text = item.itemTitle;
    return cell;
}


@end
