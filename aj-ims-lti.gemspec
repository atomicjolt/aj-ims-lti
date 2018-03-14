Gem::Specification.new do |s|
  s.name = 'aj-ims-lti'
  s.version = '1.0.1'

  s.add_dependency 'builder'
  s.add_dependency 'oauth', '~> 0.4.5'
  s.add_dependency 'uuid'

  s.add_development_dependency 'rspec'
#  s.add_development_dependency 'ruby-debug'

  s.authors = ['Atomic Jolt', 'Nick Benoit']
  s.date = '2017-09-25'
  s.extra_rdoc_files = 'LICENSE'
  s.license = 'MIT'
  s.files = Dir['{lib}/**/*'] + ['LICENSE', 'README.md', 'Changelog']
  s.homepage = 'https://github.com/atomicjolt/aj_lms_lti'
  s.require_paths = 'lib'
  s.summary = 'Ruby library for creating IMS LTI tool providers and consumers'
end
