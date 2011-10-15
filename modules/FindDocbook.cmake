# - Find DocBook/XML tools
# This module can be used to translate Docbook/XML files to different
# output formats using XSLT files. Currently support XSLT processors
# that can be used for DocBook:
#   xsltproc
#   saxon-6.5.x
#   xalan-2.x
#
# Typical usage is:
# find_package(DocBook REQUIRED)
# include(${DocBook_USE_FILE})
# docbook_generate(manpage my-app.xml MANPAGE_FILE_LIST)
# foreach(file ${MANPAGE_FILE_LIST})
#   ...
# endforeach(file)
#
# This modules uses the following variables that must be set before
# includign the USE_FILE:
#   DOCBOOK_XSLT_PROCESSOR - select the xslt processor to use
#
# The following functions are provided:
#   DOCBOOK_GENERATE(format inputFile output)
#     This function determines the output file names from the input
#     file, depending on the format and stores it as cmake list in
#     output. The currently support formats for "manpage" and "html".
#
# The following variables are set by this module:
#   DocBook_FOUND          - True is DocBook processing is available
#   DocBook_USE_FILE       - Name of the USE_FILE
#   DOCBOOK_XSLT_PROCESSOR - If not set, one of the available XSLT processors
#

find_file ( JAVA_DOCBOOK_XSL_SAXON_LIBRARY
  NAMES docbook-xsl-saxon_1.00.jar
  PATH_SUFFIXES share/java
  DOC "location of saxon 6.5.x DocBook XSL extension JAR file"
  CMAKE_FIND_ROOT_PATH_BOTH
)
mark_as_advanced ( JAVA_DOCBOOK_XSL_SAXON_LIBRARY )
set ( Xslt_SAXON_EXTENSIONS "${JAVA_DOCBOOK_XSL_SAXON_LIBRARY}" )

find_package ( Xslt )
if ( Xslt_FOUND )
  if ( NOT DOCBOOK_XSLT_PROCESSOR )
    if ( XSLT_XSLTPROC_EXECUTABLE )
      set ( DOCBOOK_XSLT_PROCESSOR "xsltproc" )
    elseif ( XSLT_SAXON_COMMAND AND JAVA_DOCBOOK_XSL_SAXON_LIBRARY )
      set ( DOCBOOK_XSLT_PROCESSOR "saxon" )
    elseif ( XSLT_XALAN2_COMMAND )
      set ( DOCBOOK_XSLT_PROCESSOR "xalan2" )
    endif ( XSLT_XSLTPROC_EXECUTABLE )
  endif ( NOT DOCBOOK_XSLT_PROCESSOR )

  set ( DOCBOOK_XSLT_PROCESSOR "${DOCBOOK_XSLT_PROCESSOR}"
        CACHE STRING "Docbook XSLT processor select (xsltproc, xalan2 or saxon)" )
  set ( XSLT_PROCESSOR  "${DOCBOOK_XSLT_PROCESSOR}" )

  if ( DOCBOOK_XSLT_PROCESSOR )
    set ( Docbook_FOUND true )
    set ( Docbook_USE_FILE UseDocbook )
  endif ( DOCBOOK_XSLT_PROCESSOR )
endif ( Xslt_FOUND )

if ( NOT Docbook_FOUND )
  if ( NOT Docbook_FIND_QUIETLY )
    message ( STATUS "No supported Docbook XSLT found." )
  endif ( NOT Docbook_FIND_QUIETLY )
  if ( Docbook_FIND_REQUIRED )
    message ( FATAL_ERROR "No supported Docbook XSLT found but it is required." )
  endif ( Docbook_FIND_REQUIRED )
endif ( NOT Docbook_FOUND )
