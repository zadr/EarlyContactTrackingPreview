Pod::Spec.new do |spec|
  spec.name             = 'EarlyContactTrackingPreview'
  spec.module_name      = 'ContactTracking'
  spec.version          = '0.0.1'
  spec.license          = { :type => 'BSD' }
  spec.homepage         = 'git@github.com:zadr/EarlyContactTrackingPreview.git'
  spec.authors          = { '…' => '…' }
  spec.summary          = 'A mock implementation of Apple\'s ContactTracking to allow for early work on apps.'
  spec.source           = { :git => 'https://github.com', :tag => '0.0.1' }
  spec.source_files     = 'Sources/**/*.{h,m}'
  spec.framework        = 'Foundation'
  spec.requires_arc     = true

  spec.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/*.{h,m}'
  end  
end
