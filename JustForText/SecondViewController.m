//
//  SecondViewController.m
//  JustForText
//
//  Created by jf on 16/6/20.
//  Copyright © 2016年 jfsld1989. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<UIScrollViewDelegate>{
    
    UIScrollView *allScrollView;
    UIScrollView *webScrollView;
    UIScrollView *tableScrollView;
    
}

@end

@implementation SecondViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title  = @"滚动测试";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self allScrollViewLoad];
    
    [self webScrollViewLoad];
    
    [self tableScrollViewLoad];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    //设置最外面的scrollview能滚动的范围，两屏
    [allScrollView setFrame:self.view.bounds];
    [allScrollView setContentSize:CGSizeMake(width, height * 2)];
    
    [webScrollView setFrame:CGRectMake(0.0f, 0.0f, width, height)];
    [webScrollView setContentSize:CGSizeMake(width, height * 2)];
    
    [tableScrollView setFrame:CGRectMake(0.0f, height, width, height)];
    [tableScrollView setContentSize:CGSizeMake(width, height * 2)];
}

- (void)allScrollViewLoad{
    
    allScrollView = [[UIScrollView alloc] init];
    allScrollView.delegate = self;
    allScrollView.scrollEnabled = NO;
    allScrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:allScrollView];
    
}

- (void)webScrollViewLoad{
    
    webScrollView = [[UIScrollView alloc] init];
    webScrollView.delegate = self;
    webScrollView.backgroundColor = [UIColor redColor];
    [allScrollView addSubview:webScrollView];
    
}

- (void)tableScrollViewLoad{
    
    tableScrollView = [[UIScrollView alloc] init];
    tableScrollView.delegate = self;
    tableScrollView.backgroundColor = [UIColor blueColor];
    [allScrollView addSubview:tableScrollView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetY = scrollView.contentOffset.y;

    //如果是网页滚动
    if (scrollView == webScrollView) {
        
        CGFloat webSpilth = offSetY + CGRectGetHeight(webScrollView.bounds) - webScrollView.contentSize.height;
        if(webSpilth > 0){
            //列表cell已经出现
            [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height)];
            
            if(webSpilth < CGRectGetHeight(tableScrollView.bounds)){
                //如果没滚动到列表底部
                [allScrollView setContentOffset:CGPointMake(0, allScrollView.contentOffset.y + webSpilth)];
                
            }else{
                //如果滚动幅度大，超过列表的高度，滚动列表
                CGFloat tableSpilth = webSpilth - CGRectGetHeight(tableScrollView.bounds);
                [tableScrollView setContentOffset:CGPointMake(0.0f, tableSpilth)];
            }
        }else{
            CGFloat allContentOffSetY = allScrollView.contentOffset.y;
            if(allContentOffSetY > 0){
                //列表cell已经出现 但是webview是往上滚动的时候
                [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height)];
                
                CGFloat allNeedSplith = allContentOffSetY + webSpilth;
                allNeedSplith = allNeedSplith >= 0 ?allNeedSplith:0;
                [allScrollView setContentOffset:CGPointMake(0, allNeedSplith)];
            }
        }
        
    }
    else if (scrollView == allScrollView){
        
        if(offSetY < 0){
            
            [allScrollView setContentOffset:CGPointMake(0.0f, 0.0f)];
            [webScrollView setContentOffset:CGPointMake(0.0f, webScrollView.contentOffset.y + offSetY)];
        }else{
            CGFloat tableSpilth = offSetY - CGRectGetHeight(allScrollView.bounds);
            if(tableSpilth > 0){
                [allScrollView setContentOffset:CGPointMake(0.0f, CGRectGetHeight(allScrollView.bounds))];
                [tableScrollView setContentOffset:CGPointMake(0.0f, tableScrollView.contentOffset.y + tableSpilth)];
            }
        }
    }
    else if (scrollView == tableScrollView){
        
        if(offSetY < 0){
            //下拉看到网页的时候
            CGFloat tableSplith = offSetY + CGRectGetHeight(allScrollView.bounds);
            
            if(tableSplith > 0){
                [allScrollView setContentOffset:CGPointMake(0, allScrollView.contentOffset.y + offSetY)];
            }else{
                [allScrollView setContentOffset:CGPointMake(0.0f, 0.0f)];
            }
            
            [tableScrollView setContentOffset:CGPointMake(0, 0.0f)];
        
        }else{
            CGFloat allContentOffSetY = allScrollView.contentOffset.y;
            if(allContentOffSetY < CGRectGetHeight(allScrollView.bounds)){
                //如果网页已经出现，滚动列表的时候其实就是在滚动最外面的ScrollView

                [tableScrollView setContentOffset:CGPointMake(0, 0.0f)];
                
                CGFloat allNeedSplith = allContentOffSetY + offSetY;
                allNeedSplith = allNeedSplith >=  CGRectGetHeight(allScrollView.bounds)*2 ? CGRectGetHeight(allScrollView.bounds):allNeedSplith;
                [allScrollView setContentOffset:CGPointMake(0, allNeedSplith)];

            }
        }
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self handleScrollEnable];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    [self handleScrollEnable];
}

- (void)handleScrollEnable{
    CGFloat allContentOffSetY = allScrollView.contentOffset.y;
    if(allContentOffSetY <= 0){
        
        [webScrollView setScrollEnabled:YES];
        [allScrollView setScrollEnabled:NO];
        [tableScrollView setScrollEnabled:NO];
        [webScrollView setShowsVerticalScrollIndicator:YES];
        [allScrollView setShowsVerticalScrollIndicator:NO];
        [tableScrollView setShowsVerticalScrollIndicator:NO];

    }
    else if (allContentOffSetY > 0 && allContentOffSetY < CGRectGetHeight(allScrollView.bounds)){
        
        [allScrollView setScrollEnabled:YES];
        [webScrollView setScrollEnabled:NO];
        [tableScrollView setScrollEnabled:NO];
        [allScrollView setShowsVerticalScrollIndicator:YES];
        [webScrollView setShowsVerticalScrollIndicator:NO];
        [tableScrollView setShowsVerticalScrollIndicator:NO];
    }
    else{
        
        [tableScrollView setScrollEnabled:YES];
        [allScrollView setScrollEnabled:NO];
        [webScrollView setScrollEnabled:NO];
        [tableScrollView setShowsVerticalScrollIndicator:YES];
        [webScrollView setShowsVerticalScrollIndicator:NO];
        [allScrollView setShowsVerticalScrollIndicator:NO];
    }
}


@end
