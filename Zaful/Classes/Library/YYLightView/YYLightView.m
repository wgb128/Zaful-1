//
//  YYLightView.m
//  ListPageViewController
//
//  Created by TsangFa on 21/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "YYLightView.h"

@implementation YYLightView{
    UIImage *_image;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.layer.contents = (id)image.CGImage;
    
}

- (UIImage *)image {
    id content = self.layer.contents;
    if (content != (id)_image.CGImage) {
        CGImageRef ref = (__bridge CGImageRef)(content);
        if (ref && CFGetTypeID(ref) == CGImageGetTypeID()) {
            _image = [UIImage imageWithCGImage:ref scale:self.layer.contentsScale orientation:UIImageOrientationUp];
        } else {
            _image = nil;
        }
    }
    return _image;
}



@end
