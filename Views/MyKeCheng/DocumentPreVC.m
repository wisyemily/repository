//
//  DocumentPreVC.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/20.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "DocumentPreVC.h"

#import "ImageCache.h"
#import "UIApplication+PresentedViewController.h"

@interface DocumentPreVC ()<UIWebViewDelegate>
@property (nonatomic) NSUInteger page;
@property (nonatomic) NSUInteger docPage;

@property (nonatomic, strong) IBOutlet UIImageView  *imageIV;
@property (nonatomic, strong) IBOutlet UIWebView  *webView;

@property (nonatomic, strong) NIMDocTranscodingInfo * info;

@property (nonatomic, strong) IBOutlet UILabel  *titleLbl;
@property (nonatomic, strong) IBOutlet UIButton *firstPage;
@property (nonatomic, strong) IBOutlet UIButton *prePage;
@property (nonatomic, strong) IBOutlet UIButton *nextPage;
@property (nonatomic, strong) IBOutlet UIButton *lastPage;

@end

@implementation DocumentPreVC

+ (DocumentPreVC*)vc {
    return [[DocumentPreVC alloc] initWithNibName:@"DocumentPreVC" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - Setter
- (void)setDocumentID:(NSString *)documentID {
    _documentID = documentID;
    
    self.page = 0;
}

- (void)setPage:(NSUInteger)page {
    [[NIMSDK sharedSDK].docTranscodingManager inquireDocInfo:_documentID completion:^(NSError * _Nullable error, NIMDocTranscodingInfo * _Nullable info) {
        if (!error) {
            self.info = info;
            self.docPage = 0;
        }else {
            //错误
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:error.userInfo[@"NSLocalizedDescription"] preferredStyle:UIAlertControllerStyleAlert];
            [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            [[UIApplication presentedViewController] presentViewController:controller animated:YES completion:nil];
        }
    }];
}

- (void)setDocPage:(NSUInteger)docPage {
    _docPage = docPage;
    
//    if (self.info.numberOfPages) {
//        self.firstPage.hidden = NO;
//        self.prePage.hidden = NO;
//        self.nextPage.hidden = NO;
//        self.lastPage.hidden = NO;
//
//        self.firstPage.enabled = _docPage != 0;
//        self.prePage.enabled = _docPage != 0;
//        self.nextPage.enabled = _docPage != (self.info.numberOfPages - 1);
//        self.lastPage.enabled = _docPage != (self.info.numberOfPages - 1);
//    }else if (self.info.numberOfPages <= 1){
        self.firstPage.hidden = YES;
        self.prePage.hidden = YES;
        self.nextPage.hidden = YES;
        self.lastPage.hidden = YES;
//    }
    
    self.titleLbl.text = [NSString stringWithFormat:@"%ld/%ld", _docPage + 1, self.info.numberOfPages];
    
    NSString *url = [self.info transcodedUrl:_docPage ofQuality:NIMDocTranscodingQualityMedium];
    if (!url) {
        url = self.info.sourceFileUrl;
    }
//    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
//    self.imageIV.image = [UIImage imageWithData:data];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    self.webView.scalesPageToFit = YES;
    NSLog(@"%@", url);
}

#pragma mark - IBAction
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)firstPage:(id)sender {
    self.docPage = 0;
}

- (IBAction)prePage:(id)sender {
    self.docPage = MAX(self.docPage, 1) - 1;
}

- (IBAction)nextPage:(id)sender {
    self.docPage = MIN(self.docPage + 1, self.info.numberOfPages - 1);
}

- (IBAction)lastPage:(id)sender {
    self.docPage = self.info.numberOfPages - 1;
}


@end
