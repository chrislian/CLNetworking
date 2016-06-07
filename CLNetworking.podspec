Pod::Spec.new do |s|

  s.name         = "CLNetworking"
  s.version      = "3.0.2"
  s.summary      = "基于AFNetworking 3.x 简易封装"
  s.description  = <<-DESC
  			基于AFNetworking 3.x封装,提供常用的api, 优化
                   DESC
  s.homepage     = "https://github.com/chrislian/CLNetworking"
  s.license      = "MIT"
  s.author       = { "chrislian" => "chris0592@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/chrislian/CLNetworking.git", :tag => "#{s.version}" }
  s.source_files = "CLNetworking/Classes/*.{h,m}"
  s.framework 	 = "UIKit"
  s.requires_arc = true
  s.dependency "AFNetworking", "~> 3.0"

end
