//
//  ITNetworkManager.m
//  IntechTest
//
//  Created by Alexander on 31.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import "ITNetworkManager.h"
#import "ITMusicItem.h"
#import <AFNetworking.h>
#import <EasyMapping.h>
//#import <AFNetworking/af


static NSString *const kAPIURLFormat = @"https://api-content-beeline.intech-global.com/public/marketplaces/1/tags/10/melodies?limit=%@&from=%@";
NSString *const ITNetworkErrorDomain = @"ITNetworkErrorDomain";


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
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [httpManager GET:url.absoluteString parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseDict) {
            NSArray *melodies = responseDict[@"melodies"];
            if (!melodies) {
                NSError *error = [NSError errorWithDomain:ITNetworkErrorDomain code:111 userInfo:@{
                    NSLocalizedDescriptionKey : @"Wrong JSON format"
                }];
                block(nil, error);
                return;
            }
            NSArray *musicItems = [EKMapper arrayOfObjectsFromExternalRepresentation:melodies
                withMapping:[ITMusicItem objectMapping]];
            block(musicItems, nil);
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
            block(nil, error);
        }
    ];
}

- (void)loadCoverImageForItem:(ITMusicItem *)item
    completion:(ITImageLoadingCompletionBlock)block {
    
}

#pragma mark - Private

- (NSURL *)URLForMusicItemsFrom:(NSInteger)fromCount
    limit:(NSInteger)limitCount {
    NSAssert(fromCount >= 0 && limitCount > 0, @"Wrong value for fromCount or limitCount");
    NSString *urlString = [NSString stringWithFormat:kAPIURLFormat, @(limitCount), @(fromCount)];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}


@end
