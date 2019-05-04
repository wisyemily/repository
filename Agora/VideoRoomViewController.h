//
//  VideoRoomViewController.h
//  AgoDemo
//
//  Created by os on 2019/4/9.
//  Copyright © 2019 os. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "EncryptionType.h"
NS_ASSUME_NONNULL_BEGIN

@class VideoRoomViewController;
@protocol VideoRoomVCDelegate <NSObject>
- (void)roomVCNeedClose:(VideoRoomViewController *)roomVC;
@end


@interface VideoRoomViewController : UIViewController
@property (copy, nonatomic) NSString *roomName;
@property (assign, nonatomic) CGSize dimension;
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@property (assign, nonatomic) EncrypType encrypType;
@property (copy, nonatomic) NSString *encrypSecret;
@property (weak, nonatomic) id<VideoRoomVCDelegate> delegate;
@property (copy, nonatomic) NSString *whiteUUID;
@property (copy, nonatomic) NSString *teachUID;
@property (assign, nonatomic) NSInteger switchType;
@end

NS_ASSUME_NONNULL_END
