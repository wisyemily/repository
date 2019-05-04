//
//  VideoRoomViewController.m
//  AgoDemo
//
//  Created by os on 2019/4/9.
//  Copyright © 2019 os. All rights reserved.
//

#import "VideoRoomViewController.h"
#import "VideoSession.h"
#import "VideoViewLayouter.h"
//#import <AgoraRtcCryptoLoader/AgoraRtcCryptoLoader.h>
#import "MsgTableView.h"
#import "AGVideoPreProcessing.h"
#import "AppDelegate.h"
#import "DataModel.h"

//White
#import "WhiteRoomViewController.h"

@interface VideoRoomViewController ()<AgoraRtcEngineDelegate,WhiteRoomViewControllerProtocal>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *flowViews;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;

@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (weak, nonatomic) IBOutlet UIButton *muteVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *muteAudioButton;

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIView *zoomView;

@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *backgroundTap;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *backgroundDoubleTap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgInputViewBottom;
@property (weak, nonatomic) IBOutlet UITextField *msgTextField;
@property (weak, nonatomic) IBOutlet MsgTableView *msgTableView;
@property (weak, nonatomic) IBOutlet UIView *msgInputView;

@property (strong, nonatomic) NSMutableArray<VideoSession *> *videoSessions;
@property (strong, nonatomic) VideoSession *doubleClickFullSession;
@property (strong, nonatomic) VideoViewLayouter *videoViewLayouter;

@property (assign, nonatomic) BOOL shouldHideFlowViews;
@property (assign, nonatomic) BOOL audioMuted;
@property (assign, nonatomic) BOOL videoMuted;
@property (assign, nonatomic) BOOL speakerEnabled;


@end

@implementation VideoRoomViewController
{
    CGRect oVideoRect;
    CGRect oWhiteRect;
    WhiteRoomViewController *roomVC;
}


static NSInteger streamID = 0;

- (void)setShouldHideFlowViews:(BOOL)shouldHideFlowViews {
    _shouldHideFlowViews = shouldHideFlowViews;
    if (self.flowViews.count) {
        for (UIView *view in self.flowViews) {
            view.hidden = shouldHideFlowViews;
        }
    }
}

- (void)setDoubleClickFullSession:(VideoSession *)doubleClickFullSession {
    _doubleClickFullSession = doubleClickFullSession;
    if (self.videoSessions.count >= 3) {
        [self updateInterfaceWithSessions:self.videoSessions targetSize:self.containerView.frame.size animation:YES];
    }
}

- (VideoViewLayouter *)videoViewLayouter {
    if (!_videoViewLayouter) {
        _videoViewLayouter = [[VideoViewLayouter alloc] init];
    }
    return _videoViewLayouter;
}

- (void)setAudioMuted:(BOOL)audioMuted {
    _audioMuted = audioMuted;
    [self.muteAudioButton setImage:[UIImage imageNamed:(audioMuted ? @"btn_mute_blue" : @"btn_mute")] forState:UIControlStateNormal];
    [self.agoraKit muteLocalAudioStream:audioMuted];
}

- (void)setVideoMuted:(BOOL)videoMuted {
    _videoMuted = videoMuted;
    [self.muteVideoButton setImage:[UIImage imageNamed:(videoMuted ? @"btn_video" : @"btn_voice")] forState:UIControlStateNormal];
    self.cameraButton.hidden = videoMuted;
    self.speakerButton.hidden = !videoMuted;
    
    [self.agoraKit muteLocalVideoStream:videoMuted];
    
    [self setVideoMuted:videoMuted forUid:0];
    [self updateSelfViewVisiable];
}

- (void)setSpeakerEnabled:(BOOL)speakerEnabled {
    _speakerEnabled = speakerEnabled;
    [self.speakerButton setImage:[UIImage imageNamed:(speakerEnabled ? @"btn_speaker_blue" : @"btn_speaker")] forState:UIControlStateNormal];
    [self.speakerButton setImage:[UIImage imageNamed:(speakerEnabled ? @"btn_speaker" : @"btn_speaker_blue")] forState:UIControlStateHighlighted];
    
    [self.agoraKit setEnableSpeakerphone:speakerEnabled];
}

#pragma mark - View did load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.agoraKit = appDelegate.agoraKit;
    self.videoSessions = [[NSMutableArray alloc] init];
    //self.agoraLoader = [[AgoraRtcCryptoLoader alloc] init];
    self.roomNameLabel.text = self.roomName;
    self.msgInputView.alpha = 0;
    [self.backgroundTap requireGestureRecognizerToFail:self.backgroundDoubleTap];
    
    [self loadAgoraKit];
    [self addKeyboardObserver];
    
    self.containerView.contentMode = UIViewContentModeRedraw;
    self.switchType = 0;
   
}
-(void)viewWillAppear:(BOOL)animated
{
    //white
    [self InitWhiteBoard];
    
    [self.view addSubview:self.zoomView];
    [self.zoomView setHidden:YES];
    //创建一个UIButton
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, 30, 30)];
    backButton.alpha = 0.8;
    //[backButton setTitle:@"<" forState:UIControlStateNormal];
    
    //设置UIButton的图像
    [backButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    //给UIButton绑定一个方法，在这个方法中进行popViewControllerAnimated
    [backButton addTarget:self action:@selector(leaveChannel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    //然后通过系统给的自定义BarButtonItem的方法创建BarButtonItem
    //UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    //覆盖返回按键
   //self.navigationItem.leftBarButtonItem = backItem;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.agoraKit disableVideo];
}
#pragma mark - white Board
-(void)InitWhiteBoard
{
    roomVC = [[WhiteRoomViewController alloc] init];
    roomVC.roomUuid = self.whiteUUID;
    roomVC.eventDelegate = self;
    [self addChildViewController:roomVC];
    roomVC.view.frame = self.whiteView.frame;//CGRectMake(0, self.controlView.frame.size.height, self.controlView.frame.size.width, self.controlView.frame.size.height);//self.whiteView.frame;
    //NSLog(@"%f",vc.view.frame.origin.y);
    [self.view addSubview:roomVC.view];
    //[self presentViewController:vc animated:NO  completion:nil];
   
}

#pragma mark - Send Data Stream
- (void)addKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardFrameChange:(NSNotification *)info {
    
    CGRect keyboardEndFrame = [info.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = [UIScreen mainScreen].bounds.size.height - keyboardEndFrame.origin.y;
    double duration = [info.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat constant;
    
    if (ty > 0) {
        constant = ty;
        self.msgInputView.alpha = 1;
    }
    else {
        constant = 0;
        self.msgInputView.alpha = 0;
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.msgInputViewBottom.constant = constant;
        [self.view layoutIfNeeded];
    }];
    
}

- (void)sendDataWithString:(NSString *)message {
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self.msgTableView appendMsgToTableViewWithMsg:message msgType:MsgTypeChat];
    [self.agoraKit sendStreamMessage:streamID data:data];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendDataWithString:textField.text];
    textField.text = @"";
    return YES;
}

#pragma mark - Click Action
- (IBAction)doFilterPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [AGVideoPreProcessing registerVideoPreprocessing:self.agoraKit];
    }
    else {
        [AGVideoPreProcessing deregisterVideoPreprocessing:self.agoraKit];
    }
}

- (IBAction)doMesPressed:(UIButton *)sender {
    [self.msgTextField becomeFirstResponder];
}

- (IBAction)doHideKeyboardPressed:(UIButton *)sender {
    [self.msgTextField resignFirstResponder];
}

- (IBAction)doMuteVideoPressed:(UIButton *)sender {
    self.videoMuted = !self.videoMuted;
}

- (IBAction)doMuteAudioPressed:(UIButton *)sender {
    self.audioMuted = !self.audioMuted;
}

- (IBAction)doCameraPressed:(UIButton *)sender {
    [self.agoraKit switchCamera];
}

- (IBAction)doSpeakerPressed:(UIButton *)sender {
    self.speakerEnabled = !self.speakerEnabled;
}

- (IBAction)doClosePressed:(UIButton *)sender {
    //[self leaveChannel];

   
}

- (IBAction)doBackTapped:(UITapGestureRecognizer *)sender {
    self.shouldHideFlowViews = !self.shouldHideFlowViews;
}

- (IBAction)doBackDoubleTapped:(UITapGestureRecognizer *)sender {
    if (!self.doubleClickFullSession) {
        NSInteger tappedIndex = [self.videoViewLayouter responseIndexOfLocation:[sender locationInView:self.containerView]];
        if (tappedIndex >= 0 && tappedIndex < self.videoSessions.count) {
            self.doubleClickFullSession = self.videoSessions[tappedIndex];
        }
    } else {
        self.doubleClickFullSession = nil;
    }
}

#pragma mark - Video View Layout
- (void)updateInterfaceWithSessions:(NSArray *)sessions targetSize:(CGSize)targetSize animation:(BOOL)animation {
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self updateInterfaceWithSessions:sessions targetSize:targetSize];
            [self.view layoutIfNeeded];
        }];
    } else {
        [self updateInterfaceWithSessions:sessions targetSize:targetSize];
    }
}

- (void)updateInterfaceWithSessions:(NSArray *)sessions targetSize:(CGSize)targetSize {
    if (!sessions.count) {
        return;
    }
    
    /*if ( sessions.count <= 1 )
    {
        VideoSession *selfSession = sessions.firstObject;
        //self.videoViewLayouter.selfView = selfSession.hostingView;
        //self.videoViewLayouter.selfSize = selfSession.size;
        //self.videoViewLayouter.targetSize = targetSize;
        selfSession.size = self.containerView.bounds.size;
        selfSession.hostingView.frame = self.containerView.frame;
        [self.containerView addSubview:selfSession.hostingView];
        return;
        
    }
    else if (sessions.count == 2)
    {
        
    }*/
    
    //self
    VideoSession *selfSession = sessions.firstObject;
    self.videoViewLayouter.selfView = selfSession.hostingView;
    self.videoViewLayouter.selfSize = selfSession.size;
    self.videoViewLayouter.targetSize = targetSize;
    self.videoViewLayouter.switchType = self.switchType;
    
    //peer
    NSMutableArray *peerVideoViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i < sessions.count; ++i) { 
        VideoSession *session = sessions[i];
        [peerVideoViews addObject:session.hostingView];
    }
    
    
    self.videoViewLayouter.videoViews = peerVideoViews;
    self.videoViewLayouter.fullView = self.doubleClickFullSession.hostingView;
    self.videoViewLayouter.containerView = self.containerView;
    self.videoViewLayouter.zoomView = self.zoomView;
    
    [self.videoViewLayouter layoutVideoViews];
    [self updateSelfViewVisiable];
    
    if (sessions.count >= 3) {
        self.backgroundDoubleTap.enabled = YES;
    } else {
        self.backgroundDoubleTap.enabled = NO;
       // self.doubleClickFullSession = nil;
    }
}

- (void)setIdleTimerActive:(BOOL)active {
    [UIApplication sharedApplication].idleTimerDisabled = !active;
}

- (void)addLocalSession {
    VideoSession *localSession = [VideoSession localSession];
    [self.videoSessions addObject:localSession];
    [self.agoraKit setupLocalVideo:localSession.canvas];
    [self updateInterfaceWithSessions:self.videoSessions targetSize:self.containerView.frame.size animation:YES];
}

- (VideoSession *)fetchSessionOfUid:(NSUInteger)uid {
    for (VideoSession *session in self.videoSessions) {
        if (session.uid == uid) {
            return session;
        }
    }
    return nil;
}

- (VideoSession *)videoSessionOfUid:(NSUInteger)uid {
    VideoSession *fetchedSession = [self fetchSessionOfUid:uid];
    if (fetchedSession) {
        return fetchedSession;
    } else {
        VideoSession *newSession = [[VideoSession alloc] initWithUid:uid];
        [self.videoSessions addObject:newSession];
        [self updateInterfaceWithSessions:self.videoSessions targetSize:self.containerView.frame.size animation:YES];
        return newSession;
    }
}

- (void)setVideoMuted:(BOOL)muted forUid:(NSUInteger)uid {
    VideoSession *fetchedSession = [self fetchSessionOfUid:uid];
    fetchedSession.isVideoMuted = muted;
}

- (void)updateSelfViewVisiable {
    UIView *selfView = self.videoSessions.firstObject.hostingView;
    if (self.videoSessions.count == 2) {
        selfView.hidden = self.videoMuted;
    } else {
        selfView.hidden = false;
    }
}

- (void)alertString:(NSString *)string {
    if (!string.length) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:string preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)leaveChannel {
    [self.agoraKit setupLocalVideo:nil];
    [self.agoraKit leaveChannel:nil];
    [self.agoraKit stopPreview];
    
    for (VideoSession *session in self.videoSessions) {
        [session.hostingView removeFromSuperview];
    }
    [self.videoSessions removeAllObjects];
    
    [self setIdleTimerActive:YES];
    
    if ([self.delegate respondsToSelector:@selector(roomVCNeedClose:)]) {
        [self.delegate roomVCNeedClose:self];
    }
}

#pragma mark - Agora Media SDK
- (void)loadAgoraKit {
    self.agoraKit.delegate = self;
    [self.agoraKit setChannelProfile:AgoraChannelProfileCommunication];
    [self.agoraKit enableVideo];
    self.dimension = AgoraVideoDimension480x480;//AgoraVideoDimension1280x720;//;
    AgoraVideoEncoderConfiguration *configuration =
    [[AgoraVideoEncoderConfiguration alloc] initWithSize:self.dimension
                                               frameRate:AgoraVideoFrameRateFps15
                                                 bitrate:AgoraVideoBitrateStandard
                                         orientationMode:AgoraVideoOutputOrientationModeAdaptative];
    [self.agoraKit setVideoEncoderConfiguration:configuration];
    int mode = [self.agoraKit setLocalRenderMode:AgoraVideoRenderModeHidden];
    NSLog(@"mode=%d",mode);
    
    [self.agoraKit setRemoteRenderMode:[self.teachUID integerValue]  mode:AgoraVideoRenderModeHidden];
    if (self.encrypSecret.length) {
        [self.agoraKit setEncryptionMode:[EncryptionType modeStringWithEncrypType:self.encrypType]];
        [self.agoraKit setEncryptionSecret:self.encrypSecret];
    }
    
    [self.agoraKit createDataStream:&streamID reliable:YES ordered:YES];
    
    [self addLocalSession];
    [self.agoraKit startPreview];
    NSInteger uid = [[[DataModel model].userInfo[@"id"] description] integerValue];
    int code = [self.agoraKit joinChannelByToken:nil channelId:self.roomName info:nil uid:uid joinSuccess:nil];
    if (code == 0) {
        [self setIdleTimerActive:NO];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertString:[NSString stringWithFormat:@"Join channel failed: %d", code]];
        });
    }
}

#pragma mark - <AgoraRtcEngineDelegate>
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed {
    [self.agoraKit setRemoteRenderMode:uid mode:AgoraVideoRenderModeHidden];
    
    VideoSession *userSession = [self videoSessionOfUid:uid];
    userSession.size = size;
    [userSession.canvas setRenderMode:1];
    [self.agoraKit setupRemoteVideo:userSession.canvas];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed {
    if (self.videoSessions.count) {
        VideoSession *selfSession = self.videoSessions.firstObject;
        selfSession.size = size;
       // [selfSession.canvas setRenderMode:1];self.containerView.frame.size
        [self updateInterfaceWithSessions:self.videoSessions targetSize:size animation:NO];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    VideoSession *deleteSession;
    for (VideoSession *session in self.videoSessions) {
        if (session.uid == uid) {
            deleteSession = session;
        }
    }
    
    if (deleteSession) {
        [self.videoSessions removeObject:deleteSession];
        [deleteSession.hostingView removeFromSuperview];
        [self updateInterfaceWithSessions:self.videoSessions targetSize:self.containerView.frame.size animation:YES];
        
        if (deleteSession == self.doubleClickFullSession) {
            self.doubleClickFullSession = nil;
        }
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid {
    [self setVideoMuted:muted forUid:uid];
}

-(void)rtcEngine:(AgoraRtcEngineKit *)engine receiveStreamMessageFromUid:(NSUInteger)uid streamId:(NSInteger)streamId data:(NSData *)data {
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.msgTableView appendMsgToTableViewWithMsg:message msgType:MsgTypeChat];
}

- (void)rtcEngineConnectionDidInterrupted:(AgoraRtcEngineKit *)engine {
    [self.msgTableView appendMsgToTableViewWithMsg:@"Connection Did Interrupted" msgType:MsgTypeError];
}

- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine {
    [self.msgTableView appendMsgToTableViewWithMsg:@"Connection Did Lost" msgType:MsgTypeError];
}

#pragma mark --white event
- (void)fireMagixEvent:(NSInteger)type
{
    NSLog(@"fireMagixEvent type = %ld",type);
    //1视频放大（老师） 2视频还原（老师）  3白板放大 4白板还原
    NSInteger orType = self.switchType;
    self.switchType = type;
    
    if ( 1 == type )
    {//视频放大（老师）
        if (orType == 5)//双屏
        {
            self.switchType = 6;
        }
        oVideoRect = self.containerView.frame;
        
        [self.zoomView setHidden:NO];
        
        self.doubleClickFullSession = self.videoSessions.firstObject;
        [self updateInterfaceWithSessions:self.videoSessions targetSize:self.zoomView.frame.size animation:NO];
        
    }
    else if(2 == type)
    {//视频还原（老师）
        if (orType == 6)//双屏
        {
            self.switchType = 7;
        }
        self.doubleClickFullSession = nil;
        [self.zoomView setHidden:YES];
        [self updateInterfaceWithSessions:self.videoSessions targetSize:self.containerView.frame.size animation:NO];
        
    }
    else if(3 == type)
    {//白板放大
         [self.agoraKit disableVideo];
        roomVC.view.frame = self.zoomView.frame;
        [roomVC.view setNeedsDisplay];
    }
    else if(4 == type)
    {//白板还原
        [self.agoraKit enableVideo];
        roomVC.view.frame = self.whiteView.frame;
        [roomVC.view setNeedsDisplay];
        [self updateInterfaceWithSessions:self.videoSessions targetSize:self.containerView.frame.size animation:NO];
    }
    else if(5 == type)
    {//切换双屏
        self.doubleClickFullSession = nil;
        [self.zoomView setHidden:YES];
        [self updateInterfaceWithSessions:self.videoSessions targetSize:self.containerView.frame.size animation:NO];
    }
}
@end
