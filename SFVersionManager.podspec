Pod::Spec.new do |s|
  s.name             = 'SFVersionManager'
  s.version          = '0.1.1'
  s.summary          = 'iOS 版本更新'
  s.homepage         = 'https://github.com/coderflower/SFVersionManager.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Coder.flower' => 'coder.flower@gmail.com' }
  s.source           = { :git => 'https://github.com/coderflower/SFVersionManager.git', :tag => s.version.to_s }
  s.swift_version    = '4.0'
  s.ios.deployment_target = '9.0'
  s.source_files = 'SFVersionManager/Classes/**/*'
end
