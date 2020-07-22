require 'json'

package = JSON.parse(File.read(File.join(__dir__, '../package.json')))

Pod::Spec.new do |s|
  s.name                = "react-native-amap-sdk"
  s.version             = "2.0.1"
  s.summary             = package['description']
  s.description         = <<-DESC
                            React Native apps are built using the React JS
                            framework, and render directly to native UIKit
                            elements using a fully asynchronous architecture.
                            There is no browser and no HTML. We have picked what
                            we think is the best set of features from these and
                            other technologies to build what we hope to become
                            the best product development framework available,
                            with an emphasis on iteration speed, developer
                            delight, continuity of technology, and absolutely
                            beautiful and fast products with no compromises in
                            quality or capability.
                         DESC
  s.homepage            = "http://git.terminus.io/reactnastive/RNAMapLocation"
  s.license             = package['license']
  s.author              = "Jianglei"
  s.source              = { :git => "git.terminus.io:reactnative/RNAMapLocation.git", :tag => "v#{s.version}" }
  s.requires_arc        = true
  s.platform            = :ios, "7.0"
  s.preserve_paths      = "*.framework"
 
  s.subspec 'LocationAmap' do |ls|
      ls.source_files = 'location/**/*.{h,m}'
      ls.dependency           'libextobjc'
      ls.dependency           'AMapSearch'
      ls.dependency           'AMapLocation'
  end
  
  s.subspec 'Map3dAmap' do |ms|
      ms.source_files = 'map3damap/**/*.{h,m}'
      ms.dependency 'AMap2DMap', "~> 5.6.0"
  end
  s.dependency 'React'
  
end

