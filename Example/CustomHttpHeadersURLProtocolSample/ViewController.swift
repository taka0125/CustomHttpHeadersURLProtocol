//
//  ViewController.swift
//  CustomHttpHeadersURLProtocolSample
//
//  Created by Takahiro Ooishi on 2015/11/21.
//  Copyright © 2015年 Takahiro Ooishi. All rights reserved.
//

import UIKit
import CustomHttpHeadersURLProtocol

class ViewController: UIViewController {
  @IBOutlet fileprivate weak var webView: UIWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCustomHttpHeadersURLProtocol()
    
    let url = URL(string: "http://0.0.0.0:9292")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    webView.loadRequest(request)
  }
  
  fileprivate func setupCustomHttpHeadersURLProtocol() {
    let setupCustomHeaders: CustomHttpHeadersConfig.SetupCustomHeaders = { (request: NSMutableURLRequest) in
//      var mutableRequest = request
      request.addValue("CustomHttpHeadersURLProtocolSample", forHTTPHeaderField: "X-App-Name")
      request.addValue("\(Date().timeIntervalSince1970)", forHTTPHeaderField: "X-Timestamp")
    }
    
    let canHandleRequest: CustomHttpHeadersConfig.CanHandleRequest = { (request: URLRequest) -> Bool in
      guard let scheme = request.url?.scheme else { return false }
      guard let host = request.url?.host else { return false }
      
      if !["http", "https"].contains(scheme) { return false }
      if host == "0.0.0.0" { return true }

      return false
    }
    
    let config = CustomHttpHeadersConfig(setupCustomHeaders: setupCustomHeaders, canHandleRequest: canHandleRequest)
    CustomHttpHeadersURLProtocol.start(config)
  }
}
