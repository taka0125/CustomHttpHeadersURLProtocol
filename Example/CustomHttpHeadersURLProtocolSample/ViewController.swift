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
    let setupCustomHeadersBlock: CustomHttpHeadersConfig.SetupCustomHeadersBlock = { (request: NSMutableURLRequest) in
      request.addValue("CustomHttpHeadersURLProtocolSample", forHTTPHeaderField: "X-App-Name")
      request.addValue("\(NSDate().timeIntervalSince1970)", forHTTPHeaderField: "X-Timestamp")
    }
    
    let canHandleHostsBlock: CustomHttpHeadersConfig.CanHandleHostsBlock = { (host: String) -> Bool in
      if host == "0.0.0.0" { return true }
      return false
    }
    
    let config = CustomHttpHeadersConfig(setupCustomHeadersBlock: setupCustomHeadersBlock, canHandleHostsBlock: canHandleHostsBlock)
    CustomHttpHeadersURLProtocol.start(config)
  }
}

