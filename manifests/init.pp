# @summary Installs and configures Duo Authentication Proxy
#
# @example including the module in a profile
#   include duo_authproxy
#
# @example in hiera
#   duo_authproxy::version: '4.0.2'
#   duo_authproxy::install_dir: '/opt/duoauthproxy'
#   duo_authproxy::settings:
#     main:
#       debug: true
#       http_proxy_host: 'my.proxy.example.com'
#       http_proxy_port: 80
#     ad_client:
#       host: 'host.ad.example.com'
#       service_account_username: 'service-account'
#       service_account_password: 'password'
#       search_dn: 'cn=users,dc=ad,dc=example,dc=com'
#     ldap_server_auto:
#       ikey: 'ikey'
#       skey: 'encrypt-with-eyaml'
#       api_host: 'api_host'
#
# @example resource-like class declaration with parameters
#   class { 'duo_authproxy':
#     version     => '4.0.2',
#     install_dir => '/opt/duoauthproxy'
#     settings    => {
#       # All required config sections and settings
#       'main' => {
#         'debug' => 'true',
#       },
#        'ad_client' => {
#          'host'                     => 'host.ad.example.com',
#          'service_account_username' => 'service-account',
#          'service_account_password' => 'password',
#          'search_dn'                => 'cn=users,dc=ad,dc=example,dc=com',
#       },
#     },
#   }
#
# @param compile_package
#   Whether or not to compile the package source.  If set to false, the package will not be 
#   compiled from source, and it will need to be installed by other means.
#
# @param package_dependencies
#   An array of packages that are required to compile Duo Authentication Proxy from source.
#   See https://duo.com/docs/authproxy-reference#installation for a complete list of packages.
#
# @param manage_package_dependencies
#   Whether or not to manage the packages required to compile the Duo Authentication Proxy source.
#
# @param manage_python
#   Whether or not to manage the `python` and `python-devel` packages.
#
# @param python_package
#   The name of the python package.  This can be set if `manage_python => true` and the host is 
#   using a versioned or otherwise non-standard python package name.
#
# @param python_package_ensure
#   Ensure value for the `python` and `python-devel` packages.
#
class duo_authproxy (
  String $version,
  Stdlib::Absolutepath $install_dir,
  Hash $settings,
  Optional[String] $proxy_server,
  Optional[Enum['none', 'ftp', 'http', 'https']] $proxy_type,
  Boolean $compile_package,
  Boolean $manage_package_dependencies,
  Array[String] $package_dependencies,
  Boolean $manage_python,
  String $python_package,
  Enum['present', 'latest', 'absent'] $python_package_ensure,
) {

  contain duo_authproxy::install
  contain duo_authproxy::config
  contain duo_authproxy::service

  Class['::duo_authproxy::install']
  -> Class['::duo_authproxy::config']
  ~> Class['::duo_authproxy::service']

}
