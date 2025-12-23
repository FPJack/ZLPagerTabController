#
# Be sure to run `pod lib lint ZLPagerTabController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZLPagerTabController'
  s.version          = '0.1.1'
  s.summary          = 'A short description of ZLPagerTabController.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/FPJack/ZLPagerTabController.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fanpeng' => 'peng.fan@ukelink.com' }
  s.source           = { :git => 'https://github.com/FPJack/ZLPagerTabController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'ZLPagerTabController/Classes/**/*'
  
  s.subspec 'PagerViewController' do |core|
    core.source_files = 'ZLPagerTabController/Classes/PagerViewController/**/*.{h,m,swift}'
  end
  s.subspec 'ParallaxHeader' do |core|
    core.source_files = 'ZLPagerTabController/Classes/ParallaxHeader/**/*.{h,m,swift}'
  end
  s.subspec 'ParallaxPagerViewController' do |core|
    core.dependency 'ZLPagerTabController/PagerViewController'
    core.dependency 'ZLPagerTabController/ParallaxHeader'
    core.source_files = 'ZLPagerTabController/Classes/ParallaxPagerViewController/**/*.{h,m,swift}'
  end
end
