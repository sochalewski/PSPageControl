Pod::Spec.new do |s|
  s.name             = "PSPageControl"
  s.version          = "0.2.1"
  s.summary          = "Easy parallax effect in UIPageControl"
  s.description      = "Easy parallax effect in UIPageControl in Swift."
  s.homepage         = "https://github.com/sochalewski/PSPageControl"
  s.license          = 'MIT'
  s.author           = { "Piotr Sochalewski" => "sochalewski@gmail.com" }
  s.source           = { :git => "https://github.com/sochalewski/PSPageControl.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = '*.swift'
  s.frameworks = 'UIKit'
  s.dependency 'UIImageViewAlignedSwift'
end
