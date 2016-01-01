//
//  ITNetworkManager.m
//  IntechTest
//
//  Created by Alexander on 31.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import "ITNetworkManager.h"


static NSString *const kAPIURLFormat = @"https://api-content-beeline.intech-global.com/public/marketplaces/1/tags/10/melodies?limit=%@&from=%@";


@implementation ITNetworkManager

+ (id)sharedManager {
    static dispatch_once_t onceToken;
    static id manager;
    dispatch_once(&onceToken, ^{
        manager = [[ITNetworkManager alloc] init];
    });
    return manager;
}

- (void)loadItemsFrom:(NSInteger)fromCount
    limit:(NSInteger)limitCount
    completion:(ITMusicItemsCompletionBlock)block {
    NSURL *url = [self URLForMusicItemsFrom:fromCount limit:limitCount];

}

- (void)loadCoverImageForItem:(ITMusicItem *)item
    completion:(ITImageLoadingCompletionBlock)block {
    
}

#pragma mark - Private

- (NSURL *)URLForMusicItemsFrom:(NSInteger)fromCount
    limit:(NSInteger)limitCount {
    NSAssert(fromCount > 0 && limitCount > 0, @"Values must be positive");
    NSString *urlString = [NSString stringWithFormat:kAPIURLFormat, @(limitCount), @(fromCount)];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}


@end
