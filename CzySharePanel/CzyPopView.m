//  CzyPopView.m
//  CzySharePanel
//  Created by macOfEthan on 17/10/9.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//  Github:https://github.com/ITIosEthan
//  简书：http://www.jianshu.com/u/1d52648daace
/**
 *   █████▒█    ██  ▄████▄   ██ ▄█▀   ██████╗ ██╗   ██╗ ██████╗
 * ▓██   ▒ ██  ▓██▒▒██▀ ▀█   ██▄█▒    ██╔══██╗██║   ██║██╔════╝
 * ▒████ ░▓██  ▒██░▒▓█    ▄ ▓███▄░    ██████╔╝██║   ██║██║  ███╗
 * ░▓█▒  ░▓▓█  ░██░▒▓▓▄ ▄██▒▓██ █▄    ██╔══██╗██║   ██║██║   ██║
 * ░▒█░   ▒▒█████▓ ▒ ▓███▀ ░▒██▒ █▄   ██████╔╝╚██████╔╝╚██████╔╝
 *  ▒ ░   ░▒▓▒ ▒ ▒ ░ ░▒ ▒  ░▒ ▒▒ ▓▒   ╚═════╝  ╚═════╝  ╚═════╝
 */

#import "CzyPopView.h"
#import "CzyCustomBtn.h"
#import <UMSocialCore/UMSocialCore.h>

@interface CzyPopView ()

/**平台*/
@property (nonatomic, strong) NSMutableArray *platforms;
/**背景*/
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
/**弹框动画计时器*/
@property (nonatomic, strong) NSTimer *timer;
/**计数*/
@property (nonatomic, assign) NSInteger upIndex;
@property (nonatomic, assign) NSInteger downIndex;

@end

@implementation CzyPopView

#pragma mark - Getter
- (NSMutableArray *)platforms
{
    if (!_platforms) {
        self.platforms = [NSMutableArray array];
    }
    return _platforms;
}


- (NSTimer *)timer
{
    if (!_timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:CZY_POP_DURATION target:self selector:@selector(popUp:) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark - Setter
- (void)setImageNames:(NSArray *)imageNames
{
    _imageNames = imageNames;
    
    [self setupPlatformUI];

    for (NSInteger i=10001; i<10001+_imageNames.count; i++) {
        
        CzyCustomBtn *btn = [_visualEffectView viewWithTag:i];
        
        if ([_imageNames[i-10001] length] == 0) {
            btn.imageView.backgroundColor = [UIColor lightGrayColor];
        }else{
            btn.backgroundColor = [UIColor clearColor];
            btn.imageView.image = [UIImage imageNamed:_imageNames[i-10001]];
        }
    }
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    
    [self setupPlatformUI];
    
    for (NSInteger i=10001; i<10001+_imageNames.count; i++) {
        
        CzyCustomBtn *btn = [_visualEffectView viewWithTag:i];
        
        [btn setTitle:_imageNames[i-10001] forState:UIControlStateNormal];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    for (CzyCustomBtn *btn in self.platforms) {
        
        [btn setTitleColor:textColor forState:UIControlStateNormal];
    }
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    
    for (CzyCustomBtn *btn in self.platforms) {
        
        btn.titleLabel.font = textFont;
    }
}

#pragma mark - 初始化平台
- (void)setupPlatformUI
{
    if (_visualEffectView) {
        return;
    }
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    _visualEffectView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:_visualEffectView];
    
    _visualEffectView.userInteractionEnabled = NO;
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismiss:)];
    [_visualEffectView addGestureRecognizer:dismiss];
    
    [self.platforms removeAllObjects];
    
    NSInteger num = 0;
    CGFloat w = (CZY_FULL_WIDTH-4*margin)/3;
    CGFloat h = w;
    for (NSInteger i=0; i<2; i++) {
        
        if (num >= _titles.count-1) {
            break;
        }
        
        for (NSInteger j=0; j<3; j++) {
            
            CzyCustomBtn *btn = [CzyCustomBtn buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((j+1)*margin+j*w, CZY_FULL_HEIGHT/2+i*h, w, h);
            [btn setTitle:_titles[num] forState:UIControlStateNormal];
            btn.imageView.transform = CGAffineTransformMakeScale(1.8, 1.8);
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(shareWithPlatform:) forControlEvents:UIControlEventTouchUpInside];
            [_visualEffectView addSubview:btn];
            
            //tag:
            btn.tag = 10001+num;
            //起始位置 屏幕下方
            btn.transform = CGAffineTransformMakeTranslation(0, CZY_FULL_HEIGHT);
            //加入数组:
            [self.platforms addObject:btn];
            //起始计数
            _upIndex = 0;
            _downIndex = self.platforms.count;
            
            //开始定时器
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            
            
            if (num >= _titles.count-1) {
                break;
            }
            
            num++;

        }
    }
    
}

#pragma mark - 按钮弹出
- (void)popUp:(NSTimer *)timer
{
    if (_upIndex == self.platforms.count) {
        
        [self destroyTimer];
        
        _upIndex = 0;
        
        return;
    }
    
    CzyCustomBtn *currentBtn = self.platforms[_upIndex];
    
    _upIndex++;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //归位
        currentBtn.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        //弹完了打开交互 避免乱弹
        if (_upIndex == self.platforms.count) {
            _visualEffectView.userInteractionEnabled = YES;
        }
    }];
}

#pragma mark - 按钮落下
- (void)popDown:(NSTimer *)timer
{
    if (_downIndex <= 0) {
        
        _downIndex = self.platforms.count;
        
        return;
    }
    
    CzyCustomBtn *currentBtn = self.platforms[_downIndex-1];
    
    _downIndex--;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        currentBtn.transform = CGAffineTransformMakeTranslation(0, CZY_FULL_HEIGHT);
        
    } completion:^(BOOL finished) {
        
        
        if (_downIndex == 0) {
            
            [self destroyView];
            [self destroyTimer];
        }
    }];
}

#pragma mark - 选择分享
- (void)shareWithPlatform:(UIButton *)sender
{
    NSLog(@"tag = %ld", sender.tag);
    UMSocialPlatformType type;
    
    switch (sender.tag) {
        case 10001:
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
                
                NSLog(@"您未安装微信客户端");
                
                return ;
            }
            
            type = UMSocialPlatformType_WechatSession;
            
            break;
        case 10002:
            
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
                
                NSLog(@"您未安装微信客户端");
                
                return ;
            }
            
            type = UMSocialPlatformType_WechatTimeLine;
            break;
        case 10003:
            
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
                
                NSLog(@"您未安装微信客户端");
                return ;
            }
            
            type = UMSocialPlatformType_WechatFavorite;
            break;
        case 10004:
            
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                
                NSLog(@"您未安装QQ客户端");
                
                return ;
                
            }
            
            type = UMSocialPlatformType_QQ;
            break;
        case 10005:
            
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                
                NSLog(@"您未安装QQ客户端");
                return ;
                
            }
            
            type = UMSocialPlatformType_Qzone;
            
            break;
        case 10006:
            
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]] && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipayshare://"]]) {
                
                NSLog(@"您未安装支付宝客户端");
                return ;
            }
            
            type = UMSocialPlatformType_AlipaySession;
            
            break;
            
        default:
            break;
    }

    [self shareWebPageToPlatformType:type];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"百度" descr:@"分享测试" thumImage:[UIImage imageNamed:@"微信"]];
    
    //设置网页地址
    shareObject.webpageUrl = @"http://www.baidu.com";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        
        NSLog(@"share error ");
        
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
//        [self alertWithError:error];
    }];
}

#pragma mark - 提示
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[NSAttributedString alloc] initWithString:@"点击右上角分享"];
}

#pragma mark - #pragma mark - 分享面板消失 没弹完所有平台默认关闭交互(1.控制交互的方式控制弹框)
- (void)tapDismiss:(UITapGestureRecognizer *)tap
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:CZY_POP_DURATION target:self selector:@selector(popDown:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 移除定时器
- (void)destroyTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 移除视图
- (void)destroyView
{
    [_visualEffectView removeFromSuperview];
    _visualEffectView = nil;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
