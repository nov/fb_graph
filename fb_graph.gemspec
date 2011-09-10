Gem::Specification.new do |s|
  s.name = "fb_graph"
  s.version = File.read("VERSION")
  s.authors = ["nov matake"]
  s.description = %q{A full-stack Facebook Graph API wrapper in Ruby.}
  s.summary = %q{A full-stack Facebook Graph API wrapper in Ruby.}
  s.email = "nov@matake.jp"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.homepage = "http://github.com/nov/fb_graph"
  s.require_paths = ["lib"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.add_runtime_dependency "httpclient", ">= 2.2.0.2"
  s.add_runtime_dependency "rack-oauth2", ">= 0.9.4"
  s.add_development_dependency "rake", ">= 0.8"
  s.add_development_dependency "rcov", ">= 0.9"
  s.add_development_dependency "rspec", ">= 2"
  s.add_development_dependency "webmock", ">= 1.6.2"
  s.add_development_dependency "actionpack", ">= 3.0.6"
end
