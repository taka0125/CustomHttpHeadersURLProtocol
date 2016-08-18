//
//  CustomHttpHeadersURLProtocol.swift
//  CustomHttpHeadersURLProtocol
//
//  Created by Takahiro Ooishi
//  Copyright (c) 2015 Takahiro Ooishi. All rights reserved.
//  Released under the MIT license.
//

import Foundation

public final class CustomHttpHeadersURLProtocol: URLProtocol {
  fileprivate struct Const {
    static let ProtocolHandledKey = "CustomHttpHeadersURLProtocol/ProtocolHandledKey"
  }
  
  fileprivate var session: URLSession?
  fileprivate var sessionTask: URLSessionTask?
  fileprivate static var customHttpHeadersConfig: CustomHttpHeadersConfig?
  fileprivate static var started = false
  
  public class func start(_ customHttpHeadersConfig: CustomHttpHeadersConfig) {
    if started { return }
    started = true
    
    self.customHttpHeadersConfig = customHttpHeadersConfig
    
    URLProtocol.registerClass(self)
  }
  
  public class func stop() {
    URLProtocol.unregisterClass(self)
    started = false
    customHttpHeadersConfig = nil
  }
  
  override public class func canInit(with request: URLRequest) -> Bool {
    if let handled = URLProtocol.property(forKey: Const.ProtocolHandledKey, in: request) as? Bool , handled { return false }
    
    guard let config = customHttpHeadersConfig else { return false }
    if !config.canHandleRequest(request) { return false }
    
    return true
  }
  
  override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override public func startLoading() {
    guard let request = (self.request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else { return }
    
    markAsHandled(request)
    type(of: self).customHttpHeadersConfig?.setupCustomHeaders(request)
    
    let config = URLSessionConfiguration.default
    config.protocolClasses = [type(of: self)]

    session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    sessionTask = session?.dataTask(with: request as URLRequest, completionHandler: { [weak self] (data, response, error) in
      guard let strongSelf = self else { return }
      
      if let error = error {
        strongSelf.client?.urlProtocol(strongSelf, didFailWithError: error)
        return
      }
      
      strongSelf.client?.urlProtocol(strongSelf, didReceive: response!, cacheStoragePolicy: .allowed)
      strongSelf.client?.urlProtocol(strongSelf, didLoad: data!)
      strongSelf.client?.urlProtocolDidFinishLoading(strongSelf)
    })
    
    sessionTask?.resume()
  }
  
  override public func stopLoading() {
    sessionTask?.cancel()
    sessionTask = nil
  }
}

// MARK: - Private Methods

extension CustomHttpHeadersURLProtocol {
  fileprivate func markAsHandled(_ request: NSMutableURLRequest) {
    URLProtocol.setProperty(true, forKey: Const.ProtocolHandledKey, in: request)
  }
}

// MARK: - NSURLSession

extension CustomHttpHeadersURLProtocol: URLSessionDataDelegate, URLSessionTaskDelegate {
  public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    if let error = error {
      client?.urlProtocol(self, didFailWithError: error)
      
      return
    }
    
    client?.urlProtocolDidFinishLoading(self)
  }
  
  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    completionHandler(.allow)
  }
  
  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    client?.urlProtocol(self, didLoad: data)
  }
  
  public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
    Notifier.notifyDidSendBodyData(bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
  }
  
  public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: (URLRequest) -> Void) {
    client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
  }
}
