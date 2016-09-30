//
//  CustomHttpHeadersNotification.swift
//  CustomHttpHeadersURLProtocol
//
//  Created by Takahiro Ooishi
//  Copyright (c) 2016 Takahiro Ooishi. All rights reserved.
//  Released under the MIT license.
//

public enum CustomHttpHeadersNotification: String {
  case didSendBodyData = "CustomHttpHeadersURLProtocol/didSendBodyData"
  
  public static func splitParams<T: CustomHttpHeadersNotificationParams>(_ notification: Notification) -> T? {
    guard let params = notification.userInfo?["params"] as? T else {
      return nil
    }
    return params
  }
}

public protocol CustomHttpHeadersNotificationParams {
}

public extension CustomHttpHeadersNotification {
  public class DidSendBodyDataParams: NSObject, CustomHttpHeadersNotificationParams {
    public let bytesSent: Int64
    public let totalBytesSent: Int64
    public let totalBytesExpectedToSend: Int64
    
    public override var description: String {
      return "bytesSent: \(bytesSent), totalBytesSent: \(totalBytesSent), totalBytesExpectedToSend: \(totalBytesExpectedToSend)"
    }
    
    public init(bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
      self.bytesSent = bytesSent
      self.totalBytesSent = totalBytesSent
      self.totalBytesExpectedToSend = totalBytesExpectedToSend
    }
  }
}
