//
//  RNCConvert.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/21/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCConvert.h"
#import "NSData+FastHex.h"
#import "RNCSafeOperation.h"

@implementation RNCConvert

+ (NSData *)dataFromEncodedString:(NSString *)string {
    return [NSData dataWithHexString:string];
}

+ (NSString *)encodedStringFromData:(NSData *)data {
    return [data hexStringRepresentationUppercase:YES];
}

+ (NSDictionary *)dictionaryFromJsonData:(NSData *)data error:(NSError **)error {
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
}

+ (NSString *)stringFromBytes:(const char*)bytes length:(NSUInteger)len {
    NSData* data = [[NSData alloc] initWithBytesNoCopy:(void*)bytes length:len];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSData *)jsonDataFromDictionary:(NSDictionary *)dictionary error:(NSError **)error {
    return [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:error];
}

+ (NSDictionary *)dictionaryResponseFromJsonData:(NSData *)data error:(NSError **)error {
    NSDictionary* dict = [self dictionaryFromJsonData:data error:error];
    if (*error != nil) {
        return nil;
    }
    if ([[dict objectForKey:@"failed"] boolValue]) {
        *error = [NSError rustError:
                  [NSString stringWithFormat:@"Error in: %@, message: %@",
                   [dict objectForKey:@"loc"], [dict objectForKey: @"message"]
                   ]];
        return nil;
    }
    return [dict objectForKey:@"result"];
}

+ (NSArray *)arrayResponseFromJsonData:(NSData *)data error:(NSError **)error {
    NSDictionary* dict = [self dictionaryFromJsonData:data error:error];
    if (*error != nil) {
        return nil;
    }
    if ([[dict objectForKey:@"failed"] boolValue]) {
        *error = [NSError rustError:
                  [NSString stringWithFormat:@"Error in: %@, message: %@",
                   [dict objectForKey:@"loc"], [dict objectForKey: @"message"]
                   ]];
        return nil;
    }
    return [dict objectForKey:@"result"];
}

@end
