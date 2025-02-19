#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
   Check these declarations against the C/Fortran source code.
*/

/* .C calls */
extern void discrete_leloup_goldbeter_noisy_rhs_dde(void *);
extern void discrete_leloup_goldbeter_rhs_dde(void *);

/* .Call calls */
extern SEXP discrete_leloup_goldbeter_contents(SEXP);
extern SEXP discrete_leloup_goldbeter_create(SEXP);
extern SEXP discrete_leloup_goldbeter_initial_conditions(SEXP, SEXP);
extern SEXP discrete_leloup_goldbeter_metadata(SEXP);
extern SEXP discrete_leloup_goldbeter_noisy_contents(SEXP);
extern SEXP discrete_leloup_goldbeter_noisy_create(SEXP);
extern SEXP discrete_leloup_goldbeter_noisy_initial_conditions(SEXP, SEXP);
extern SEXP discrete_leloup_goldbeter_noisy_metadata(SEXP);
extern SEXP discrete_leloup_goldbeter_noisy_rhs_r(SEXP, SEXP, SEXP);
extern SEXP discrete_leloup_goldbeter_noisy_set_initial(SEXP, SEXP, SEXP, SEXP);
extern SEXP discrete_leloup_goldbeter_noisy_set_user(SEXP, SEXP);
extern SEXP discrete_leloup_goldbeter_rhs_r(SEXP, SEXP, SEXP);
extern SEXP discrete_leloup_goldbeter_set_initial(SEXP, SEXP, SEXP, SEXP);
extern SEXP discrete_leloup_goldbeter_set_user(SEXP, SEXP);

static const R_CMethodDef CEntries[] = {
    {"discrete_leloup_goldbeter_noisy_rhs_dde", (DL_FUNC) &discrete_leloup_goldbeter_noisy_rhs_dde, 1},
    {"discrete_leloup_goldbeter_rhs_dde",       (DL_FUNC) &discrete_leloup_goldbeter_rhs_dde,       1},
    {NULL, NULL, 0}
};

static const R_CallMethodDef CallEntries[] = {
    {"discrete_leloup_goldbeter_contents",                 (DL_FUNC) &discrete_leloup_goldbeter_contents,                 1},
    {"discrete_leloup_goldbeter_create",                   (DL_FUNC) &discrete_leloup_goldbeter_create,                   1},
    {"discrete_leloup_goldbeter_initial_conditions",       (DL_FUNC) &discrete_leloup_goldbeter_initial_conditions,       2},
    {"discrete_leloup_goldbeter_metadata",                 (DL_FUNC) &discrete_leloup_goldbeter_metadata,                 1},
    {"discrete_leloup_goldbeter_noisy_contents",           (DL_FUNC) &discrete_leloup_goldbeter_noisy_contents,           1},
    {"discrete_leloup_goldbeter_noisy_create",             (DL_FUNC) &discrete_leloup_goldbeter_noisy_create,             1},
    {"discrete_leloup_goldbeter_noisy_initial_conditions", (DL_FUNC) &discrete_leloup_goldbeter_noisy_initial_conditions, 2},
    {"discrete_leloup_goldbeter_noisy_metadata",           (DL_FUNC) &discrete_leloup_goldbeter_noisy_metadata,           1},
    {"discrete_leloup_goldbeter_noisy_rhs_r",              (DL_FUNC) &discrete_leloup_goldbeter_noisy_rhs_r,              3},
    {"discrete_leloup_goldbeter_noisy_set_initial",        (DL_FUNC) &discrete_leloup_goldbeter_noisy_set_initial,        4},
    {"discrete_leloup_goldbeter_noisy_set_user",           (DL_FUNC) &discrete_leloup_goldbeter_noisy_set_user,           2},
    {"discrete_leloup_goldbeter_rhs_r",                    (DL_FUNC) &discrete_leloup_goldbeter_rhs_r,                    3},
    {"discrete_leloup_goldbeter_set_initial",              (DL_FUNC) &discrete_leloup_goldbeter_set_initial,              4},
    {"discrete_leloup_goldbeter_set_user",                 (DL_FUNC) &discrete_leloup_goldbeter_set_user,                 2},
    {NULL, NULL, 0}
};

void R_init_clockSim(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
