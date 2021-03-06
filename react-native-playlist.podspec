require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-playlist"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-playlist
                   DESC
  s.homepage     = "https://github.com/stokesbga/react-native-playlist"
  s.license      = "MIT"
  s.authors      = {  'Alex Yosef' => 'alex@quadio.com',
                      'Stan Tsai' => 'feocms@gmail.com',
                      'iTSangar' => 'itsangardev@gmail.com' }
  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/stokesbga/react-native-playlist.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.resource_bundles = {
    'RNPlaylistBundle' => ['ios/Resources/**/*.{xcassets,mp3}']
  }
  
  s.requires_arc = true
  s.swift_versions = "5"

  s.dependency "React"
  s.dependency "MarqueeLabel", "~> 4.0.2"
  s.dependency "AlamofireImage", "~> 4.0.0"
end

