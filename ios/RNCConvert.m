//
//  RNCConvert.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/21/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCConvert.h"

@implementation RNCConvert

+ (NSData *)dataFromArray:(NSArray<NSNumber *> *)array {
    NSUInteger length = [array count];
    NSMutableData* data = [NSMutableData dataWithLength:length];
    
    char* bytes = [data mutableBytes];
    
    for (uint i = 0; i < length; i++) {
        bytes[i] = array[i].charValue;
    }
    
    return data;
}

+ (NSArray<NSNumber *> *)arrayFromData:(NSData *)data {
    NSUInteger length = [data length];
    const char* bytes = [data bytes];
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:length];
    
    for (uint i = 0; i < length; i++) {
        array[i] = [NSNumber numberWithChar:bytes[i]];
    }
    
    return array;
}

+ (NSDictionary *)dictionaryFromJsonData:(NSData *)data error:(NSError **)error {
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
}

+ (NSArray *)arrayFromJsonData:(NSData *)data error:(NSError **)error {
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
}

+ (NSString *)stringFromBytes:(const char*)bytes length:(NSUInteger)len {
    NSData* data = [[NSData alloc] initWithBytesNoCopy:(void*)bytes length:len];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end