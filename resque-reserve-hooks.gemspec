Gem::Specification.new do |s|
  s.name        = 'resque-reserve-hooks'
  s.version     = '0.0.2'
  s.date        = '2016-01-13'
  s.summary     = 'Reserve hooks for Resque plugins'
  s.description = 'Reserve hooks for Resque plugins'
  s.authors     = ['Dynamic Yield']
  s.email       = 'support@dynamicyield.com'
  s.files       = ['LICENSE', 'Gemfile', "#{s.name}.gemspec"] + Dir['lib/*.rb'] + Dir['lib/**/*.rb']
  s.homepage    = ''
  s.license     = 'MIT'

  s.add_dependency 'resque', '~> 1.20'
end
