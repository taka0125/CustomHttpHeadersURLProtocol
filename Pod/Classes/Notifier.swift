//
//  Notifier.swift
//  CustomHttpHeadersURLProtocol
//
//  Created by Takahiro Ooishi
//  Copyright (c) 2016 Takahiro Ooishi. All rights reserved.
//  Released under the MIT license.
//

internal struct Notifier {
  static func notifyDidSendBodyData(bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
    let params = CustomHttpHeadersNotification.DidSendBodyDataParams(bytesSent: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
    sendNotification(.DidSendBodyData, params: params)
  }
}

extension Notifier {
  private static func sendNotification(notification: CustomHttpHeadersNotification, params: AnyObject?) {
    var userInfo = [String: AnyObject]()
    if let params = params {
      userInfo["params"] = params;
    }
    
    let n = NSNotification(name: notification.rawValue, object: nil, userInfo: userInfo)
    NSNotificationCenter.defaultCenter().postNotification(n)
  }
}
