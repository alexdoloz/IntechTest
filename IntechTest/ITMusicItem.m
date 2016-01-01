//
//  ITMusicItem.m
//  IntechTest
//
//  Created by Alexander on 01.01.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

#import "ITMusicItem.h"
#import <EKMappingBlocks.h>


@implementation ITMusicItem

+ (EKObjectMapping *)objectMapping {
    return [EKObjectMapping mappingForClass:[self class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapKeyPath:@"title" toProperty:NSStringFromSelector(@selector(itemTitle))];
        [mapping mapKeyPath:@"artist" toProperty:NSStringFromSelector(@selector(artist))];
        [mapping mapKeyPath:@"picUrl" toProperty:NSStringFromSelector(@selector(coverImageURL)) withValueBlock:[EKMappingBlocks urlMappingBlock]];
        [mapping mapKeyPath:@"demoUrl" toProperty:NSStringFromSelector(@selector(audioURL)) withValueBlock:[EKMappingBlocks urlMappingBlock]];
    }];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@(%@)", self.itemTitle, self.artist];
}

@end
