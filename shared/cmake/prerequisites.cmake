################################################################################
include(DownloadProject)

# Shortcut function
function(igl_download_project name)
	download_project(
		PROJ         ${name}
		SOURCE_DIR   ${LIBIGL_EXTERNAL}/${name}
		DOWNLOAD_DIR ${LIBIGL_EXTERNAL}/.cache/${name}
		${ARGN}
	)
endfunction()

################################################################################

igl_download_project(eigen
	URL          http://bitbucket.org/eigen/eigen/get/3.2.10.tar.gz
	URL_MD5      8ad10ac703a78143a4062c9bda9d8fd3
)

################################################################################

if(LIBIGL_WITH_EMBREE)
	# GIT_TAG can also be a SHA1 commit number ...
	# Note that if we use the URL of the release directly, we don't have to download the .git folder (saves 70 MB)
	igl_download_project(embree
		# URL            https://github.com/embree/embree/archive/v2.17.4.tar.gz
		# URL_MD5        2038f3216b1d626e87453aee72c470e5
		GIT_REPOSITORY https://github.com/embree/embree.git
		GIT_TAG        cb61322db3bb7082caed21913ad14869b436fe78
	)
endif()
