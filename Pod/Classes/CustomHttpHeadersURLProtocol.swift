//
//  CustomHttpHeadersURLProtocol.swift
//  CustomHttpHeadersURLProtocol
//
//  Created by Takahiro Ooishi
//  Copyright (c) 2015 Takahiro Ooishi. All rights reserved.
//  Released under the MIT license.
//

import Foundation

public final class CustomHttpHeadersConfig {
  public typealias CanHandleRequest = NSURLRequest -> Bool
  public typealias SetupCustomHeaders = NSMutableURLRequest -> Void
  
  private let setupCustomHeaders: SetupCustomHeaders
  private let canHandleRequest: CanHandleRequest
  
  public init(setupCustomHeaders: SetupCustomHeaders, canHandleRequest: CanHandleRequest) {
    self.setupCustomHeaders = setupCustomHeaders
    self.canHandleRequest = canHandleRequest
  }
  
  public convenience init(setupCustomHeaders: SetupCustomHeaders) {
    let canHandleRequest = { (request: NSURLRequest) -> Bool in
      guard let scheme = request.URL?.scheme else { return false }
      if !["http", "https"].contains(scheme) { return false }
      return true
    }
    
    self.init(setupCustomHeaders: setupCustomHeaders, canHandleRequest: canHandleRequest)
  }
}

public final class CustomHttpHeadersURLProtocol: NSURLProtocol {
  private struct Const {
    static let ProtocolHandledKey = "CustomHttpHeadersURLProtocol/ProtocolHandledKey"
  }
  
  private var session: NSURLSession?
  private var sessionTask: NSURLSessionTask?
  private static var customHttpHeadersConfig: CustomHttpHeadersConfig?
  private static var started = false
  
  public class func start(customHttpHeadersConfig: CustomHttpHeadersConfig) {
    if started { return }
    started = true
    
    self.customHttpHeadersConfig = customHttpHeadersConfig
    
    NSURLProtocol.registerClass(self)
  }
  
  public class func stop() {
    NSURLProtocol.unregisterClass(self)
    started = false
    customHttpHeadersConfig = nil
  }
  
  override public class func canInitWithRequest(request: NSURLRequest) -> Bool {
    if let handled = NSURLProtocol.propertyForKey(Const.ProtocolHandledKey, inRequest: request) as? Bool where handled { return false }
    
    guard let config = customHttpHeadersConfig else { return false }
    if !config.canHandleRequest(request) { return false }
    
    return true
  }
  
  override public class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
    return request
  }
  
  override public func startLoading() {
    guard let request = self.request.mutableCopy() as? NSMutableURLRequest else { return }
    
    markAsHandled(request)
    self.dynamicType.customHttpHeadersConfig?.setupCustomHeaders(request)
    
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    config.protocolClasses = [self.dynamicType]

    session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)

    sessionTask = session?.dataTaskWithRequest(request)
    sessionTask?.resume()
  }
  
  override public func stopLoading() {
    sessionTask?.cancel()
    sessionTask = nil
  }
  
  private func markAsHandled(request: NSMutableURLRequest) {
    NSURLProtocol.setProperty(true, forKey: Const.ProtocolHandledKey, inRequest: request)
  }
}

extension CustomHttpHeadersURLProtocol: NSURLSessionDataDelegate, NSURLSessionTaskDelegate {
  public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
    if let error = error {
      client?.URLProtocol(self, didFailWithError: error)
      
      return
    }
    
    client?.URLProtocolDidFinishLoading(self)
  }
  
  public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
    client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
    completionHandler(.Allow)
  }
  
  public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
    client?.URLProtocol(self, didLoadData: data)
  }
}