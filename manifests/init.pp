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
# @param source_type The source_type parameter determines the type of the
#                    installation. If it is 'sh', the installer script will be
#                    downloaded and installed. Otherwise, it is assumed that the
#                    source URL points to a source archive that needs to be
#                    built. For Linux machines, you would typically use 'tar.gz'
#                    in this case.
# @param version The version of CMake that should be installed. 
# @param override_url If set, forces download from the specified URL, bypassing
#                     any of the automatic guess work.
#
# @author Christoph Müller
class cmake(
        String $source_dir = '/usr/local/src',
        String $install_dir = '/usr',
        String $base_url = 'https://github.com/Kitware/CMake/releases/download/',
        String $source_type = 'sh',
        Array[String] $build_dependencies = [ 'gcc' ],
        String $version,
        Optional[String] $override_url = undef
        ) {

    # Ensure that all build depedencies are installed.
    ensure_packages($build_dependencies)

    # Resolve the actual remote location of the sources.
    $url = if $override_url {
        $override_url
    } elsif $source_type == 'sh' {
        "${base_url}/v${version}/cmake-${version}-linux-${facts['os']['architecture']}.${source_type}"
    } else {
        "${base_url}/v${version}/cmake-${version}.${source_type}"
    }

    # Resolve the local source file.
    $src_file = "${source_dir}/${basename($url)}"

    if $source_type == 'sh' {
        # Download the installer script.
        #notify { "Download cmake installer ${url}": }
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

    } else {
        $src_dir = "${source_dir}/${basename(basename($url, '.*'), '.*')}"

        notify { ">>>> ${url} >>>> ${src_dir}": }


        # Download and extract the source archive.
        archive { $src_file:
            source => $url,
            user => 'root',
            group => 'root',
            extract => true,
            extract_path => $source_dir,
            cleanup => false,
        }

        # Build and install the source.
        ~> cmake::build { "${title}-${version}":
            src_dir => $src_dir,
            prefix => $install_dir
        }     
    }
}
