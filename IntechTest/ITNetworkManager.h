//
//  ITNetworkManager.h
//  IntechTest
//
//  Created by Alexander on 31.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ITMusicItem;


typedef void(^ITMusicItemsCompletionBlock)(NSArray<ITMusicItem *> *items, NSError *error);
typedef void(^ITImageLoadingCompletionBlock)(UIImage *coverImage, NSError *error);
//typedef void(^ITMusicTrackLoadingCompletionBlock)();


@interface ITNetworkManager : NSObject

+ (id)sharedManager;

- (void)loadItemsFrom:(NSInteger)fromCount
    limit:(NSInteger)limitCount
    completion:(ITMusicItemsCompletionBlock)block;

- (void)loadCoverImageForItem:(ITMusicItem *)item
    completion:(ITImageLoadingCompletionBlock)block;


@end
