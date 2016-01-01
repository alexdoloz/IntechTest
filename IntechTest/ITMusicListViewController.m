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
@property BOOL loadingInProgress;
@property (nonatomic) BOOL isListExausted;

@end


@implementation ITMusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = [NSMutableArray new];
//    [self loadMusicItems];
    [self loadMoreItems];
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

- (void)loadMoreItems {
    if (self.loadingInProgress) return;
    ITNetworkManager *manager = [ITNetworkManager sharedManager];
    __weak typeof(self) weakSelf = self;
    NSInteger fromCount = self.items.count;
    NSInteger limitCount = 10;
    self.loadingInProgress = YES;
    [manager loadItemsFrom:fromCount limit:limitCount completion:^(NSArray<ITMusicItem *> *items, NSError *error) {
        NSLog(@"Finish loading %@ from %@; loaded %@ with error %@",
            @(limitCount),
            @(fromCount),
            @(items.count),
            error
        );
        self.loadingInProgress = NO;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            [strongSelf showLoadingError:error];
            return;
        }
        
        strongSelf.isListExausted = items.count < limitCount;
        [strongSelf.items addObjectsFromArray:items];
        [strongSelf.tableView beginUpdates];
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (NSInteger i = 0; i < items.count; i++) {
            NSInteger row = i + fromCount;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [indexPaths addObject:indexPath];
        }
        [strongSelf.tableView insertRowsAtIndexPaths:indexPaths
            withRowAnimation:UITableViewRowAnimationLeft];
//        if (strongSelf.isListExausted) {
//            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:            [strongSelf.tableView numberOfRowsInSection:0] - 1 inSection:0];
//            [strongSelf.tableView deleteRowsAtIndexPaths:@[lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
        [strongSelf.tableView endUpdates];
        [strongSelf.tableView reloadData];
    }];
}

- (void)showLoadingError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка при загрузке"
        message:error.localizedDescription
        preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *retry = [UIAlertAction
        actionWithTitle:@"Повторить"
        style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf loadMoreItems];
        }
    ];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"ОК"
        style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:retry];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    NSInteger musicItemsCount = self.items.count;
    return musicItemsCount + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isIndexPathForLoadingCell:indexPath]) {
        ITLoadingCell *cell = (ITLoadingCell *)[tableView dequeueReusableCellWithIdentifier:kLoadingCellIdentifier forIndexPath:indexPath];
        [cell.activityIndicator startAnimating];
        return cell;
    }
    ITMusicItemCell *cell = (ITMusicItemCell *)[tableView dequeueReusableCellWithIdentifier:kMusicItemCellIdentifier
    forIndexPath:indexPath];
    ITMusicItem *item = self.items[indexPath.row];
    cell.coverImageView.image = nil;
    [cell.activityIndicator startAnimating];
    [cell.coverImageView setImageWithURL:item.coverImageURL];
    cell.artistNameLabel.text = item.artist;
    cell.itemTitleLabel.text = item.itemTitle;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForLoadingCell = self.isListExausted ? 0.0f : 40.0f;
    return [self isIndexPathForLoadingCell:indexPath] ?
        heightForLoadingCell :
        120.0f;
}

- (BOOL)isIndexPathForLoadingCell:(NSIndexPath *)indexPath {
    return indexPath.row == self.items.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    if (self.isListExausted || self.loadingInProgress) return;
    NSInteger bottomMargin = 2;
    NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:self.items.count - bottomMargin inSection:0];
    NSArray *sortedVisibleIndexPaths = [[self.tableView indexPathsForVisibleRows] sortedArrayUsingSelector:@selector(compare:)];
    NSIndexPath *lastIndexPath = [sortedVisibleIndexPaths lastObject];
//    NSLog(@"Last index path: %@", lastIndexPath);
    
    if ([lastIndexPath compare:bottomIndexPath] == NSOrderedDescending) {
        [self loadMoreItems];
    }
}

@end
