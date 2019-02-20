

Pod::Spec.new do |s|

  #项目名称
  s.name         = "TanColor"
  #项目版本号
  s.version      = "0.0.2"
  #修改摘要文字
  s.summary      = "TanColor库"
  #详细描述，这里的文字数一定要大于上面的摘要文字数
  s.description  = <<-DESC
一个改变颜色的库，非常好用，大家都适用我的库吧
                   DESC
  #项目git的地址
  s.homepage     = "https://github.com/tanxinjun/TanColor"
  #许可证使用MIT
  s.license      = "MIT"
  #作者
  s.author = { "谭新均" => "1610514151@qq.com" }
  #平台
  s.platform = :ios, "11.4"
  #来源
  s.source       = { :git => "https://github.com/tanxinjun/TanColor.git", :tag => "#{s.version}" }
  #源文件，如果是一个文件，那就指向一个文件，如果是整个文件夹，则指向整个文件夹，下面我是一个文件
  s.source_files  = "TanColor"
  s.exclude_files = "TanColor/Exclude"
  #需要指定swift语言的版本号
  s.swift_version = '4.0'
  #如果有其他的依赖的库，就在这里添加
  #s.dependency "Kingfisher","~> 4.1.1"

end                                                                
                                                   