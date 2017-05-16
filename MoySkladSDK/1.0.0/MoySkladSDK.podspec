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
  s.name         = "MoySkladSDK"
  s.version      = "1.0.0"
  s.summary      = "Client to MoySklad JSON API"

  s.homepage     = "https://bitbucket.org/aparshakov_moysklad/com.lognex.mobile.ios.mistructs"

  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author    = "Lognex"

  s.source       = { :git => "git@bitbucket.org:aparshakov_moysklad/com.lognex.mobile.ios.mistructs.git", :tag => "v#{s.version}" }

  s.source_files = "MoySkladSDK/**/*.{swift}"

  s.dependency 'Alamofire', '~> 4.4.0'
  s.dependency 'RxSwift', '~> 3.2.0'

end
