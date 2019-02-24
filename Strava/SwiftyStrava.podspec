Pod::Spec.new do |s|
  s.name    = 'SwiftyStrava'
  s.version = '0.8.1'
  s.summary = 'Swift Strava API wrapper'
  s.description = <<-DESC
    The Strava V3 API is a publicly available interface allowing developers access to the rich Strava dataset. This project is not official Strava library written in Swift. It supports read operations for all of the API endpoints and supports user activities upload.
    DESC
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage = 'http://limlab.io/swift/2017/01/08/swifty-strava.html'
  s.authors = { 'Oleksandr Glagoliev' => 'oglagoliev@gmail.com',
                'Anatolii Pankevych' => 'anatolii.pankevych@gmail.com' }
  s.social_media_url = 'https://twitter.com/limlab_io'
  s.source = { :git => 'https://github.com/limlab/SwiftyStrava.git', :tag => s.version }
  s.source_files = 'Sources/*'
  s.ios.deployment_target = '9.0'
  s.dependency 'AlamofireObjectMapper'
end
