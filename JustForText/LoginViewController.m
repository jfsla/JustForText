//
//  ViewController.m
//  JustForText
//
//  Created by jfsld1989 on 15/12/23.
//  Copyright © 2015年 jfsld1989. All rights reserved.
//

#import "LoginViewController.h"
#import "SecondViewController.h"

@interface LoginViewController (){
    
}

@end

@implementation LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 44.0f)];
    [b setTitle:@"跳转" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(jumpToSecondeC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:b];
    [self.navigationItem setRightBarButtonItem:item];
}

- (void)jumpToSecondeC{
    SecondViewController *sc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:sc animated:YES];
}

@end
