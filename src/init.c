#include <stdlib.h>
#include <R_ext/Rdynload.h>
#include <Rinternals.h> // for SEXP

extern void getjagsversions(int *forced, int *assumed, int *detected, int *used);
extern void testneojags(int *disttype, int *dpqr, int *uselog, int *lower, int *N, double *x, int *npars, double *parameters, double *values, int *status);

static R_NativePrimitiveArgType getjagsversions_t[] = {
    INTSXP, INTSXP, INTSXP, INTSXP
};
static R_NativePrimitiveArgType testneojags_t[] = {
    INTSXP, INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, INTSXP, REALSXP, REALSXP, INTSXP
};

static const R_CMethodDef cMethods[] = {
    {"getjagsversions", (DL_FUNC) &getjagsversions, 4, getjagsversions_t},
    {"testneojags", (DL_FUNC) &testneojags, 10, testneojags_t},
    {NULL, NULL, 0, NULL}
};

void
R_init_neojags(DllInfo *dll)
{
    R_registerRoutines(dll, cMethods, NULL, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
