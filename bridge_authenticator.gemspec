Gem::Specification.new do |s|
  s.name        = 'bridge_authenticator'
  s.version     = '0.1.1'
  s.date        = '2013-05-23'
  s.summary     = "Bridge authenticator"
  s.description = "Bridge authenticator middleware for faraday. Middleware generated fingerprint which will be checked on server side"
  s.authors     = ["Oleg Ivanov", "Krzysztof Kotlarek"]
  s.email       = 'krzys.kotlarek@jnsolutions.com.au'
  s.files       = ["lib/bridge_authenticator.rb"]
  s.test_files  = ["spec/spec_helper.rb", "spec/bridge_authenticator_spec.rb", "Rakefile"]
  s.add_dependency 'faraday'
  s.add_dependency 'gpgme'
  s.add_dependency 'base64'
  s.add_development_dependency 'rspec'
end
