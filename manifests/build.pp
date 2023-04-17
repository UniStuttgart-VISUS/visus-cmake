# # @summary Builds and installs a specific version of Cmake
# #
# # @api private
# define cmake::build(
#         String $source_dir,
#         #String $install_dir,
#         String $base_url,
#         String $version,
#         Optional[String] $override_url = undef,
#         String $configure_flags = '--enable-optimizations',
#         String $make_target = 'altinstall') {

#     # Resolve the actual remote location of the sources.
#     $url = if $override_url {
#         $override_url
#     } else {
#         "${base_url}/${version}/Python-${version}.tgz"
#     }

#     # Resolve the local source file and directory.
#     $src_file = "${source_dir}/${basename($url)}"
#     $src_dir = "${source_dir}/${basename($url, '.*')}"

#     # Download and extract the sources.
#     archive { $src_file:
#         source => $url,
#         extract => true,
#         extract_path => $source_dir,
#         creates => $src_dir,
#         cleanup => true,
#         user => 'root',
#         group => 'root',
#         notify => Exec["autoconf-${title}"]
#     }

#     # Build by configuring followed by make.
#     ~> exec { "autoconf-${title}":
#         path => '/usr/bin:/bin:/usr/sbin:/sbin',
#         cwd => $src_dir,
#         command => 'autoconf',
#         refreshonly => true
#     }
#     ~> exec { "configure-${title}":
#         path => "${src_dir}:/usr/bin:/bin:/usr/sbin:/sbin",
#         cwd => $src_dir,
#         command => "./configure ${configure_flags}",
#         refreshonly => true
#     }
#     ~> exec { "make-${title}":
#         path => '/usr/bin:/bin:/usr/sbin:/sbin',
#         cwd => $src_dir,
#         command => "make ${make_target}",
#         refreshonly => true
#     }
#     ~> exec { "ldconfig-${title}":
#         path => '/usr/bin:/bin:/usr/sbin:/sbin',
#         command => 'ldconfig',
#         refreshonly => true
#     }

# }
