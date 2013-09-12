#include "view_axis.h"
#ifndef IGL_NO_OPENGL

#include "OpenGL_convenience.h"

IGL_INLINE void igl::view_axis(double * x, double * y, double * z)
{
  double mv[16];
  glGetDoublev(GL_MODELVIEW_MATRIX, mv);
  igl::view_axis(mv,x,y,z);
}

IGL_INLINE void igl::view_axis(const double * mv, double * x, double * y, double * z)
{
  *x = -mv[0*4+2];
  *y = -mv[1*4+2];
  *z = -mv[2*4+2];
}
#endif
