dnl
dnl Copyright 1999-2004 The Apache Software Foundation
dnl
dnl Licensed under the Apache License, Version 2.0 (the "License");
dnl you may not use this file except in compliance with the License.
dnl You may obtain a copy of the License at
dnl
dnl     http://www.apache.org/licenses/LICENSE-2.0
dnl
dnl Unless required by applicable law or agreed to in writing, software
dnl distributed under the License is distributed on an "AS IS" BASIS,
dnl WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
dnl See the License for the specific language governing permissions and
dnl limitations under the License.
dnl

dnl -------------------------------------------------------------------------
dnl Author  Pier Fumagalli <mailto:pier.fumagalli@eng.sun.com>
dnl Version $Id$
dnl -------------------------------------------------------------------------

AC_DEFUN([AP_PROG_JAVAC_WORKS],[
  AC_CACHE_CHECK([wether the Java compiler ($JAVAC) works],ap_cv_prog_javac_works,[
    echo "public class Test {}" > Test.java
    $JAVAC $JAVACFLAGS Test.java > /dev/null 2>&1
    if test $? -eq 0
    then
      rm -f Test.java Test.class
      ap_cv_prog_javac_works=yes
    else
      rm -f Test.java Test.class
      AC_MSG_RESULT(no)
      AC_MSG_ERROR([installation or configuration problem: javac cannot compile])
    fi
  ])
])

dnl Check for JAVA compilers.
AC_DEFUN([AP_PROG_JAVAC],[
  if test "$SABLEVM" != "NONE"
  then
    AC_PATH_PROG(JAVAC,javac-sablevm,NONE,$JAVA_HOME/bin)
  else
    XPATH="$JAVA_HOME/bin:$PATH"
    AC_PATH_PROG(JAVAC,javac,NONE,$XPATH)
  fi
  if test "$JAVAC" = "NONE"
  then
    AC_MSG_ERROR([javac not found])
  fi
  AP_PROG_JAVAC_WORKS()
  AC_PROVIDE([$0])
  AC_SUBST(JAVAC)
  AC_SUBST(JAVACFLAGS)
])

dnl Check for jar archivers.
AC_DEFUN([AP_PROG_JAR],[
  if test "$SABLEVM" != "NONE"
  then
    AC_PATH_PROG(JAR,jar-sablevm,NONE,$JAVA_HOME/bin)
  else
    XPATH="$JAVA_HOME/bin:$PATH"
    AC_PATH_PROG(JAR,jar,NONE,$XPATH)
  fi
  if test "$JAR" = "NONE"
  then
    AC_MSG_ERROR([jar not found])
  fi
  AC_PROVIDE([$0])
  AC_SUBST(JAR)
])

AC_DEFUN([AP_JAVA],[
  AC_ARG_WITH(java,[  --with-java=DIR         Specify the location of your JDK installation],[
    AC_MSG_CHECKING([JAVA_HOME])
    if test -d "$withval"
    then
      JAVA_HOME="$withval"
      AC_MSG_RESULT([$JAVA_HOME])
    else
      AC_MSG_RESULT([failed])
      AC_MSG_ERROR([$withval is not a directory])
    fi
    AC_SUBST(JAVA_HOME)
  ])
  if test x"$JAVA_HOME" = x
  then
    AC_MSG_ERROR([Java Home not defined. Rerun with --with-java=[...] parameter])
  fi
])

dnl check if the JVM in JAVA_HOME is sableVM
dnl $JAVA_HOME/bin/sablevm and /opt/java/lib/sablevm/bin are tested.
AC_DEFUN([AP_SABLEVM],[
  if test x"$JAVA_HOME" != x
  then
    AC_PATH_PROG(SABLEVM,sablevm,NONE,$JAVA_HOME/bin)
    if test "$SABLEVM" != "NONE"
    then
      AC_MSG_RESULT([Using sableVM: $SABLEVM])
      CFLAGS="$CFLAGS -DHAVE_SABLEVM"
    fi
  fi
])
