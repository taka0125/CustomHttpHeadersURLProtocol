//
//  CustomHttpHeadersNotification.swift
//  CustomHttpHeadersURLProtocol
//
//  Created by Takahiro Ooishi
//  Copyright (c) 2016 Takahiro Ooishi. All rights reserved.
//  Released under the MIT license.
//

public enum CustomHttpHeadersNotification: String {
  case DidSendBodyData = "CustomHttpHeadersURLProtocol/DidSendBodyData"
  
  public static func splitParams<T: CustomHttpHeadersNotificationParams>(_ notification: Notification) -> T? {
    guard let params = (notification as NSNotification).userInfo?["params"] as? T else {
      return nil
    }
    return params
  }
}

public protocol CustomHttpHeadersNotificationParams {
}

public extension CustomHttpHeadersNotification {
  open class DidSendBodyDataParams: NSObject, CustomHttpHeadersNotificationParams {
    open let bytesSent: Int64
    open let totalBytesSent: Int64
    open let totalBytesExpectedToSend: Int64
    
    open override var description: String {
      return "bytesSent: \(bytesSent), totalBytesSent: \(totalBytesSent), totalBytesExpectedToSend: \(totalBytesExpectedToSend)"
    }
    
    public init(bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
      self.bytesSent = bytesSent
      self.totalBytesSent = totalBytesSent
      self.totalBytesExpectedToSend = totalBytesExpectedToSend
    }
  }
}
