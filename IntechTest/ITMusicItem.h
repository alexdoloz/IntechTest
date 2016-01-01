//
//  ITMusicItem.h
//  IntechTest
//
//  Created by Alexander on 01.01.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EKMappingProtocol.h>


@interface ITMusicItem : NSObject<EKMappingProtocol>

@property (nonatomic, copy) NSString *itemTitle;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic) NSURL *coverImageURL;
@property (nonatomic) NSURL *audioURL;

@end
