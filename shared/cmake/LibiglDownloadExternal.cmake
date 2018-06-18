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

## AntTweakBar
function(igl_download_anttweakbar)
	# TODO
endfunction()

## CGAL
function(igl_download_cgal)
	# TODO
endfunction()

## CoMISo
function(igl_download_comiso)
	igl_download_project(CoMISo
		GIT_REPOSITORY https://github.com/libigl/CoMISo.git
		GIT_TAG        fea3ee0ba7d42ee3eca202d484e4fad855e4d6aa
	)
endfunction()

## Cork
function(igl_download_cork)
	igl_download_project(cork
		GIT_REPOSITORY https://github.com/libigl/cork.git
		GIT_TAG        27ad8a285838f5a480d856429e39d3d56d4338f9
	)
endfunction()

## Eigen
function(igl_download_eigen)
	igl_download_project(eigen
		URL           http://bitbucket.org/eigen/eigen/get/3.2.10.tar.gz
		URL_MD5       8ad10ac703a78143a4062c9bda9d8fd3
	)
endfunction()

## Embree
function(igl_download_embree)
	igl_download_project(embree
		URL            https://github.com/embree/embree/archive/v2.17.4.tar.gz
		URL_MD5        2038f3216b1d626e87453aee72c470e5
		# GIT_REPOSITORY https://github.com/embree/embree.git
		# GIT_TAG        cb61322db3bb7082caed21913ad14869b436fe78
	)
endfunction()

## lim
function(igl_download_lim)
	# TODO
endfunction()

## GLFW
function(igl_download_glfw)
	igl_download_project(glfw
		GIT_REPOSITORY https://github.com/glfw/glfw.git
		GIT_TAG        58cc4b2c5c2c9a245e09451437dd6f5af4d60c84
	)
endfunction()

## ImGui
function(igl_download_imgui)
	download_project(
		PROJ           imgui
		SOURCE_DIR     ${LIBIGL_EXTERNAL}/imgui/imgui
		DOWNLOAD_DIR   ${LIBIGL_EXTERNAL}/.cache/${name}
		GIT_REPOSITORY https://github.com/ocornut/imgui.git
		GIT_TAG        7cc1bc7635989e2372102462922378df585e7f03
	)
endfunction()

## pybind11
function(igl_download_pybind11)
	igl_download_project(pybind11
		GIT_REPOSITORY https://github.com/pybind/pybind11.git
		GIT_TAG        2d0507db43cd5a117f7843e053b17dffca114107
	)
endfunction()

## TetGen
function(igl_download_tetgen)
	igl_download_project(tetgen
		GIT_REPOSITORY https://github.com/libigl/tetgen.git
		GIT_TAG        3c3b022727629c22f3685b0e45e11f7c9f9598e2
	)
endfunction()

## TinyXML
function(igl_download_tinyxml2)
	igl_download_project(tinyxml2
		GIT_REPOSITORY https://github.com/leethomason/tinyxml2.git
		GIT_TAG        d175e9de0be0d4db75d0a8cf065599a435a87eb6
	)
endfunction()

## Triangle
function(igl_download_triangle)
	igl_download_project(triangle
		GIT_REPOSITORY https://github.com/libigl/triangle.git
		GIT_TAG        d6761dd691e2e1318c83bf7773fea88d9437464a
	)
endfunction()

