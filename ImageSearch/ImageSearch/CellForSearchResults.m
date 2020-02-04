//
//  CellForSearchResults.m
//  ImageSearch
//
//  Created by Amantay on 05.12.17.
//  Copyright © 2017 Amantay. All rights reserved.
//

#import "CellForSearchResults.h"

@interface CellForSearchResults ()

@property(nonatomic, strong) IBOutlet UILabel* title;
@property(nonatomic, strong) IBOutlet UIImageView* thumbnail;

@end

@implementation CellForSearchResults

-(void)setTitle:(NSString*)title
   andThumbnail:(UIImage*)thumbnail
{
    self.title.text=title;
    
    self.thumbnail.image=thumbnail;
}

@end
