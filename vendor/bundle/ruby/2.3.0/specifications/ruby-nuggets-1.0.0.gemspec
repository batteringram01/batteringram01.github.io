# -*- encoding: utf-8 -*-
# stub: ruby-nuggets 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby-nuggets".freeze
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jens Wille".freeze]
  s.date = "2014-05-06"
  s.description = "Various extensions to Ruby classes. [Transitional gem]".freeze
  s.email = "jens.wille@gmail.com".freeze
  s.homepage = "http://github.com/blackwinter/nuggets".freeze
  s.licenses = ["AGPL-3.0".freeze]
  s.post_install_message = "\nruby-nuggets-1.0.0 [2014-06-20]:\n\n* This project has been renamed to +nuggets+. Please update your dependencies.\n\n".freeze
  s.rubygems_version = "2.6.8".freeze
  s.summary = "Extending Ruby. [Transitional gem]".freeze

  s.installed_by_version = "2.6.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nuggets>.freeze, ["= 1.0.0"])
    else
      s.add_dependency(%q<nuggets>.freeze, ["= 1.0.0"])
    end
  else
    s.add_dependency(%q<nuggets>.freeze, ["= 1.0.0"])
  end
end
