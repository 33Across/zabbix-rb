# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: zabbix-33x 0.4.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "zabbix-33x".freeze
  s.version = "0.4.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Matthew Knopp".freeze]
  s.date = "2019-03-06"
  s.description = "send data to zabbix from ruby".freeze
  s.email = "mknopp@yammer-inc.com".freeze
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".gitlab-ci.yml",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/zabbix.rb",
    "lib/zabbix/agent/configuration.rb",
    "lib/zabbix/sender.rb",
    "lib/zabbix/sender/buffer.rb",
    "lib/zabbix/sender/easy.rb",
    "test/helper.rb",
    "test/test_zabbix.rb",
    "test/zabbix_agentd.conf",
    "zabbix-33x.gemspec"
  ]
  s.homepage = "http://github.com/mhat/zabbix-rb".freeze
  s.rubygems_version = "2.6.14".freeze
  s.summary = "send data to zabbix from ruby".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<jeweler>.freeze, [">= 0"])
      s.add_development_dependency(%q<shoulda>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<yajl-ruby>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<jeweler>.freeze, [">= 0"])
      s.add_dependency(%q<shoulda>.freeze, [">= 0"])
      s.add_dependency(%q<yajl-ruby>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<jeweler>.freeze, [">= 0"])
    s.add_dependency(%q<shoulda>.freeze, [">= 0"])
    s.add_dependency(%q<yajl-ruby>.freeze, [">= 0"])
  end
end

