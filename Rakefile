# -*- ruby -*-

require "rubygems"
require "hoe"

Hoe.plugin :isolate
Hoe.plugin :seattlerb

Hoe.spec "makerakeworkwell" do
  developer "Ryan Davis", "ryand-ruby@zenspider.com"

  dependency "rake", "~> 0.9.2"
end

task :docs do
  fonts = '"Courier New", Courier, monospace'
  sh %(echo 'h1 { font-family: #{fonts}; }' >> doc/rdoc.css)
end

# vim: syntax=ruby
