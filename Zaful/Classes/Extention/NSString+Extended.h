//
//  NSString+Extended.h
//  Yoshop
//
//  Created by 7F-shigm on 16/6/29.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extended)

- (NSString*) decodeFromPercentEscapeString:(NSString *) string;

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (NSDate *)date;
@end
