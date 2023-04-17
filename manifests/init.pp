# @summary Installs CMake from source.
#
# This module downloads CMake from Kitware's GitHub repository, optionally
# bootstraps and builds it and installs it afterwards.
#
# @param source_dir The directory where to download and extract the sources to.
# @param install_dir The installation prefix, which defaults to '/usr'.
# @param base_url The base URL where the CMake sources are downloaded from.
#                 This defaults to the release directory on for CMake on GitHub.
# @param build_dependencies A list of packages that need to be installed in
#                           order to successfully build CMake. These
#                           dependencies should be specified via Hiera.
# @param version The version of CMake that should be installed. 
# @param override_url If set, forces download from the specified URL, bypassing
#                     any of the automatic guess work.
#
# @author Christoph Müller
class cmake(
        String $source_dir,
        String $install_dir,
        String $base_url,
        Array[String] $build_dependencies,
        String $version,
        Optional[String] $override_url = undef
        ) {

    # Ensure that all build depedencies are installed.
    ensure_packages($build_dependencies)

    # Resolve the actual remote location of the sources.
    $url = if $override_url {
        $override_url
    } else {
        "${base_url}/v${version}/cmake-${version}-linux-${facts['os']['architecture']}.sh"
    }

    # Resolve the local source file and directory.
    $src_file = "${source_dir}/${basename($url)}"
    #$src_dir = "${source_dir}/${basename($url, '.*')}"

  notify { ">>>>>>>>>>>>>>>>>>>${src_file}": }

    # Download and extract the installer script.
    archive { $src_file:
        source => $url,
        user => 'root',
        group => 'root',
    }

    # Run the installer.
    ~> cmake::install { "${title}-${version}":
        script => $src_file,
        prefix => $install_dir
    }

}
