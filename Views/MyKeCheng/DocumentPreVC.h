//
//  DocumentPreVC.h
//  jsz
//
//  Created by 朱东勇 on 2018/4/20.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>

@interface DocumentPreVC : UIViewController
@property (nonatomic, copy) NSString *documentID;

+ (DocumentPreVC*)vc;

@end
