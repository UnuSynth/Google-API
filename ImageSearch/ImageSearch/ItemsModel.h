//
//  ItemsModel.h
//  ImageSearch
//
//  Created by Amantay on 05.12.17.
//  Copyright © 2017 Amantay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PagemapModel.h"

@interface ItemsModel : JSONModel

@property(nonatomic)PagemapModel* pagemap;
@property(nonatomic)NSString* title;

@end

@protocol ItemsModel

@end
