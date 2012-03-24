#ifndef IGL_NORMALIZE_ROW_LENGTHS_H
#define IGL_NORMALIZE_ROW_LENGTHS_H
#include "igl_inline.h"
#include <Eigen/Core>

// History:
// March 24, 2012: Alec changed function name from normalize_rows to
//   normalize_row_lengths to avoid confusion with normalize_row_sums

namespace igl
{
  // Normalize the rows in A so that their lengths are each 1 and place the new
  // entries in B
  // Inputs:
  //   A  #rows by k input matrix
  // Outputs:
  //   B  #rows by k input matrix, can be the same as A
  template <typename DerivedV>
  IGL_INLINE void normalize_row_lengths(
   const Eigen::PlainObjectBase<DerivedV>& A,
   Eigen::PlainObjectBase<DerivedV> & B);
}

#ifdef IGL_HEADER_ONLY
#  include "normalize_row_lengths.cpp"
#endif

#endif
