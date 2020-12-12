platform :ios, '13.0'

inhibit_all_warnings!

workspace "Product"

def shared_testing_libraries
    # Testing
    pod 'Quick'
    pod 'Nimble'
end

target 'App' do
  project 'Projects/App/App'
  use_frameworks!
end

target 'List' do
  project 'Projects/List/List'
  use_frameworks!


  target 'ListTests' do
    shared_testing_libraries
  end
end

target 'Detail' do
  project 'Projects/Detail/Detail'
  use_frameworks!

  target 'DetailTests' do
    shared_testing_libraries
  end
end

target 'Common' do
  project 'Projects/Common/Common'
  use_frameworks!
  pod 'R.swift'
  pod 'SwiftLint'

  target 'CommonTests' do
    shared_testing_libraries
  end
end



post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['VALID_ARCHS'] = 'arm64'
      config.build_settings['VALID_ARCHS[sdk=iphonesimulator*]'] = 'x86_64'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
