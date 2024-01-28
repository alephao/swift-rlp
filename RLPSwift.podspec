Pod::Spec.new do |s|
  s.name         = "RLPSwift"
  s.version      = "0.0.4"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = "https://github.com/alephao/RLPSwift"
  s.author       = "Aleph Retamal"
  s.summary      = "Recursive Length Prefix encoding written in Swift"
  s.source       = { :git => "https://github.com/alephao/RLPSwift.git", :tag => "v#{s.version}" }
  s.ios.deployment_target  = '9.0'
  s.osx.deployment_target  = '10.10'
  s.swift_versions = ['5.0', '5.1']
  s.source_files  = "Sources/RLPSwift"
end
