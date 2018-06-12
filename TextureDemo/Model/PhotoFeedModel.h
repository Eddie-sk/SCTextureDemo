//
//  PhotoFeedModel.h
//  TextureDemo
//
//  Created by sunkai on 2018/6/1.
//  Copyright © 2018年 CCWork. All rights reserved.
//
#import "Photo.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PhotoFeedModelType) {
    PhotoFeedModelTypePopular,
    PhotoFeedModelTypeLocation,
    PhotoFeedModelTypeUserPhotos
};

@interface PhotoFeedModel : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithPhotoFeedModelType:(PhotoFeedModelType)type imageSize:(CGSize)size NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSArray<Photo *> *photos;

- (NSUInteger)totalNumberOfPhotos;
- (NSUInteger)numberOfItemsInFeed;
- (Photo *)objectAtIndex:(NSUInteger)index;
- (NSInteger)indexOfPhotoModel:(Photo *)photoModel;

- (void)updatePhotoFeedModelTypeUserId:(NSUInteger)userID;

- (void)clearFeed;
- (void)requestPageWithCompletionBlock:(void(^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults;
- (void)refreshFeedWithCompletionBlock:(void(^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults;

@end
