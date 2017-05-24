name             'jenkins-ci'
maintainer       'Oleksandr Semych'
maintainer_email 'Ooleksandr_semych@epam.com'
license          'All rights reserved'
description      'Installs/Configures jenkins-ci'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "jenkins"
depends "git"
depends 'maven'