Pod::Spec.new do |s|
  s.name             = "CustomHttpHeadersURLProtocol"
  s.version          = "0.1.0"
  s.summary          = "Logger"
  s.homepage         = "https://github.com/taka0125/CustomHttpHeadersURLProtocol"
  s.license          = "MIT"
  s.author           = { "Takahiro Ooishi" => "taka0125@gmail.com" }
  s.source           = { :git => "https://github.com/taka0125/CustomHttpHeadersURLProtocol.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/taka0125'

  s.ios.deployment_target = '8.0'

  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
