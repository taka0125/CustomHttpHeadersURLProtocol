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
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCustomHttpHeadersURLProtocol()
  }
  
  @IBAction func doRequest() {
    let url = NSURL(string: "http://0.0.0.0:9292")!
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "GET"
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
      if error == nil {
        let result = NSString(data: data!, encoding: NSUTF8StringEncoding)
        print(result)
      } else {
        print(error)
      }
    }
    task.resume()
  }
  
  private func setupCustomHttpHeadersURLProtocol() {
    let setupCustomHeaders: CustomHttpHeadersConfig.SetupCustomHeaders = { (request: NSMutableURLRequest) in
      request.addValue("CustomHttpHeadersURLProtocolSample", forHTTPHeaderField: "X-App-Name")
      request.addValue("\(NSDate().timeIntervalSince1970)", forHTTPHeaderField: "X-Timestamp")
    }
    
    let canHandleRequest: CustomHttpHeadersConfig.CanHandleRequest = { (request: NSURLRequest) -> Bool in
      guard let scheme = request.URL?.scheme else { return false }
      guard let host = request.URL?.host else { return false }
      
      if !["http", "https"].contains(scheme) { return false }
      if host == "0.0.0.0" { return true }

      return false
    }
    
    let config = CustomHttpHeadersConfig(setupCustomHeaders: setupCustomHeaders, canHandleRequest: canHandleRequest)
    CustomHttpHeadersURLProtocol.start(config)
  }
}
