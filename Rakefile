# -*- ruby -*-

require "rubygems"
require "hoe"

Hoe.plugin :isolate
Hoe.plugin :seattlerb

Hoe.spec "makerakeworkwell" do
  developer "Ryan Davis", "ryand-ruby@zenspider.com"

  self.urls = { # FIX: I messed with the Readme format so I have to do this
    "home" => "https://github.com/seattlerb/makerakeworkwell",
    "rdoc" => "http://docs.seattlerb.org/makerakeworkwell",
  }

  dependency "rake", "~> 0.9.2"
end

task :docs do
  fonts = '"Courier New", Courier, monospace'
  sh %(echo 'h1 { font-family: #{fonts}; }' >> doc/rdoc.css)
end

# vim: syntax=ruby
