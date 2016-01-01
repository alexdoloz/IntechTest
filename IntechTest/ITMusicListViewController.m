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
#import "ITLoadingCell.h"
#import <UIImageView+AFNetworking.h>


static NSString *const kMusicItemCellIdentifier = @"MUSIC_ITEM_CELL";
static NSString *const kLoadingCellIdentifier = @"LOADING_CELL";


@interface ITMusicListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSMutableArray<ITMusicItem *> *items;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSInteger limitCount;

@end


@implementation ITMusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = [NSMutableArray new];
    [self loadMusicItems];
}

- (void)loadMusicItems {
    ITNetworkManager *manager = [ITNetworkManager sharedManager];
    __weak typeof(self) weakSelf = self;
    [manager loadItemsFrom:0 limit:10 completion:^(NSArray<ITMusicItem *> *items, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.items addObjectsFromArray:items];
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    return self.items.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isLastIndexPath:indexPath]) {
        ITLoadingCell *cell = (ITLoadingCell *)[tableView dequeueReusableCellWithIdentifier:kLoadingCellIdentifier forIndexPath:indexPath];
        [cell.activityIndicator startAnimating];
        return cell;
    }
    ITMusicItemCell *cell = (ITMusicItemCell *)[tableView dequeueReusableCellWithIdentifier:kMusicItemCellIdentifier
    forIndexPath:indexPath];
    ITMusicItem *item = self.items[indexPath.row];
    [cell.coverImageView setImageWithURL:item.coverImageURL];
    cell.artistNameLabel.text = item.artist;
    cell.itemTitleLabel.text = item.itemTitle;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self isLastIndexPath:indexPath] ?
        40.0f :
        120.0f;
}

- (BOOL)isLastIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == self.items.count;
}

@end
