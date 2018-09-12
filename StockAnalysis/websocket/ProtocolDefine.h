//
//  ProtocolDefine.h
//  StockAnalysis
//
//  Created by try on 2018/9/12.
//  Copyright © 2018年 try. All rights reserved.
//

#ifndef ProtocolDefine_h
#define ProtocolDefine_h
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ProtocolNumber) {
    PN_KlineQuery = 1001,
    PN_KlineSubscribe,
    PN_KlineUnsubscribe,
    PN_KlineUpdate,
    PN_PriceQuery,
    PN_PriceSubscribe,
    PN_PriceUnsubscribe,
    PN_PriceUpdate,
    PN_StateQuery,
    PN_StateSubscribe,
    PN_StateUnsubscribe,
    PN_StateUpdate,
    PN_TodayQuery,
    PN_TodaySubscribe,
    PN_TodayUnsubscribe,
    PN_TodayUpdate,
    PN_DealsQuery,
    PN_DealsSubscribe,
    PN_DealsUnsubscribe,
    PN_DealsUpdate,
    PN_DepthQuery,
    PN_DepthSubscribe,
    PN_DepthUnsubscribe,
    PN_DepthUpdate,
    PN_OrderQuery,
    PN_OrderHistory,
    PN_OrderSubscribe,
    PN_OrderUnsubscribe,
    PN_OrderUpdate,
    PN_AssetQuery,
    PN_AssetHistory,
    PN_AssetSubscribe,
    PN_AssetUnsubscribe,
    PN_AssetUpdate
};

#endif /* ProtocolDefine_h */
