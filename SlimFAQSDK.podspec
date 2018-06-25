#
# Be sure to run `pod lib lint SlimFAQSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SlimFAQSDK'
  s.version          = '0.1.0'
  s.summary          = 'SlimFAQ iOS SDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                      SlimFAQSDK provides native UI for SlimFAQ service contents.
                       DESC

  s.homepage         = 'https://github.com/oozou/slimfaqsdk-ios'
  s.screenshots      = 'https://github.com/oozou/slimfaqsdk-ios/blob/master/screenshots/slimfaq_1.png?raw=true'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'freemansion' => 'stan@oozou.com' }
  s.source           = { :git => 'https://github.com/oozou/slimfaqsdk-ios.git', :tag => s.version.to_s }
  s.social_media_url = 'http://facebook.com/oozou/'
  s.ios.deployment_target = '9.0'
  s.swift_version = '4.0'
  s.source_files = 'SlimFAQSDK/Classes/**/*'
  s.resources = 'SlimFAQSDK/Assets/*.{png,pdf,xib,storyboard,xcassets}'
  s.resource_bundles = {
      'SlimFAQSDK' => ['SlimFAQSDK/Assets/*.{png,pdf,xib,storyboard,xcassets}']
  }
  s.frameworks = 'UIKit', 'Foundation'
  s.requires_arc = true
end
