//
//  KeyChainHandler.m
//  LoginWithTouchID
//
//  Created by 胡金友 on 16/3/2.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "KeyChainHandler.h"


@interface KeychainResults()

// 私有的获取到的数据的结果
@property (assign, nonatomic) id p_results;

// 私有的获取数据时的状态码
@property (assign, nonatomic) KeyChainFetchStatus p_status;

@end

@implementation KeychainResults

/**
 *  @author JyHu, 16-03-03 14:03:28
 *
 *  组装一个数据结果
 *
 *  @param results 从KeyChain中获取到的数据
 *  @param status  获取数据的状态码
 *
 *  @return self
 *
 *  @since v1.0
 */
+ (id)packageWithResults:(id)results status:(KeyChainFetchStatus)status;
{
    KeychainResults *res = [[KeychainResults alloc] init];
    res.p_results = results;
    res.p_status = status;
    return res;
}

// Getter
- (id)results { return self.p_results; }

// Getter
- (KeyChainFetchStatus)status { return self.p_status; }

@end



@implementation KeyChainHandler

+ (KeyChainHandler *)shareHandler
{
    static KeyChainHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[KeyChainHandler alloc] init];
    });
    
    return handler;
}

- (OSStatus)saveObject:(id)object forService:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQueryWithService:service];
    
    KeychainResults *existsResults = [self loadObjectForService:service];
    
    if (existsResults.status == KeyChainFetchStatusSuccessed)
    {
        return [self updateService:service withObject:object];
    }
    else
    {
        if (existsResults.status != KeyChainFetchStatusNotFound)
        {
            NSLog(@"error");
            
            return -1;
        }
        
        [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:object]
                          forKey:(__bridge id)kSecValueData];
        return SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
    }
}

- (OSStatus)updateService:(NSString *)service withObject:(id)object
{
    NSDictionary *keychainQuery = [self getKeychainQueryWithService:service];
    
    NSDictionary *changes = @{
                              (__bridge id)kSecValueData : [NSKeyedArchiver archivedDataWithRootObject:object]
                              };
    return SecItemUpdate((__bridge CFDictionaryRef)keychainQuery, (__bridge CFDictionaryRef)changes);
}

- (KeychainResults *)loadObjectForService:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQueryWithService:service];
    
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
    
    CFDataRef dataRef = NULL;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&dataRef);
    
    id results = nil;
    
    KeyChainFetchStatus kcStatus = KeyChainFetchStatusSuccessed;
    
    if (status == errSecSuccess)
    {
        @try {
            results = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)dataRef];
        }
        @catch (NSException *exception) {
            kcStatus = KeyChainFetchStatusUnarchiveError;
        }
        @finally {
            
        }
    }
    else
    {
        if (status == errSecItemNotFound)
        {
            kcStatus = KeyChainFetchStatusNotFound;
        }
        else
        {
            kcStatus = KeyChainFetchStatusOSError;
        }
    }
    
    if (dataRef)
    {
        CFRelease(dataRef);
    }
    
    return [KeychainResults packageWithResults:results status:kcStatus];
}

- (OSStatus)deleteObjectForService:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQueryWithService:service];
    
    return SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

#pragma mark - help methods

- (NSMutableDictionary *)getKeychainQueryWithService:(NSString *)service
{
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
                service, (__bridge id)kSecAttrService,
                service, (__bridge id)kSecAttrAccount,
                (__bridge id)kSecAttrAccessibleAfterFirstUnlock, (__bridge id)kSecAttrAccessible,
            nil];
    
    if (self.accessGroupName != nil)
    {
        [query setObject:self.accessGroupName forKey:(__bridge id)kSecAttrAccessGroup];
    }
    
    return query;
}

- (NSString *)keychainErrorToString:(OSStatus)error
{
    NSString *message = [NSString stringWithFormat:@"%ld", (long)error];
    
    switch (error)
    {
        case errSecSuccess:
            message = @"success";
            break;
            
        case errSecDuplicateItem:
            message = @"error item already exists";
            break;
            
        case errSecItemNotFound:
            message = @"error item not found";
            break;
            
        case errSecAuthFailed:
            message = @"error item authentication failed";
            break;
            
        default:
            break;
    }
    
    return message;
}

@end
