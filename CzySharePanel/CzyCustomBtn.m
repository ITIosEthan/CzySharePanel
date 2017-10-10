//  CzyCustomBtn.m
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

#import "CzyCustomBtn.h"

@implementation CzyCustomBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews
{
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*2/3);
    self.titleLabel.frame = CGRectMake(0, self.frame.size.height*2/3, self.frame.size.width, self.frame.size.height/3);
}


@end
