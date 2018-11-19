#
# Be sure to run `pod lib lint SFVersionManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SFVersionManager'
  s.version          = '0.1.1'
  s.summary          = 'iOS 版本更新'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
从 App Store 获取当前 App 最新版本, 如果有最新版本则提示用户更新
                       DESC

  s.homepage         = 'https://github.com/coderflower/SFVersionManager.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Coder.flower' => 'coder.flower@gmail.com' }
  s.source           = { :git => 'https://github.com/coderflower/SFVersionManager.git', :tag => s.version.to_s }
  s.swift_version    = '4.0'
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9avis.0'

  s.source_files = 'SFVersionManager/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SFVersionManager' => ['SFVersionManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
