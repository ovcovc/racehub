# Podfile
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

use_frameworks!

def common_pods
    pod 'GoogleMaps'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxGesture'
    pod 'RealmSwift'
    pod 'MXParallaxHeader'
    pod 'XLPagerTabStrip', '~> 7.0'
    pod 'Firebase/Core'
    pod 'Kingfisher'
    pod 'PKHUD', '~> 4.0'
end

target 'RaceHub' do
    common_pods
end

target 'RaceHubTests' do
    inherit! :search_paths
    common_pods
end

target 'RaceHubUITests' do
    inherit! :search_paths
    common_pods
end


