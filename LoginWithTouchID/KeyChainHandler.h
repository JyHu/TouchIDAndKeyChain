//
//  KeyChainHandler.h
//  LoginWithTouchID
//
//  Created by 胡金友 on 16/3/2.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KeyChainFetchStatus) {
    KeyChainFetchStatusSuccessed,   // 有数据，并且成功查询到
    KeyChainFetchStatusOSError,     // 获取失败
    KeyChainFetchStatusNotFound,    // 没有查到数据
    KeyChainFetchStatusUnarchiveError   // 解归档失败
};

/**
 *  @author JyHu, 16-03-03 14:03:16
 *
 *  获取KeyChain中得数据返回结果
 *
 *  @since v1.0
 */
@interface KeychainResults : NSObject

/**
 *  @author JyHu, 16-03-03 14:03:47
 *
 *  获取到的结果
 *
 *  @since v1.0
 */
@property (assign, nonatomic, readonly) id results;

/**
 *  @author JyHu, 16-03-03 14:03:02
 *
 *  获取结果的状态信息
 *
 *  @since v1.0
 */
@property (assign, nonatomic, readonly) KeyChainFetchStatus status;

@end

@interface KeyChainHandler : NSObject

/**
 *  @author JyHu, 16-03-03 14:03:17
 *
 *  单例方法
 *
 *  @return self
 *
 *  @since v1.0
 */
+ (KeyChainHandler *)shareHandler;

/**
 *  @author JyHu, 16-03-03 14:03:28
 *
 *  是否使用分组，关于分组，分组的话，可以让同一家的不同APP共享KeyChain中得数据
 *
 *  @since v1.0
 */
@property (retain, nonatomic) NSString *accessGroupName;

/**
 *  @author JyHu, 16-03-03 14:03:07
 *
 *  保存数据到KeyChain
 *
 *  @param object  要保存的数据
 *  @param service 保存的时候的key
 *
 *  @return 保存的结果
 *
 *  @since v1.0
 */
- (OSStatus)saveObject:(id)object forService:(NSString *)service;

/**
 *  @author JyHu, 16-03-03 14:03:40
 *
 *  删除KeyChain中得数据
 *
 *  @param service 保存数据时用到的key
 *
 *  @return 删除的结果
 *
 *  @since v1.0
 */
- (OSStatus)deleteObjectForService:(NSString *)service;

/**
 *  @author JyHu, 16-03-03 14:03:17
 *
 *  获取保存在KeyChain中得数据
 *
 *  @param service 保存数据时用到的key
 *
 *  @return KeychainResults
 *
 *  @since v1.0
 */
- (KeychainResults *)loadObjectForService:(NSString *)service;

@end


#if 0

// OSStatus 状态码说明

CF_ENUM(OSStatus)
{
    errSecSuccess                               = 0,       /* No error. */
    errSecUnimplemented                         = -4,      /* Function or operation not implemented. */
    errSecIO                                    = -36,     /*I/O error (bummers)*/
    errSecOpWr                                  = -49,     /*file already open with with write permission*/
    errSecParam                                 = -50,     /* One or more parameters passed to a function where not valid. */
    errSecAllocate                              = -108,    /* Failed to allocate memory. */
    errSecUserCanceled                          = -128,    /* User canceled the operation. */
    errSecBadReq                                = -909,    /* Bad parameter or invalid state for operation. */
    errSecInternalComponent                     = -2070,
    errSecNotAvailable                          = -25291,  /* No keychain is available. You may need to restart your computer. */
    errSecDuplicateItem                         = -25299,  /* The specified item already exists in the keychain. */
    errSecItemNotFound                          = -25300,  /* The specified item could not be found in the keychain. */
    errSecInteractionNotAllowed                 = -25308,  /* User interaction is not allowed. */
    errSecDecode                                = -26275,  /* Unable to decode the provided data. */
    errSecAuthFailed                            = -25293,  /* The user name or passphrase you entered is not correct. */
};

#endif