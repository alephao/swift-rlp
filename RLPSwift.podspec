Pod::Spec.new do |s|
  s.name         = "RLPSwift"
  s.version      = "0.0.2"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = "https://github.com/bitfwdcommunity/RLPSwift"
  s.author       = "Aleph Retamal"
  s.summary      = "Recursive Length Prefix encoding written in Swift"
  s.source       = { :git => "https://github.com/bitfwdcommunity/RLPSwift.git", :tag => "v#{s.version}" }
  s.platform     = :ios
  s.ios.deployment_target = '9.0'
  s.source_files  = "Source"
end
