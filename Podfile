# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def common_pods_for_target
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'Kingfisher'
end

target 'iOSAssignment_MVVM' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  common_pods_for_target
  # Pods for iOSAssignment_MVVM

  target 'iOSAssignment_MVVMTests' do
    inherit! :search_paths
    common_pods_for_target
    # Pods for testing
  end

  target 'iOSAssignment_MVVMUITests' do
    # Pods for testing
  end

end
