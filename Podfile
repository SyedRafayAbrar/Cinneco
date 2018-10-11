# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Cinneco' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Cinneco
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'FacebookLogin'
  pod 'FacebookCore'
  pod 'NVActivityIndicatorView'
  pod 'Kingfisher', '~> 3.0'
  pod 'IQKeyboardManagerSwift', '5.0.0'
  pod 'PageMenu'
  pod 'Cosmos', '~> 16.0.0'
  
  post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
          config.build_settings.delete('CODE_SIGNING_ALLOWED')
          config.build_settings.delete('CODE_SIGNING_REQUIRED')
      end
  end
  
  
  pod 'Alamofire', '~> 4.4'
  pod 'SwiftyJSON'
end
