# -*- encoding: utf-8 -*-
# stub: jekyll-tagging 1.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-tagging".freeze
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Arne Eilermann".freeze, "Jens Wille".freeze]
  s.date = "2015-06-11"
  s.description = "Jekyll plugin to automatically generate a tag cloud and tag pages.".freeze
  s.email = ["arne@kleinerdrei.net".freeze, "jens.wille@uni-koeln.de".freeze]
  s.extra_rdoc_files = ["ChangeLog".freeze]
  s.files = ["ChangeLog".freeze]
  s.homepage = "http://github.com/pattex/jekyll-tagging".freeze
  s.licenses = ["MIT".freeze]
  s.post_install_message = "\njekyll-tagging-1.0.1 [2015-06-11]:\n\n* Substitution of non ASCII characters and whitespaces, also when 'tag_permalink_style: pretty'.\n\n".freeze
  s.rdoc_options = ["--title".freeze, "jekyll-tagging Application documentation (v1.0.1)".freeze, "--charset".freeze, "UTF-8".freeze, "--line-numbers".freeze, "--all".freeze, "--main".freeze, "ChangeLog".freeze]
  s.rubygems_version = "2.6.8".freeze
  s.summary = "Jekyll plugin to automatically generate a tag cloud and tag pages.".freeze

  s.installed_by_version = "2.6.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby-nuggets>.freeze, [">= 0"])
      s.add_development_dependency(%q<hen>.freeze, [">= 0.8.1", "~> 0.8"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<ruby-nuggets>.freeze, [">= 0"])
      s.add_dependency(%q<hen>.freeze, [">= 0.8.1", "~> 0.8"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<ruby-nuggets>.freeze, [">= 0"])
    s.add_dependency(%q<hen>.freeze, [">= 0.8.1", "~> 0.8"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
