//
//  UIImageView+SDWebImage.m
//  FSFurnitureStore
//
//  Created by TAN on 16/8/4.
//  Copyright © 2016年 TAN. All rights reserved.
//
#import "UIImageView+SDWebImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SDWebImage)

- (void)setImage:(NSString *)url placeholder:(NSString *)imageName {
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
}

- (void)setImage:(NSString *)url
     placeholder:(NSString *)imageName
         success:(DownloadImageSuccessBlock)success
          failed:(DownloadImageFailedBlock)failed
        progress:(DownloadImageProgressBlock)progress {
    
//    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        
//        progress(receivedSize * 1.0 / expectedSize);
//        
//    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//        if (error) {
//            
//            failed(error);
//            
//        } else {
//            
//            self.image = image;
//            success(image);
//        }
//    }];
}

@end
