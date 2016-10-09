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
  public typealias CanHandleRequest = (URLRequest) -> Bool
  public typealias SetupCustomHeaders = (NSMutableURLRequest) -> Void
  
  public let setupCustomHeaders: SetupCustomHeaders
  public let canHandleRequest: CanHandleRequest
  
  public init(setupCustomHeaders: @escaping SetupCustomHeaders, canHandleRequest: @escaping CanHandleRequest) {
    self.setupCustomHeaders = setupCustomHeaders
    self.canHandleRequest = canHandleRequest
  }
  
  public convenience init(setupCustomHeaders: @escaping SetupCustomHeaders) {
    let canHandleRequest = { (request: URLRequest) -> Bool in
      guard let scheme = request.url?.scheme else { return false }
      if !["http", "https"].contains(scheme) { return false }
      return true
    }
    
    self.init(setupCustomHeaders: setupCustomHeaders, canHandleRequest: canHandleRequest)
  }
}
