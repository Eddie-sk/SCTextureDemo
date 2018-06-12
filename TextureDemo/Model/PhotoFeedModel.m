//
//  PhotoFeedModel.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/1.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "PhotoFeedModel.h"
#import "ImageUrlModel.h"

#define unsplash_ENDPOINT_HOST      @"https://api.unsplash.com/"
#define unsplash_ENDPOINT_POPULAR   @"photos?order_by=popular"
#define unsplash_ENDPOINT_SEARCH    @"photos/search?geo="    //latitude,longitude,radius<units>
#define unsplash_ENDPOINT_USER      @"photos?user_id="
#define unsplash_CONSUMER_KEY_PARAM @"&client_id=3b99a69cee09770a4a0bbb870b437dbda53efb22f6f6de63714b71c4df7c9642"   // PLEASE REQUEST YOUR OWN UNSPLASH CONSUMER KEY
#define unsplash_IMAGES_PER_PAGE    30

@implementation PhotoFeedModel
{
    PhotoFeedModelType _feedType;
    
    NSMutableArray *_photos;    // array of PhotoModel objects
    NSMutableArray *_ids;
    
    CGSize         _imageSize;
    NSString       *_urlString;
    NSUInteger     _currentPage;
    NSUInteger     _totalPages;
    NSUInteger     _totalItems;
    BOOL           _fetchPageInProgress;
    BOOL           _refreshFeedInProgress;
    NSURLSessionDataTask *_task;
    
    NSUInteger    _userID;
}

- (instancetype)initWithPhotoFeedModelType:(PhotoFeedModelType)type imageSize:(CGSize)size {
    
    self = [super init];
    if (self) {
        _feedType    = type;
        _imageSize   = size;
        _photos      = [[NSMutableArray alloc] init];
        _ids         = [[NSMutableArray alloc] init];
        _currentPage = 0;
        
        NSString *apiEndpointString;
        switch (type) {
            case (PhotoFeedModelTypePopular):
                apiEndpointString = unsplash_ENDPOINT_POPULAR;
                break;
                
            case (PhotoFeedModelTypeLocation):
                apiEndpointString = unsplash_ENDPOINT_SEARCH;
                break;
                
            case (PhotoFeedModelTypeUserPhotos):
                apiEndpointString = unsplash_ENDPOINT_USER;
                break;
                
            default:
                break;
        }
        _urlString = [[unsplash_ENDPOINT_HOST stringByAppendingString:apiEndpointString] stringByAppendingString:unsplash_CONSUMER_KEY_PARAM];
    }
    return self;
}

#pragma mark - Instance Methods

- (NSArray<Photo *> *)photos {
    return [_photos copy];
}

- (NSUInteger)totalNumberOfPhotos {
    return _totalItems;
}

- (NSUInteger)numberOfItemsInFeed {
    return [_photos count];
}

- (Photo *)objectAtIndex:(NSUInteger)index {
    if (_photos.count > index) {
        return [_photos objectAtIndex:index];
    }
    return nil;
}

- (NSInteger)indexOfPhotoModel:(Photo *)photoModel {
    NSAssert(photoModel, nil);
    if (!photoModel) {
        return -1;
    }
    
    return [_photos indexOfObject:photoModel];
}

- (void)updatePhotoFeedModelTypeUserId:(NSUInteger)userID {
    
}

- (void)clearFeed {
    _photos = [[NSMutableArray alloc]  init];
    _ids = [[NSMutableArray alloc] init];
    _currentPage = 0;
    _fetchPageInProgress = NO;
    _refreshFeedInProgress = NO;
    [_task cancel];
    _task = nil;
}

- (void)requestPageWithCompletionBlock:(void(^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults {
    if (_fetchPageInProgress) {
        return;
    }
    _fetchPageInProgress = YES;
    [self fetchPageWithCompletionBlock:block numResultsToReturn:numResults replaceData:NO];
    
}

- (void)refreshFeedWithCompletionBlock:(void(^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults {
    if (_refreshFeedInProgress) {
        return;
    }
    _refreshFeedInProgress = YES;
    [self fetchPageWithCompletionBlock:^(NSArray *newPhotos) {
        if (block) {
            block(newPhotos);
        }
        self->_refreshFeedInProgress = YES;
    } numResultsToReturn:numResults replaceData:YES];
}

#pragma makr -Helper Methods

- (void)fetchPageWithCompletionBlock:(void(^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults replaceData:(BOOL)replaceData {
    if (_totalPages) {
        if (_totalPages == _currentPage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(@[]);
                }
            });
            return;
        }
    }
    
    NSUInteger numPhotos = (numResults < unsplash_IMAGES_PER_PAGE) ? numResults : unsplash_IMAGES_PER_PAGE;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *newPhotos = [NSMutableArray array];
        NSMutableArray *newIds = [NSMutableArray array];
        
        @synchronized(self) {
            NSUInteger nextPage = self->_currentPage + 1;
            NSString *imageSizeParam = [ImageUrlModel imageParameterForClosestImageSize:self->_imageSize];
            NSString *urlAdditions   = [NSString stringWithFormat:@"&page=%lu&per_page=%lu%@", (unsigned long)nextPage, (long)numPhotos, imageSizeParam];
            NSURL *url               = [NSURL URLWithString:[self->_urlString stringByAppendingString:urlAdditions]];
            NSURLSession *session    = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
            self->_task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                {
                    @synchronized(self) {
                        NSHTTPURLResponse *httpResponse = nil;
                        if (data && [response isKindOfClass:[NSHTTPURLResponse class]]) {
                            httpResponse = (NSHTTPURLResponse *)response;
                            NSArray *objects = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                            
                            if ([objects isKindOfClass:[NSArray class]]) {
                                self->_currentPage = nextPage;
                                self->_totalItems = [[httpResponse allHeaderFields][@"x-total"] integerValue];
                                self->_totalPages  = self->_totalItems / unsplash_IMAGES_PER_PAGE; // default per page is 10
                                if (self->_totalItems % unsplash_IMAGES_PER_PAGE != 0) {
                                    self->_totalPages += 1;
                                }
                                
                                NSArray *photos = objects;
                                for (NSDictionary *photoDictionary in photos) {
                                    if ([photoDictionary isKindOfClass:[NSDictionary class]]) {
                                        Photo *photo = [[Photo alloc] initWithUnsplashPhoto:photoDictionary];
                                        if (photo) {
                                            if (replaceData || ![self->_ids containsObject:photo.photoID]) {
                                                [newPhotos addObject:photo];
                                                [newIds addObject:photo.photoID];
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        @synchronized(self) {
                            if (replaceData) {
                                self->_photos = [newPhotos mutableCopy];
                                self->_ids = [newIds mutableCopy];
                            } else {
                                [self->_photos addObjectsFromArray:newPhotos];
                                [self->_ids addObjectsFromArray:newIds];
                            }
                            if (block) {
                                block(newPhotos);
                            }
                            self->_fetchPageInProgress = NO;
                        }
                    });
                }
            }];
            [self->_task resume];
        }
    });
}

@end
