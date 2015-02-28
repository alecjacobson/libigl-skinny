#include "ortho.h"

template < typename DerivedP>
IGL_INLINE void igl::ortho(
  const typename DerivedP::Scalar left,
  const typename DerivedP::Scalar right,
  const typename DerivedP::Scalar bottom,
  const typename DerivedP::Scalar top,
  const typename DerivedP::Scalar nearVal,
  const typename DerivedP::Scalar farVal,
  Eigen::PlainObjectBase<DerivedP> & P)
{
  P.setIdentity();
  P(0,0) = 2. / (right - left);
  P(1,1) = 2. / (top - bottom);
  P(2,2) = - 2./ (farVal - nearVal);
  P(0,3) = - (right + left) / (right - left);
  P(1,3) = - (top + bottom) / (top - bottom);
  P(2,3) = - (farVal + nearVal) / (farVal - nearVal);
}
