class icinga::params {
  $managerepo          = false
  $client              = true
  $server              = false
  $use_auth            = true
  $plugins             = [ 'checkpuppet' ]
  $nrpe_allowed_hosts  = [ '127.0.0.1,', $::ipaddress ]
  $nrpe_server_address = $::ipaddress
  $icinga_admins       = [ 'icingaadmin,', 'nagiosadmin' ]

  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      # Icinga
      $package_client_ensure     = 'present'
      $package_server_ensure     = 'present'
      $package_client            = [ 'nagios-nrpe-server', 'nagios-plugins' ]
      $package_server            = [ 'icinga', 'icinga-core', 'icinga-common', 'icinga-cgi', 'icinga-phpapi', 'nagios-nrpe-plugin' ]
      $service_client            = 'nagios-nrpe-server'
      $service_client_ensure     = 'running'
      $service_client_enable     = true
      $service_client_hasstatus  = false
      $service_client_hasrestart = true
      $service_client_pattern    = 'nrpe'
      $service_server            = 'icinga'
      $service_server_ensure     = 'running'
      $service_server_enable     = true
      $service_server_hasstatus  = true
      $service_server_hasrestart = true
      $pidfile_client            = '/var/run/nagios/nrpe.pid'
      $pidfile_server            = '/var/run/icinga/icinga.pid'
      $confdir_client            = '/etc/nagios'
      $confdir_server            = '/etc/icinga'
      $vardir_client             = '/var/lib/nagios'
      $vardir_server             = '/var/lib/icinga'
      $sharedir_server           = '/usr/share/icinga/htdocs'
      $includedir_client         = '/etc/nagios/nrpe.d'
      $usrlib                    = '/usr/lib'
      $plugindir                 = "${usrlib}/nagios/plugins"
      $service_webserver         = 'apache2'
      $webserver_user            = 'www-data'
      $webserver_group           = 'www-data'
      $server_user               = 'nagios'
      $server_group              = 'nagios'
      $client_user               = $server_user
      $client_group              = $server_group
      $server_cmd_group          = $server_group
      $htaccess                  = "${confdir_server}/htpasswd.users"
      $targetdir                 = "${confdir_server}/objects"
      $icinga_vhost              = '/etc/icinga/apache2.conf'
      $logdir_client             = '/var/log/nrpe'
      $logdir_server             = '/var/log/icinga'

      # Plugins => TO BE REFACTORED
      $icingaweb_pkg     = ''
      $icingaweb_pkg_dep = ''
      $icingaweb_confdir = ''
      $icingaweb_dbname  = 'icinga_web'
      $icingaweb_dbuser  = 'icinga_web'
      $icingaweb_dbpass  = 'icinga_web'
      $icingaweb_vhost   = '/etc/apache2/sites-enabled/icinga-web.conf'

      $idoutils_pkg     = 'icinga-idoutils'
      $idoutils_confdir = '/etc/icinga/idoutils'
      $idoutils_service = 'ido2db'
      $idoutils_dbname  = 'icinga'
      $idoutils_dbuser  = 'icinga'
      $idoutils_dbpass  = 'icinga'
    }

    'RedHat', 'CentOS', 'Scientific', 'OEL', 'Amazon': {
      case $::architecture {
        'x86_64': { $usrlib = '/usr/lib64' }
        default:  { $usrlib = '/usr/lib'   }
      }

      # Icinga
      $package_client_ensure     = 'present'
      $package_server_ensure     = 'present'
      $package_client            = [ 'nagios-nrpe', 'nagios-plugins', 'nagios-plugins-all' ]
      $package_server            = [ 'icinga', 'icinga-api', 'icinga-doc', 'icinga-gui', 'nagios-plugins-nrpe' ]
      $service_client            = 'nrpe'
      $service_client_ensure     = 'running'
      $service_client_enable     = true
      $service_client_hasstatus  = true
      $service_client_hasrestart = true
      $service_client_pattern    = ''
      $service_server            = 'icinga'
      $service_server_ensure     = 'running'
      $service_server_enable     = true
      $service_server_hasstatus  = true
      $service_server_hasrestart = true
      $pidfile_client            = '/var/run/nrpe/nrpe.pid'
      $pidfile_server            = ''
      $confdir_client            = '/etc/nagios'
      $confdir_server            = '/etc/icinga'
      $vardir_client             = '/var/icinga'
      $vardir_server             = '/var/icinga'
      $sharedir_server           = '/usr/share/icinga'
      $includedir_client         = '/etc/nrpe.d'
      $plugindir                 = "${usrlib}/nagios/plugins"
      $service_webserver         = 'httpd'
      $webserver_user            = 'apache'
      $webserver_group           = 'apache'
      $server_user               = 'icinga'
      $server_group              = 'icinga'
      $client_user               = 'nagios'
      $client_group              = 'nagios'
      $server_cmd_group          = 'icingacmd'
      $targetdir                 = "${confdir_server}/objects"
      $icinga_vhost              = '/etc/icinga/apache2.conf'
      $logdir_client             = '/var/log/nrpe'
      $logdir_server             = '/var/log/icinga'
      $max_check_attempts        = '4'
      $notification_period       = '24x7'

      # Plugin: Icinga Web
      $icingaweb_pkg     = [ 'icinga-web' ]
      $icingaweb_pkg_dep = [ 'perl-Locale-PO', 'php-ldap', 'php-pear', 'php-xml', 'php-mysql' ]
      $icingaweb_confdir = '/usr/share/icinga-web'
      $icingaweb_bindir  = "${icingaweb_confdir}/bin:${::path}"
      $icingaweb_logdir  = '/usr/share/icinga-web/log'
      $icingaweb_dbname  = 'icinga_web'
      $icingaweb_dbuser  = 'icinga_web'
      $icingaweb_dbpass  = 'icinga_web'
      $icingaweb_vhost   = '/etc/httpd/conf.d/icinga-web.conf'

      # Plugin: IDOUtils
      $idoutils_pkg     = [ 'icinga-idoutils', 'libdbi', 'libdbi-devel', 'libdbi-drivers', 'libdbi-dbd-mysql' ]
      $idoutils_confdir = '/etc/icinga/idoutils'
      $idoutils_service = 'ido2db'
      $idoutils_dbname  = 'icinga'
      $idoutils_dbuser  = 'icinga'
      $idoutils_dbpass  = 'icinga'
    }

    default: {}
  }
}
