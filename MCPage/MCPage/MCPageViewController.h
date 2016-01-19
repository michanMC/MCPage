//
//  MCPageViewController.h
//  MCPage
//
//  Created by MC on 16/1/18.
//  Copyright © 2016年 MC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCPageViewController : UIViewController
@property(nonatomic,strong)UIViewController * firstViewController;//第一个视图
@property(nonatomic,strong)UIViewController * secondViewController;//第二个视图（TableView）
@property(nonatomic,strong)UIViewController * secondWebViewController;//第二个视图（WebView）


@end
