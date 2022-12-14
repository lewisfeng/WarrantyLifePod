#
# Be sure to run `pod lib lint WarrantyLifePod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WarrantyLifePod'
  s.version          = '1.1'
  s.swift_version    = '5.0'
  s.summary          = 'Quick setup — if you’ve done this kind of thing before'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Trivia game that support up to 8 people using peer-to-peer technology and display on the second screen (not mirroring)
                       DESC

  s.homepage         = 'https://github.com/lewisfeng/WarrantyLifePod'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'YI BIN FENG' => 'lewis@warrantylife.com' }
  s.source           = { :git => 'https://github.com/lewisfeng/WarrantyLifePod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'WarrantyLifePod/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WarrantyLifePod' => ['WarrantyLifePod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire'
  s.dependency 'SwiftyJSON'
  s.dependency 'GzipSwift'
  
end
