//
//  Notifier.swift
//  CustomHttpHeadersURLProtocol
//
//  Created by Takahiro Ooishi
//  Copyright (c) 2016 Takahiro Ooishi. All rights reserved.
//  Released under the MIT license.
//

internal struct Notifier {
  static func notifyDidSendBodyData(_ bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
    let params = CustomHttpHeadersNotification.DidSendBodyDataParams(bytesSent: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
    sendNotification(.DidSendBodyData, params: params)
  }
}

extension Notifier {
  fileprivate static func sendNotification(_ notification: CustomHttpHeadersNotification, params: AnyObject?) {
    var userInfo = [String: AnyObject]()
    if let params = params {
      userInfo["params"] = params;
    }
    
    let n = Notification(name: Notification.Name(rawValue: notification.rawValue), object: nil, userInfo: userInfo)
    NotificationCenter.default.post(n)
  }
}
