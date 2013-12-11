name             'openstack-network-wrapper'
maintainer       'Stephan Renatus'
maintainer_email 's.renatus@cloudbau.de'
license          'All rights reserved'
description      'Installs/Configures stackforge networing for havana'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

depends 'openstack-common'
depends 'openstack-network'
depends 'openstack-image'
depends 'openstack-block-storage'
depends 'openstack-compute'
depends 'openstack-dashboard'
