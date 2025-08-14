# @summary Builds and installs a specific version of CMake
#
# @api private
define cmake::build(
         String $src_dir,
         String $prefix) {
    # Boostrap the build.
    exec { "bootstrap-${title}":
         path => '/usr/bin:/bin:/usr/sbin:/sbin',
         cwd => $src_dir,
         command => "$src_dir/bootstrap --prefix=$prefix",
         refreshonly => true
    }

    # Run the build.
    ~> exec { "make-${title}":
         path => "${src_dir}:/usr/bin:/bin:/usr/sbin:/sbin",
         cwd => $src_dir,
         command => "make",
         refreshonly => true
    }

    # Install
    ~> exec { "${prefix}/bin/cmake":
         path => "${src_dir}:/usr/bin:/bin:/usr/sbin:/sbin",
         cwd => $src_dir,
         command => "make install",
         refreshonly => true
    }
}
