Gem::Specification.new do |s|
  s.name = "fb_graph"
  s.version = File.read("VERSION").delete("\n\r")
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
  s.add_runtime_dependency "httpclient", ">= 2.4"
  s.add_runtime_dependency "rack-oauth2", ">= 0.14.4"
  s.add_runtime_dependency "tzinfo"
  s.add_runtime_dependency "multi_json", ">= 1.3"
  if RUBY_VERSION >= '2.0' && RUBY_VERSION < '2.1'
    s.add_runtime_dependency "string-scrub", ">= 0.0.2"
  end
  s.add_development_dependency "rake", ">= 0.8"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "rspec", "< 2.99"
  s.add_development_dependency "fb_graph-mock", ">= 1.0.3"
  s.add_development_dependency "actionpack", ">= 3.0.6"
end
