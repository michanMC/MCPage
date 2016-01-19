//
//  MCPageViewController.m
//  MCPage
//
//  Created by MC on 16/1/18.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "MCPageViewController.h"

@interface MCPageViewController ()
<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    UIViewController *currentViewController;
    //系统自的下拉刷新控制器
    UIRefreshControl * _refreshControl;
}

@property(nonatomic,strong) UITableView *firstViewTableView;
@property(nonatomic,strong) UITableView *secondViewTableView;
@property(nonatomic,strong) UIWebView *secondWebView;

@property(nonatomic,strong)UILabel * foortlabel;//继续滑动Lbl
@property(nonatomic,strong)UILabel * headlabel;//继续滑动返回Lbl

@property(nonatomic,strong)UIView * firstViewPullview;


@end

@implementation MCPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self prepareFirstView];
   // [self prepareSecondView];
    [self prepareSecondWebView];
    
    currentViewController=_firstViewController;
    // Do any additional setup after loading the view.
}
-(void)prepareFirstView{
    _firstViewController = [[UIViewController alloc]init];
    [self addChildViewController:_firstViewController];
    _firstViewController.view.frame = CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height -64 );
    _firstViewController.view.backgroundColor = [UIColor yellowColor];
    //再准备一下准背景视图
    //让这个view初始状态，是显示在屏幕外面的，当下拉时，才被显示进来
    _firstViewPullview= [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
    _firstViewPullview.backgroundColor = [UIColor whiteColor];
    //准备下拉刷新的视图
    _foortlabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
    _foortlabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _foortlabel.text = @"继续滑动看详情";
    _foortlabel.tag = 1000;
    _foortlabel.textAlignment = NSTextAlignmentCenter;
    _foortlabel.textColor = [UIColor purpleColor];
    
    //想显示这个视图，那得让这个视图跟着tableView的滚动来进出
    //所以需要把这个视图加到tableView上
    
    //a.将label加到view上
    [_firstViewPullview addSubview:_foortlabel];
    
    _firstViewTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 64) style:UITableViewStyleGrouped];
    _firstViewTableView.delegate  =self;
    _firstViewTableView.dataSource = self;
    
    //  [_firstViewTableView addSubview:firstViewPullview];
    
    _firstViewTableView.tableFooterView = _firstViewPullview;
    [_firstViewController.view addSubview:_firstViewTableView];
    [self.view addSubview:self.firstViewController.view];
 

}
-(void)prepareSecondView{
    _secondViewController = [[UIViewController alloc]init];
    _secondViewController.view.backgroundColor = [UIColor redColor];
    _secondViewController.view.frame = CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height -64 );
    //    [self.view addSubview:secondViewController.view];
    [self addChildViewController:_secondViewController];
    
    _secondViewTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 64) style:UITableViewStyleGrouped];
    _secondViewTableView.delegate  =self;
    _secondViewTableView.dataSource = self;
    
    
    //b.将view加到tableView上
    [_secondViewTableView addSubview:[self secondViewPullview]];
    
    [_secondViewController.view addSubview:_secondViewTableView];

}
-(void)prepareSecondWebView{
    _secondViewController = [[UIViewController alloc]init];
    _secondViewController.view.backgroundColor = [UIColor redColor];
    _secondViewController.view.frame = CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height -64 );
    //    [self.view addSubview:secondViewController.view];
    [self addChildViewController:_secondViewController];

    _secondWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height -64 )];
    _secondWebView.delegate = self;
    _secondWebView.backgroundColor = [UIColor whiteColor];
//    _secondWebView.scrollView.bounces = NO;

   // [_secondWebView.scrollView addSubview:[self secondViewPullview]];
   _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉返回商品详情"];
    _refreshControl.tintColor = [UIColor grayColor];
    [_refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];

    [_secondWebView.scrollView addSubview:_refreshControl];
    
    
    
    NSURL* nsurl = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsurl];
    [_secondWebView loadRequest:request];

    [_secondViewController.view addSubview:_secondWebView];

}
- (void)refreshAction{
    
    [_refreshControl endRefreshing];
    UIViewController *oldViewController=currentViewController;
    
    [self transitionFromViewController:currentViewController toViewController:_firstViewController duration:.6 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    }  completion:^(BOOL finished) {
        
        
        if (finished) {
            currentViewController=_firstViewController;
        }else{
            currentViewController=oldViewController;
        }
    }];

    
}
-(UIView*)secondViewPullview{
    //再准备一下准背景视图
    //让这个view初始状态，是显示在屏幕外面的，当下拉时，才被显示进来
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, -200, Main_Screen_Width, 200)];
    view.backgroundColor = [UIColor whiteColor];
    //准备下拉刷新的视图
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, Main_Screen_Width, 100)];
    label.text = @"释放返回商品详情";
    label.tag = 1001;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor purpleColor];
    
    //想显示这个视图，那得让这个视图跟着tableView的滚动来进出
    //所以需要把这个视图加到tableView上
    
    //a.将label加到view上
    [view addSubview:label];
    return view;
}
//实现滚动视图的didScroll这个协议方法，来判断是否在刷新数据
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //在这里实现下拉刷新，就是利用了tableView在上下滚动时，
    //y轴的坐标变化来控制是否刷新的
    NSLog(@"---- %f ----",scrollView.contentOffset.y);
    
    if (scrollView == _firstViewTableView) {
        if ((scrollView.contentOffset.y - (Main_Screen_Height-64)) > 60) {
            _foortlabel.text = @"释放查看图文详情";
            
            if (scrollView.isDragging) {
                
                NSLog(@"1");
            } else {
                
                NSLog(@"2");
                
                UIViewController *oldViewController=currentViewController;
                
                [self transitionFromViewController:currentViewController toViewController:_secondViewController duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                }  completion:^(BOOL finished) {
                    
                    
                    if (finished) {
                        currentViewController=_secondViewController;
                    }else{
                        currentViewController=oldViewController;
                    }
                }];
                
            }
            
        }
        else
        {
            _foortlabel.text = @"继续滑动看详情";
        }
    }
    else
        
    {
    
        if (scrollView.contentOffset.y < -58) {
            
            if (scrollView.isDragging) {
                
                NSLog(@"1");
            } else {
                
                NSLog(@"2");
                
                UIViewController *oldViewController=currentViewController;
                
                [self transitionFromViewController:currentViewController toViewController:_firstViewController duration:.6 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                }  completion:^(BOOL finished) {
                    
                    
                    if (finished) {
                        currentViewController=_firstViewController;
                    }else{
                        currentViewController=oldViewController;
                    }
                }];
                
            }
            
        }
        else
        {
            NSLog(@"3");
            
            
        }
    
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        
        return 60;
    }
    if (indexPath.row == 2) {
        
        return 100;
    }
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_firstViewTableView==tableView) {
        
        CGFloat hh =tableView.contentSize.height;
        
        if (hh > Main_Screen_Height-64) {
            _foortlabel.frame = CGRectMake(0, 0, Main_Screen_Width, 50);
            
            
            
        }
        else
        {
            CGFloat ff =  tableView.frame.size.height - hh;
            NSLog(@"MMMMMMMM%f",ff);
           _firstViewPullview.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - hh-10);
            _foortlabel.frame = CGRectMake(0, _firstViewPullview.frame.size.height - 50, Main_Screen_Width, 50);
            // b.将view加到tableView上
            //[_firstViewTableView addSubview:firstViewPullview];
            
        }
        
        
    }
    return 20;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MC"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MC"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.textLabel.textColor = AppCOLOR;
    return cell;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewDidStartLoad:(UIWebView*)webView{
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", Main_Screen_Width];
    [_secondWebView stringByEvaluatingJavaScriptFromString:meta];
    [_secondWebView stringByEvaluatingJavaScriptFromString:
     @"var tagHead =document.documentElement.firstChild;"
     "var tagMeta = document.createElement(\"meta\");"
     "tagMeta.setAttribute(\"http-equiv\", \"Content-Type\");"
     "tagMeta.setAttribute(\"content\", \"text/html; charset=utf-8\");"
     "var tagHeadAdd = tagHead.appendChild(tagMeta);"];
    [_secondWebView stringByEvaluatingJavaScriptFromString:
     @"var tagHead =document.documentElement.firstChild;"
     "var tagStyle = document.createElement(\"style\");"
     "tagStyle.setAttribute(\"type\", \"text/css\");"
     "tagStyle.appendChild(document.createTextNode(\"BODY{padding: 10pt 10pt}\"));"
     "var tagHeadAdd = tagHead.appendChild(tagStyle);"];
    //拦截网页图片  并修改图片大小
    [_secondWebView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth,oldheight;"
     "var maxwidth=300;"
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;oldheight=myimg.height;"
     "myimg.width = maxwidth;"
     "myimg.height = oldheight*(maxwidth*1.0/oldwidth);"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
}

-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [_secondWebView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
