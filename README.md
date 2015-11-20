# CustomHttpHeadersURLProtocol

[![Version](https://img.shields.io/cocoapods/v/CustomHttpHeadersURLProtocol.svg?style=flat)](http://cocoapods.org/pods/CustomHttpHeadersURLProtocol)
[![License](https://img.shields.io/cocoapods/l/CustomHttpHeadersURLProtocol.svg?style=flat)](http://cocoapods.org/pods/CustomHttpHeadersURLProtocol)
[![Platform](https://img.shields.io/cocoapods/p/CustomHttpHeadersURLProtocol.svg?style=flat)](http://cocoapods.org/pods/CustomHttpHeadersURLProtocol)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CustomHttpHeadersURLProtocol is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CustomHttpHeadersURLProtocol"
```

## Sample

```
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
```

## Author

Takahiro Ooishi, taka0125@gmail.com

## License

CustomHttpHeadersURLProtocol is available under the MIT license. See the LICENSE file for more info.
