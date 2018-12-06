Pod::Spec.new do |s|
s.name = 'JTPagingView'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = '分页控制器View'
s.homepage = 'https://github.com/FuncTime/JTPagingView'
s.authors = { 'mcmore' => 'xjt000@126.com' }
s.source = { :git => "https://github.com/FuncTime/JTPagingView", :tag => "1.0.0"}
s.requires_arc = trues.ios.deployment_target = '9.0'
s.source_files = "JTPagingView/*.{h,m}", "JTPagingView/JTPagingView.a"
s.source = "JTPagingView/JTPagingView.bundle"
s.frameworks = 'UIKit'
end
