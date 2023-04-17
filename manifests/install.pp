# @summary Executes the installation script provided by Kitware.
#
# @api private
define cmake::install(
        String $script,
        String $prefix,
        Boolean $refreshonly = false
        ) {
    $script_name = basename($script)

    exec { $script_name:
        path => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => "sh ${script} --prefix=${prefix} --skip-license",
        refreshonly => $refreshonly,
    }

}
