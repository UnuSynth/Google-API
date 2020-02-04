//
//  OriginalImageViewController.m
//  ImageSearch
//
//  Created by Amantay on 06.12.17.
//  Copyright © 2017 Amantay. All rights reserved.
//

#import "OriginalImageViewController.h"

@interface OriginalImageViewController ()

@property(nonatomic, strong)IBOutlet UIImageView* imageView;
@property(nonatomic, strong)IBOutlet UILabel* titleLabel;

@end

@implementation OriginalImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.titleLabel.text=self.titleText;
    self.imageView.image=self.image;
}

@end
