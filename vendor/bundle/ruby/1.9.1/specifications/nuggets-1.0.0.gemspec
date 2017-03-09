# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "nuggets"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = "2014-06-20"
  s.description = "Various extensions to Ruby classes."
  s.email = "jens.wille@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["README", "COPYING", "ChangeLog"]
  s.homepage = "http://github.com/blackwinter/nuggets"
  s.licenses = ["AGPL-3.0"]
  s.post_install_message = "\nnuggets-1.0.0 [2014-06-20]:\n\n* First release under new name. Formerly known as ruby-nuggets.\n\n"
  s.rdoc_options = ["--title", "nuggets Application documentation (v1.0.0)", "--charset", "UTF-8", "--line-numbers", "--all", "--main", "README"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "1.8.23.2"
  s.summary = "Extending Ruby."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<mime-types>, [">= 0"])
      s.add_development_dependency(%q<open4>, [">= 0"])
      s.add_development_dependency(%q<hen>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<mime-types>, [">= 0"])
      s.add_dependency(%q<open4>, [">= 0"])
      s.add_dependency(%q<hen>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<mime-types>, [">= 0"])
    s.add_dependency(%q<open4>, [">= 0"])
    s.add_dependency(%q<hen>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
