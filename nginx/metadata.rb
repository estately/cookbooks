maintainer       "Ben Bleything"
maintainer_email "ben@estately.com"
license          "Apache 2.0"
description      "Installs/Configures nginx"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.4.0"

%w{ build-essential runit }.each do |cb|
  depends cb
end
