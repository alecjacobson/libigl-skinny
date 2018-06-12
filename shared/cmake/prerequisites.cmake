include(DownloadProject)

download_project(
	PROJ       eigen
	URL        http://bitbucket.org/eigen/eigen/get/3.2.10.tar.gz
	URL_MD5    8ad10ac703a78143a4062c9bda9d8fd3
	SOURCE_DIR ${LIBIGL_EXTERNAL}/eigen
)

if(LIBIGL_WITH_EMBREE)
	# GIT_TAG can also be a SHA1 commit number ...
	# Note that if we use the URL of the release directly, we don't have to download the .git folder (saves 70 MB)
	download_project(
		PROJ           embree
		URL            https://github.com/embree/embree/archive/v2.17.4.tar.gz
		URL_MD5        2038f3216b1d626e87453aee72c470e5
		# GIT_REPOSITORY https://github.com/embree/embree.git
		# GIT_TAG        v2.17.4
		SOURCE_DIR     ${LIBIGL_EXTERNAL}/embree
	)
endif()
