Pod::Spec.new do |s|
  s.name         = "SKDispatcher"
  s.version      = "0.0.1"
  s.summary      = "push dispatcher"
  s.description  = <<-DESC
                   跳转工具类
                   SKDispatcher
                   DESC
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage     = "https://github.com/shaveKevin/SKDispatcher"
  s.authors      = { 'shavekevin' => 'shavekevin@gmail.com' }
  s.social_media_url   = "http://www.shavekevin.com"
  s.platform     = :ios,"7.0"
  s.requires_arc = true
  s.source_files = 'SKDispatcher/**/*.{h,m}'
  s.public_header_files = 'SKDispatcher/**/*.{h}'
  s.source       = { :git => "https://github.com/shaveKevin/SKDispatcher.git", :tag => "0.0.1" }
  s.frameworks = 'Foundation,UIKit'

end
