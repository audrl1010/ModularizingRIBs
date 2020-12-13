platform :ios, '13.0'

inhibit_all_warnings!

workspace "Product"

def shared_testing_libraries
  # Testing
  pod 'Quick'
  pod 'Nimble'
end

def feature_module_libraries
  pod 'Texture'
  pod 'RIBs', git: 'https://github.com/uber/RIBs.git', branch: 'master', submodules: true
  pod 'ReactorKit', git: 'https://github.com/ReactorKit/ReactorKit', branch: 'master', submodules: true
  pod 'RxCocoa-Texture', :git => 'https://github.com/audrl1010/RxCocoa-Texture', :branch => 'master'
  pod 'RxDataSources-Texture'
  pod 'BonMot'
  pod 'Then'
  pod 'RxViewController'
  pod 'SnapKit'
  pod 'RxSwiftExt'
  pod 'ManualLayout'

  
end

def common_libraries
  pod 'Texture'
  pod 'RIBs', git: 'https://github.com/uber/RIBs.git', branch: 'master', submodules: true
  pod 'R.swift'
  pod 'SwiftLint'

  pod 'RxSwift'
  pod 'RxRelay'
  pod 'RxCocoa'
  pod 'RxOptional'
  pod 'BonMot'

  pod 'ManualLayout'
  pod 'Realm', :modular_headers => true
  pod 'RealmSwift', :modular_headers => true
  pod 'RxRealm'

  pod 'URLNavigator'

  pod 'Swinject'
  pod 'SwinjectAutoregistration'
  pod 'SnapKit'
end

target 'Common' do
  use_frameworks!
  inherit! :search_paths
  project 'Projects/Common/Common'
  
  common_libraries
  
  target 'CommonTests' do
    use_frameworks!
    inherit! :search_paths
    shared_testing_libraries
  end
end

target 'App' do
  use_frameworks!
  inherit! :search_paths
  project 'Projects/App/App'
  common_libraries
  feature_module_libraries
end

target 'Tasks' do
  use_frameworks!
  inherit! :search_paths
  project 'Projects/Tasks/Tasks'
  
  def libraries
    feature_module_libraries
  end
  
  libraries

  target 'TasksTests' do
    use_frameworks!
    inherit! :search_paths
    shared_testing_libraries
  end
  
  target 'TasksAppEnvironmentTests' do
    use_frameworks!
    inherit! :search_paths
    common_libraries
    libraries
  end
end

target 'TaskEditing' do
  use_frameworks!
  inherit! :search_paths
  project 'Projects/TaskEditing/TaskEditing'
  
  def libraries
    feature_module_libraries
  end
  
  libraries

  target 'TaskEditingTests' do
    use_frameworks!
    inherit! :search_paths
    shared_testing_libraries
  end
  
  target 'TaskEditingAppEnvironmentTests' do
    use_frameworks!
    inherit! :search_paths
    common_libraries
    libraries
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
