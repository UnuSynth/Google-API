//
//  SearchImage.h
//  ImageSearch
//
//  Created by Amantay on 05.12.17.
//  Copyright © 2017 Amantay. All rights reserved.
//

//Класс для представления изображения, миниатюры и заголовка в виде одного объекта.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SearchImage : NSObject

@property(nonatomic, strong)UIImage* image;
@property(nonatomic, strong)UIImage* thumbnailImage;
@property(nonatomic, strong)NSString* title;

@end
