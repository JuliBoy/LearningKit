#
# Be sure to run `pod lib lint LearningKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LearningKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of LearningKit.'
  s.description      = <<-DESC
To learn how to create and manage private libraries using Cocoapods.
                       DESC

  s.homepage         = 'https://github.com/JuliBoy/LearningKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '鲍宗平' => '14541@9ji.com' }
  s.source           = { :git => 'https://github.com/JuliBoy/LearningKit', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'LearningKit/Classes/**/*'
  
  s.swift_version = "5.3"
  s.static_framework = true
  
  s.dependency 'JiuFoundation', '< 1'
  
  s.resource_bundles = {
    'LearningKitAssets' => ['LearningKit/Assets/**/*.{xcassets,xib}']
  }
  
  # s.resource_bundles = {
  #   'LearningKit' => ['LearningKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
