name             "base"
maintainer       "Steffen Gebert / TYPO3 Association"
maintainer_email "steffen.gebert@typo3.org"
license          "Apache 2.0"
description      "Base configuration for TYPO3 infrastructure"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

# virtualization
depends "openvz", "~> 1.0.0"

# others
depends "datacenter", "~> 1.0.0"
depends "operatingsystem", "~> 1.0.0"
