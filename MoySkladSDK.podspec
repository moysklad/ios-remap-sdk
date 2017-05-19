#
#  Be sure to run `pod spec lint MoySkladSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.name         = "moysklad-ios-remap-sdk"
  s.version      = "1.2.4"
  s.summary      = "Client to MoySklad JSON API"

  s.homepage     = "https://github.com/moysklad/ios-remap-sdk"

  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author    = "Lognex"

  s.source       = { :git => "https://github.com/moysklad/ios-remap-sdk.git", :tag => "v#{s.version}" }

  s.source_files = "MoySkladSDK/**/*.{swift}"
  s.resources = "Localizable.strings"

  s.dependency 'Alamofire', '~> 4.4.0'
  s.dependency 'RxSwift', '~> 3.2.0'

end
