#
#  Generated from roslisp/cmake/roslisp-extras.cmake.in
#

@[if DEVELSPACE]@
# location of script in develspace
set(ROSLISP_MAKE_NODE_BIN "@(CMAKE_CURRENT_SOURCE_DIR)/scripts/make_node_exec")
@[else]@
# location of script in installspace
set(ROSLISP_MAKE_NODE_BIN "${roslisp_DIR}/../../common-lisp/ros/roslisp/scripts/make_node_exec")
@[end if]@

# Build up a list of executables, in order to make them depend on each
# other, to avoid building them in parallel, because it's not safe to do
# that.
if(NOT ${ROSLISP_EXECUTABLES})
  set(${ROSLISP_EXECUTABLES})
endif()

function(catkin_add_lisp_executable _output _system_name _entry_point)
  if(${ARGC} LESS 4)
    set(_targetname _roslisp_${_output})
  elseif(${ARGC} LESS 5)
    set(extra_macro_args ${ARGN})
    list(GET extra_macro_args 0 _targetname)
  elseif(${ARGC} GREATER 4)
    message(SEND_ERROR "[roslisp] catkin_ad_lisp_executable can have maximum of 4 arguments")
  endif()
  string(REPLACE "/" "_" _targetname ${_targetname})
  set(_targetdir ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_BIN_DESTINATION})

  # Add dummy custom command to get make clean behavior right.
  add_custom_command(OUTPUT ${_targetdir}/${_output} ${_targetdir}/${_output}.lisp
    COMMAND echo -n)
  add_custom_target(${_targetname} ALL
                     DEPENDS ${_targetdir}/${_output} ${_targetdir}/${_output}.lisp
                     COMMAND ${ROSLISP_MAKE_NODE_BIN} ${PROJECT_NAME} ${_system_name} ${_entry_point} ${_targetdir}/${_output})

  # Make this executable depend on all previously declared executables, to serialize them.
  add_dependencies(${_targetname} rosbuild_precompile ${ROSLISP_EXECUTABLES})
  # Add this executable to the list of executables on which all future
  # executables will depend.
  list(APPEND ROSLISP_EXECUTABLES ${_targetname})
  set(ROSLISP_EXECUTABLES "${ROSLISP_EXECUTABLES}" PARENT_SCOPE)

  # mark the generated executables for installation
  install(PROGRAMS ${_targetdir}/${_output}
    DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})
  install(FILES ${_targetdir}/${_output}.lisp
    DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})
endfunction(catkin_add_lisp_executable)
