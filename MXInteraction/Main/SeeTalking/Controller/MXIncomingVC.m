//
//  MXIncomingVC.m
//  MXInteraction
//
//  Created by maRk on 16/10/11.
//  Copyright © 2016年 maRk. All rights reserved.
//

#import "MXIncomingVC.h"

@interface MXIncomingVC ()

@property (nonatomic, strong) EMCallSession *callSession;
@property (nonatomic, assign) BOOL isCaller;
@property (nonatomic, weak) UIImageView *bgView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *countdownLabel;
@property (nonatomic, weak) UIButton *acceptBtn;
@property (nonatomic, weak) UIButton *unlockBtn;
@property (nonatomic, weak) UIButton *rejectBtn;

@end

@implementation MXIncomingVC

- (instancetype)initWithSessicon:(EMCallSession *)callSession andIsCaller:(BOOL)isCaller
{
    if (self = [super init]) {
        self.callSession = callSession;
        self.isCaller = isCaller;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"bg.png"];
    self.bgView = bgView;
    [self.view addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 100, 40)];
    titleLabel.text = @"01栋03小区";
    self.titleLabel = titleLabel;
    [self.view addSubview:titleLabel];
    
    UILabel *countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 20)];
    countdownLabel.text = @"10:00";
    self.countdownLabel = countdownLabel;
    [self.view addSubview:countdownLabel];
    
    self.callSession.remoteVideoView = [[EMCallRemoteView alloc] initWithFrame:CGRectMake(50 , 100, 200, 200)];
    self.callSession.remoteVideoView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.callSession.remoteVideoView];
    
    UIButton *acceptBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 50, 50)];
    [acceptBtn setTitle:@"接受" forState:UIControlStateNormal];
    acceptBtn.backgroundColor = [UIColor greenColor];
    [acceptBtn addTarget:self action:@selector(accept) forControlEvents:UIControlEventTouchUpInside];
    self.acceptBtn = acceptBtn;
    [self.view addSubview:acceptBtn];
    
    UIButton *rejectBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 300, 50, 50)];
    [rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    rejectBtn.backgroundColor = [UIColor redColor];
    [rejectBtn addTarget:self action:@selector(reject) forControlEvents:UIControlEventTouchUpInside];
    self.rejectBtn = rejectBtn;
    [self.view addSubview:rejectBtn];
    
}

- (void)accept
{
    if (self.callSession) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient].callManager answerIncomingCall:self.callSession.sessionId];
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error.code == EMErrorNetworkUnavailable) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"network.disconnection", @"Network disconnection") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                    else{
                        //                        [self hangupCallWithReason:EMCallEndReasonFailed];
                    }
                });
            }
        });
    }
}

- (void)reject
{
    if (self.callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.sessionId reason:EMCallEndReasonDecline];
    }
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
