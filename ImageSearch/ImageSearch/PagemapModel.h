//
//  PagemapModel.h
//  ImageSearch
//
//  Created by Amantay on 05.12.17.
//  Copyright © 2017 Amantay. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SrcModel.h"

@interface PagemapModel : JSONModel

@property(nonatomic)NSArray<SrcModel, Optional>* cse_image;
@property(nonatomic)NSArray<SrcModel, Optional>* cse_thumbnail;

@end
