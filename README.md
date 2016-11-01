# CustomHttpHeadersURLProtocol

[![Version](https://img.shields.io/cocoapods/v/CustomHttpHeadersURLProtocol.svg?style=flat)](http://cocoapods.org/pods/CustomHttpHeadersURLProtocol)
[![License](https://img.shields.io/cocoapods/l/CustomHttpHeadersURLProtocol.svg?style=flat)](http://cocoapods.org/pods/CustomHttpHeadersURLProtocol)
[![Platform](https://img.shields.io/cocoapods/p/CustomHttpHeadersURLProtocol.svg?style=flat)](http://cocoapods.org/pods/CustomHttpHeadersURLProtocol)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## CocoaPods

CustomHttpHeadersURLProtocol is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CustomHttpHeadersURLProtocol"
```

## Carthage

```
github "taka0125/CustomHttpHeadersURLProtocol"
```

## Sample

```
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
```

## Author

Takahiro Ooishi, taka0125@gmail.com

## License

CustomHttpHeadersURLProtocol is available under the MIT license. See the LICENSE file for more info.
