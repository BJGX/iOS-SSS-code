//
//  ServerConfig.h
//  WXReader
//
//  Created by Andrew on 2018/5/15.
//  Copyright © 2018年 Andrew. All rights reserved.
//

#ifndef ServerConfig_h
#define ServerConfig_h

// 请求成功
#define Request_Success_From(x) [[NSString stringWithFormat:@"%@",[x objectForKey:@"code"]] isEqualToString:@"0"]

// 比对ErrorNo
#define Compare_Json_isEqualTo(A,B) [[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@", [A objectForKey:@"code"]]] isEqualToString:B]

// 每页数据量
#define Page_size 10




#endif /* ServerConfig_h */
