
/*
  (c) 2003-2013 Coverity, Inc. All rights reserved worldwide.
  The information contained in this file is the proprietary and confidential
  information of Coverity, Inc. and its licensors, and is supplied subject to,
  and may be used only by Coverity customers in accordance with the terms and
  conditions of a previously executed license agreement between Coverity and
  that customer.
*/


/* DO NOT MODIFY THE CONTENTS OF THIS FILE */

#pragma builtin begin

#if defined(__APPLE__)
#if defined(__BLOCKS__)
#undef __BLOCKS__
#endif
// __private_extern__ is a keyword in C (not C++)
#define __private_extern__
const void* __builtin___CFStringMakeConstantString(const char*);
#endif

#if defined(__GNUC__)

#if defined(__SPU__) || defined(__PPC__)
#if defined(__COVERITY_GCC_DIALECT_C89) || defined(__COVERITY_GCC_DIALECT_GNU89)
  #undef __STDC_VERSION__
#endif
#endif

#if __GNUC__ >= 4
typedef __coverity___float80 long double __float80;
typedef __coverity___float128 long double __float128;

// Taken from the gcc 4.3.0 manual
// definitions for long, long long and their unsigned counterparts may be needed

extern int __sync_fetch_and_add (volatile int*, int, ...);
extern int __sync_fetch_and_sub (volatile int*, int, ...);
extern int __sync_fetch_and_or (volatile int*, int, ...);
extern int __sync_fetch_and_and (volatile int*, int, ...);
extern int __sync_fetch_and_xor (volatile int*, int, ...);
extern int __sync_fetch_and_nand (volatile int*, int, ...);
extern int __sync_add_and_fetch (volatile int*, int, ...);
extern int __sync_sub_and_fetch (volatile int*, int, ...);
extern int __sync_or_and_fetch (volatile int*, int, ...);
extern int __sync_and_and_fetch (volatile int*, int, ...);
extern int __sync_xor_and_fetch (volatile int*, int, ...);
extern int __sync_nand_and_fetch (volatile int*, int, ...);
extern int __sync_bool_compare_and_swap (volatile int *ptr, int, int, ...);
extern int __sync_val_compare_and_swap (volatile int *ptr, int, int, ...);
extern void __sync_synchronize ();
extern int __sync_lock_test_and_set (volatile int*, int, ...);
extern void __sync_lock_release (volatile int *ptr, ...);

//Added with GCC 4.7
__complex double __builtin_complex(double real, double imag);

#endif //__GNUC__ >= 4


#endif // __GNUC__

#pragma builtin end

/*
  (c) 2008-2013 Coverity, Inc. All rights reserved worldwide.
  The information contained in this file is the proprietary and confidential
  information of Coverity, Inc. and its licensors, and is supplied subject to,
  and may be used only by Coverity customers in accordance with the terms and
  conditions of a previously executed license agreement between Coverity and
  that customer.
*/

#pragma builtin begin

#ifdef __IA64__
typedef __coverity___fpreg long double __fpreg;
typedef __coverity___float80 long double __float80;
typedef __coverity___float128 long double __float128;

#endif

#ifdef __clang__
#define __has_include __coverity_has_include
#define __has_include_next __coverity_has_include_next
#endif

#ifdef __cplusplus
extern "C" {
#endif

// The following macros are used in the Linux Kernel
#nodef BUG_ON(x) do { if (x) __coverity_panic__(); } while (0)
#nodef WARN_ON(x) do { if (x) __coverity_panic__(); } while (0)
#nodef BUG() __coverity_panic__()
void __coverity_panic__();

#ifndef __COVERITY_NO_STRING_NODEFS__
// Function list obtained from "cstring"+memrchr+stpcopy (from bits/string.h)

#nodef memcpy __coverity_memcpy
void *__coverity_memcpy(void *, const void *, __COVERITY_SIZE_TYPE__);

#nodef memmove __coverity_memmove
void *__coverity_memmove(void *, const void *, __COVERITY_SIZE_TYPE__);

#nodef strcpy __coverity_strcpy
char *__coverity_strcpy(char *, const char *);

#nodef strncpy __coverity_strncpy
char *__coverity_strncpy(char *, const char *, __COVERITY_SIZE_TYPE__);

#nodef strcat __coverity_strcat
char *__coverity_strcat (char *, const char *);

#nodef strncat __coverity_strncat
char *__coverity_strncat (char *, const char *, __COVERITY_SIZE_TYPE__);

#nodef memcmp __coverity_memcmp
int __coverity_memcmp(const void *, const void *, __COVERITY_SIZE_TYPE__ n);

#nodef strcmp __coverity_strcmp
int __coverity_strcmp(const char *, const char *);

#nodef strcoll __coverity_strcoll
int __coverity_strcoll(const char *, const char *);

#nodef strncmp __coverity_strncmp
int __coverity_strncmp(const char *, const char *, __COVERITY_SIZE_TYPE__);

#nodef strxfrm __coverity_strxfrm
__COVERITY_SIZE_TYPE__
__coverity_strxfrm(char *, const char *, __COVERITY_SIZE_TYPE__);

#nodef memchr __coverity_memchr
void *__coverity_memchr(const void *, int, __COVERITY_SIZE_TYPE__);

#nodef strchr __coverity_strchr
char *__coverity_strchr(const char *, int);

#nodef strcspn __coverity_strcspn
__COVERITY_SIZE_TYPE__ __coverity_strcspn(const char *, const char *);

#nodef strpbrk __coverity_strpbrk
char *__coverity_strpbrk(const char *, const char *);

#nodef strrchr __coverity_strrchr
char *__coverity_strrchr(const char *, int);

#nodef strspn __coverity_strspn
__COVERITY_SIZE_TYPE__ __coverity_strspn(const char *, const char *);

#nodef strstr __coverity_strstr
char *__coverity_strstr (const char *, const char *);

#nodef strtok __coverity_strtok
char *__coverity_strtok(char *, const char *);

#nodef memset __coverity_memset
void *__coverity_memset(void *, int, __COVERITY_SIZE_TYPE__);

#nodef strlen __coverity_strlen
__COVERITY_SIZE_TYPE__ __coverity_strlen(const char *);

#nodef strerror __coverity_strerror
char *__coverity_strerror(int);

#nodef memrchr __coverity_memrchr
void *__coverity_memrchr(const void *, int, __COVERITY_SIZE_TYPE__);

#nodef stpcpy __coverity_stpcpy
char *__coverity_stpcpy(char *, const char *);

#nodef strdup __coverity_strdup
char *__coverity_strdup(const char *);
#endif // __COVERITY_NO_STRING_NODEFS__

#ifdef __cplusplus
}
#endif

#if ((__GNUC__ == 3) && (__GNUC_MINOR__ >= 4)) || (__GNUC__ >= 4)
extern char *__builtin_stpcpy(char *, const char *);
#endif

#if ((__GNUC__==4 && __GNUC_MINOR__>=4) || (__GNUC__>4))
#define __builtin_ms_va_list __builtin_va_list
#define __builtin_ms_va_copy __builtin_va_copy
#define __builtin_ms_va_start __builtin_va_start
#define __builtin_ms_va_end __builtin_va_end

#define __builtin_sysv_va_list __builtin_va_list
#define __builtin_sysv_va_copy __builtin_va_copy
#define __builtin_sysv_va_start __builtin_va_start
#define __builtin_sysv_va_end __builtin_va_end

#define __ms_va_copy(__d,__s) __builtin_ms_va_copy(__d,__s)
#define __ms_va_start(__v,__l) __builtin_ms_va_start(__v,__l)
#define __ms_va_arg(__v,__l)    __builtin_va_arg(__v,__l)
#define __ms_va_end(__v) __builtin_ms_va_end(__v)

#define __sysv_va_copy(__d,__s) __builtin_sysv_va_copy(__d,__s)
#define __sysv_va_start(__v,__l) __builtin_sysv_va_start(__v,__l)
#define __sysv_va_arg(__v,__l)  __builtin_va_arg(__v,__l)
#define __sysv_va_end(__v) __builtin_sysv_va_end(__v)
#endif // (__GNUC__==4 && __GNUC_MINOR__>=4) || (__GNUC__>4)

#if __GNUC__ >= 4
extern double __builtin_powi(double,int);
extern float __builtin_powif(float,int);
extern long double __builtin_powil(long double,int);

extern float __builtin_cabsf(__complex__ float);
extern double __builtin_cabs(__complex__ double);
extern long double __builtin_cabsl(__complex__ long double);
extern float __builtin_cargf(__complex__ float);
extern double __builtin_carg(__complex__ double);
extern long double __builtin_cargl(__complex__ long double);

#ifdef __COVERITY_NO_STRING_NODEFS__
/* With new style #nodef, __COVERITY_NO_STRING_NODEFS__ should no longer
   be needed, but just in case it is still being used. Lets define
   macros that do not depend on __coverity versions. Eventually we should put
   a #error here and retire this feature. */
#define __builtin_memchr(dst, src, len) memchr(dst, src, len)
#define __builtin_memcpy(dst, src, len) memcpy (dst, src, len)
#define __builtin_memmove(dst, src, len) memmove (dst, src, len)
#define __builtin_memset(dst, val, len) memset (dst, val, len)
#define __builtin_strcpy(dst, src) strcpy (dst, src)
#define __builtin_strcat(dst, src) strcat (dst, src)
#define __builtin_strncpy(dst, src, len) strncpy (dst, src, len)
#define __builtin_strncat(dst, src, len) strncat (dst, src, len)
#else
#define __builtin_memchr(dst, src, len) __coverity_memchr(dst, src, len)
#define __builtin_memcpy(dst, src, len) __coverity_memcpy (dst, src, len)
#define __builtin_memmove(dst, src, len) __coverity_memmove (dst, src, len)
#define __builtin_memset(dst, val, len) __coverity_memset (dst, val, len)
#define __builtin_strcpy(dst, src) __coverity_strcpy (dst, src)
#define __builtin_strcat(dst, src) __coverity_strcat (dst, src)
#define __builtin_strncpy(dst, src, len) __coverity_strncpy (dst, src, len)
#define __builtin_strncat(dst, src, len) __coverity_strncat (dst, src, len)
#endif

#define __builtin_mempcpy(dst, src, len) mempcpy (dst, src, len)
#define __builtin_sprintf(dst, ...) sprintf (dst, __VA_ARGS__)
#define __builtin_snprintf(dst, len, ...) snprintf (dst, len, __VA_ARGS__)

int __builtin_vsprintf(char *, const char *, __builtin_va_list);
int __builtin_vsnprintf(char *, int, const char *, __builtin_va_list);
#endif

#ifndef __COVERITY_DISABLE_BUILTIN_DECLS

/* mmx, sse compat */

#if (__GNUC__ <3)
typedef int __cov_m64 __attribute__ ((__mode__ (__V2SI__)));
typedef float __cov_m128 __attribute__ ((__mode__(__V4SF__)));

/* Internal data types for implementing the intrinsics.  */
typedef int __cov_v2si __attribute__ ((__mode__ (__V2SI__)));
typedef int __cov_v4hi __attribute__ ((__mode__ (__V4HI__)));
typedef int __cov_v8qi __attribute__ ((__mode__ (__V8QI__)));

/* Internal data types for implementing the intrinsics.  */
typedef float __cov_v4sf __attribute__ ((__mode__(__V4SF__)));
typedef int __cov_v4si __attribute__ ((mode (V4SI)));

typedef double __cov_v2df __attribute__ ((mode (V2DF)));
typedef int __cov_v8hi __attribute__ ((mode (V8HI)));
typedef int __cov_v2di __attribute__ ((mode (V2DI)));
typedef int __cov_v16qi __attribute__ ((mode (V16QI)));

typedef int __cov_v1di __attribute__ ((mode (V1DI)));

#define __cov_m128i __cov_v2di
#define __cov_m128d __cov_v2df
#endif

#if ((__GNUC__ >= 3) && (__GNUC__ < 4))

typedef int __cov_m64 __attribute__ ((__mode__ (__V2SI__)));

/* Internal data types for implementing the intrinsics.  */
typedef int __cov_v2si __attribute__ ((__mode__ (__V2SI__)));
typedef int __cov_v4hi __attribute__ ((__mode__ (__V4HI__)));
typedef int __cov_v8qi __attribute__ ((__mode__ (__V8QI__)));

/* The data type intended for user use.  */
typedef float __cov_m128 __attribute__ ((__mode__(__V4SF__)));

/* Internal data types for implementing the intrinsics.  */
typedef float __cov_v4sf __attribute__ ((__mode__(__V4SF__)));
typedef int __cov_v4si __attribute__ ((mode (V4SI)));

typedef double __cov_v2df __attribute__ ((mode (V2DF)));
typedef int __cov_v2di __attribute__ ((mode (V2DI)));
typedef int __cov_v8hi __attribute__ ((mode (V8HI)));
typedef int __cov_v16qi __attribute__ ((mode (V16QI)));
typedef int __cov_v1di __attribute__ ((mode (V1DI)));

#define __cov_m128i __cov_v2di
#define __cov_m128d __cov_v2df

#endif // gnu 3.x 

#if ( __GNUC__ >= 4)


/* The Intel API is flexible enough that we must allow aliasing with other
vector types, and their scalar components.  */
#if defined(__APPLE__)
typedef long long __cov_m64 __attribute__ ((__vector_size__ (8)));
#else
typedef int __cov_m64 __attribute__ ((__vector_size__ (8), __may_alias__));
#endif

/* Internal data types for implementing the intrinsics.  */
typedef int __cov_v2si __attribute__ ((__vector_size__ (8)));
typedef short __cov_v4hi __attribute__ ((__vector_size__ (8)));
typedef char __cov_v8qi __attribute__ ((__vector_size__ (8)));
typedef long long __cov_v1di __attribute__ ((__vector_size__ (8)));

/* The Intel API is flexible enough that we must allow aliasing with other
vector types, and their scalar components.  */
typedef float __cov_m128 __attribute__ ((__vector_size__ (16), __may_alias__));
/* Internal data types for implementing the intrinsics.  */
typedef float __cov_v4sf __attribute__ ((__vector_size__ (16)));
typedef int __cov_v4si __attribute__ ((__vector_size__ (16)));
typedef float __cov_v2sf __attribute__ ((__vector_size__ (8)));

/* SSE2 */
typedef double __cov_v2df __attribute__ ((__vector_size__ (16)));
typedef long long __cov_v2di __attribute__ ((__vector_size__ (16)));
typedef short __cov_v8hi __attribute__ ((__vector_size__ (16)));
typedef char __cov_v16qi __attribute__ ((__vector_size__ (16)));

/* The Intel API is flexible enough that we must allow aliasing with other
vector types, and their scalar components.  */
typedef long long __cov_m128i __attribute__ ((__vector_size__ (16), __may_alias__));
typedef double __cov_m128d __attribute__ ((__vector_size__ (16), __may_alias__));

#endif // GNU 4

#if defined(__GNUC__)

int __builtin_ia32_bsrsi(int);
void __builtin_ia32_fxsave(void *);
void __builtin_ia32_fxsave64(void *);
void __builtin_ia32_fxrstor(void *);
void __builtin_ia32_fxrstor64(void *);
unsigned long long __builtin_ia32_rdpmc(int);
unsigned long long __builtin_ia32_rdtsc();
unsigned long long __builtin_ia32_rdtscp(unsigned int *);
unsigned char __builtin_ia32_rolqi(unsigned char,int);
unsigned short __builtin_ia32_rolhi(unsigned short,int);
unsigned char __builtin_ia32_rorqi(unsigned char,int);
unsigned short __builtin_ia32_rorhi(unsigned short,int);
int __builtin_ia32_bsrdi(long long);
unsigned char __builtin_ia32_addcarryx_u32(unsigned char,unsigned int,unsigned int,unsigned int *);
unsigned char __builtin_ia32_addcarryx_u64(unsigned char,unsigned long,unsigned long,unsigned long long *);

//SSE
void __builtin_ia32_pause();
__cov_m64 __builtin_ia32_pshufw(__cov_v4hi,int const);
__cov_m64 __builtin_ia32_vec_set_v4hi(__cov_v4hi, int const, int const);
int __builtin_ia32_vec_ext_v4hi(__cov_v4hi,int const);
__cov_m128i __builtin_ia32_vec_set_v8hi(__cov_v8hi,int const,int const);
unsigned short __builtin_ia32_vec_ext_v8hi(__cov_v8hi,int const);

// generic MMX
void __builtin_ia32_emms ();

__cov_v4hi __builtin_ia32_packsswb (__cov_v4hi, __cov_v4hi);
__cov_v2si __builtin_ia32_packssdw (__cov_v2si, __cov_v2si);
__cov_v4hi __builtin_ia32_packuswb (__cov_v4hi, __cov_v4hi);
__cov_v8qi __builtin_ia32_punpckhbw (__cov_v8qi, __cov_v8qi);
__cov_v4hi __builtin_ia32_punpckhwd (__cov_v4hi, __cov_v4hi);
__cov_v2si __builtin_ia32_punpckhdq (__cov_v2si, __cov_v2si);
__cov_v8qi __builtin_ia32_punpcklbw (__cov_v8qi, __cov_v8qi);
__cov_v4hi __builtin_ia32_punpcklwd (__cov_v4hi, __cov_v4hi);
__cov_v2si __builtin_ia32_punpckldq (__cov_v2si, __cov_v2si);
__cov_v8qi __builtin_ia32_paddb (__cov_v8qi, __cov_v8qi);
__cov_v4hi __builtin_ia32_paddw (__cov_v4hi, __cov_v4hi);
__cov_v2si __builtin_ia32_paddd (__cov_v2si, __cov_v2si);
__cov_v8qi __builtin_ia32_paddsb (__cov_v8qi, __cov_v8qi);
__cov_v4hi __builtin_ia32_paddsw (__cov_v4hi, __cov_v4hi);
__cov_v8qi __builtin_ia32_paddusb (__cov_v8qi, __cov_v8qi);
__cov_v4hi __builtin_ia32_paddusw (__cov_v4hi, __cov_v4hi);
__cov_v8qi __builtin_ia32_psubb (__cov_v8qi, __cov_v8qi);
__cov_v4hi __builtin_ia32_psubw (__cov_v4hi, __cov_v4hi);
__cov_v2si __builtin_ia32_psubd (__cov_v2si, __cov_v2si);
__cov_v8qi __builtin_ia32_psubsb (__cov_v8qi, __cov_v8qi);
__cov_v4hi __builtin_ia32_psubsw (__cov_v4hi, __cov_v4hi);
__cov_v8qi __builtin_ia32_psubusb (__cov_v8qi, __cov_v8qi);
__cov_v4hi __builtin_ia32_psubusw (__cov_v4hi, __cov_v4hi);
__cov_v4hi __builtin_ia32_pmaddwd (__cov_v4hi, __cov_v4hi);
__cov_v4hi __builtin_ia32_pmulhw (__cov_v4hi, __cov_v4hi);
__cov_v4hi __builtin_ia32_pmullw (__cov_v4hi, __cov_v4hi);
__cov_v8qi __builtin_ia32_pcmpeqb (__cov_v8qi, __cov_v8qi);
__cov_v8qi __builtin_ia32_pcmpgtb (__cov_v8qi, __cov_v8qi);
__cov_v4hi __builtin_ia32_pcmpeqw (__cov_v4hi, __cov_v4hi);
__cov_v4hi __builtin_ia32_pcmpgtw (__cov_v4hi, __cov_v4hi);
__cov_v2si __builtin_ia32_pcmpeqd (__cov_v2si, __cov_v2si);
__cov_v2si __builtin_ia32_pcmpgtd (__cov_v2si, __cov_v2si);
__cov_v2si __builtin_ia32_mmx_zero ();

#if ( __GNUC__ >=4 && __GNUC_MINOR__ >= 4)
long long __builtin_ia32_paddq (__cov_v1di, __cov_v1di);
long long __builtin_ia32_psubq (__cov_v1di, __cov_v1di);
__cov_m64 __builtin_ia32_psrlq (__cov_v1di, __cov_v1di);
__cov_v4hi __builtin_ia32_psllw (__cov_v4hi, __cov_v4hi);
__cov_v2si __builtin_ia32_pslld (__cov_v2si, __cov_v2si);
__cov_m64 __builtin_ia32_psllq (__cov_v1di, __cov_v1di);
__cov_v4hi __builtin_ia32_psraw (__cov_v4hi, __cov_v4hi);
__cov_v2si __builtin_ia32_psrad (__cov_v2si, __cov_v2si);
__cov_m64 __builtin_ia32_psrlw (__cov_v4hi, __cov_v4hi);
__cov_v2si __builtin_ia32_psrld (__cov_v2si, __cov_v2si);
#else
long long __builtin_ia32_paddq (long long, long long);
long long __builtin_ia32_psubq (long long, long long);
long long __builtin_ia32_psrlq (long long, long long);
__cov_v4hi __builtin_ia32_psllw (__cov_v4hi, int);
__cov_v2si __builtin_ia32_pslld (__cov_v2si, int);
long long __builtin_ia32_psllq (long long, long long);
__cov_v4hi __builtin_ia32_psraw (__cov_v4hi, int);
__cov_v2si __builtin_ia32_psrad (__cov_v2si, int);
__cov_v4hi __builtin_ia32_psrlw (__cov_v4hi, int);
__cov_v2si __builtin_ia32_psrld (__cov_v2si, int);
#endif

#if ( __GNUC__ >=4)
// MMX G++ 4.x specific
__cov_m64 __builtin_ia32_vec_init_v2si (int, int);
int __builtin_ia32_vec_ext_v2si (__cov_v2si, int);
__cov_m64 __builtin_ia32_pand (__cov_m64, __cov_m64);
__cov_m64 __builtin_ia32_pandn (__cov_m64, __cov_m64);
__cov_m64 __builtin_ia32_por (__cov_m64, __cov_m64);
__cov_m64 __builtin_ia32_pxor (__cov_m64, __cov_m64);
__cov_m64 __builtin_ia32_vec_init_v4hi (short, short, short, short);
__cov_m64 __builtin_ia32_vec_init_v8qi (char, char, char, char,
										char, char, char, char);
__cov_m64 _mm_set_pi32 (int, int);
__cov_m64 _mm_set_pi16 (short, short, short, short);
__cov_m64 _mm_set_pi8(char, char, char, char,
					  char, char, char, char);

#if (__GNUC_MINOR__ >= 4)
__cov_m64 __builtin_ia32_psllwi (__cov_v4hi, int);
__cov_m64 __builtin_ia32_pslldi (__cov_v2si, int);
__cov_m64 __builtin_ia32_psllqi (__cov_v1di, int);
__cov_m64 __builtin_ia32_psrlwi(__cov_v4hi, int);
__cov_m64 __builtin_ia32_psrldi (__cov_v2si, int);
__cov_m64 __builtin_ia32_psrlqi (__cov_v1di, int);
__cov_m64 __builtin_ia32_psrawi (__cov_v4hi, int);
__cov_m64 __builtin_ia32_psradi (__cov_v2si, int);
#endif

#else  // GNU 3.xx
long long __builtin_ia32_pand (long long, long long);
long long __builtin_ia32_pandn (long long, long long);
long long __builtin_ia32_por (long long, long long);
long long __builtin_ia32_pxor (long long, long long);
#endif  // __GNUC__ >= 4

int __builtin_ia32_comieq (__cov_v4sf, __cov_v4sf);
int __builtin_ia32_comineq (__cov_v4sf, __cov_v4sf);
int __builtin_ia32_comilt (__cov_v4sf, __cov_v4sf);
int __builtin_ia32_comile (__cov_v4sf, __cov_v4sf);
int __builtin_ia32_comigt (__cov_v4sf, __cov_v4sf);
int __builtin_ia32_comige (__cov_v4sf, __cov_v4sf);
int __builtin_ia32_ucomieq (__cov_v4sf, __cov_v4sf);
int __builtin_ia32_ucomineq (__cov_v4sf, __cov_v4sf);
int __builtin_ia32_ucomilt (__cov_v4sf, __cov_v4sf);
int __builtin_ia32_ucomile (__cov_v4sf, __cov_v4sf);
int __builtin_ia32_ucomigt (__cov_v4sf, __cov_v4sf);
int __builtin_ia32_ucomige (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_addps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_subps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_mulps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_divps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_addss (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_subss (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_mulss (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_divss (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpeqps (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpltps (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpleps (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpgtps (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpgeps (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpunordps (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpneqps (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpnltps (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpnleps (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpngtps (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpngeps (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpordps (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpeqss (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpltss (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpless (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpunordss (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpneqss (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpnlts (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpnless (__cov_v4sf, __cov_v4sf);
__cov_v4si __builtin_ia32_cmpordss (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_maxps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_maxss (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_minps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_minss (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_andps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_andnps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_orps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_xorps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_movss (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_movhlps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_movlhps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_unpckhps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_unpcklps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_cvtpi2ps (__cov_v4sf, __cov_v2si);
__cov_v4sf __builtin_ia32_cvtsi2ss (__cov_v4sf, int);
__cov_v2si __builtin_ia32_cvtps2pi (__cov_v4sf);
int __builtin_ia32_cvtss2si (__cov_v4sf);
__cov_v2si __builtin_ia32_cvttps2pi (__cov_v4sf);
int __builtin_ia32_cvttss2si (__cov_v4sf);
#ifdef __x86_64__
long long __builtin_ia32_cvtss2si64(__cov_v4sf);
long long __builtin_ia32_cvttss2si64(__cov_v4sf);
#endif
__cov_v4sf __builtin_ia32_rcpps (__cov_v4sf);
__cov_v4sf __builtin_ia32_rsqrtps (__cov_v4sf);
__cov_v4sf __builtin_ia32_sqrtps (__cov_v4sf);
__cov_v4sf __builtin_ia32_rcpss (__cov_v4sf);
__cov_v4sf __builtin_ia32_rsqrtss (__cov_v4sf);
__cov_v4sf __builtin_ia32_sqrtss (__cov_v4sf);
__cov_v4sf __builtin_ia32_shufps (__cov_v4sf, __cov_v4sf, int);
void __builtin_ia32_movntps (float *, __cov_v4sf);
int __builtin_ia32_movmskps (__cov_v4sf);

// extracted out of warnings in xmmintrin.h
__cov_v4sf __builtin_ia32_loadaps (float const *);
void __builtin_ia32_storeaps (float *, __cov_v4sf);  
__cov_m128 __builtin_ia32_cmpnltss(__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_setzerops ();
unsigned int  __builtin_ia32_stmxcsr ();
void __builtin_ia32_ldmxcsr (unsigned int);
__cov_v4sf __builtin_ia32_loadss (float const *);
__cov_m128 __builtin_ia32_loadups (float const *);
__cov_v4sf __builtin_ia32_loadss (float const *);
void __builtin_ia32_storess (float *, __cov_v4sf);
void __builtin_ia32_storeups (float *, __cov_v4sf);
__cov_m64 __builtin_ia32_pmaxsw (__cov_v4hi, __cov_v4hi);
__cov_m64 __builtin_ia32_pmaxub (__cov_v8qi, __cov_v8qi);
__cov_m64 __builtin_ia32_pminsw (__cov_v4hi, __cov_v4hi);
__cov_m64 __builtin_ia32_pminub (__cov_v8qi, __cov_v8qi);
int __builtin_ia32_pmovmskb (__cov_v8qi);
__cov_m64 __builtin_ia32_pmulhuw (__cov_v4hi, __cov_v4hi);
__cov_v8qi __builtin_ia32_maskmovq (__cov_v8qi, __cov_v8qi, char *);
__cov_m64 __builtin_ia32_pavgb (__cov_v8qi, __cov_v8qi);
__cov_m64 __builtin_ia32_pavgw (__cov_v4hi, __cov_v4hi);
__cov_m64 __builtin_ia32_psadbw (__cov_v8qi, __cov_v8qi);
void __builtin_ia32_movntq (unsigned long long *, unsigned long long);
void __builtin_ia32_sfence ();

#if ( __GNUC__>= 4 )
float __builtin_ia32_vec_ext_v4sf (__cov_v4sf, int);
#endif //   __GNUC__>= 4 

#if ( __GNUC__>=4 && __GNUC_MINOR__ >= 4)
__cov_m128 __builtin_ia32_loadhps(__cov_v4sf, const __cov_v2sf *);
void __builtin_ia32_storehps (__cov_v2sf *, __cov_v4sf);
__cov_m128 __builtin_ia32_loadlps (__cov_v4sf, const __cov_v2sf *);
void __builtin_ia32_storelps (__cov_v2sf *, __cov_v4sf);
#else
__cov_m128 __builtin_ia32_loadhps(__cov_v4sf, __cov_v2si *);
void __builtin_ia32_storehps (__cov_v2si *, __cov_v4sf);
__cov_m128 __builtin_ia32_loadlps (__cov_v4sf, __cov_v2si *);
void __builtin_ia32_storelps (__cov_v2si *, __cov_v4sf);
#endif

int __builtin_ia32_comisdeq (__cov_v2df, __cov_v2df);
int __builtin_ia32_comisdlt (__cov_v2df, __cov_v2df);
int __builtin_ia32_comisdle (__cov_v2df, __cov_v2df);
int __builtin_ia32_comisdgt (__cov_v2df, __cov_v2df);
int __builtin_ia32_comisdge (__cov_v2df, __cov_v2df);
int __builtin_ia32_comisdneq (__cov_v2df, __cov_v2df);
int __builtin_ia32_ucomisdeq (__cov_v2df, __cov_v2df);
int __builtin_ia32_ucomisdlt (__cov_v2df, __cov_v2df);
int __builtin_ia32_ucomisdle (__cov_v2df, __cov_v2df);
int __builtin_ia32_ucomisdgt (__cov_v2df, __cov_v2df);
int __builtin_ia32_ucomisdge (__cov_v2df, __cov_v2df);
int __builtin_ia32_ucomisdneq (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpeqpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpltpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmplepd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpgtpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpgepd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpunordpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpneqpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpnltpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpnlepd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpngtpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpngepd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpordpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpeqsd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpltsd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmplesd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpunordsd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpneqsd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpnltsd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpnlesd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_cmpordsd (__cov_v2df, __cov_v2df);
//  __cov_v2di __builtin_ia32_paddq (__cov_v2di, __cov_v2di); // causes warning in gcc -msse2
//  __cov_v2di __builtin_ia32_psubq (__cov_v2di, __cov_v2di); // causes warning in gcc -mssse3
__cov_v2df __builtin_ia32_addpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_subpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_mulpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_divpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_addsd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_subsd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_mulsd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_divsd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_minpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_maxpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_minsd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_maxsd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_andpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_andnpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_orpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_xorpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_movsd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_unpckhpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_unpcklpd (__cov_v2df, __cov_v2df);
__cov_v16qi __builtin_ia32_paddb128 (__cov_v16qi, __cov_v16qi);
__cov_v8hi __builtin_ia32_paddw128 (__cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_paddd128 (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_paddq128 (__cov_v2di, __cov_v2di);
__cov_v16qi __builtin_ia32_psubb128 (__cov_v16qi, __cov_v16qi);
__cov_v8hi __builtin_ia32_psubw128 (__cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_psubd128 (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_psubq128 (__cov_v2di, __cov_v2di);
__cov_v8hi __builtin_ia32_pmullw128 (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_pmulhw128 (__cov_v8hi, __cov_v8hi);
__cov_v2di __builtin_ia32_pand128 (__cov_v2di, __cov_v2di);
__cov_v2di __builtin_ia32_pandn128 (__cov_v2di, __cov_v2di);
__cov_v2di __builtin_ia32_por128 (__cov_v2di, __cov_v2di);
__cov_v2di __builtin_ia32_pxor128 (__cov_v2di, __cov_v2di);
__cov_v16qi __builtin_ia32_pavgb128 (__cov_v16qi, __cov_v16qi);
__cov_v8hi __builtin_ia32_pavgw128 (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pcmpeqb128 (__cov_v16qi, __cov_v16qi);
__cov_v8hi __builtin_ia32_pcmpeqw128 (__cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_pcmpeqd128 (__cov_v4si, __cov_v4si);
__cov_v16qi __builtin_ia32_pcmpgtb128 (__cov_v16qi, __cov_v16qi);
__cov_v8hi __builtin_ia32_pcmpgtw128 (__cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_pcmpgtd128 (__cov_v4si, __cov_v4si);
__cov_v16qi __builtin_ia32_pmaxub128 (__cov_v16qi, __cov_v16qi);
__cov_v8hi __builtin_ia32_pmaxsw128 (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pminub128 (__cov_v16qi, __cov_v16qi);
__cov_v8hi __builtin_ia32_pminsw128 (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_punpckhbw128 (__cov_v16qi, __cov_v16qi);
__cov_v8hi __builtin_ia32_punpckhwd128 (__cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_punpckhdq128 (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_punpckhqdq128 (__cov_v2di, __cov_v2di);
__cov_v16qi __builtin_ia32_punpcklbw128 (__cov_v16qi, __cov_v16qi);
__cov_v8hi __builtin_ia32_punpcklwd128 (__cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_punpckldq128 (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_punpcklqdq128 (__cov_v2di, __cov_v2di);
__cov_v16qi __builtin_ia32_packsswb128 (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_packssdw128 (__cov_v4si, __cov_v4si);
__cov_v16qi __builtin_ia32_packuswb128 (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_pmulhuw128 (__cov_v8hi, __cov_v8hi);
void __builtin_ia32_maskmovdqu (__cov_v16qi, __cov_v16qi, char * c ); // char * c=0
void __builtin_ia32_storeupd (double *, __cov_v2df);
#if (__GNUC__ < 4)
__cov_v2df __builtin_ia32_loadhpd (__cov_v2df, __cov_v2si *);
__cov_v2df __builtin_ia32_loadlpd (__cov_v2df, __cov_v2si *);
__cov_v2df __builtin_ia32_loadupd (double const *);
#else
__cov_v2df __builtin_ia32_loadhpd (__cov_v2df, double const *);
__cov_v2df __builtin_ia32_loadlpd (__cov_v2df, double const *);
__cov_m128d __builtin_ia32_loadupd (double const *);
#endif
int __builtin_ia32_movmskpd (__cov_v2df);
int __builtin_ia32_pmovmskb128 (__cov_v16qi);
void __builtin_ia32_movnti (int *, int);
void __builtin_ia32_movnti64 (long long int *, long long int);
void __builtin_ia32_movntpd (double *, __cov_v2df);
void __builtin_ia32_movntdq (__cov_v2di *, __cov_v2di); 
__cov_v4si __builtin_ia32_pshufd (__cov_v4si, int);
__cov_v8hi __builtin_ia32_pshuflw (__cov_v8hi, int);
__cov_v8hi __builtin_ia32_pshufhw (__cov_v8hi, int);
__cov_v2di __builtin_ia32_psadbw128 (__cov_v16qi, __cov_v16qi);
__cov_v2df __builtin_ia32_sqrtpd (__cov_v2df);
__cov_v2df __builtin_ia32_sqrtsd (__cov_v2df);
__cov_v2df __builtin_ia32_shufpd (__cov_v2df, __cov_v2df, int);
__cov_v2df __builtin_ia32_cvtdq2pd (__cov_v4si);
__cov_v4sf __builtin_ia32_cvtdq2ps (__cov_v4si);
__cov_v4si __builtin_ia32_cvtpd2dq (__cov_v2df);
__cov_v2si __builtin_ia32_cvtpd2pi (__cov_v2df);
__cov_v4sf __builtin_ia32_cvtpd2ps (__cov_v2df);
__cov_v4si __builtin_ia32_cvttpd2dq (__cov_v2df);
__cov_v2si __builtin_ia32_cvttpd2pi (__cov_v2df);
__cov_v2df __builtin_ia32_cvtpi2pd (__cov_v2si);
int __builtin_ia32_cvtsd2si (__cov_v2df);
int __builtin_ia32_cvttsd2si (__cov_v2df);
long long __builtin_ia32_cvtsd2si64 (__cov_v2df);
long long __builtin_ia32_cvttsd2si64 (__cov_v2df);
__cov_v4si __builtin_ia32_cvtps2dq (__cov_v4sf);
__cov_v2df __builtin_ia32_cvtps2pd (__cov_v4sf);
__cov_v4si __builtin_ia32_cvttps2dq (__cov_v4sf);
__cov_v2df __builtin_ia32_cvtsi2sd (__cov_v2df, int);
__cov_v2df __builtin_ia32_cvtsi642sd (__cov_v2df, long long);
__cov_v4sf __builtin_ia32_cvtsi642ss (__cov_v4sf, long long);
__cov_v4sf __builtin_ia32_cvtsd2ss (__cov_v4sf, __cov_v2df);
__cov_v2df __builtin_ia32_cvtss2sd (__cov_v2df, __cov_v4sf);
void __builtin_ia32_clflush (const void *);
void __builtin_ia32_lfence (void);
void __builtin_ia32_mfence (void);
__cov_v16qi __builtin_ia32_loaddqu (const char *);
void __builtin_ia32_storedqu (char *, __cov_v16qi);
__cov_v1di __builtin_ia32_pmuludq (__cov_v2si, __cov_v2si); // was ret type v1di
__cov_v2di __builtin_ia32_pmuludq128 (__cov_v4si, __cov_v4si);
#if (__GNUC__ < 4)
// The following two intrinsics deviate from the manual in pre4, see BZ 18359
__cov_v8hi __builtin_ia32_psllw128 (__cov_v8hi, __cov_v2di);
__cov_v4si __builtin_ia32_pslld128 (__cov_v4si, __cov_v2di);
#else
__cov_v8hi __builtin_ia32_psllw128 (__cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_pslld128 (__cov_v4si, __cov_v4si);
#endif
__cov_v2di __builtin_ia32_psllq128 (__cov_v2di, __cov_v2di);
#if (__GNUC__ < 4)
// The following two intrinsics deviate from the manual in pre4, see BZ 18359
__cov_v8hi __builtin_ia32_psrlw128 (__cov_v8hi, __cov_v2di);
__cov_v4si __builtin_ia32_psrld128 (__cov_v4si, __cov_v2di);
#else
__cov_v8hi __builtin_ia32_psrlw128 (__cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_psrld128 (__cov_v4si, __cov_v4si);
#endif
__cov_v2di __builtin_ia32_psrlq128 (__cov_v2di, __cov_v2di);
#if (__GNUC__ < 4)
// The following two intrinsics deviate from the manual in pre4, see BZ 18359
__cov_v8hi __builtin_ia32_psraw128 (__cov_v8hi, __cov_v2di);
__cov_v4si __builtin_ia32_psrad128 (__cov_v4si, __cov_v2di);
#else
__cov_v8hi __builtin_ia32_psraw128 (__cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_psrad128 (__cov_v4si, __cov_v4si);
#endif
__cov_v2di __builtin_ia32_pslldqi128 (__cov_v2di, int);
__cov_v8hi __builtin_ia32_psllwi128 (__cov_v8hi, int);
__cov_v4si __builtin_ia32_pslldi128 (__cov_v4si, int);
__cov_v2di __builtin_ia32_psllqi128 (__cov_v2di, int);
__cov_v2di __builtin_ia32_psrldqi128 (__cov_v2di, int);
__cov_v8hi __builtin_ia32_psrlwi128 (__cov_v8hi, int);
__cov_v4si __builtin_ia32_psrldi128 (__cov_v4si, int);
__cov_v2di __builtin_ia32_psrlqi128 (__cov_v2di, int);
__cov_v8hi __builtin_ia32_psrawi128 (__cov_v8hi, int);
__cov_v4si __builtin_ia32_psradi128 (__cov_v4si, int);
__cov_v4si __builtin_ia32_pmaddwd128 (__cov_v8hi, __cov_v8hi);
__cov_v2di __builtin_ia32_movq128 (__cov_v2di);

__cov_v2df  __builtin_ia32_loadsd (double const *);
__cov_v2df  __builtin_ia32_loadapd (double const *);
__cov_v4si  __builtin_ia32_loadd (int *);
__cov_m128i __builtin_ia32_loaddqa (char const *);
/* __cov_m128i __builtin_ia32_loaddqu (char const *); */
#if defined(__APPLE__)
__cov_m128i __builtin_ia32_loadlv4si(__cov_v2si*);
void __builtin_ia32_storelv4si (__cov_v2si *,__cov_m128i);
__cov_m128i __builtin_ia32_movqv4si (__cov_v4si);
#endif
__cov_m128d __builtin_ia32_setzeropd ();
__cov_m128i __builtin_ia32_setzero128 ();

void __builtin_ia32_storesd (double *, __cov_v2df);
void __builtin_ia32_storeapd (double *, __cov_v2df);
void __builtin_ia32_storedqa (char *, __cov_v16qi);
void __builtin_ia32_storedqu (char *, __cov_v16qi);

__cov_v2di __builtin_ia32_movq2dq (unsigned long long);
long long  __builtin_ia32_movdq2q (__cov_v2di); 
/*__cov_m64 __builtin_ia32_movdq2q (__cov_v2di);  */
__cov_m128i __builtin_ia32_movq (__cov_v2di);


void __builtin_ia32_storehpd (__cov_v2si *, __cov_v2df);
void __builtin_ia32_storelpd (__cov_v2si *, __cov_v2df);
void __builtin_ia32_stored (int *, __cov_v4si);
__cov_m128i __builtin_ia32_paddsb128 (__cov_v16qi, __cov_v16qi);
__cov_m128i __builtin_ia32_paddsw128 (__cov_v8hi, __cov_v8hi);
__cov_m128i __builtin_ia32_paddusb128 (__cov_v16qi, __cov_v16qi);
__cov_m128i __builtin_ia32_paddusw128 (__cov_v8hi, __cov_v8hi);
__cov_m128i __builtin_ia32_psubsb128 (__cov_v16qi, __cov_v16qi);
__cov_m128i __builtin_ia32_psubsw128 (__cov_v8hi, __cov_v8hi);
__cov_m128i __builtin_ia32_psubusb128 (__cov_v16qi, __cov_v16qi);
__cov_m128i __builtin_ia32_psubusw128 (__cov_v8hi, __cov_v8hi);

#if (__GNUC__ >=4 )
double __builtin_ia32_vec_ext_v2df (__cov_m128d, int);
int __builtin_ia32_vec_ext_v4si (__cov_v4si, int);
long long __builtin_ia32_vec_ext_v2di (__cov_v2di, int); // ret: __m64 at line emmintrin.h:717
#endif //(__GNUC__ >=4 )


__cov_v2df __builtin_ia32_addsubpd (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_addsubps (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_haddpd (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_haddps (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_hsubpd (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_hsubps (__cov_v4sf, __cov_v4sf);
__cov_v16qi __builtin_ia32_lddqu (char const *);
void __builtin_ia32_monitor (const void *, unsigned int, unsigned int);
__cov_v2df __builtin_ia32_movddup (__cov_v2df);
__cov_v4sf __builtin_ia32_movshdup (__cov_v4sf);
__cov_v4sf __builtin_ia32_movsldup (__cov_v4sf);
void __builtin_ia32_mwait (unsigned int, unsigned int);

__cov_v2df __builtin_ia32_loadddup (double const *);

// MMX regs
__cov_v2si __builtin_ia32_phaddd (__cov_v2si, __cov_v2si);
__cov_v4hi __builtin_ia32_phaddw (__cov_v4hi, __cov_v4hi);
__cov_v4hi __builtin_ia32_phaddsw (__cov_v4hi, __cov_v4hi);
__cov_v2si __builtin_ia32_phsubd (__cov_v2si, __cov_v2si);
__cov_v4hi __builtin_ia32_phsubw (__cov_v4hi, __cov_v4hi);
__cov_v4hi __builtin_ia32_phsubsw (__cov_v4hi, __cov_v4hi);
__cov_v4hi __builtin_ia32_pmaddubsw (__cov_v8qi, __cov_v8qi);
__cov_v4hi __builtin_ia32_pmulhrsw (__cov_v4hi, __cov_v4hi);
__cov_v8qi __builtin_ia32_pshufb (__cov_v8qi, __cov_v8qi);
__cov_v8qi __builtin_ia32_psignb (__cov_v8qi, __cov_v8qi);
__cov_v2si __builtin_ia32_psignd (__cov_v2si, __cov_v2si);
__cov_v4hi __builtin_ia32_psignw (__cov_v4hi, __cov_v4hi);
__cov_v1di __builtin_ia32_palignr (__cov_v1di, __cov_v1di, int);
__cov_v8qi __builtin_ia32_pabsb (__cov_v8qi);
__cov_v2si __builtin_ia32_pabsd (__cov_v2si);
__cov_v4hi __builtin_ia32_pabsw (__cov_v4hi);

// SSE reg
__cov_v4si __builtin_ia32_phaddd128 (__cov_v4si, __cov_v4si);
__cov_v8hi __builtin_ia32_phaddw128 (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_phaddsw128 (__cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_phsubd128 (__cov_v4si, __cov_v4si);
__cov_v8hi __builtin_ia32_phsubw128 (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_phsubsw128 (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_pmaddubsw128 (__cov_v16qi, __cov_v16qi);
__cov_v8hi __builtin_ia32_pmulhrsw128 (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pshufb128 (__cov_v16qi, __cov_v16qi);
__cov_v16qi __builtin_ia32_psignb128 (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_psignd128 (__cov_v4si, __cov_v4si);
__cov_v8hi __builtin_ia32_psignw128 (__cov_v8hi, __cov_v8hi);
__cov_v2di __builtin_ia32_palignr128 (__cov_v2di, __cov_v2di, int);
__cov_v16qi __builtin_ia32_pabsb128 (__cov_v16qi);
__cov_v4si __builtin_ia32_pabsd128 (__cov_v4si);
__cov_v8hi __builtin_ia32_pabsw128 (__cov_v8hi);

__cov_v2si __builtin_ia32_phaddd (__cov_v2si, __cov_v2si);
__cov_v4hi __builtin_ia32_phaddw (__cov_v4hi, __cov_v4hi);
__cov_v4hi __builtin_ia32_phaddsw (__cov_v4hi, __cov_v4hi);
__cov_v2si __builtin_ia32_phsubd (__cov_v2si, __cov_v2si);
__cov_v4hi __builtin_ia32_phsubw (__cov_v4hi, __cov_v4hi);
__cov_v4hi __builtin_ia32_phsubsw (__cov_v4hi, __cov_v4hi);
__cov_v4hi __builtin_ia32_pmaddubsw (__cov_v8qi, __cov_v8qi);
__cov_v4hi __builtin_ia32_pmulhrsw (__cov_v4hi, __cov_v4hi);
__cov_v8qi __builtin_ia32_pshufb (__cov_v8qi, __cov_v8qi);
__cov_v8qi __builtin_ia32_psignb (__cov_v8qi, __cov_v8qi);
__cov_v2si __builtin_ia32_psignd (__cov_v2si, __cov_v2si);
__cov_v4hi __builtin_ia32_psignw (__cov_v4hi, __cov_v4hi);
__cov_v1di __builtin_ia32_palignr (__cov_v1di, __cov_v1di, int);
__cov_v8qi __builtin_ia32_pabsb (__cov_v8qi);
__cov_v2si __builtin_ia32_pabsd (__cov_v2si);
__cov_v4hi __builtin_ia32_pabsw (__cov_v4hi);

__cov_v4si __builtin_ia32_phaddd128 (__cov_v4si, __cov_v4si);
__cov_v8hi __builtin_ia32_phaddw128 (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_phaddsw128 (__cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_phsubd128 (__cov_v4si, __cov_v4si);
__cov_v8hi __builtin_ia32_phsubw128 (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_phsubsw128 (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_pmaddubsw128 (__cov_v16qi, __cov_v16qi);
__cov_v8hi __builtin_ia32_pmulhrsw128 (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pshufb128 (__cov_v16qi, __cov_v16qi);
__cov_v16qi __builtin_ia32_psignb128 (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_psignd128 (__cov_v4si, __cov_v4si);
__cov_v8hi __builtin_ia32_psignw128 (__cov_v8hi, __cov_v8hi);
__cov_v2di __builtin_ia32_palignr128 (__cov_v2di, __cov_v2di, int);
__cov_v16qi __builtin_ia32_pabsb128 (__cov_v16qi);
__cov_v4si __builtin_ia32_pabsd128 (__cov_v4si);
__cov_v8hi __builtin_ia32_pabsw128 (__cov_v8hi);

#if (__GNUC__ >= 4)
__cov_v2df __builtin_ia32_blendpd (__cov_v2df, __cov_v2df, const int);
__cov_v4sf __builtin_ia32_blendps (__cov_v4sf, __cov_v4sf, const int);
__cov_v2df __builtin_ia32_blendvpd (__cov_v2df, __cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_blendvps (__cov_v4sf, __cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_dppd (__cov_v2df, __cov_v2df, const int);
__cov_v4sf __builtin_ia32_dpps (__cov_v4sf, __cov_v4sf, const int);
__cov_v4sf __builtin_ia32_insertps128 (__cov_v4sf, __cov_v4sf, const int);
__cov_v2di __builtin_ia32_movntdqa (__cov_v2di *);
__cov_v16qi __builtin_ia32_mpsadbw128 (__cov_v16qi, __cov_v16qi, const int);
__cov_v8hi __builtin_ia32_packusdw128 (__cov_v4si, __cov_v4si);
__cov_v16qi __builtin_ia32_pblendvb128 (__cov_v16qi, __cov_v16qi, __cov_v16qi);
__cov_v8hi __builtin_ia32_pblendw128 (__cov_v8hi, __cov_v8hi, const int);
__cov_v2di __builtin_ia32_pcmpeqq (__cov_v2di, __cov_v2di);
__cov_v8hi __builtin_ia32_phminposuw128 (__cov_v8hi);
__cov_v16qi __builtin_ia32_pmaxsb128 (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pmaxsd128 (__cov_v4si, __cov_v4si);
__cov_v4si __builtin_ia32_pmaxud128 (__cov_v4si, __cov_v4si);
__cov_v8hi __builtin_ia32_pmaxuw128 (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pminsb128 (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pminsd128 (__cov_v4si, __cov_v4si);
__cov_v4si __builtin_ia32_pminud128 (__cov_v4si, __cov_v4si);
__cov_v8hi __builtin_ia32_pminuw128 (__cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_pmovsxbd128 (__cov_v16qi);
__cov_v2di __builtin_ia32_pmovsxbq128 (__cov_v16qi);
__cov_v8hi __builtin_ia32_pmovsxbw128 (__cov_v16qi);
__cov_v2di __builtin_ia32_pmovsxdq128 (__cov_v4si);
__cov_v4si __builtin_ia32_pmovsxwd128 (__cov_v8hi);
__cov_v2di __builtin_ia32_pmovsxwq128 (__cov_v8hi);
__cov_v4si __builtin_ia32_pmovzxbd128 (__cov_v16qi);
__cov_v2di __builtin_ia32_pmovzxbq128 (__cov_v16qi);
__cov_v8hi __builtin_ia32_pmovzxbw128 (__cov_v16qi);
__cov_v2di __builtin_ia32_pmovzxdq128 (__cov_v4si);
__cov_v4si __builtin_ia32_pmovzxwd128 (__cov_v8hi);
__cov_v2di __builtin_ia32_pmovzxwq128 (__cov_v8hi);
__cov_v2di __builtin_ia32_pmuldq128 (__cov_v4si, __cov_v4si);
__cov_v4si __builtin_ia32_pmulld128 (__cov_v4si, __cov_v4si);


__cov_v4sf __builtin_ia32_vec_set___cov_v4sf (__cov_v4sf, float, const int);
//    Generates the insertps machine instruction.
int __builtin_ia32_vec_ext___cov_v16qi (__cov_v16qi, const int);
//    Generates the pextrb machine instruction.
__cov_v16qi __builtin_ia32_vec_set___cov_v16qi (__cov_v16qi, int, const int);
//    Generates the pinsrb machine instruction.
__cov_v4si __builtin_ia32_vec_set___cov_v4si (__cov_v4si, int, const int);
//    Generates the pinsrd machine instruction.
__cov_v2di __builtin_ia32_vec_set___cov_v2di (__cov_v2di, long long, const int);
//    Generates the pinsrq machine instruction in 64bit mode. 

float __builtin_ia32_vec_ext___cov_v4sf (__cov_v4sf, const int);
//    Generates the extractps machine instruction.
int __builtin_ia32_vec_ext___cov_v4si (__cov_v4si, const int);
//    Generates the pextrd machine instruction.
long long __builtin_ia32_vec_ext___cov_v2di (__cov_v2di, const int);
//    Generates the pextrq machine instruction in 64bit mode. 
#endif // GNU4

#if (__GNUC__ >= 4)
int __builtin_ia32_ptestc128 (__cov_v2di, __cov_v2di);
int __builtin_ia32_ptestnzc128 (__cov_v2di, __cov_v2di);
int __builtin_ia32_ptestz128 (__cov_v2di, __cov_v2di); //common SSE 5
__cov_v2df __builtin_ia32_roundpd (__cov_v2df, const int);
__cov_v4sf __builtin_ia32_roundps (__cov_v4sf, const int);
__cov_v2df __builtin_ia32_roundsd (__cov_v2df, __cov_v2df, const int);
__cov_v4sf __builtin_ia32_roundss (__cov_v4sf, __cov_v4sf, const int);
#endif


#if (__GNUC__ >= 4)
__cov_v16qi __builtin_ia32_pcmpestrm128 (__cov_v16qi, int, __cov_v16qi, int, const int);
int __builtin_ia32_pcmpestri128 (__cov_v16qi, int, __cov_v16qi, int, const int);
int __builtin_ia32_pcmpestria128 (__cov_v16qi, int, __cov_v16qi, int, const int);
int __builtin_ia32_pcmpestric128 (__cov_v16qi, int, __cov_v16qi, int, const int);
int __builtin_ia32_pcmpestrio128 (__cov_v16qi, int, __cov_v16qi, int, const int);
int __builtin_ia32_pcmpestris128 (__cov_v16qi, int, __cov_v16qi, int, const int);
int __builtin_ia32_pcmpestriz128 (__cov_v16qi, int, __cov_v16qi, int, const int);
__cov_v16qi __builtin_ia32_pcmpistrm128 (__cov_v16qi, __cov_v16qi, const int);
int __builtin_ia32_pcmpistri128 (__cov_v16qi, __cov_v16qi, const int);
int __builtin_ia32_pcmpistria128 (__cov_v16qi, __cov_v16qi, const int);
int __builtin_ia32_pcmpistric128 (__cov_v16qi, __cov_v16qi, const int);
int __builtin_ia32_pcmpistrio128 (__cov_v16qi, __cov_v16qi, const int);
int __builtin_ia32_pcmpistris128 (__cov_v16qi, __cov_v16qi, const int);
int __builtin_ia32_pcmpistriz128 (__cov_v16qi, __cov_v16qi, const int);
__cov_v2di __builtin_ia32_pcmpgtq (__cov_v2di, __cov_v2di);
unsigned int __builtin_ia32_crc32qi (unsigned int, unsigned char);
unsigned int __builtin_ia32_crc32hi (unsigned int, unsigned short);
unsigned int __builtin_ia32_crc32si (unsigned int, unsigned int);
unsigned long long __builtin_ia32_crc32di (unsigned long long, unsigned long long);

int __builtin_popcount (unsigned int);
int __builtin_popcountl (unsigned long);
int __builtin_popcountll (unsigned long long);

#endif

#if (__GNUC__ >= 4)
void __builtin_ia32_movntsd (double *, __cov_v2df);
void __builtin_ia32_movntss (float *, __cov_v4sf);
__cov_v2di __builtin_ia32_extrq  (__cov_v2di, __cov_v16qi);
__cov_v2di __builtin_ia32_extrqi (__cov_v2di, const unsigned int, const unsigned int);
__cov_v2di __builtin_ia32_insertq (__cov_v2di, __cov_v2di);
__cov_v2di __builtin_ia32_insertqi (__cov_v2di, __cov_v2di, const unsigned int, const unsigned int);
#endif

#if (__GNUC__ >= 4)
/* Internal data types for implementing the intrinsics.  */
typedef double __cov_v4df __attribute__ ((__vector_size__ (32)));
typedef float __cov_v8sf __attribute__ ((__vector_size__ (32)));
typedef long long __cov_v4di __attribute__ ((__vector_size__ (32)));
typedef int __cov_v8si __attribute__ ((__vector_size__ (32)));
typedef short __cov_v16hi __attribute__ ((__vector_size__ (32)));
typedef char __cov_v32qi __attribute__ ((__vector_size__ (32)));

/* The Intel API is flexible enough that we must allow aliasing with other
vector types, and their scalar components.  */
/*
typedef float __cov_m256 __attribute__ ((__vector_size__ (32),
__may_alias__));
typedef long long __cov_m256i __attribute__ ((__vector_size__ (32),
__may_alias__));
typedef double __cov_m256d __attribute__ ((__vector_size__ (32),
__may_alias__));
*/

__cov_v2df __builtin_ia32_comeqpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comeqps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comeqsd (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comeqss (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comfalsepd (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comfalsesd (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comfalsess (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comgepd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comgeps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comgesd (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comgess (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comgtpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comgtps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comgtsd (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comgtss (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comlepd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comleps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comless (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comltpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comltps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comltsd (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comltss (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comnepd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comneps (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comnesd (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comness (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comordpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comordps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comordss (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comtruepd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comtrueps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comtruesd (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comtruess (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comueqpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comueqps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comueqss (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comugepd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comugeps (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comugesd (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comugess (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comugtpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comugtps (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comugtsd (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comugtss (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comulepd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comuleps (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comulesd (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comuless (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comultpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comultps (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comultsd (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comultss (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comunepd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comuneps (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comunesd (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comuness (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_comunordpd (__cov_v2df, __cov_v2df);
__cov_v2df __builtin_ia32_comunordps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comunordsd (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comunordss (__cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_fmaddpd (__cov_v2df, __cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_fmaddps (__cov_v4sf, __cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_fmaddsd (__cov_v2df, __cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_fmaddss (__cov_v4sf, __cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_fmsubpd (__cov_v2df, __cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_fmsubps (__cov_v4sf, __cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_fmsubsd (__cov_v2df, __cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_fmsubss (__cov_v4sf, __cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_fnmaddpd (__cov_v2df, __cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_fnmaddps (__cov_v4sf, __cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_fnmaddsd (__cov_v2df, __cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_fnmaddss (__cov_v4sf, __cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_fnmsubpd (__cov_v2df, __cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_fnmsubps (__cov_v4sf, __cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_fnmsubsd (__cov_v2df, __cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_fnmsubss (__cov_v4sf, __cov_v4sf, __cov_v4sf);
__cov_v2df __builtin_ia32_frczpd (__cov_v2df);
__cov_v4sf __builtin_ia32_frczps (__cov_v4sf);
__cov_v2df __builtin_ia32_frczsd (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_frczss (__cov_v4sf, __cov_v4sf);
__cov_v2di __builtin_ia32_pcmov (__cov_v2di, __cov_v2di, __cov_v2di);
__cov_v2di __builtin_ia32_pcmov___cov_v2di (__cov_v2di, __cov_v2di, __cov_v2di);
__cov_v4si __builtin_ia32_pcmov___cov_v4si (__cov_v4si, __cov_v4si, __cov_v4si);
__cov_v8hi __builtin_ia32_pcmov___cov_v8hi (__cov_v8hi, __cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pcmov___cov_v16qi (__cov_v16qi, __cov_v16qi, __cov_v16qi);
__cov_v2df __builtin_ia32_pcmov___cov_v2df (__cov_v2df, __cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_pcmov___cov_v4sf (__cov_v4sf, __cov_v4sf, __cov_v4sf);
__cov_v16qi __builtin_ia32_pcomeqb (__cov_v16qi, __cov_v16qi);
__cov_v8hi __builtin_ia32_pcomeqw (__cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_pcomeqd (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomeqq (__cov_v2di, __cov_v2di);
__cov_v16qi __builtin_ia32_pcomequb (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomequd (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomequq (__cov_v2di, __cov_v2di);
__cov_v8hi __builtin_ia32_pcomequw (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_pcomeqw (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pcomfalseb (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomfalsed (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomfalseq (__cov_v2di, __cov_v2di);
__cov_v16qi __builtin_ia32_pcomfalseub (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomfalseud (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomfalseuq (__cov_v2di, __cov_v2di);
__cov_v8hi __builtin_ia32_pcomfalseuw (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_pcomfalsew (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pcomgeb (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomged (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomgeq (__cov_v2di, __cov_v2di);
__cov_v16qi __builtin_ia32_pcomgeub (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomgeud (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomgeuq (__cov_v2di, __cov_v2di);
__cov_v8hi __builtin_ia32_pcomgeuw (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_pcomgew (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pcomgtb (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomgtd (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomgtq (__cov_v2di, __cov_v2di);
__cov_v16qi __builtin_ia32_pcomgtub (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomgtud (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomgtuq (__cov_v2di, __cov_v2di);
__cov_v8hi __builtin_ia32_pcomgtuw (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_pcomgtw (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pcomleb (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomled (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomleq (__cov_v2di, __cov_v2di);
__cov_v16qi __builtin_ia32_pcomleub (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomleud (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomleuq (__cov_v2di, __cov_v2di);
__cov_v8hi __builtin_ia32_pcomleuw (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_pcomlew (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pcomltb (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomltd (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomltq (__cov_v2di, __cov_v2di);
__cov_v16qi __builtin_ia32_pcomltub (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomltud (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomltuq (__cov_v2di, __cov_v2di);
__cov_v8hi __builtin_ia32_pcomltuw (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_pcomltw (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pcomneb (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomned (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomneq (__cov_v2di, __cov_v2di);
__cov_v16qi __builtin_ia32_pcomneub (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomneud (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomneuq (__cov_v2di, __cov_v2di);
__cov_v8hi __builtin_ia32_pcomneuw (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_pcomnew (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pcomtrueb (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomtrued (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomtrueq (__cov_v2di, __cov_v2di);
__cov_v16qi __builtin_ia32_pcomtrueub (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pcomtrueud (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pcomtrueuq (__cov_v2di, __cov_v2di);
__cov_v8hi __builtin_ia32_pcomtrueuw (__cov_v8hi, __cov_v8hi);
__cov_v8hi __builtin_ia32_pcomtruew (__cov_v8hi, __cov_v8hi);
__cov_m128d __builtin_ia32_permpd (__cov_v2df, __cov_v2df, __cov_v16qi);
__cov_v4sf __builtin_ia32_permps (__cov_v4sf, __cov_v4sf, __cov_v16qi);
__cov_v4si __builtin_ia32_phaddbd (__cov_v16qi);
__cov_v2di __builtin_ia32_phaddbq (__cov_v16qi);
__cov_v8hi __builtin_ia32_phaddbw (__cov_v16qi);
__cov_v2di __builtin_ia32_phadddq (__cov_v4si);
__cov_v4si __builtin_ia32_phaddubd (__cov_v16qi);
__cov_v2di __builtin_ia32_phaddubq (__cov_v16qi);
__cov_v8hi __builtin_ia32_phaddubw (__cov_v16qi);
__cov_v2di __builtin_ia32_phaddudq (__cov_v4si);
__cov_v4si __builtin_ia32_phadduwd (__cov_v8hi);
__cov_v2di __builtin_ia32_phadduwq (__cov_v8hi);
__cov_v4si __builtin_ia32_phaddwd (__cov_v8hi);
__cov_v2di __builtin_ia32_phaddwq (__cov_v8hi);
__cov_v8hi __builtin_ia32_phsubbw (__cov_v16qi);
__cov_v2di __builtin_ia32_phsubdq (__cov_v4si);
__cov_v4si __builtin_ia32_phsubwd (__cov_v8hi);
__cov_v4si __builtin_ia32_pmacsdd (__cov_v4si, __cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pmacsdqh (__cov_v4si, __cov_v4si, __cov_v2di);
__cov_v2di __builtin_ia32_pmacsdql (__cov_v4si, __cov_v4si, __cov_v2di);
__cov_v4si __builtin_ia32_pmacssdd (__cov_v4si, __cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pmacssdqh (__cov_v4si, __cov_v4si, __cov_v2di);
__cov_v2di __builtin_ia32_pmacssdql (__cov_v4si, __cov_v4si, __cov_v2di);
__cov_v4si __builtin_ia32_pmacsswd (__cov_v8hi, __cov_v8hi, __cov_v4si);
__cov_v8hi __builtin_ia32_pmacssww (__cov_v8hi, __cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_pmacswd (__cov_v8hi, __cov_v8hi, __cov_v4si);
__cov_v8hi __builtin_ia32_pmacsww (__cov_v8hi, __cov_v8hi, __cov_v8hi);
__cov_v4si __builtin_ia32_pmadcsswd (__cov_v8hi, __cov_v8hi, __cov_v4si);
__cov_v4si __builtin_ia32_pmadcswd (__cov_v8hi, __cov_v8hi, __cov_v4si);
__cov_v16qi __builtin_ia32_pperm (__cov_v16qi, __cov_v16qi, __cov_v16qi);
__cov_v16qi __builtin_ia32_protb (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_protd (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_protq (__cov_v2di, __cov_v2di);
__cov_v8hi __builtin_ia32_protw (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pshab (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pshad (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pshaq (__cov_v2di, __cov_v2di);
__cov_v8hi __builtin_ia32_pshaw (__cov_v8hi, __cov_v8hi);
__cov_v16qi __builtin_ia32_pshlb (__cov_v16qi, __cov_v16qi);
__cov_v4si __builtin_ia32_pshld (__cov_v4si, __cov_v4si);
__cov_v2di __builtin_ia32_pshlq (__cov_v2di, __cov_v2di);
__cov_v8hi __builtin_ia32_pshlw (__cov_v8hi, __cov_v8hi);

__cov_v16qi __builtin_ia32_protb_int (__cov_v16qi, int);
__cov_v4si __builtin_ia32_protd_int (__cov_v4si, int);
__cov_v2di __builtin_ia32_protq_int (__cov_v2di, int);
__cov_v8hi __builtin_ia32_protw_int (__cov_v8hi, int);

// These have different possibilities for parameters, take a guess based on
//   OS or allow all if C++
#if defined(__unix) || defined(__cplusplus)
__cov_v2df __builtin_ia32_comfalseps (__cov_v2df, __cov_v2df);
__cov_v4sf __builtin_ia32_comlesd (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comordsd (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comueqsd (__cov_v4sf, __cov_v4sf);
#endif

#if !defined(__unix) || defined(__cplusplus)
__cov_m128 __builtin_ia32_comfalseps (__cov_v4sf, __cov_v4sf);
__cov_v4sf __builtin_ia32_comlesd (__cov_v2df, __cov_v2df);
__cov_m128d __builtin_ia32_comordsd (__cov_v2df, __cov_v2df);
__cov_m128d __builtin_ia32_comueqsd (__cov_v2df, __cov_v2df);
#endif

// from headers
__cov_m128 __builtin_ia32_comunltps (__cov_v4sf, __cov_v4sf);
__cov_m128 __builtin_ia32_comuneqps (__cov_v4sf, __cov_v4sf);
__cov_m128  __builtin_ia32_comunleps (__cov_v4sf, __cov_v4sf);
__cov_m128 __builtin_ia32_comungeps (__cov_v4sf, __cov_v4sf);
__cov_m128 __builtin_ia32_comungtps (__cov_v4sf, __cov_v4sf);
__cov_m128 __builtin_ia32_comneqps (__cov_v4sf, __cov_v4sf);
__cov_m128d __builtin_ia32_comuneqpd (__cov_v2df, __cov_v2df);
__cov_m128d __builtin_ia32_comunltpd (__cov_v2df, __cov_v2df);
__cov_m128d __builtin_ia32_comunlepd (__cov_v2df, __cov_v2df);
__cov_m128d __builtin_ia32_comungepd (__cov_v2df, __cov_v2df);
__cov_m128d __builtin_ia32_comungtpd (__cov_v2df, __cov_v2df);
__cov_m128d __builtin_ia32_comneqpd (__cov_v2df, __cov_v2df);
__cov_m128 __builtin_ia32_comuneqss (__cov_v4sf, __cov_v4sf);
__cov_m128 __builtin_ia32_comunltss (__cov_v4sf, __cov_v4sf);
__cov_m128 __builtin_ia32_comunless (__cov_v4sf, __cov_v4sf);
__cov_m128 __builtin_ia32_comungess (__cov_v4sf, __cov_v4sf);
__cov_m128 __builtin_ia32_comungtss (__cov_v4sf, __cov_v4sf);
__cov_m128 __builtin_ia32_comneqss (__cov_v4sf, __cov_v4sf);
__cov_m128d __builtin_ia32_comuneqsd (__cov_v2df, __cov_v2df);
__cov_m128d __builtin_ia32_comunltsd (__cov_v2df, __cov_v2df);
__cov_m128d __builtin_ia32_comunlesd (__cov_v2df, __cov_v2df);
__cov_m128d __builtin_ia32_comungesd (__cov_v2df, __cov_v2df);
__cov_m128d __builtin_ia32_comungtsd (__cov_v2df, __cov_v2df);
__cov_m128d __builtin_ia32_comneqsd (__cov_v2df, __cov_v2df);
__cov_m128i __builtin_ia32_pcomnequb (__cov_v16qi, __cov_v16qi);
__cov_m128i __builtin_ia32_pcomnequw (__cov_v8hi, __cov_v8hi);
__cov_m128i __builtin_ia32_pcomnequd (__cov_v4si, __cov_v4si);
__cov_m128i __builtin_ia32_pcomnequq (__cov_v2di, __cov_v2di);
__cov_m128i __builtin_ia32_pcomneqb (__cov_v16qi, __cov_v16qi);
__cov_m128i __builtin_ia32_pcomneqw (__cov_v8hi, __cov_v8hi);
__cov_m128i __builtin_ia32_pcomneqd (__cov_v4si, __cov_v4si);
__cov_m128i __builtin_ia32_pcomneqq (__cov_v2di, __cov_v2di);


void __builtin_ia32_femms(void);
__cov_m64 __builtin_ia32_pavgusb (__cov_v8qi, __cov_v8qi);
__cov_m64 __builtin_ia32_pf2id (__cov_v2sf);
__cov_m64 __builtin_ia32_pfacc (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pfadd (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pfcmpeq (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pfcmpge (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pfcmpgt (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pfmax (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pfmin (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pfmul (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pfrcp (__cov_v2sf );
__cov_m64 __builtin_ia32_pfrcpit1 (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pfrcpit2 (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pfrsqrt (__cov_v2sf);
__cov_m64 __builtin_ia32_pfrsqit1 (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pfsub (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pfsubr (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pi2fd (__cov_v2si);
__cov_m64 __builtin_ia32_pmulhrw (__cov_v4hi, __cov_v4hi);

__cov_m64 __builtin_ia32_pf2iw (__cov_v2sf);
__cov_m64 __builtin_ia32_pfnacc (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pfpnacc (__cov_v2sf, __cov_v2sf);
__cov_m64 __builtin_ia32_pi2fw (__cov_v2si);
__cov_m64 __builtin_ia32_pswapdsf (__cov_v2sf);

#endif
#endif


#ifdef __COVERITY_ALTIVEC__
/* Declarations of AltiVec PPU built-in intrinsic functions. */
/* Many of these are overloaded, so they can't be declared in C.  For those
 * that have operator equivalents those equivalents are used in C instead,
 * otherwise a generic version with no parameter types is declared.
 */

typedef vector int __coverity_generic_altivec_vector;

#ifdef __cplusplus
extern vector signed char __builtin_vec_abs (vector signed char a1);
extern vector signed short __builtin_vec_abs (vector signed short a1);
extern vector signed int __builtin_vec_abs (vector signed int a1);
extern vector float __builtin_vec_abs (vector float a1);

extern vector signed char __builtin_vec_abss (vector signed char a1);
extern vector signed short __builtin_vec_abss (vector signed short a1);
#else
__coverity_generic_altivec_vector  __builtin_vec_abs();
__coverity_generic_altivec_vector  __builtin_vec_abss();
#endif

#ifdef __cplusplus
    extern vector unsigned int __builtin_vec_vslw (vector unsigned int a1, vector unsigned int a2);
#else
__coverity_generic_altivec_vector  __builtin_vec_vslw ();
#endif

#ifdef __cplusplus
extern int __builtin_vec_vcmpgt_p(int, vector signed char a1, vector signed char a2);
extern int __builtin_vec_vcmpgt_p(int, vector unsigned char a1, vector unsigned char a2);
extern int __builtin_vec_vcmpgt_p(int, vector signed short a1, vector signed short a2);
extern int __builtin_vec_vcmpgt_p(int, vector unsigned short a1, vector unsigned short a2);
extern int __builtin_vec_vcmpgt_p(int, vector signed int a1, vector signed int a2);
extern int __builtin_vec_vcmpgt_p(int, vector unsigned int a1, vector unsigned int a2);
extern int __builtin_vec_vcmpgt_p(int, vector signed char a1, vector signed char a2);
extern int __builtin_vec_vcmpgt_p(int, vector float a1, vector float a2);
#else
int __builtin_vec_vcmpgt_p();
#endif

#ifdef __cplusplus
extern vector signed char __builtin_vec_add (vector signed char a1, vector signed char a2);
extern vector unsigned char __builtin_vec_add (vector signed char a1, vector unsigned char a2);

extern vector unsigned char __builtin_vec_add (vector unsigned char a1, vector signed char a2);

extern vector unsigned char __builtin_vec_add (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed short __builtin_vec_add (vector signed short a1, vector signed short a2);
extern vector unsigned short __builtin_vec_add (vector signed short a1,
                               vector unsigned short a2);
extern vector unsigned short __builtin_vec_add (vector unsigned short a1,
                               vector signed short a2);
extern vector unsigned short __builtin_vec_add (vector unsigned short a1,
                               vector unsigned short a2);
extern vector signed int __builtin_vec_add (vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_add (vector signed int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_add (vector unsigned int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_add (vector unsigned int a1, vector unsigned int a2);
extern vector float __builtin_vec_add (vector float a1, vector float a2);
#else
# define __builtin_vec_add(a, b) ((a) + (b))
#endif

extern vector unsigned int __builtin_vec_addc (vector unsigned int a1, vector unsigned int a2);

#ifdef __cplusplus
extern vector unsigned char __builtin_vec_adds (vector signed char a1,
                               vector unsigned char a2);
extern vector unsigned char __builtin_vec_adds (vector unsigned char a1,
                               vector signed char a2);
extern vector unsigned char __builtin_vec_adds (vector unsigned char a1,
                               vector unsigned char a2);
extern vector signed char __builtin_vec_adds (vector signed char a1, vector signed char a2);
extern vector unsigned short __builtin_vec_adds (vector signed short a1,
                                vector unsigned short a2);
extern vector unsigned short __builtin_vec_adds (vector unsigned short a1,
                                vector signed short a2);
extern vector unsigned short __builtin_vec_adds (vector unsigned short a1,
                                vector unsigned short a2);
extern vector signed short __builtin_vec_adds (vector signed short a1, vector signed short a2);

extern vector unsigned int __builtin_vec_adds (vector signed int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_adds (vector unsigned int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_adds (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_adds (vector signed int a1, vector signed int a2);
#else
__coverity_generic_altivec_vector  __builtin_vec_adds ();
#endif

#ifdef __cplusplus
extern vector float __builtin_vec_and (vector float a1, vector float a2);
extern vector float __builtin_vec_and (vector float a1, vector signed int a2);
extern vector float __builtin_vec_and (vector signed int a1, vector float a2);
extern vector signed int __builtin_vec_and (vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_and (vector signed int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_and (vector unsigned int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_and (vector unsigned int a1, vector unsigned int a2);
extern vector signed short __builtin_vec_and (vector signed short a1, vector signed short a2);
extern vector unsigned short __builtin_vec_and (vector signed short a1,
                               vector unsigned short a2);
extern vector unsigned short __builtin_vec_and (vector unsigned short a1,
                               vector signed short a2);
extern vector unsigned short __builtin_vec_and (vector unsigned short a1,
                               vector unsigned short a2);
extern  vector signed char __builtin_vec_and (vector signed char a1, vector signed char a2);
extern vector unsigned char __builtin_vec_and (vector signed char a1, vector unsigned char a2);

extern vector unsigned char __builtin_vec_and (vector unsigned char a1, vector signed char a2);

extern vector unsigned char __builtin_vec_and (vector unsigned char a1,
                              vector unsigned char a2);
#else
# define__builtin_vec_and(a, b) ((a) & (b))
#endif

#ifdef __cplusplus
extern vector float __builtin_vec_andc (vector float a1, vector float a2);
extern vector float __builtin_vec_andc (vector float a1, vector signed int a2);
extern vector float __builtin_vec_andc (vector signed int a1, vector float a2);
extern vector signed int __builtin_vec_andc (vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_andc (vector signed int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_andc (vector unsigned int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_andc (vector unsigned int a1, vector unsigned int a2);

extern vector signed short __builtin_vec_andc (vector signed short a1, vector signed short a2);

extern vector unsigned short __builtin_vec_andc (vector signed short a1,
                                vector unsigned short a2);
extern vector unsigned short __builtin_vec_andc (vector unsigned short a1,
                                vector signed short a2);
extern vector unsigned short __builtin_vec_andc (vector unsigned short a1,
                                vector unsigned short a2);
extern vector signed char __builtin_vec_andc (vector signed char a1, vector signed char a2);
extern vector unsigned char __builtin_vec_andc (vector signed char a1,
                               vector unsigned char a2);
extern vector unsigned char __builtin_vec_andc (vector unsigned char a1,
                               vector signed char a2);
extern vector unsigned char __builtin_vec_andc (vector unsigned char a1,
                               vector unsigned char a2);
#else
__coverity_generic_altivec_vector  __builtin_vec_andc ();
#endif

#ifdef __cplusplus
extern vector unsigned char __builtin_vec_avg (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed char __builtin_vec_avg (vector signed char a1, vector signed char a2);
extern vector unsigned short __builtin_vec_avg (vector unsigned short a1,
                               vector unsigned short a2);
extern vector signed short __builtin_vec_avg (vector signed short a1, vector signed short a2);
extern vector unsigned int __builtin_vec_avg (vector unsigned int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_avg (vector signed int a1, vector signed int a2);
#else
__coverity_generic_altivec_vector  __builtin_vec_avg ();
#endif

extern vector float __builtin_vec_ceil (vector float a1);

extern vector signed int __builtin_vec_cmpb (vector float a1, vector float a2);

#ifdef __cplusplus
extern vector signed char __builtin_vec_cmpeq (vector signed char a1, vector signed char a2);
extern vector signed char __builtin_vec_cmpeq (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed short __builtin_vec_cmpeq (vector signed short a1,
                               vector signed short a2);
extern vector signed short __builtin_vec_cmpeq (vector unsigned short a1,
                               vector unsigned short a2);
extern vector signed int __builtin_vec_cmpeq (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_cmpeq (vector unsigned int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_cmpeq (vector float a1, vector float a2);

extern vector signed int __builtin_vec_cmpge (vector float a1, vector float a2);

extern vector signed char __builtin_vec_cmpgt (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed char __builtin_vec_cmpgt (vector signed char a1, vector signed char a2);
extern vector signed short __builtin_vec_cmpgt (vector unsigned short a1,
                               vector unsigned short a2);
extern vector signed short __builtin_vec_cmpgt (vector signed short a1,
                               vector signed short a2);
extern vector signed int __builtin_vec_cmpgt (vector unsigned int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_cmpgt (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_cmpgt (vector float a1, vector float a2);

extern vector signed int __builtin_vec_cmple (vector float a1, vector float a2);

extern vector signed char __builtin_vec_cmplt (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed char __builtin_vec_cmplt (vector signed char a1, vector signed char a2);
extern vector signed short __builtin_vec_cmplt (vector unsigned short a1,
                               vector unsigned short a2);
extern vector signed short __builtin_vec_cmplt (vector signed short a1,
                               vector signed short a2);
extern vector signed int __builtin_vec_cmplt (vector unsigned int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_cmplt (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_cmplt (vector float a1, vector float a2);
#else
__coverity_generic_altivec_vector  __builtin_vec_cmpeq ();
__coverity_generic_altivec_vector  __builtin_vec_cmpge ();
__coverity_generic_altivec_vector  __builtin_vec_cmpgt ();
__coverity_generic_altivec_vector  __builtin_vec_cmple ();
__coverity_generic_altivec_vector  __builtin_vec_cmplt ();
#endif

#ifdef __cplusplus
extern vector float __builtin_vec_ctf (vector unsigned int a1, const char a2);
extern vector float __builtin_vec_ctf (vector signed int a1, const char a2);
#else
extern vector float __builtin_vec_ctf ();
#endif

extern vector signed int __builtin_vec_cts (vector float a1, const char a2);

extern vector unsigned int __builtin_vec_ctu (vector float a1, const char a2);

extern void __builtin_vec_dss (const char a1);

extern void __builtin_vec_dssall (void);

extern void __builtin_vec_dst (const void * a1, int a2, const char a3);

extern void __builtin_vec_dstst (const void * a1, int a2, const char a3);

extern void __builtin_vec_dststt (const void * a1, int a2, const char a3);

extern void __builtin_vec_dstt (const void * a1, int a2, const char a3);

#ifdef __cplusplus
extern vector float __builtin_vec_expte (vector float a1, vector float a2);
extern vector float __builtin_vec_expte (vector float a1);

extern vector float __builtin_vec_floor (vector float a1, vector float a2);
extern vector float __builtin_vec_floor (vector float a1);
#else
__coverity_generic_altivec_vector __builtin_vec_expte();
__coverity_generic_altivec_vector __builtin_vec_floor();
#endif

#ifdef __cplusplus
extern vector float __builtin_vec_ld (int a1, vector float * a2);
extern vector float __builtin_vec_ld (int a1, float * a2);
extern vector signed int __builtin_vec_ld (int a1, int * a2);
extern vector signed int __builtin_vec_ld (int a1, vector signed int * a2);
extern vector unsigned int __builtin_vec_ld (int a1, vector unsigned int * a2);
extern vector unsigned int __builtin_vec_ld (int a1, unsigned int * a2);
extern vector signed short __builtin_vec_ld (int a1, short * a2, vector signed short * a3);
extern vector unsigned short __builtin_vec_ld (int a1, unsigned short * a2,
                              vector unsigned short * a3);
extern vector signed char __builtin_vec_ld (int a1, signed char * a2);
extern vector signed char __builtin_vec_ld (int a1, vector signed char * a2);
extern vector unsigned char __builtin_vec_ld (int a1, unsigned char * a2);
extern vector unsigned char __builtin_vec_ld (int a1, vector unsigned char * a2);

extern vector signed char __builtin_vec_lde (int a1, signed char * a2);
extern vector unsigned char __builtin_vec_lde (int a1, unsigned char * a2);
extern vector signed short __builtin_vec_lde (int a1, short * a2);
extern vector unsigned short __builtin_vec_lde (int a1, unsigned short * a2);
extern vector float __builtin_vec_lde (int a1, float * a2);
extern vector signed int __builtin_vec_lde (int a1, int * a2);
extern vector unsigned int __builtin_vec_lde (int a1, unsigned int * a2);

extern vector float __builtin_vec_ldl (int a1, float * a2);
extern vector float __builtin_vec_ldl (int a1, vector float * a2);
extern vector signed int __builtin_vec_ldl (int a1, vector signed int * a2);
extern vector signed int __builtin_vec_ldl (int a1, int * a2);
extern vector unsigned int __builtin_vec_ldl (int a1, unsigned int * a2);
extern vector unsigned int __builtin_vec_ldl (int a1, vector unsigned int * a2);
extern vector signed short __builtin_vec_ldl (int a1, vector signed short * a2);
extern vector signed short __builtin_vec_ldl (int a1, short * a2);
extern vector unsigned short __builtin_vec_ldl (int a1, vector unsigned short * a2);
extern vector unsigned short __builtin_vec_ldl (int a1, unsigned short * a2);
extern vector signed char __builtin_vec_ldl (int a1, vector signed char * a2);
extern vector signed char __builtin_vec_ldl (int a1, signed char * a2);
extern vector unsigned char __builtin_vec_ldl (int a1, vector unsigned char * a2);
extern vector unsigned char __builtin_vec_ldl (int a1, unsigned char * a2);
#else
__coverity_generic_altivec_vector  __builtin_vec_ld ();
__coverity_generic_altivec_vector  __builtin_vec_lde ();
__coverity_generic_altivec_vector  __builtin_vec_ldl ();
#endif

extern vector float __builtin_vec_loge (vector float a1);

extern vector unsigned char __builtin_vec_lvsl (int a1, const void * a2, int * a3);

extern vector unsigned char __builtin_vec_lvsr (int a1, const void * a2, int * a3);

extern vector float __builtin_vec_madd (vector float a1, vector float a2, vector float a3);

extern vector signed short __builtin_vec_madds (vector signed short a1, vector signed short a2,
                               vector signed short a3);

#ifdef __cplusplus
extern vector unsigned char __builtin_vec_max (vector signed char a1, vector unsigned char a2);

extern vector unsigned char __builtin_vec_max (vector unsigned char a1, vector signed char a2);

extern vector unsigned char __builtin_vec_max (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed char __builtin_vec_max (vector signed char a1, vector signed char a2);
extern vector unsigned short __builtin_vec_max (vector signed short a1,
                               vector unsigned short a2);
extern vector unsigned short __builtin_vec_max (vector unsigned short a1,
                               vector signed short a2);
extern vector unsigned short __builtin_vec_max (vector unsigned short a1,
                               vector unsigned short a2);
extern vector signed short __builtin_vec_max (vector signed short a1, vector signed short a2);
extern vector unsigned int __builtin_vec_max (vector signed int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_max (vector unsigned int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_max (vector unsigned int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_max (vector signed int a1, vector signed int a2);
extern vector float __builtin_vec_max (vector float a1, vector float a2);

extern vector signed char __builtin_vec_mergeh (vector signed char a1, vector signed char a2);
extern vector unsigned char __builtin_vec_mergeh (vector unsigned char a1,
                                 vector unsigned char a2);
extern vector signed short __builtin_vec_mergeh (vector signed short a1,
                                vector signed short a2);
extern vector unsigned short __builtin_vec_mergeh (vector unsigned short a1,
                                  vector unsigned short a2);
extern vector float __builtin_vec_mergeh (vector float a1, vector float a2);
extern vector signed int __builtin_vec_mergeh (vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_mergeh (vector unsigned int a1,
                                vector unsigned int a2);

extern vector signed char __builtin_vec_mergel (vector signed char a1, vector signed char a2);
extern vector unsigned char __builtin_vec_mergel (vector unsigned char a1,
                                 vector unsigned char a2);
extern vector signed short __builtin_vec_mergel (vector signed short a1,
                                vector signed short a2);
extern vector unsigned short __builtin_vec_mergel (vector unsigned short a1,
                                  vector unsigned short a2);
extern vector float __builtin_vec_mergel (vector float a1, vector float a2);
extern vector signed int __builtin_vec_mergel (vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_mergel (vector unsigned int a1,
                                vector unsigned int a2);
#else
__coverity_generic_altivec_vector  __builtin_vec_max ();
__coverity_generic_altivec_vector  __builtin_vec_mergeh ();
__coverity_generic_altivec_vector  __builtin_vec_mergel ();
#endif

extern vector unsigned short __builtin_vec_mfvscr (void);

#ifdef __cplusplus
extern vector unsigned char __builtin_vec_min (vector signed char a1, vector unsigned char a2);

extern vector unsigned char __builtin_vec_min (vector unsigned char a1, vector signed char a2);

extern vector unsigned char __builtin_vec_min (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed char __builtin_vec_min (vector signed char a1, vector signed char a2);
extern vector unsigned short __builtin_vec_min (vector signed short a1,
                               vector unsigned short a2);
extern vector unsigned short __builtin_vec_min (vector unsigned short a1,
                               vector signed short a2);
extern vector unsigned short __builtin_vec_min (vector unsigned short a1,
                               vector unsigned short a2);
extern vector signed short __builtin_vec_min (vector signed short a1, vector signed short a2);
extern vector unsigned int __builtin_vec_min (vector signed int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_min (vector unsigned int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_min (vector unsigned int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_min (vector signed int a1, vector signed int a2);
extern vector float __builtin_vec_min (vector float a1, vector float a2);

extern vector signed short __builtin_vec_mladd (vector signed short a1, vector signed short a2,
                               vector signed short a3);
extern vector signed short __builtin_vec_mladd (vector signed short a1,
                               vector unsigned short a2,
                               vector unsigned short a3);
extern vector signed short __builtin_vec_mladd (vector unsigned short a1,
                               vector signed short a2,
                               vector signed short a3);
extern vector unsigned short __builtin_vec_mladd (vector unsigned short a1,
                                 vector unsigned short a2,
                                 vector unsigned short a3);
#else
__coverity_generic_altivec_vector __builtin_vec_min ();
__coverity_generic_altivec_vector __builtin_vec_mladd ();
#endif

extern vector signed short __builtin_vec_mradds (vector signed short a1,
                                vector signed short a2,
                                vector signed short a3);

#ifdef __cplusplus
extern vector unsigned int __builtin_vec_msum (vector unsigned char a1,
                              vector unsigned char a2,
                              vector unsigned int a3);
extern vector signed int __builtin_vec_msum (vector signed char a1, vector unsigned char a2,
                            vector signed int a3);
extern vector unsigned int __builtin_vec_msum (vector unsigned short a1,
                              vector unsigned short a2,
                              vector unsigned int a3);
extern vector signed int __builtin_vec_msum (vector signed short a1, vector signed short a2,
                            vector signed int a3);

extern vector unsigned int __builtin_vec_msums (vector unsigned short a1,
                               vector unsigned short a2,
                               vector unsigned int a3);
extern vector signed int __builtin_vec_msums (vector signed short a1, vector signed short a2,
                             vector signed int a3);

extern void __builtin_vec_mtvscr (vector signed int a1);
extern void __builtin_vec_mtvscr (vector unsigned int a1);
extern void __builtin_vec_mtvscr (vector signed short a1);
extern void __builtin_vec_mtvscr (vector unsigned short a1);
extern void __builtin_vec_mtvscr (vector signed char a1);
extern void __builtin_vec_mtvscr (vector unsigned char a1);

extern vector unsigned short __builtin_vec_mule (vector unsigned char a1,
                                vector unsigned char a2);
extern vector signed short __builtin_vec_mule (vector signed char a1, vector signed char a2);
extern vector unsigned int __builtin_vec_mule (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_mule (vector signed short a1, vector signed short a2);

extern vector unsigned short __builtin_vec_mulo (vector unsigned char a1,
                                vector unsigned char a2);
extern vector signed short __builtin_vec_mulo (vector signed char a1, vector signed char a2);
extern vector unsigned int __builtin_vec_mulo (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_mulo (vector signed short a1, vector signed short a2);
#else
__coverity_generic_altivec_vector __builtin_vec_msum ();
__coverity_generic_altivec_vector __builtin_vec_msums ();
extern void __builtin_vec_mtvscr ();
__coverity_generic_altivec_vector __builtin_vec_mule ();
__coverity_generic_altivec_vector __builtin_vec_mulo ();
#endif

extern vector float __builtin_vec_nmsub (vector float a1, vector float a2, vector float a3);

#ifdef __cplusplus
extern vector float __builtin_vec_nor (vector float a1, vector float a2);
extern vector signed int __builtin_vec_nor (vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_nor (vector unsigned int a1, vector unsigned int a2);
extern vector signed short __builtin_vec_nor (vector signed short a1, vector signed short a2);
extern vector unsigned short __builtin_vec_nor (vector unsigned short a1,
                               vector unsigned short a2);
extern vector signed char __builtin_vec_nor (vector signed char a1, vector signed char a2);
extern vector unsigned char __builtin_vec_nor (vector unsigned char a1,
                              vector unsigned char a2);

extern vector float __builtin_vec_or (vector float a1, vector float a2);
extern vector float __builtin_vec_or (vector float a1, vector signed int a2);
extern vector float __builtin_vec_or (vector signed int a1, vector float a2);
extern vector signed int __builtin_vec_or (vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_or (vector signed int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_or (vector unsigned int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_or (vector unsigned int a1, vector unsigned int a2);
extern vector signed short __builtin_vec_or (vector signed short a1, vector signed short a2);
extern vector unsigned short __builtin_vec_or (vector signed short a1,
                              vector unsigned short a2);
extern vector unsigned short __builtin_vec_or (vector unsigned short a1,
                              vector signed short a2);
extern vector unsigned short __builtin_vec_or (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed char __builtin_vec_or (vector signed char a1, vector signed char a2);
extern vector unsigned char __builtin_vec_or (vector signed char a1, vector unsigned char a2);
extern vector unsigned char __builtin_vec_or (vector unsigned char a1, vector signed char a2);
extern vector unsigned char __builtin_vec_or (vector unsigned char a1,
                             vector unsigned char a2);

extern vector signed char __builtin_vec_pack (vector signed short a1, vector signed short a2);
extern vector unsigned char __builtin_vec_pack (vector unsigned short a1,
                               vector unsigned short a2);
extern vector signed short __builtin_vec_pack (vector signed int a1, vector signed int a2);
extern vector unsigned short __builtin_vec_pack (vector unsigned int a1,
                                vector unsigned int a2);
#else
# define __builtin_vec_nor(a, b) (~((a) | (b)))
# define __builtin_vec_or(a, b) ((a) | (b))
__coverity_generic_altivec_vector __builtin_vec_pack ();
#endif

extern vector signed short __builtin_vec_packpx (vector unsigned int a1,
                                vector unsigned int a2);

#ifdef __cplusplus
extern vector unsigned char __builtin_vec_packs (vector unsigned short a1,
                                vector unsigned short a2);
extern vector signed char __builtin_vec_packs (vector signed short a1, vector signed short a2);

extern vector unsigned short __builtin_vec_packs (vector unsigned int a1,
                                 vector unsigned int a2);
extern vector signed short __builtin_vec_packs (vector signed int a1, vector signed int a2);

extern vector unsigned char __builtin_vec_packsu (vector unsigned short a1,
                                 vector unsigned short a2);
extern vector unsigned char __builtin_vec_packsu (vector signed short a1,
                                 vector signed short a2);
extern vector unsigned short __builtin_vec_packsu (vector unsigned int a1,
                                  vector unsigned int a2);
extern vector unsigned short __builtin_vec_packsu (vector signed int a1, vector signed int a2);

extern vector float __builtin_vec_perm (vector float a1, vector float a2,
                       vector unsigned char a3);
extern vector signed int __builtin_vec_perm (vector signed int a1, vector signed int a2,
                            vector unsigned char a3);
extern vector unsigned int __builtin_vec_perm (vector unsigned int a1, vector unsigned int a2,
                              vector unsigned char a3);
extern vector signed short __builtin_vec_perm (vector signed short a1, vector signed short a2,
                              vector unsigned char a3);
extern vector unsigned short __builtin_vec_perm (vector unsigned short a1,
                                vector unsigned short a2,
                                vector unsigned char a3);
extern vector signed char __builtin_vec_perm (vector signed char a1, vector signed char a2,
                             vector unsigned char a3);
extern vector unsigned char __builtin_vec_perm (vector unsigned char a1,
                               vector unsigned char a2,
                               vector unsigned char a3);
#else
__coverity_generic_altivec_vector __builtin_vec_packs ();
__coverity_generic_altivec_vector __builtin_vec_packsu ();
__coverity_generic_altivec_vector __builtin_vec_perm ();
#endif

extern vector float __builtin_vec_re (vector float a1);

#ifdef __cplusplus
extern vector signed char __builtin_vec_rl (vector signed char a1, vector unsigned char a2);
extern vector unsigned char __builtin_vec_rl (vector unsigned char a1,
                             vector unsigned char a2);
extern vector signed short __builtin_vec_rl (vector signed short a1, vector unsigned short a2);

extern vector unsigned short __builtin_vec_rl (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_rl (vector signed int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_rl (vector unsigned int a1, vector unsigned int a2);
#else
__coverity_generic_altivec_vector __builtin_vec_rl ();
#endif

extern vector float __builtin_vec_round (vector float a1);

extern vector float __builtin_vec_rsqrte (vector float a1);

#ifdef __cplusplus
extern vector float __builtin_vec_sel (vector float a1, vector float a2, vector signed int a3);
extern vector float __builtin_vec_sel (vector float a1, vector float a2, vector unsigned int a3);
extern vector signed int __builtin_vec_sel (vector signed int a1, vector signed int a2,
                           vector signed int a3);
extern vector signed int __builtin_vec_sel (vector signed int a1, vector signed int a2,
                           vector unsigned int a3);
extern vector unsigned int __builtin_vec_sel (vector unsigned int a1, vector unsigned int a2,
                             vector signed int a3);
extern vector unsigned int __builtin_vec_sel (vector unsigned int a1, vector unsigned int a2,
                             vector unsigned int a3);
extern vector signed short __builtin_vec_sel (vector signed short a1, vector signed short a2,
                             vector signed short a3);
extern vector signed short __builtin_vec_sel (vector signed short a1, vector signed short a2,
                             vector unsigned short a3);
extern vector unsigned short __builtin_vec_sel (vector unsigned short a1,
                               vector unsigned short a2,
                               vector signed short a3);
extern vector unsigned short __builtin_vec_sel (vector unsigned short a1,
                               vector unsigned short a2,
                               vector unsigned short a3);
extern vector signed char __builtin_vec_sel (vector signed char a1, vector signed char a2,
                            vector signed char a3);
extern vector signed char __builtin_vec_sel (vector signed char a1, vector signed char a2,
                            vector unsigned char a3);
extern vector unsigned char __builtin_vec_sel (vector unsigned char a1,
                              vector unsigned char a2,
                              vector signed char a3);
extern vector unsigned char __builtin_vec_sel (vector unsigned char a1,
                              vector unsigned char a2,
                              vector unsigned char a3);

extern vector signed char __builtin_vec_sl (vector signed char a1, vector unsigned char a2);
extern vector unsigned char __builtin_vec_sl (vector unsigned char a1,
                             vector unsigned char a2);
extern vector signed short __builtin_vec_sl (vector signed short a1, vector unsigned short a2);

extern vector unsigned short __builtin_vec_sl (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_sl (vector signed int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_sl (vector unsigned int a1, vector unsigned int a2);

extern vector float __builtin_vec_sld (vector float a1, vector float a2, const char a3);
extern vector signed int __builtin_vec_sld (vector signed int a1, vector signed int a2,
                           const char a3);
extern vector unsigned int __builtin_vec_sld (vector unsigned int a1, vector unsigned int a2,
                             const char a3);
extern vector signed short __builtin_vec_sld (vector signed short a1, vector signed short a2,
                             const char a3);
extern vector unsigned short __builtin_vec_sld (vector unsigned short a1,
                               vector unsigned short a2, const char a3);
extern vector signed char __builtin_vec_sld (vector signed char a1, vector signed char a2,
                            const char a3);
extern vector unsigned char __builtin_vec_sld (vector unsigned char a1,
                              vector unsigned char a2,
                              const char a3);

extern vector signed int __builtin_vec_sll (vector signed int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_sll (vector signed int a1, vector unsigned short a2);
extern vector signed int __builtin_vec_sll (vector signed int a1, vector unsigned char a2);
extern vector unsigned int __builtin_vec_sll (vector unsigned int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_sll (vector unsigned int a1,
                             vector unsigned short a2);
extern vector unsigned int __builtin_vec_sll (vector unsigned int a1, vector unsigned char a2);

extern vector signed short __builtin_vec_sll (vector signed short a1, vector unsigned int a2);
extern vector signed short __builtin_vec_sll (vector signed short a1,
                             vector unsigned short a2);
extern vector signed short __builtin_vec_sll (vector signed short a1, vector unsigned char a2);

extern vector unsigned short __builtin_vec_sll (vector unsigned short a1,
                               vector unsigned int a2);
extern vector unsigned short __builtin_vec_sll (vector unsigned short a1,
                               vector unsigned short a2);
extern vector unsigned short __builtin_vec_sll (vector unsigned short a1,
                               vector unsigned char a2);
extern vector signed char __builtin_vec_sll (vector signed char a1, vector unsigned int a2);
extern vector signed char __builtin_vec_sll (vector signed char a1, vector unsigned short a2);
extern vector signed char __builtin_vec_sll (vector signed char a1, vector unsigned char a2);
extern vector unsigned char __builtin_vec_sll (vector unsigned char a1,
                              vector unsigned int a2);
extern vector unsigned char __builtin_vec_sll (vector unsigned char a1,
                              vector unsigned short a2);
extern vector unsigned char __builtin_vec_sll (vector unsigned char a1,
                              vector unsigned char a2);

extern vector float __builtin_vec_slo (vector float a1, vector signed char a2);
extern vector float __builtin_vec_slo (vector float a1, vector unsigned char a2);
extern vector signed int __builtin_vec_slo (vector signed int a1, vector signed char a2);
extern vector signed int __builtin_vec_slo (vector signed int a1, vector unsigned char a2);
extern vector unsigned int __builtin_vec_slo (vector unsigned int a1, vector signed char a2);
extern vector unsigned int __builtin_vec_slo (vector unsigned int a1, vector unsigned char a2);

extern vector signed short __builtin_vec_slo (vector signed short a1, vector signed char a2);
extern vector signed short __builtin_vec_slo (vector signed short a1, vector unsigned char a2);

extern vector unsigned short __builtin_vec_slo (vector unsigned short a1,
                               vector signed char a2);
extern vector unsigned short __builtin_vec_slo (vector unsigned short a1,
                               vector unsigned char a2);
extern vector signed char __builtin_vec_slo (vector signed char a1, vector signed char a2);
extern vector signed char __builtin_vec_slo (vector signed char a1, vector unsigned char a2);
extern vector unsigned char __builtin_vec_slo (vector unsigned char a1, vector signed char a2);

extern vector unsigned char __builtin_vec_slo (vector unsigned char a1,
                              vector unsigned char a2);

extern vector signed char __builtin_vec_splat (vector signed char a1, const char a2);
extern vector unsigned char __builtin_vec_splat (vector unsigned char a1, const char a2);
extern vector signed short __builtin_vec_splat (vector signed short a1, const char a2);
extern vector unsigned short __builtin_vec_splat (vector unsigned short a1, const char a2);
extern vector float __builtin_vec_splat (vector float a1, const char a2);
extern vector signed int __builtin_vec_splat (vector signed int a1, const char a2);
extern vector unsigned int __builtin_vec_splat (vector unsigned int a1, const char a2);
#else
# define __builtin_vec_sl(a, b) ((a) << (b))
__coverity_generic_altivec_vector __builtin_vec_sel ();
__coverity_generic_altivec_vector __builtin_vec_sel ();
__coverity_generic_altivec_vector __builtin_vec_sld ();
__coverity_generic_altivec_vector __builtin_vec_sll ();
__coverity_generic_altivec_vector __builtin_vec_slo ();
#endif

extern vector signed char __builtin_vec_splat_s8 (const char a1);

extern vector signed short __builtin_vec_splat_s16 (const char a1);

extern vector signed int __builtin_vec_splat_s32 (const char a1);

extern vector unsigned char __builtin_vec_splat_u8 (const char a1);

extern vector unsigned short __builtin_vec_splat_u16 (const char a1);

extern vector unsigned int __builtin_vec_splat_u32 (const char a1);

#ifdef __cplusplus
extern vector signed char __builtin_vec_sr (vector signed char a1, vector unsigned char a2);
extern vector unsigned char __builtin_vec_sr (vector unsigned char a1,
                             vector unsigned char a2);
extern vector signed short __builtin_vec_sr (vector signed short a1, vector unsigned short a2);

extern vector unsigned short __builtin_vec_sr (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_sr (vector signed int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_sr (vector unsigned int a1, vector unsigned int a2);

extern vector signed char __builtin_vec_sra (vector signed char a1, vector unsigned char a2);
extern vector unsigned char __builtin_vec_sra (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed short __builtin_vec_sra (vector signed short a1,
                             vector unsigned short a2);
extern vector unsigned short __builtin_vec_sra (vector unsigned short a1,
                               vector unsigned short a2);
extern vector signed int __builtin_vec_sra (vector signed int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_sra (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_srl (vector signed int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_srl (vector signed int a1, vector unsigned short a2);
extern vector signed int __builtin_vec_srl (vector signed int a1, vector unsigned char a2);
extern vector unsigned int __builtin_vec_srl (vector unsigned int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_srl (vector unsigned int a1,
                             vector unsigned short a2);
extern vector unsigned int __builtin_vec_srl (vector unsigned int a1, vector unsigned char a2);

extern vector signed short __builtin_vec_srl (vector signed short a1, vector unsigned int a2);
extern vector signed short __builtin_vec_srl (vector signed short a1,
                             vector unsigned short a2);
extern vector signed short __builtin_vec_srl (vector signed short a1, vector unsigned char a2);

extern vector unsigned short __builtin_vec_srl (vector unsigned short a1,
                               vector unsigned int a2);
extern vector unsigned short __builtin_vec_srl (vector unsigned short a1,
                               vector unsigned short a2);
extern vector unsigned short __builtin_vec_srl (vector unsigned short a1,
                               vector unsigned char a2);
extern vector signed char __builtin_vec_srl (vector signed char a1, vector unsigned int a2);
extern vector signed char __builtin_vec_srl (vector signed char a1, vector unsigned short a2);
extern vector signed char __builtin_vec_srl (vector signed char a1, vector unsigned char a2);
extern vector unsigned char __builtin_vec_srl (vector unsigned char a1,
                              vector unsigned int a2);
extern vector unsigned char __builtin_vec_srl (vector unsigned char a1,
                              vector unsigned short a2);
extern vector unsigned char __builtin_vec_srl (vector unsigned char a1,
                              vector unsigned char a2);

extern vector float __builtin_vec_sro (vector float a1, vector signed char a2);
extern vector float __builtin_vec_sro (vector float a1, vector unsigned char a2);
extern vector signed int __builtin_vec_sro (vector signed int a1, vector signed char a2);
extern vector signed int __builtin_vec_sro (vector signed int a1, vector unsigned char a2);
extern vector unsigned int __builtin_vec_sro (vector unsigned int a1, vector signed char a2);
extern vector unsigned int __builtin_vec_sro (vector unsigned int a1, vector unsigned char a2);

extern vector signed short __builtin_vec_sro (vector signed short a1, vector signed char a2);
extern vector signed short __builtin_vec_sro (vector signed short a1, vector unsigned char a2);

extern vector unsigned short __builtin_vec_sro (vector unsigned short a1,
                               vector signed char a2);
extern vector unsigned short __builtin_vec_sro (vector unsigned short a1,
                               vector unsigned char a2);
extern vector signed char __builtin_vec_sro (vector signed char a1, vector signed char a2);
extern vector signed char __builtin_vec_sro (vector signed char a1, vector unsigned char a2);
extern vector unsigned char __builtin_vec_sro (vector unsigned char a1, vector signed char a2);

extern vector unsigned char __builtin_vec_sro (vector unsigned char a1,
                              vector unsigned char a2);

extern void __builtin_vec_st (vector float a1, int a2, const void * a3);
extern void __builtin_vec_st (vector signed int a1, int a2, const void * a3);
extern void __builtin_vec_st (vector unsigned int a1, int a2, const void * a3);
extern void __builtin_vec_st (vector signed short a1, int a2, const void * a3);
extern void __builtin_vec_st (vector unsigned short a1, int a2, const void * a3);
extern void __builtin_vec_st (vector signed char a1, int a2, const void * a3);
extern void __builtin_vec_st (vector unsigned char a1, int a2, const void * a3);

extern void __builtin_vec_ste (vector signed char a1, int a2, const void * a3);
extern void __builtin_vec_ste (vector unsigned char a1, int a2, unsigned char * a3);
extern void __builtin_vec_ste (vector signed short a1, int a2, const void * a3);
extern void __builtin_vec_ste (vector unsigned short a1, int a2, const void * a3);
extern void __builtin_vec_ste (vector signed int a1, int a2, const void * a3);
extern void __builtin_vec_ste (vector unsigned int a1, int a2, unsigned int * a3);
extern void __builtin_vec_ste (vector float a1, int a2, float * a3);

extern void __builtin_vec_stl (vector float a1, int a2, const void * a3);
extern void __builtin_vec_stl (vector signed int a1, int a2, const void * a3);
extern void __builtin_vec_stl (vector unsigned int a1, int a2, const void * a3);
extern void __builtin_vec_stl (vector signed short a1, int a2, const void * a3);
extern void __builtin_vec_stl (vector unsigned short a1, int a2, const void * a3);
extern void __builtin_vec_stl (vector signed char a1, int a2, const void * a3);
extern void __builtin_vec_stl (vector unsigned char a1, int a2, const void * a3);

extern vector signed char __builtin_vec_sub (vector signed char a1, vector signed char a2);
extern vector unsigned char __builtin_vec_sub (vector signed char a1, vector unsigned char a2);

extern vector unsigned char __builtin_vec_sub (vector unsigned char a1, vector signed char a2);

extern vector unsigned char __builtin_vec_sub (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed short __builtin_vec_sub (vector signed short a1, vector signed short a2);
extern vector unsigned short __builtin_vec_sub (vector signed short a1,
                               vector unsigned short a2);
extern vector unsigned short __builtin_vec_sub (vector unsigned short a1,
                               vector signed short a2);
extern vector unsigned short __builtin_vec_sub (vector unsigned short a1,
                               vector unsigned short a2);
extern vector signed int __builtin_vec_sub (vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_sub (vector signed int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_sub (vector unsigned int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_sub (vector unsigned int a1, vector unsigned int a2);
extern vector float __builtin_vec_sub (vector float a1, vector float a2);

extern vector unsigned int __builtin_vec_subc (vector unsigned int a1, vector unsigned int a2);

extern vector unsigned char __builtin_vec_subs (vector signed char a1,
                               vector unsigned char a2);
extern vector unsigned char __builtin_vec_subs (vector unsigned char a1,
                               vector signed char a2);
extern vector unsigned char __builtin_vec_subs (vector unsigned char a1,
                               vector unsigned char a2);
extern vector signed char __builtin_vec_subs (vector signed char a1, vector signed char a2);
extern vector unsigned short __builtin_vec_subs (vector signed short a1,
                                vector unsigned short a2);
extern vector unsigned short __builtin_vec_subs (vector unsigned short a1,
                                vector signed short a2);
extern vector unsigned short __builtin_vec_subs (vector unsigned short a1,
                                vector unsigned short a2);
extern vector signed short __builtin_vec_subs (vector signed short a1, vector signed short a2);

extern vector unsigned int __builtin_vec_subs (vector signed int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_subs (vector unsigned int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_subs (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_subs (vector signed int a1, vector signed int a2);

extern vector unsigned int __builtin_vec_sum4s (vector unsigned char a1,
                               vector unsigned int a2);
extern vector signed int __builtin_vec_sum4s (vector signed char a1, vector signed int a2);
extern vector signed int __builtin_vec_sum4s (vector signed short a1, vector signed int a2);
#else
# define __builtin_vec_sr(a, b) ((a) >> (b))
# define __builtin_vec_sub(a, b) ((a) - (b))
__coverity_generic_altivec_vector __builtin_vec_sra ();
__coverity_generic_altivec_vector __builtin_vec_srl ();
__coverity_generic_altivec_vector __builtin_vec_sro ();
extern void __builtin_vec_st ();
extern void __builtin_vec_ste ();
extern void __builtin_vec_stl ();
__coverity_generic_altivec_vector __builtin_vec_subc ();
__coverity_generic_altivec_vector __builtin_vec_subs ();
__coverity_generic_altivec_vector __builtin_vec_sum4s ();
#endif

extern vector signed int __builtin_vec_sum2s (vector signed int a1, vector signed int a2);

extern vector signed int __builtin_vec_sums (vector signed int a1, vector signed int a2);

extern vector float __builtin_vec_trunc (vector float a1);

#ifdef __cplusplus
extern vector signed short __builtin_vec_unpackh (vector signed char a1);
extern vector unsigned int __builtin_vec_unpackh (vector unsigned short a1);
extern vector signed int __builtin_vec_unpackh (vector signed short a1);

extern vector signed short __builtin_vec_unpackl (vector signed char a1);
extern vector unsigned int __builtin_vec_unpackl (vector unsigned short a1);
extern vector signed int __builtin_vec_unpackl (vector signed short a1);

extern vector float __builtin_vec_xor (vector float a1, vector float a2);
extern vector float __builtin_vec_xor (vector float a1, vector signed int a2);
extern vector float __builtin_vec_xor (vector signed int a1, vector float a2);
extern vector signed int __builtin_vec_xor (vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_xor (vector signed int a1, vector unsigned int a2);
extern vector unsigned int __builtin_vec_xor (vector unsigned int a1, vector signed int a2);
extern vector unsigned int __builtin_vec_xor (vector unsigned int a1, vector unsigned int a2);
extern vector signed short __builtin_vec_xor (vector signed short a1, vector signed short a2);
extern vector unsigned short __builtin_vec_xor (vector signed short a1,
                               vector unsigned short a2);
extern vector unsigned short __builtin_vec_xor (vector unsigned short a1,
                               vector signed short a2);
extern vector unsigned short __builtin_vec_xor (vector unsigned short a1,
                               vector unsigned short a2);
extern vector signed char __builtin_vec_xor (vector signed char a1, vector signed char a2);
extern vector unsigned char __builtin_vec_xor (vector signed char a1, vector unsigned char a2);

extern vector unsigned char __builtin_vec_xor (vector unsigned char a1, vector signed char a2);

extern vector unsigned char __builtin_vec_xor (vector unsigned char a1,
                              vector unsigned char a2);

extern vector signed int __builtin_vec_all_eq (vector signed char a1, vector unsigned char a2);

extern vector signed int __builtin_vec_all_eq (vector signed char a1, vector signed char a2);
extern vector signed int __builtin_vec_all_eq (vector unsigned char a1, vector signed char a2);

extern vector signed int __builtin_vec_all_eq (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed int __builtin_vec_all_eq (vector signed short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_all_eq (vector signed short a1, vector signed short a2);

extern vector signed int __builtin_vec_all_eq (vector unsigned short a1,
                              vector signed short a2);
extern vector signed int __builtin_vec_all_eq (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_all_eq (vector signed int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_all_eq (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_all_eq (vector unsigned int a1, vector signed int a2);
extern vector signed int __builtin_vec_all_eq (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_all_eq (vector float a1, vector float a2);

extern vector signed int __builtin_vec_all_ge (vector signed char a1, vector unsigned char a2);

extern vector signed int __builtin_vec_all_ge (vector unsigned char a1, vector signed char a2);

extern vector signed int __builtin_vec_all_ge (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed int __builtin_vec_all_ge (vector signed char a1, vector signed char a2);
extern vector signed int __builtin_vec_all_ge (vector signed short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_all_ge (vector unsigned short a1,
                              vector signed short a2);
extern vector signed int __builtin_vec_all_ge (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_all_ge (vector signed short a1, vector signed short a2);

extern vector signed int __builtin_vec_all_ge (vector signed int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_all_ge (vector unsigned int a1, vector signed int a2);
extern vector signed int __builtin_vec_all_ge (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_all_ge (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_all_ge (vector float a1, vector float a2);

extern vector signed int __builtin_vec_all_gt (vector signed char a1, vector unsigned char a2);

extern vector signed int __builtin_vec_all_gt (vector unsigned char a1, vector signed char a2);

extern vector signed int __builtin_vec_all_gt (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed int __builtin_vec_all_gt (vector signed char a1, vector signed char a2);
extern vector signed int __builtin_vec_all_gt (vector signed short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_all_gt (vector unsigned short a1,
                              vector signed short a2);
extern vector signed int __builtin_vec_all_gt (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_all_gt (vector signed short a1, vector signed short a2);

extern vector signed int __builtin_vec_all_gt (vector signed int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_all_gt (vector unsigned int a1, vector signed int a2);
extern vector signed int __builtin_vec_all_gt (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_all_gt (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_all_gt (vector float a1, vector float a2);

extern vector signed int __builtin_vec_all_in (vector float a1, vector float a2);

extern vector signed int __builtin_vec_all_le (vector signed char a1, vector unsigned char a2);

extern vector signed int __builtin_vec_all_le (vector unsigned char a1, vector signed char a2);

extern vector signed int __builtin_vec_all_le (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed int __builtin_vec_all_le (vector signed char a1, vector signed char a2);
extern vector signed int __builtin_vec_all_le (vector signed short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_all_le (vector unsigned short a1,
                              vector signed short a2);
extern vector signed int __builtin_vec_all_le (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_all_le (vector signed short a1, vector signed short a2);

extern vector signed int __builtin_vec_all_le (vector signed int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_all_le (vector unsigned int a1, vector signed int a2);
extern vector signed int __builtin_vec_all_le (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_all_le (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_all_le (vector float a1, vector float a2);

extern vector signed int __builtin_vec_all_lt (vector signed char a1, vector unsigned char a2);

extern vector signed int __builtin_vec_all_lt (vector unsigned char a1, vector signed char a2);

extern vector signed int __builtin_vec_all_lt (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed int __builtin_vec_all_lt (vector signed char a1, vector signed char a2);
extern vector signed int __builtin_vec_all_lt (vector signed short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_all_lt (vector unsigned short a1,
                              vector signed short a2);
extern vector signed int __builtin_vec_all_lt (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_all_lt (vector signed short a1, vector signed short a2);

extern vector signed int __builtin_vec_all_lt (vector signed int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_all_lt (vector unsigned int a1, vector signed int a2);
extern vector signed int __builtin_vec_all_lt (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_all_lt (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_all_lt (vector float a1, vector float a2);
#else
__coverity_generic_altivec_vector __builtin_vec_unpackh ();
__coverity_generic_altivec_vector __builtin_vec_unpackl ();
#define __builtin_vec_xor(a1, a2) ((a1) ^ (a2))
__coverity_generic_altivec_vector __builtin_vec_all_eq ();
__coverity_generic_altivec_vector __builtin_vec_all_ge ();
__coverity_generic_altivec_vector __builtin_vec_all_gt ();
__coverity_generic_altivec_vector __builtin_vec_all_le ();
__coverity_generic_altivec_vector __builtin_vec_all_lt ();
#endif

extern vector signed int __builtin_vec_all_nan (vector float a1);

#ifdef __cplusplus
extern vector signed int __builtin_vec_all_ne (vector signed char a1, vector unsigned char a2);

extern vector signed int __builtin_vec_all_ne (vector signed char a1, vector signed char a2);
extern vector signed int __builtin_vec_all_ne (vector unsigned char a1, vector signed char a2);

extern vector signed int __builtin_vec_all_ne (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed int __builtin_vec_all_ne (vector signed short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_all_ne (vector signed short a1, vector signed short a2);

extern vector signed int __builtin_vec_all_ne (vector unsigned short a1,
                              vector signed short a2);
extern vector signed int __builtin_vec_all_ne (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_all_ne (vector signed int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_all_ne (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_all_ne (vector unsigned int a1, vector signed int a2);
extern vector signed int __builtin_vec_all_ne (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_all_ne (vector float a1, vector float a2);

#else
__coverity_generic_altivec_vector __builtin_vec_all_ne ();
#endif

extern vector signed int __builtin_vec_all_nge (vector float a1, vector float a2);

extern vector signed int __builtin_vec_all_ngt (vector float a1, vector float a2);

extern vector signed int __builtin_vec_all_nle (vector float a1, vector float a2);

extern vector signed int __builtin_vec_all_nlt (vector float a1, vector float a2);

extern vector signed int __builtin_vec_all_numeric (vector float a1);

#ifdef __cplusplus
extern vector signed int __builtin_vec_any_eq (vector signed char a1, vector unsigned char a2);

extern vector signed int __builtin_vec_any_eq (vector signed char a1, vector signed char a2);
extern vector signed int __builtin_vec_any_eq (vector unsigned char a1, vector signed char a2);

extern vector signed int __builtin_vec_any_eq (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed int __builtin_vec_any_eq (vector signed short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_any_eq (vector signed short a1, vector signed short a2);

extern vector signed int __builtin_vec_any_eq (vector unsigned short a1,
                              vector signed short a2);
extern vector signed int __builtin_vec_any_eq (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_any_eq (vector signed int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_any_eq (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_any_eq (vector unsigned int a1, vector signed int a2);
extern vector signed int __builtin_vec_any_eq (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_any_eq (vector float a1, vector float a2);

extern vector signed int __builtin_vec_any_ge (vector signed char a1, vector unsigned char a2);

extern vector signed int __builtin_vec_any_ge (vector unsigned char a1, vector signed char a2);

extern vector signed int __builtin_vec_any_ge (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed int __builtin_vec_any_ge (vector signed char a1, vector signed char a2);
extern vector signed int __builtin_vec_any_ge (vector signed short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_any_ge (vector unsigned short a1,
                              vector signed short a2);
extern vector signed int __builtin_vec_any_ge (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_any_ge (vector signed short a1, vector signed short a2);

extern vector signed int __builtin_vec_any_ge (vector signed int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_any_ge (vector unsigned int a1, vector signed int a2);
extern vector signed int __builtin_vec_any_ge (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_any_ge (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_any_ge (vector float a1, vector float a2);

extern vector signed int __builtin_vec_any_gt (vector signed char a1, vector unsigned char a2);

extern vector signed int __builtin_vec_any_gt (vector unsigned char a1, vector signed char a2);

extern vector signed int __builtin_vec_any_gt (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed int __builtin_vec_any_gt (vector signed char a1, vector signed char a2);
extern vector signed int __builtin_vec_any_gt (vector signed short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_any_gt (vector unsigned short a1,
                              vector signed short a2);
extern vector signed int __builtin_vec_any_gt (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_any_gt (vector signed short a1, vector signed short a2);

extern vector signed int __builtin_vec_any_gt (vector signed int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_any_gt (vector unsigned int a1, vector signed int a2);
extern vector signed int __builtin_vec_any_gt (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_any_gt (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_any_gt (vector float a1, vector float a2);

extern vector signed int __builtin_vec_any_le (vector signed char a1, vector unsigned char a2);

extern vector signed int __builtin_vec_any_le (vector unsigned char a1, vector signed char a2);

extern vector signed int __builtin_vec_any_le (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed int __builtin_vec_any_le (vector signed char a1, vector signed char a2);
extern vector signed int __builtin_vec_any_le (vector signed short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_any_le (vector unsigned short a1,
                              vector signed short a2);
extern vector signed int __builtin_vec_any_le (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_any_le (vector signed short a1, vector signed short a2);

extern vector signed int __builtin_vec_any_le (vector signed int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_any_le (vector unsigned int a1, vector signed int a2);
extern vector signed int __builtin_vec_any_le (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_any_le (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_any_le (vector float a1, vector float a2);

extern vector signed int __builtin_vec_any_lt (vector signed char a1, vector unsigned char a2);

extern vector signed int __builtin_vec_any_lt (vector unsigned char a1, vector signed char a2);

extern vector signed int __builtin_vec_any_lt (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed int __builtin_vec_any_lt (vector signed char a1, vector signed char a2);
extern vector signed int __builtin_vec_any_lt (vector signed short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_any_lt (vector unsigned short a1,
                              vector signed short a2);
extern vector signed int __builtin_vec_any_lt (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_any_lt (vector signed short a1, vector signed short a2);

extern vector signed int __builtin_vec_any_lt (vector signed int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_any_lt (vector unsigned int a1, vector signed int a2);
extern vector signed int __builtin_vec_any_lt (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_any_lt (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_any_lt (vector float a1, vector float a2);
#else
__coverity_generic_altivec_vector __builtin_vec_any_eq ();
__coverity_generic_altivec_vector __builtin_vec_any_ge ();
__coverity_generic_altivec_vector __builtin_vec_any_gt ();
__coverity_generic_altivec_vector __builtin_vec_any_le ();
__coverity_generic_altivec_vector __builtin_vec_any_lt ();
#endif

extern vector signed int __builtin_vec_any_nan (vector float a1);

#ifdef __cplusplus
extern vector signed int __builtin_vec_any_ne (vector signed char a1, vector unsigned char a2);

extern vector signed int __builtin_vec_any_ne (vector signed char a1, vector signed char a2);
extern vector signed int __builtin_vec_any_ne (vector unsigned char a1, vector signed char a2);

extern vector signed int __builtin_vec_any_ne (vector unsigned char a1,
                              vector unsigned char a2);
extern vector signed int __builtin_vec_any_ne (vector signed short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_any_ne (vector signed short a1, vector signed short a2);

extern vector signed int __builtin_vec_any_ne (vector unsigned short a1,
                              vector signed short a2);
extern vector signed int __builtin_vec_any_ne (vector unsigned short a1,
                              vector unsigned short a2);
extern vector signed int __builtin_vec_any_ne (vector signed int a1, vector unsigned int a2);
extern vector signed int __builtin_vec_any_ne (vector signed int a1, vector signed int a2);
extern vector signed int __builtin_vec_any_ne (vector unsigned int a1, vector signed int a2);
extern vector signed int __builtin_vec_any_ne (vector unsigned int a1, vector unsigned int a2);

extern vector signed int __builtin_vec_any_ne (vector float a1, vector float a2);
#else
__coverity_generic_altivec_vector __builtin_vec_any_ne ();
#endif

extern vector signed int __builtin_vec_any_nge (vector float a1, vector float a2);

extern vector signed int __builtin_vec_any_ngt (vector float a1, vector float a2);

extern vector signed int __builtin_vec_any_nle (vector float a1, vector float a2);

extern vector signed int __builtin_vec_any_nlt (vector float a1, vector float a2);

extern vector signed int __builtin_vec_any_numeric (vector float a1);

extern vector signed int __builtin_vec_any_out (vector float a1, vector float a2);

# ifndef OFFSET_T
#  ifdef _ARCH_PPC64
#   define OFFSET_T long
#  else
#   define OFFSET_T int
# endif
# endif

extern int __builtin_altivec_vcmpbfp_p(int a1, vector float a2, vector float a3);
extern int __builtin_altivec_vcmpeqfp_p(int a1, vector float a2, vector float a3);
extern int __builtin_altivec_vcmpeqfp_p(int, vector float a1, vector float a2);
extern int __builtin_altivec_vcmpequb_p(int a1, vector signed char a2, vector signed char a3);
extern int __builtin_altivec_vcmpequh_p(int a1, vector signed short a2, vector signed short a3);
extern int __builtin_altivec_vcmpequw_p(int a1, vector signed int a2, vector signed int a3);
extern int __builtin_altivec_vcmpgefp_p(int a1, vector float a2, vector float a3);
extern int __builtin_altivec_vcmpgtfp_p(int a1, vector float a2, vector float a3);
extern int __builtin_altivec_vcmpgtsb_p(int a1, vector signed char a2, vector signed char a3);
extern int __builtin_altivec_vcmpgtsh_p(int a1, vector signed short a2, vector signed short a3);
extern int __builtin_altivec_vcmpgtsw_p(int a1, vector signed int a2, vector signed int a3);
extern int __builtin_altivec_vcmpgtub_p(int a1, vector signed char a2, vector signed char a3);
extern int __builtin_altivec_vcmpgtuh_p(int a1, vector signed short a2, vector signed short a3);
extern int __builtin_altivec_vcmpgtuw_p(int a1, vector signed int a2, vector signed int a3);
extern vector bool char __builtin_altivec_lvx(OFFSET_T a1, const void * a2);
extern vector bool char __builtin_altivec_lvxl(OFFSET_T a1, const void * a2);
extern vector bool char __builtin_altivec_vand(vector signed int a1, vector signed int a2);
extern vector bool char __builtin_altivec_vandc(vector signed int a1, vector signed int a2);
extern vector bool char __builtin_altivec_vcmpequb(vector signed char a1, vector signed char a2);
extern vector bool char __builtin_altivec_vcmpgtsb(vector signed char a1, vector signed char a2);
extern vector bool char __builtin_altivec_vcmpgtub(vector signed char a1, vector signed char a2);
extern vector bool char __builtin_altivec_vmrghb(vector signed char a1, vector signed char a2);
extern vector bool char __builtin_altivec_vmrglb(vector signed char a1, vector signed char a2);
extern vector bool char __builtin_altivec_vnor(vector signed int a1, vector signed int a2);
extern vector bool char __builtin_altivec_vor(vector signed int a1, vector signed int a2);
extern vector bool char __builtin_altivec_vperm_4si(vector signed int a1, vector signed int a2, vector signed char a3);
extern vector bool char __builtin_altivec_vpkuhum(vector signed short a1, vector signed short a2);
extern vector bool char __builtin_altivec_vsel_4si(vector signed int a1, vector signed int a2, vector signed int a3);
extern vector bool char __builtin_altivec_vsl(vector signed int a1, vector signed int a2);
extern vector bool char __builtin_altivec_vsldoi_4si(vector signed int a1, vector signed int a2, const int a3);
extern vector bool char __builtin_altivec_vsldoi_4sf(vector float a1, vector float a2, const int a3);
extern vector bool char __builtin_altivec_vspltb(vector signed char a1, const int a2);
extern vector bool char __builtin_altivec_vsr(vector signed int a1, vector signed int a2);
extern vector bool char __builtin_altivec_vxor(vector signed int a1, vector signed int a2);
extern vector bool int __builtin_altivec_vcmpeqfp(vector float a1, vector float a2);
extern vector bool int __builtin_altivec_vcmpequw(vector signed int a1, vector signed int a2);
extern vector bool int __builtin_altivec_vcmpgefp(vector float a1, vector float a2);
extern vector bool int __builtin_altivec_vcmpgtfp(vector float a1, vector float a2);
extern vector bool int __builtin_altivec_vcmpgtsw(vector signed int a1, vector signed int a2);
extern vector bool int __builtin_altivec_vcmpgtuw(vector signed int a1, vector signed int a2);
extern vector bool int __builtin_altivec_vmrghw(vector signed int a1, vector signed int a2);
extern vector bool int __builtin_altivec_vmrglw(vector signed int a1, vector signed int a2);
extern vector bool int __builtin_altivec_vspltw(vector signed int a1, const int a2);
extern vector bool int __builtin_altivec_vupkhsh(vector signed short a1);
extern vector bool int __builtin_altivec_vupklsh(vector signed short a1);
extern vector bool short __builtin_altivec_vcmpequh(vector signed short a1, vector signed short a2);
extern vector bool short __builtin_altivec_vcmpgtsh(vector signed short a1, vector signed short a2);
extern vector bool short __builtin_altivec_vcmpgtuh(vector signed short a1, vector signed short a2);
extern vector bool short __builtin_altivec_vmrghh(vector signed short a1, vector signed short a2);
extern vector bool short __builtin_altivec_vmrglh(vector signed short a1, vector signed short a2);
extern vector bool short __builtin_altivec_vpkuwum(vector signed int a1, vector signed int a2);
extern vector bool short __builtin_altivec_vsplth(vector signed short a1, const int a2);
extern vector bool short __builtin_altivec_vupkhsb(vector signed char a1);
extern vector bool short __builtin_altivec_vupklsb(vector signed char a1);
extern vector float __builtin_altivec_abs_v4sf(vector float a1);
extern vector float __builtin_altivec_lvewx(OFFSET_T a1, const void * a2);
extern vector float __builtin_altivec_vaddfp(vector float a1, vector float a2);
extern vector float __builtin_altivec_vcfsx(vector signed int a1, const int a2);
extern vector float __builtin_altivec_vcfux(vector signed int a1, const int a2);
extern vector float __builtin_altivec_vexptefp(vector float a1);
extern vector float __builtin_altivec_vlogefp(vector float a1);
extern vector float __builtin_altivec_vmaddfp(vector float a1, vector float a2, vector float a3);
extern vector float __builtin_altivec_vmaxfp(vector float a1, vector float a2);
extern vector float __builtin_altivec_vminfp(vector float a1, vector float a2);
extern vector float __builtin_altivec_vnmsubfp(vector float a1, vector float a2, vector float a3);
extern vector float __builtin_altivec_vrefp(vector float a1);
extern vector float __builtin_altivec_vrfim(vector float a1);
extern vector float __builtin_altivec_vrfin(vector float a1);
extern vector float __builtin_altivec_vrfip(vector float a1);
extern vector float __builtin_altivec_vrfiz(vector float a1);
extern vector float __builtin_altivec_vrsqrtefp(vector float a1);
extern vector float __builtin_altivec_vslo(vector signed int a1, vector signed int a2);
extern vector float __builtin_altivec_vsro(vector signed int a1, vector signed int a2);
extern vector float __builtin_altivec_vsubfp(vector float a1, vector float a2);
extern vector pixel __builtin_altivec_vpkpx(vector signed int a1, vector signed int a2);
extern vector signed char __builtin_altivec_abs_v16qi(vector signed char a1);
extern vector signed char __builtin_altivec_abss_v16qi(vector signed char a1);
extern vector signed char __builtin_altivec_lvebx(OFFSET_T a1, const void * a2);
extern vector signed char __builtin_altivec_vaddsbs(vector signed char a1, vector signed char a2);
extern vector signed char __builtin_altivec_vaddubm(vector signed char a1, vector signed char a2);
extern vector signed char __builtin_altivec_vavgsb(vector signed char a1, vector signed char a2);
extern vector signed char __builtin_altivec_vmaxsb(vector signed char a1, vector signed char a2);
extern vector signed char __builtin_altivec_vminsb(vector signed char a1, vector signed char a2);
extern vector signed char __builtin_altivec_vpkshss(vector signed short a1, vector signed short a2);
extern vector signed char __builtin_altivec_vrlb(vector signed char a1, vector signed char a2);
extern vector signed char __builtin_altivec_vslb(vector signed char a1, vector signed char a2);
extern vector signed char __builtin_altivec_vspltisb(const int a1);
extern vector signed char __builtin_altivec_vsrab(vector signed char a1, vector signed char a2);
extern vector signed char __builtin_altivec_vsrb(vector signed char a1, vector signed char a2);
extern vector signed char __builtin_altivec_vsubsbs(vector signed char a1, vector signed char a2);
extern vector signed char __builtin_altivec_vsububm(vector signed char a1, vector signed char a2);
extern vector signed int __builtin_altivec_abs_v4si(vector signed int a1);
extern vector signed int __builtin_altivec_abss_v4si(vector signed int a1);
extern vector signed int __builtin_altivec_vaddsws(vector signed int a1, vector signed int a2);
extern vector signed int __builtin_altivec_vadduwm(vector signed int a1, vector signed int a2);
extern vector signed int __builtin_altivec_vavgsw(vector signed int a1, vector signed int a2);
extern vector signed int __builtin_altivec_vcmpbfp(vector float a1, vector float a2);
extern vector signed int __builtin_altivec_vctsxs(vector float a1, const int a2);
extern vector signed int __builtin_altivec_vmaxsw(vector signed int a1, vector signed int a2);
extern vector signed int __builtin_altivec_vminsw(vector signed int a1, vector signed int a2);
extern vector signed int __builtin_altivec_vmsummbm(vector signed char a1, vector signed char a2, vector signed int a3);
extern vector signed int __builtin_altivec_vmsumshm(vector signed short a1, vector signed short a2, vector signed int a3);
extern vector signed int __builtin_altivec_vmsumshs(vector signed short a1, vector signed short a2, vector signed int a3);
extern vector signed int __builtin_altivec_vmulesh(vector signed short a1, vector signed short a2);
extern vector signed int __builtin_altivec_vmulosh(vector signed short a1, vector signed short a2);
extern vector signed int __builtin_altivec_vrlw(vector signed int a1, vector signed int a2);
extern vector signed int __builtin_altivec_vslw(vector signed int a1, vector signed int a2);
extern vector signed int __builtin_altivec_vspltisw(const int a1);
extern vector signed int __builtin_altivec_vsraw(vector signed int a1, vector signed int a2);
extern vector signed int __builtin_altivec_vsrw(vector signed int a1, vector signed int a2);
extern vector signed int __builtin_altivec_vsubsws(vector signed int a1, vector signed int a2);
extern vector signed int __builtin_altivec_vsubuwm(vector signed int a1, vector signed int a2);
extern vector signed int __builtin_altivec_vsum2sws(vector signed int a1, vector signed int a2);
extern vector signed int __builtin_altivec_vsum4sbs(vector signed char a1, vector signed int a2);
extern vector signed int __builtin_altivec_vsum4shs(vector signed short a1, vector signed int a2);
extern vector signed int __builtin_altivec_vsumsws(vector signed int a1, vector signed int a2);
extern vector signed short __builtin_altivec_abs_v8hi(vector signed short a1);
extern vector signed short __builtin_altivec_abss_v8hi(vector signed short a1);
extern vector signed short __builtin_altivec_lvehx(OFFSET_T a1, const void * a2);
extern vector signed short __builtin_altivec_vaddshs(vector signed short a1, vector signed short a2);
extern vector signed short __builtin_altivec_vadduhm(vector signed short a1, vector signed short a2);
extern vector signed short __builtin_altivec_vavgsh(vector signed short a1, vector signed short a2);
extern vector signed short __builtin_altivec_vmaxsh(vector signed short a1, vector signed short a2);
extern vector signed short __builtin_altivec_vmhaddshs(vector signed short a1, vector signed short a2, vector signed short a3);
extern vector signed short __builtin_altivec_vmhraddshs(vector signed short a1, vector signed short a2, vector signed short a3);
extern vector signed short __builtin_altivec_vminsh(vector signed short a1, vector signed short a2);
extern vector signed short __builtin_altivec_vmladduhm(vector signed short a1, vector signed short a2, vector signed short a3);
extern vector signed short __builtin_altivec_vmulesb(vector signed char a1, vector signed char a2);
extern vector signed short __builtin_altivec_vmuleub(vector signed char a1, vector signed char a2);
extern vector signed short __builtin_altivec_vmulosb(vector signed char a1, vector signed char a2);
extern vector signed short __builtin_altivec_vpkswss(vector signed int a1, vector signed int a2);
extern vector signed short __builtin_altivec_vrlh(vector signed short a1, vector signed short a2);
extern vector signed short __builtin_altivec_vslh(vector signed short a1, vector signed short a2);
extern vector signed short __builtin_altivec_vspltish(const int a1);
extern vector signed short __builtin_altivec_vsrah(vector signed short a1, vector signed short a2);
extern vector signed short __builtin_altivec_vsrh(vector signed short a1, vector signed short a2);
extern vector signed short __builtin_altivec_vsubshs(vector signed short a1, vector signed short a2);
extern vector signed short __builtin_altivec_vsubuhm(vector signed short a1, vector signed short a2);
extern vector unsigned char __builtin_altivec_lvlx(OFFSET_T a1, const void * a2);
extern vector unsigned char __builtin_altivec_lvlxl(OFFSET_T a1, const void * a2);
extern vector unsigned char __builtin_altivec_lvrx(OFFSET_T a1, const void * a2);
extern vector unsigned char __builtin_altivec_lvrxl(OFFSET_T a1, const void * a2);
extern vector unsigned char __builtin_altivec_lvsl(OFFSET_T a1, const void * a2);
extern vector unsigned char __builtin_altivec_lvsr(OFFSET_T a1, const void * a2);
extern vector unsigned char __builtin_altivec_vaddubs(vector signed char a1, vector signed char a2);
extern vector unsigned char __builtin_altivec_vavgub(vector signed char a1, vector signed char a2);
extern vector unsigned char __builtin_altivec_vmaxub(vector signed char a1, vector signed char a2);
extern vector unsigned char __builtin_altivec_vminub(vector signed char a1, vector signed char a2);
extern vector unsigned char __builtin_altivec_vpkshus(vector signed short a1, vector signed short a2);
extern vector unsigned char __builtin_altivec_vpkuhus(vector signed short a1, vector signed short a2);
extern vector unsigned char __builtin_altivec_vsububs(vector signed char a1, vector signed char a2);
extern vector unsigned int __builtin_altivec_vaddcuw(vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_altivec_vadduws(vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_altivec_vavguw(vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_altivec_vctuxs(vector float a1, const int a2);
extern vector unsigned int __builtin_altivec_vmaxuw(vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_altivec_vminuw(vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_altivec_vmsumubm(vector signed char a1, vector signed char a2, vector signed int a3);
extern vector unsigned int __builtin_altivec_vmsumuhm(vector signed short a1, vector signed short a2, vector signed int a3);
extern vector unsigned int __builtin_altivec_vmsumuhs(vector signed short a1, vector signed short a2, vector signed int a3);
extern vector unsigned int __builtin_altivec_vmuleuh(vector signed short a1, vector signed short a2);
extern vector unsigned int __builtin_altivec_vmulouh(vector signed short a1, vector signed short a2);
extern vector unsigned int __builtin_altivec_vsubcuw(vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_altivec_vsubuws(vector signed int a1, vector signed int a2);
extern vector unsigned int __builtin_altivec_vsum4ubs(vector signed char a1, vector signed int a2);
extern vector unsigned int __builtin_altivec_vupkhpx(vector signed short a1);
extern vector unsigned int __builtin_altivec_vupklpx(vector signed short a1);
extern vector unsigned short __builtin_altivec_mfvscr();
extern vector unsigned short __builtin_altivec_vadduhs(vector signed short a1, vector signed short a2);
extern vector unsigned short __builtin_altivec_vavguh(vector signed short a1, vector signed short a2);
extern vector unsigned short __builtin_altivec_vmaxuh(vector signed short a1, vector signed short a2);
extern vector unsigned short __builtin_altivec_vminuh(vector signed short a1, vector signed short a2);
extern vector unsigned short __builtin_altivec_vmuloub(vector signed char a1, vector signed char a2);
extern vector unsigned short __builtin_altivec_vpkswus(vector signed int a1, vector signed int a2);
extern vector unsigned short __builtin_altivec_vpkuwus(vector signed int a1, vector signed int a2);
extern vector unsigned short __builtin_altivec_vsubuhs(vector signed short a1, vector signed short a2);
extern void __builtin_altivec_dss(int a1);
extern void __builtin_altivec_dssall();
extern void __builtin_altivec_dst(const void *a1, OFFSET_T a2, const int a3);
extern void __builtin_altivec_dstst(const void *a1, OFFSET_T a2, const int a3);
extern void __builtin_altivec_dststt(const void *a1, OFFSET_T a2, const int a3);
extern void __builtin_altivec_dstt(const void *a1, OFFSET_T a2, const int a3);
extern void __builtin_altivec_mtvscr(vector signed int a1);
#ifdef __cplusplus
extern void __builtin_altivec_stvebx(vector signed char a1, OFFSET_T a2, const void * a3);
extern void __builtin_altivec_stvehx(vector signed short a1, OFFSET_T a2, const void * a3);
extern void __builtin_altivec_stvewx(vector signed int a1, OFFSET_T a2, const void * a3);
extern void __builtin_altivec_stvlx(vector signed char a1, OFFSET_T a2, const void * a3);
extern void __builtin_altivec_stvlxl(vector signed char a1, OFFSET_T a2, const void * a3);
extern void __builtin_altivec_stvrx(vector signed char a1, OFFSET_T a2, const void * a3);
extern void __builtin_altivec_stvrxl(vector signed char a1, OFFSET_T a2, const void * a3);
extern void __builtin_altivec_stvx(vector signed int a1, OFFSET_T a2, const void * a3);
extern void __builtin_altivec_stvxl(vector signed int a1, OFFSET_T a2, const void * a3);
extern vector bool char __builtin_altivec_vsel_4sf(vector float a1, vector float a2, vector float a3);
extern vector bool char __builtin_altivec_vsel_4sf(vector float a1, vector float a2, vector signed int a3);
#else
extern void __builtin_altivec_stvebx();
extern void __builtin_altivec_stvehx();
extern void __builtin_altivec_stvewx();
extern void __builtin_altivec_stvlx();
extern void __builtin_altivec_stvlxl();
extern void __builtin_altivec_stvrx();
extern void __builtin_altivec_stvrxl();
extern void __builtin_altivec_stvx();
extern void __builtin_altivec_stvxl();
extern __coverity_generic_altivec_vector __builtin_altivec_vsel_4sf();
#endif
#endif /* __ALTIVEC__ */

//SPU intrinsic
#if defined(COVERITY_SPU_COMPILER_2_5) && !defined(__COVERITY_DISABLE_BUILTIN_DECLS)
#define __cov_qword __vector signed char
#define __cov_imm int
#define __cov_ra __cov_qword
#define __cov_rb __cov_qword
#define __cov_rc __cov_qword
#define __cov_rd __cov_qword
#define __cov_rt __cov_qword
#define __cov_scalar double 
#define __cov_count unsigned int
#define __cov_pos unsigned int

__cov_qword __builtin_si_lqd(__cov_ra,__cov_imm);
__cov_qword __builtin_si_lqx(__cov_ra,__cov_rb);
__cov_qword __builtin_si_lqa(__cov_imm);
__cov_qword __builtin_si_lqr(__cov_imm);
__cov_qword __builtin_si_stqd(__cov_rt,__cov_ra,__cov_imm);
__cov_qword __builtin_si_stqx(__cov_rt,__cov_ra,__cov_rb);
__cov_qword __builtin_si_stqa(__cov_rt,__cov_imm);
__cov_qword __builtin_si_stqr(__cov_rt,__cov_imm);
__cov_qword __builtin_si_cbd(__cov_ra,__cov_imm);
__cov_qword __builtin_si_cbx(__cov_ra,__cov_rb);
__cov_qword __builtin_si_chd(__cov_ra,__cov_imm);
__cov_qword __builtin_si_chx(__cov_ra,__cov_rb);
__cov_qword __builtin_si_cwd(__cov_ra,__cov_imm);
__cov_qword __builtin_si_cwx(__cov_ra,__cov_rb);
__cov_qword __builtin_si_cdd(__cov_ra,__cov_imm);
__cov_qword __builtin_si_cdx(__cov_ra,__cov_rb);
__cov_qword __builtin_si_ilh(__cov_imm);
__cov_qword __builtin_si_ilhu(__cov_imm);
__cov_qword __builtin_si_il(__cov_imm);
__cov_qword __builtin_si_ila(__cov_imm);
__cov_qword __builtin_si_iohl(__cov_ra,__cov_imm);
__cov_qword __builtin_si_fsmbi(__cov_imm);
__cov_qword __builtin_si_ah(__cov_ra,__cov_rb);
__cov_qword __builtin_si_ahi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_a(__cov_ra,__cov_rb);
__cov_qword __builtin_si_ai(__cov_ra,__cov_imm);
__cov_qword __builtin_si_addx(__cov_ra,__cov_rb,__cov_rt);
__cov_qword __builtin_si_cg(__cov_ra,__cov_rb);
__cov_qword __builtin_si_cgx(__cov_ra,__cov_rb,__cov_rt);
__cov_qword __builtin_si_sfh(__cov_ra,__cov_rb);
//__cov_qword __builtin_si_sfhi(__cov_imm,__cov_ra);
__cov_qword __builtin_si_sf(__cov_ra,__cov_rb);
__cov_qword __builtin_si_sfi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_sfx(__cov_ra,__cov_rb,__cov_rt);
__cov_qword __builtin_si_bg(__cov_ra,__cov_rb);
__cov_qword __builtin_si_bgx(__cov_ra,__cov_rb,__cov_rt);
__cov_qword __builtin_si_mpy(__cov_ra,__cov_rb);
__cov_qword __builtin_si_mpyu(__cov_ra,__cov_rb);
__cov_qword __builtin_si_mpyi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_mpyui(__cov_ra,__cov_imm);
__cov_qword __builtin_si_mpya(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_si_mpyh(__cov_ra,__cov_rb);
__cov_qword __builtin_si_mpys(__cov_ra,__cov_rb);
__cov_qword __builtin_si_mpyhh(__cov_ra,__cov_rb);
__cov_qword __builtin_si_mpyhhu(__cov_ra,__cov_rb);
__cov_qword __builtin_si_mpyhha(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_si_mpyhhau(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_si_clz(__cov_ra);
__cov_qword __builtin_si_cntb(__cov_ra);
__cov_qword __builtin_si_fsmb(__cov_ra);
__cov_qword __builtin_si_fsmh(__cov_ra);
__cov_qword __builtin_si_fsm(__cov_ra);
__cov_qword __builtin_si_gbb(__cov_ra);
__cov_qword __builtin_si_gbh(__cov_ra);
__cov_qword __builtin_si_gb(__cov_ra);
__cov_qword __builtin_si_avgb(__cov_ra,__cov_rb);
__cov_qword __builtin_si_absdb(__cov_ra,__cov_rb);
__cov_qword __builtin_si_sumb(__cov_ra,__cov_rb);
__cov_qword __builtin_si_xsbh(__cov_ra);
__cov_qword __builtin_si_xshw(__cov_ra);
__cov_qword __builtin_si_xswd(__cov_ra);
__cov_qword __builtin_si_and(__cov_ra,__cov_rb);
__cov_qword __builtin_si_andc(__cov_ra,__cov_rb);
__cov_qword __builtin_si_andbi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_andhi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_andi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_or(__cov_ra,__cov_rb);
__cov_qword __builtin_si_orc(__cov_ra,__cov_rb);
__cov_qword __builtin_si_orbi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_orhi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_ori(__cov_ra,__cov_imm);
__cov_qword __builtin_si_orx(__cov_ra);
__cov_qword __builtin_si_xor(__cov_ra,__cov_rb);
__cov_qword __builtin_si_xorbi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_xorhi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_xori(__cov_ra,__cov_imm);
__cov_qword __builtin_si_nand(__cov_ra,__cov_rb);
__cov_qword __builtin_si_nor(__cov_ra,__cov_rb);
__cov_qword __builtin_si_eqv(__cov_ra,__cov_rb);
__cov_qword __builtin_si_selb(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_si_shufb(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_si_shlh(__cov_ra,__cov_rb);
__cov_qword __builtin_si_shlhi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_shl(__cov_ra,__cov_rb);
__cov_qword __builtin_si_shli(__cov_ra,__cov_imm);
__cov_qword __builtin_si_shlqbi(__cov_ra,__cov_rb);
__cov_qword __builtin_si_shlqbii(__cov_ra,__cov_imm);
__cov_qword __builtin_si_shlqby(__cov_ra,__cov_rb);
__cov_qword __builtin_si_shlqbyi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_shlqbybi(__cov_ra,__cov_rb);
__cov_qword __builtin_si_roth(__cov_ra,__cov_rb);
__cov_qword __builtin_si_rothi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_rot(__cov_ra,__cov_rb);
__cov_qword __builtin_si_roti(__cov_ra,__cov_imm);
__cov_qword __builtin_si_rotqby(__cov_ra,__cov_rb);
__cov_qword __builtin_si_rotqbyi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_rotqbybi(__cov_ra,__cov_rb);
__cov_qword __builtin_si_rotqbi(__cov_ra,__cov_rb);
__cov_qword __builtin_si_rotqbii(__cov_ra,__cov_imm);
__cov_qword __builtin_si_rothm(__cov_ra,__cov_rb);
__cov_qword __builtin_si_rothmi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_rotm(__cov_ra,__cov_rb);
__cov_qword __builtin_si_rotmi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_rotqmby(__cov_ra,__cov_rb);
__cov_qword __builtin_si_rotqmbyi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_rotqmbi(__cov_ra,__cov_rb);
__cov_qword __builtin_si_rotqmbii(__cov_ra,__cov_imm);
__cov_qword __builtin_si_rotqmbybi(__cov_ra,__cov_rb);
__cov_qword __builtin_si_rotmah(__cov_ra,__cov_rb);
__cov_qword __builtin_si_rotmahi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_rotma(__cov_ra,__cov_rb);
__cov_qword __builtin_si_rotmai(__cov_ra,__cov_imm);
__cov_qword __builtin_si_heq(__cov_ra,__cov_rb);
__cov_qword __builtin_si_heqi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_hgt(__cov_ra,__cov_rb);
__cov_qword __builtin_si_hgti(__cov_ra,__cov_imm);
__cov_qword __builtin_si_hlgt(__cov_ra,__cov_rb);
__cov_qword __builtin_si_hlgti(__cov_ra,__cov_imm);
__cov_qword __builtin_si_ceqb(__cov_ra,__cov_rb);
__cov_qword __builtin_si_ceqbi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_ceqh(__cov_ra,__cov_rb);
__cov_qword __builtin_si_ceqhi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_ceq(__cov_ra,__cov_rb);
__cov_qword __builtin_si_ceqi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_cgtb(__cov_ra,__cov_rb);
__cov_qword __builtin_si_cgtbi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_cgth(__cov_ra,__cov_rb);
__cov_qword __builtin_si_cgthi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_cgt(__cov_ra,__cov_rb);
__cov_qword __builtin_si_cgti(__cov_ra,__cov_imm);
__cov_qword __builtin_si_clgtb(__cov_ra,__cov_rb);
__cov_qword __builtin_si_clgtbi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_clgth(__cov_ra,__cov_rb);
__cov_qword __builtin_si_clgthi(__cov_ra,__cov_imm);
__cov_qword __builtin_si_clgt(__cov_ra,__cov_rb);
__cov_qword __builtin_si_clgti(__cov_ra,__cov_imm);
//__cov_qword __builtin_si_bisled(__cov_ra,int);
//__cov_qword __builtin_si_bisledd(__cov_ra,int);
//__cov_qword __builtin_si_bislede(__cov_ra,int);
__cov_qword __builtin_si_fa(__cov_ra,__cov_rb);
__cov_qword __builtin_si_dfa(__cov_ra,__cov_rb);
__cov_qword __builtin_si_fs(__cov_ra,__cov_rb);
__cov_qword __builtin_si_dfs(__cov_ra,__cov_rb);
__cov_qword __builtin_si_fm(__cov_ra,__cov_rb);
__cov_qword __builtin_si_dfm(__cov_ra,__cov_rb);
__cov_qword __builtin_si_fma(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_si_dfma(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_si_dfnma(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_si_fnms(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_si_dfnms(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_si_fms(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_si_dfms(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_si_frest(__cov_ra);
__cov_qword __builtin_si_frsqest(__cov_ra);
__cov_qword __builtin_si_fi(__cov_ra,__cov_rb);
__cov_qword __builtin_si_csflt(__cov_ra,__cov_imm);
__cov_qword __builtin_si_cflts(__cov_ra,__cov_imm);
__cov_qword __builtin_si_cuflt(__cov_ra,__cov_imm);
__cov_qword __builtin_si_cfltu(__cov_ra,__cov_imm);
__cov_qword __builtin_si_frds(__cov_ra);
__cov_qword __builtin_si_fesd(__cov_ra);
__cov_qword __builtin_si_fceq(__cov_ra,__cov_rb);
__cov_qword __builtin_si_fcmeq(__cov_ra,__cov_rb);
__cov_qword __builtin_si_fcgt(__cov_ra,__cov_rb);
__cov_qword __builtin_si_fcmgt(__cov_ra,__cov_rb);
__cov_qword __builtin_si_stop(__cov_imm);
__cov_qword __builtin_si_stopd(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_si_lnop();
__cov_qword __builtin_si_nop();
__cov_qword __builtin_si_sync();
__cov_qword __builtin_si_syncc();
__cov_qword __builtin_si_dsync();
__cov_qword __builtin_si_mfspr(__cov_imm);
__cov_qword __builtin_si_mtspr(__cov_imm,__cov_ra);
__cov_qword __builtin_si_fscrrd();
__cov_qword __builtin_si_fscrwr(__cov_ra);
__cov_qword __builtin_si_rdch(__cov_imm);
__cov_qword __builtin_si_rchcnt(__cov_imm);
__cov_qword __builtin_si_wrch(__cov_imm,__cov_ra);

__cov_qword __builtin_si_dfceq(__cov_ra,__cov_rb);
__cov_qword __builtin_si_dfcmeq(__cov_ra,__cov_rb);
__cov_qword __builtin_si_dfcgt(__cov_ra,__cov_rb);
__cov_qword __builtin_si_dfcmgt(__cov_ra,__cov_rb);
__cov_qword __builtin_si_dftsv(__cov_ra,__cov_imm);

__cov_qword __builtin_si_from_char(signed char);
__cov_qword __builtin_si_from_uchar(unsigned char);
__cov_qword __builtin_si_from_short(short);
__cov_qword __builtin_si_from_ushort(unsigned short);
__cov_qword __builtin_si_from_int(int);
__cov_qword __builtin_si_from_uint(unsigned int);
//__cov_qword __builtin_si_from_long(long);
//__cov_qword __builtin_si_from_ulong(unsigned long);
__cov_qword __builtin_si_from_float(float);
__cov_qword __builtin_si_from_double(double);
//__cov_qword __builtin_si_from_ptr(volatile void *);

signed char __builtin_si_to_char(__cov_ra);
unsigned char __builtin_si_to_uchar(__cov_ra);
short __builtin_si_to_short(__cov_ra);
unsigned short __builtin_si_to_ushort(__cov_ra);
int __builtin_si_to_int(__cov_ra);
unsigned short __builtin_si_to_uint(__cov_ra);
long __builtin_si_to_long(__cov_ra);
unsigned long __builtin_si_to_ulong(__cov_ra);
float __builtin_si_to_float(__cov_ra);
double __builtin_si_to_double(__cov_ra);
void * __builtin_si_to_ptr(__cov_ra);

//__builtin_spu_align_hint(ptr,base,offset);
void __builtin_spu_align_hint(void *,int,int);

/* generic spu_* intrinsics */

__cov_qword __builtin_spu_splats(__cov_scalar); 
__cov_qword __builtin_spu_convtf(__cov_ra,__cov_imm);
//__cov_qword __builtin_spu_convts(__cov_ra,__cov_imm);
//__cov_qword __builtin_spu_convtu(__cov_ra,__cov_imm);
__cov_qword __builtin_spu_extend(__cov_ra); 
//__cov_qword __builtin_spu_roundtf(__cov_ra);
__cov_qword __builtin_spu_add(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_addx(__cov_ra,__cov_rb,__cov_rt); 
__cov_qword __builtin_spu_genc(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_gencx(__cov_ra,__cov_rb,__cov_rt); 
__cov_qword __builtin_spu_madd(__cov_ra,__cov_rb,__cov_rc);
//__cov_qword __builtin_spu_nmadd(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_spu_mhhadd(__cov_ra,__cov_rb,__cov_rc);
__cov_qword __builtin_spu_msub(__cov_ra,__cov_rb,__cov_rc); 
__cov_qword __builtin_spu_mul(__cov_ra,__cov_rb); 
//__cov_qword __builtin_spu_mulh(__cov_ra,__cov_rb);
__cov_qword __builtin_spu_mule(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_mulo(__cov_ra,__cov_rb); 
//__cov_qword __builtin_spu_mulsr(__cov_ra,__cov_rb);
__cov_qword __builtin_spu_nmsub(__cov_ra,__cov_rb,__cov_rc); 
__cov_qword __builtin_spu_sub(__cov_ra,__cov_rb);
__cov_qword __builtin_spu_subx(__cov_ra,__cov_rb,__cov_rt); 
__cov_qword __builtin_spu_genb(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_genbx(__cov_ra,__cov_rb,__cov_rt); 
//__cov_qword __builtin_spu_absd(__cov_ra,__cov_rb);
//__cov_qword __builtin_spu_avg(__cov_ra,__cov_rb);
//__cov_qword __builtin_spu_sumb(__cov_ra,__cov_rb);
//__cov_qword __builtin_spu_bisled(__cov_ra, int);
//__cov_qword __builtin_spu_bisled_d(__cov_ra, int);
//__cov_qword __builtin_spu_bisled_e(__cov_ra, int);
__cov_qword __builtin_spu_cmpabseq(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_cmpabsgt(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_cmpeq(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_cmpgt(__cov_ra,__cov_rb); 
//__cov_qword __builtin_spu_testsv(__cov_ra,__cov_imm);
__cov_qword __builtin_spu_hcmpeq(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_hcmpgt(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_cntb(__cov_ra); 
__cov_qword __builtin_spu_cntlz(__cov_ra); 
__cov_qword __builtin_spu_gather(__cov_ra); 
__cov_qword __builtin_spu_maskb(__cov_ra); 
__cov_qword __builtin_spu_maskh(__cov_ra); 
__cov_qword __builtin_spu_maskw(__cov_ra); 
__cov_qword __builtin_spu_sel(__cov_ra,__cov_rb,__cov_rc); 
__cov_qword __builtin_spu_shuffle(__cov_ra,__cov_rb,__cov_rc); 
__cov_qword __builtin_spu_and(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_andc(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_eqv(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_nand(__cov_ra,__cov_rb);
__cov_qword __builtin_spu_nor(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_or(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_orc(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_orx(__cov_ra);
__cov_qword __builtin_spu_xor(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_rl(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_rlqw(__cov_ra,__cov_count); 
__cov_qword __builtin_spu_rlqwbyte(__cov_ra,__cov_count); 
__cov_qword __builtin_spu_rlqwbytebc(__cov_ra,__cov_count); 
__cov_qword __builtin_spu_rlmask(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_rlmaska(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_rlmaskqw(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_rlmaskqwbyte(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_rlmaskqwbytebc(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_sl(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_slqw(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_slqwbyte(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_slqwbytebc(__cov_ra,__cov_rb); 
__cov_qword __builtin_spu_extract(__cov_ra,__cov_pos); 
__cov_qword __builtin_spu_insert(__cov_scalar,__cov_ra,__cov_pos); 
__cov_qword __builtin_spu_promote(__cov_scalar,__cov_pos); 

void __builtin_spu_idisable();
void __builtin_spu_ienable();

#if defined(__PS3_GCC_REVISION__)
void __builtin_spu_hcmpeq_0 (int a, int b);
void __builtin_spu_hcmpeq_1 (unsigned int a, unsigned int b);
void __builtin_spu_hcmpgt_0 (int a, int b);
void __builtin_spu_hcmpgt_1 (unsigned int a, unsigned int b);
#endif

/* See BZ31369 for how the SPU builtins were generated from spu-builtins.def */
/* BEGIN: Generated from spu-builtins.def */
void __builtin_si_bisled(__vector signed char arg0, void *arg1);
void __builtin_si_bisledd(__vector signed char arg0, void *arg1);
void __builtin_si_bislede(__vector signed char arg0, void *arg1);
void __builtin_spu_bisled(void *arg0, void *arg1);
void __builtin_spu_bisled_d(void *arg0, void *arg1);
void __builtin_spu_bisled_e(void *arg0, void *arg1);
double __builtin_dfmas(double arg0, double arg1, double arg2);
float __builtin_fmas(float arg0, float arg1, float arg2);
__vector signed char __builtin_si_a(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_absdb(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_addx(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_ah(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_ahi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_ai(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_and(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_andbi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_andc(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_andhi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_andi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_avgb(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_bg(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_bgx(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_cbd(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_cbx(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_cdd(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_cdx(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_ceq(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_ceqb(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_ceqbi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_ceqh(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_ceqhi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_ceqi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_cflts(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_cfltu(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_cg(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_cgt(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_cgtb(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_cgtbi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_cgth(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_cgthi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_cgti(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_cgx(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_chd(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_chx(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_clgt(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_clgtb(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_clgtbi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_clgth(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_clgthi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_clgti(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_clz(__vector signed char arg0);
__vector signed char __builtin_si_cntb(__vector signed char arg0);
__vector signed char __builtin_si_csflt(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_cuflt(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_cwd(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_cwx(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_dfa(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_dfceq(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_dfcgt(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_dfcmeq(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_dfcmgt(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_dfm(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_dfma(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_dfms(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_dfnma(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_dfnms(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_dfs(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_dftsv(__vector signed char arg0, int arg1);
void __builtin_si_dsync();
__vector signed char __builtin_si_eqv(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_fa(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_fceq(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_fcgt(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_fcmeq(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_fcmgt(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_fesd(__vector signed char arg0);
__vector signed char __builtin_si_fi(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_fm(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_fma(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_fms(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_fnms(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_frds(__vector signed char arg0);
__vector signed char __builtin_si_frest(__vector signed char arg0);
__vector signed char __builtin_si_from_char(signed char arg0);
__vector signed char __builtin_si_from_double(double arg0);
__vector signed char __builtin_si_from_float(float arg0);
__vector signed char __builtin_si_from_int(signed int arg0);
__vector signed char __builtin_si_from_long(signed long long arg0);
__vector signed char __builtin_si_from_ptr(volatile void *arg0);
__vector signed char __builtin_si_from_short(signed short arg0);
__vector signed char __builtin_si_from_uchar(unsigned char arg0);
__vector signed char __builtin_si_from_uint(unsigned int arg0);
__vector signed char __builtin_si_from_ulong(unsigned long long arg0);
__vector signed char __builtin_si_from_ushort(unsigned short arg0);
__vector signed char __builtin_si_frsqest(__vector signed char arg0);
__vector signed char __builtin_si_fs(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_fscrrd();
void __builtin_si_fscrwr(__vector signed char arg0);
__vector signed char __builtin_si_fsm(__vector signed char arg0);
__vector signed char __builtin_si_fsmb(__vector signed char arg0);
__vector signed char __builtin_si_fsmbi(int arg0);
__vector signed char __builtin_si_fsmh(__vector signed char arg0);
__vector signed char __builtin_si_gb(__vector signed char arg0);
__vector signed char __builtin_si_gbb(__vector signed char arg0);
__vector signed char __builtin_si_gbh(__vector signed char arg0);
void __builtin_si_heq(__vector signed char arg0, __vector signed char arg1);
void __builtin_si_heqi(__vector signed char arg0, int arg1);
void __builtin_si_hgt(__vector signed char arg0, __vector signed char arg1);
void __builtin_si_hgti(__vector signed char arg0, int arg1);
void __builtin_si_hlgt(__vector signed char arg0, __vector signed char arg1);
void __builtin_si_hlgti(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_il(int arg0);
__vector signed char __builtin_si_ila(int arg0);
__vector signed char __builtin_si_ilh(int arg0);
__vector signed char __builtin_si_ilhu(int arg0);
__vector signed char __builtin_si_iohl(__vector signed char arg0, int arg1);
void __builtin_si_lnop();
__vector signed char __builtin_si_lqa(int arg0);
__vector signed char __builtin_si_lqd(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_lqr(int arg0);
__vector signed char __builtin_si_lqx(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_mfspr(int arg0);
__vector signed char __builtin_si_mpy(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_mpya(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_mpyh(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_mpyhh(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_mpyhha(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_mpyhhau(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_mpyhhu(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_mpyi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_mpys(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_mpyu(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_mpyui(__vector signed char arg0, int arg1);
void __builtin_si_mtspr(int arg0, __vector signed char arg1);
__vector signed char __builtin_si_nand(__vector signed char arg0, __vector signed char arg1);
void __builtin_si_nop();
__vector signed char __builtin_si_nor(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_or(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_orbi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_orc(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_orhi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_ori(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_orx(__vector signed char arg0);
__vector signed char __builtin_si_rchcnt(int arg0);
__vector signed char __builtin_si_rdch(int arg0);
__vector signed char __builtin_si_rot(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_roth(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_rothi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_rothm(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_rothmi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_roti(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_rotm(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_rotma(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_rotmah(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_rotmahi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_rotmai(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_rotmi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_rotqbi(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_rotqbii(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_rotqby(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_rotqbybi(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_rotqbyi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_rotqmbi(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_rotqmbii(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_rotqmby(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_rotqmbybi(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_rotqmbyi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_selb(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_sf(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_sfh(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_sfhi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_sfi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_sfx(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_shl(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_shlh(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_shlhi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_shli(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_shlqbi(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_shlqbii(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_shlqby(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_shlqbybi(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_shlqbyi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_shufb(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
void __builtin_si_stop(int arg0);
void __builtin_si_stopd(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
void __builtin_si_stqa(__vector signed char arg0, int arg1);
void __builtin_si_stqd(__vector signed char arg0, __vector signed char arg1, int arg2);
void __builtin_si_stqr(__vector signed char arg0, int arg1);
void __builtin_si_stqx(__vector signed char arg0, __vector signed char arg1, __vector signed char arg2);
__vector signed char __builtin_si_sumb(__vector signed char arg0, __vector signed char arg1);
void __builtin_si_sync();
void __builtin_si_syncc();
signed char __builtin_si_to_char(__vector signed char arg0);
double __builtin_si_to_double(__vector signed char arg0);
float __builtin_si_to_float(__vector signed char arg0);
signed int __builtin_si_to_int(__vector signed char arg0);
signed long long __builtin_si_to_long(__vector signed char arg0);
void * __builtin_si_to_ptr(__vector signed char arg0);
signed short __builtin_si_to_short(__vector signed char arg0);
unsigned char __builtin_si_to_uchar(__vector signed char arg0);
unsigned int __builtin_si_to_uint(__vector signed char arg0);
unsigned long long __builtin_si_to_ulong(__vector signed char arg0);
unsigned short __builtin_si_to_ushort(__vector signed char arg0);
void __builtin_si_wrch(int arg0, __vector signed char arg1);
__vector signed char __builtin_si_xor(__vector signed char arg0, __vector signed char arg1);
__vector signed char __builtin_si_xorbi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_xorhi(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_xori(__vector signed char arg0, int arg1);
__vector signed char __builtin_si_xsbh(__vector signed char arg0);
__vector signed char __builtin_si_xshw(__vector signed char arg0);
__vector signed char __builtin_si_xswd(__vector signed char arg0);
__vector unsigned char __builtin_spu_absd(__vector unsigned char arg0, __vector unsigned char arg1);
void __builtin_spu_align_hint(void *arg0, int arg1, int arg2);
__vector unsigned char __builtin_spu_avg(__vector unsigned char arg0, __vector unsigned char arg1);
__vector signed int __builtin_spu_convts(__vector float arg0, signed int arg1);
__vector unsigned int __builtin_spu_convtu(__vector float arg0, signed int arg1);
__vector float __builtin_spu_frest(__vector float arg0);
__vector float __builtin_spu_frsqest(__vector float arg0);
void __builtin_spu_idisable();
void __builtin_spu_ienable();
__vector signed char __builtin_spu_lvsr(void *arg0);
__vector signed int __builtin_spu_mulh(__vector signed short arg0, __vector signed short arg1);
__vector signed int __builtin_spu_mulsr(__vector signed short arg0, __vector signed short arg1);
__vector double __builtin_spu_nmadd(__vector double arg0, __vector double arg1, __vector double arg2);
__vector float __builtin_spu_roundtf(__vector double arg0);
__vector unsigned short __builtin_spu_sumb(__vector unsigned char arg0, __vector unsigned char arg1);
__vector unsigned long long __builtin_spu_testsv(__vector double arg0, int arg1);
#if __cplusplus
__vector unsigned int __builtin_spu_add(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_add(__vector signed int arg0, __vector signed int arg1);
__vector unsigned short __builtin_spu_add(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_add(__vector signed short arg0, __vector signed short arg1);
__vector float __builtin_spu_add(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_add(__vector double arg0, __vector double arg1);
__vector unsigned short __builtin_spu_add(__vector unsigned short arg0, unsigned short arg1);
__vector signed short __builtin_spu_add(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_add(__vector unsigned int arg0, unsigned int arg1);
__vector signed int __builtin_spu_add(__vector signed int arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned int __builtin_spu_add_0(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_add_1(__vector signed int arg0, __vector signed int arg1);
__vector unsigned short __builtin_spu_add_2(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_add_3(__vector signed short arg0, __vector signed short arg1);
__vector float __builtin_spu_add_4(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_add_5(__vector double arg0, __vector double arg1);
__vector unsigned short __builtin_spu_add_6(__vector unsigned short arg0, unsigned short arg1);
__vector signed short __builtin_spu_add_7(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_add_8(__vector unsigned int arg0, unsigned int arg1);
__vector signed int __builtin_spu_add_9(__vector signed int arg0, signed int arg1);
#if __cplusplus
__vector signed int __builtin_spu_addx(__vector signed int arg0, __vector signed int arg1, __vector signed int arg2);
__vector unsigned int __builtin_spu_addx(__vector unsigned int arg0, __vector unsigned int arg1, __vector unsigned int arg2);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed int __builtin_spu_addx_0(__vector signed int arg0, __vector signed int arg1, __vector signed int arg2);
__vector unsigned int __builtin_spu_addx_1(__vector unsigned int arg0, __vector unsigned int arg1, __vector unsigned int arg2);
#if __cplusplus
__vector unsigned char __builtin_spu_and(__vector unsigned char arg0, __vector unsigned char arg1);
__vector signed char __builtin_spu_and(__vector signed char arg0, __vector signed char arg1);
__vector unsigned short __builtin_spu_and(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_and(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_and(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_and(__vector signed int arg0, __vector signed int arg1);
__vector unsigned long long __builtin_spu_and(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed long long __builtin_spu_and(__vector signed long long arg0, __vector signed long long arg1);
__vector float __builtin_spu_and(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_and(__vector double arg0, __vector double arg1);
__vector unsigned char __builtin_spu_and(__vector unsigned char arg0, unsigned char arg1);
__vector signed char __builtin_spu_and(__vector signed char arg0, signed char arg1);
__vector unsigned short __builtin_spu_and(__vector unsigned short arg0, unsigned short arg1);
__vector signed short __builtin_spu_and(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_and(__vector unsigned int arg0, unsigned int arg1);
__vector signed int __builtin_spu_and(__vector signed int arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_and_0(__vector unsigned char arg0, __vector unsigned char arg1);
__vector signed char __builtin_spu_and_1(__vector signed char arg0, __vector signed char arg1);
__vector unsigned short __builtin_spu_and_2(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_and_3(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_and_4(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_and_5(__vector signed int arg0, __vector signed int arg1);
__vector unsigned long long __builtin_spu_and_6(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed long long __builtin_spu_and_7(__vector signed long long arg0, __vector signed long long arg1);
__vector float __builtin_spu_and_8(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_and_9(__vector double arg0, __vector double arg1);
__vector unsigned char __builtin_spu_and_10(__vector unsigned char arg0, unsigned char arg1);
__vector signed char __builtin_spu_and_11(__vector signed char arg0, signed char arg1);
__vector unsigned short __builtin_spu_and_12(__vector unsigned short arg0, unsigned short arg1);
__vector signed short __builtin_spu_and_13(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_and_14(__vector unsigned int arg0, unsigned int arg1);
__vector signed int __builtin_spu_and_15(__vector signed int arg0, signed int arg1);
#if __cplusplus
__vector signed long long __builtin_spu_andc(__vector signed long long arg0, __vector signed long long arg1);
__vector unsigned long long __builtin_spu_andc(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed int __builtin_spu_andc(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_andc(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed short __builtin_spu_andc(__vector signed short arg0, __vector signed short arg1);
__vector unsigned short __builtin_spu_andc(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed char __builtin_spu_andc(__vector signed char arg0, __vector signed char arg1);
__vector unsigned char __builtin_spu_andc(__vector unsigned char arg0, __vector unsigned char arg1);
__vector float __builtin_spu_andc(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_andc(__vector double arg0, __vector double arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed long long __builtin_spu_andc_0(__vector signed long long arg0, __vector signed long long arg1);
__vector unsigned long long __builtin_spu_andc_1(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed int __builtin_spu_andc_2(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_andc_3(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed short __builtin_spu_andc_4(__vector signed short arg0, __vector signed short arg1);
__vector unsigned short __builtin_spu_andc_5(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed char __builtin_spu_andc_6(__vector signed char arg0, __vector signed char arg1);
__vector unsigned char __builtin_spu_andc_7(__vector unsigned char arg0, __vector unsigned char arg1);
__vector float __builtin_spu_andc_8(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_andc_9(__vector double arg0, __vector double arg1);
#if __cplusplus
__vector unsigned int __builtin_spu_cmpabseq(__vector float arg0, __vector float arg1);
__vector unsigned long long __builtin_spu_cmpabseq(__vector double arg0, __vector double arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned int __builtin_spu_cmpabseq_0(__vector float arg0, __vector float arg1);
__vector unsigned long long __builtin_spu_cmpabseq_1(__vector double arg0, __vector double arg1);
#if __cplusplus
__vector unsigned int __builtin_spu_cmpabsgt(__vector float arg0, __vector float arg1);
__vector unsigned long long __builtin_spu_cmpabsgt(__vector double arg0, __vector double arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned int __builtin_spu_cmpabsgt_0(__vector float arg0, __vector float arg1);
__vector unsigned long long __builtin_spu_cmpabsgt_1(__vector double arg0, __vector double arg1);
#if __cplusplus
__vector unsigned char __builtin_spu_cmpeq(__vector unsigned char arg0, __vector unsigned char arg1);
__vector unsigned char __builtin_spu_cmpeq(__vector signed char arg0, __vector signed char arg1);
__vector unsigned short __builtin_spu_cmpeq(__vector unsigned short arg0, __vector unsigned short arg1);
__vector unsigned short __builtin_spu_cmpeq(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_cmpeq(__vector unsigned int arg0, __vector unsigned int arg1);
__vector unsigned int __builtin_spu_cmpeq(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_cmpeq(__vector float arg0, __vector float arg1);
__vector unsigned char __builtin_spu_cmpeq(__vector unsigned char arg0, unsigned char arg1);
__vector unsigned char __builtin_spu_cmpeq(__vector signed char arg0, signed char arg1);
__vector unsigned short __builtin_spu_cmpeq(__vector unsigned short arg0, unsigned short arg1);
__vector unsigned short __builtin_spu_cmpeq(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_cmpeq(__vector unsigned int arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_cmpeq(__vector signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_cmpeq(__vector double arg0, __vector double arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_cmpeq_0(__vector unsigned char arg0, __vector unsigned char arg1);
__vector unsigned char __builtin_spu_cmpeq_1(__vector signed char arg0, __vector signed char arg1);
__vector unsigned short __builtin_spu_cmpeq_2(__vector unsigned short arg0, __vector unsigned short arg1);
__vector unsigned short __builtin_spu_cmpeq_3(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_cmpeq_4(__vector unsigned int arg0, __vector unsigned int arg1);
__vector unsigned int __builtin_spu_cmpeq_5(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_cmpeq_6(__vector float arg0, __vector float arg1);
__vector unsigned char __builtin_spu_cmpeq_7(__vector unsigned char arg0, unsigned char arg1);
__vector unsigned char __builtin_spu_cmpeq_8(__vector signed char arg0, signed char arg1);
__vector unsigned short __builtin_spu_cmpeq_9(__vector unsigned short arg0, unsigned short arg1);
__vector unsigned short __builtin_spu_cmpeq_10(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_cmpeq_11(__vector unsigned int arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_cmpeq_12(__vector signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_cmpeq_13(__vector double arg0, __vector double arg1);
#if __cplusplus
__vector unsigned char __builtin_spu_cmpgt(__vector unsigned char arg0, __vector unsigned char arg1);
__vector unsigned char __builtin_spu_cmpgt(__vector signed char arg0, __vector signed char arg1);
__vector unsigned short __builtin_spu_cmpgt(__vector unsigned short arg0, __vector unsigned short arg1);
__vector unsigned short __builtin_spu_cmpgt(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_cmpgt(__vector unsigned int arg0, __vector unsigned int arg1);
__vector unsigned int __builtin_spu_cmpgt(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_cmpgt(__vector float arg0, __vector float arg1);
__vector unsigned char __builtin_spu_cmpgt(__vector unsigned char arg0, unsigned char arg1);
__vector unsigned char __builtin_spu_cmpgt(__vector signed char arg0, signed char arg1);
__vector unsigned short __builtin_spu_cmpgt(__vector unsigned short arg0, unsigned short arg1);
__vector unsigned short __builtin_spu_cmpgt(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_cmpgt(__vector signed int arg0, signed int arg1);
__vector unsigned int __builtin_spu_cmpgt(__vector unsigned int arg0, unsigned int arg1);
__vector unsigned long long __builtin_spu_cmpgt(__vector double arg0, __vector double arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_cmpgt_0(__vector unsigned char arg0, __vector unsigned char arg1);
__vector unsigned char __builtin_spu_cmpgt_1(__vector signed char arg0, __vector signed char arg1);
__vector unsigned short __builtin_spu_cmpgt_2(__vector unsigned short arg0, __vector unsigned short arg1);
__vector unsigned short __builtin_spu_cmpgt_3(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_cmpgt_4(__vector unsigned int arg0, __vector unsigned int arg1);
__vector unsigned int __builtin_spu_cmpgt_5(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_cmpgt_6(__vector float arg0, __vector float arg1);
__vector unsigned char __builtin_spu_cmpgt_7(__vector unsigned char arg0, unsigned char arg1);
__vector unsigned char __builtin_spu_cmpgt_8(__vector signed char arg0, signed char arg1);
__vector unsigned short __builtin_spu_cmpgt_9(__vector unsigned short arg0, unsigned short arg1);
__vector unsigned short __builtin_spu_cmpgt_10(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_cmpgt_11(__vector signed int arg0, signed int arg1);
__vector unsigned int __builtin_spu_cmpgt_12(__vector unsigned int arg0, unsigned int arg1);
__vector unsigned long long __builtin_spu_cmpgt_13(__vector double arg0, __vector double arg1);
#if __cplusplus
__vector unsigned char __builtin_spu_cntb(__vector signed char arg0);
__vector unsigned char __builtin_spu_cntb(__vector unsigned char arg0);
#else
void __builtin_spu_cntb();
#endif
__vector unsigned char __builtin_spu_cntb_0(__vector signed char arg0);
__vector unsigned char __builtin_spu_cntb_1(__vector unsigned char arg0);
#if __cplusplus
__vector unsigned int __builtin_spu_cntlz(__vector signed int arg0);
__vector unsigned int __builtin_spu_cntlz(__vector unsigned int arg0);
__vector unsigned int __builtin_spu_cntlz(__vector float arg0);
#else
void __builtin_spu_cntlz();
#endif
__vector unsigned int __builtin_spu_cntlz_0(__vector signed int arg0);
__vector unsigned int __builtin_spu_cntlz_1(__vector unsigned int arg0);
__vector unsigned int __builtin_spu_cntlz_2(__vector float arg0);
#if __cplusplus
__vector float __builtin_spu_convtf(__vector unsigned int arg0, unsigned int arg1);
__vector float __builtin_spu_convtf(__vector signed int arg0, unsigned int arg1);
#else
void __builtin_spu_convtf();
#endif
__vector float __builtin_spu_convtf_0(__vector unsigned int arg0, unsigned int arg1);
__vector float __builtin_spu_convtf_1(__vector signed int arg0, unsigned int arg1);
#if __cplusplus
__vector signed long long __builtin_spu_eqv(__vector signed long long arg0, __vector signed long long arg1);
__vector unsigned long long __builtin_spu_eqv(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed int __builtin_spu_eqv(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_eqv(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed short __builtin_spu_eqv(__vector signed short arg0, __vector signed short arg1);
__vector unsigned short __builtin_spu_eqv(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed char __builtin_spu_eqv(__vector signed char arg0, __vector signed char arg1);
__vector unsigned char __builtin_spu_eqv(__vector unsigned char arg0, __vector unsigned char arg1);
__vector float __builtin_spu_eqv(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_eqv(__vector double arg0, __vector double arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed long long __builtin_spu_eqv_0(__vector signed long long arg0, __vector signed long long arg1);
__vector unsigned long long __builtin_spu_eqv_1(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed int __builtin_spu_eqv_2(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_eqv_3(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed short __builtin_spu_eqv_4(__vector signed short arg0, __vector signed short arg1);
__vector unsigned short __builtin_spu_eqv_5(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed char __builtin_spu_eqv_6(__vector signed char arg0, __vector signed char arg1);
__vector unsigned char __builtin_spu_eqv_7(__vector unsigned char arg0, __vector unsigned char arg1);
__vector float __builtin_spu_eqv_8(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_eqv_9(__vector double arg0, __vector double arg1);
#if __cplusplus
__vector signed short __builtin_spu_extend(__vector signed char arg0);
__vector signed int __builtin_spu_extend(__vector signed short arg0);
__vector signed long long __builtin_spu_extend(__vector signed int arg0);
__vector double __builtin_spu_extend(__vector float arg0);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed short __builtin_spu_extend_0(__vector signed char arg0);
__vector signed int __builtin_spu_extend_1(__vector signed short arg0);
__vector signed long long __builtin_spu_extend_2(__vector signed int arg0);
__vector double __builtin_spu_extend_3(__vector float arg0);
#if __cplusplus
unsigned char __builtin_spu_extract(__vector unsigned char arg0, signed int arg1);
signed char __builtin_spu_extract(__vector signed char arg0, signed int arg1);
unsigned short __builtin_spu_extract(__vector unsigned short arg0, signed int arg1);
signed short __builtin_spu_extract(__vector signed short arg0, signed int arg1);
unsigned int __builtin_spu_extract(__vector unsigned int arg0, signed int arg1);
signed int __builtin_spu_extract(__vector signed int arg0, signed int arg1);
unsigned long long __builtin_spu_extract(__vector unsigned long long arg0, signed int arg1);
signed long long __builtin_spu_extract(__vector signed long long arg0, signed int arg1);
float __builtin_spu_extract(__vector float arg0, signed int arg1);
double __builtin_spu_extract(__vector double arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
unsigned char __builtin_spu_extract_0(__vector unsigned char arg0, signed int arg1);
signed char __builtin_spu_extract_1(__vector signed char arg0, signed int arg1);
unsigned short __builtin_spu_extract_2(__vector unsigned short arg0, signed int arg1);
signed short __builtin_spu_extract_3(__vector signed short arg0, signed int arg1);
unsigned int __builtin_spu_extract_4(__vector unsigned int arg0, signed int arg1);
signed int __builtin_spu_extract_5(__vector signed int arg0, signed int arg1);
unsigned long long __builtin_spu_extract_6(__vector unsigned long long arg0, signed int arg1);
signed long long __builtin_spu_extract_7(__vector signed long long arg0, signed int arg1);
float __builtin_spu_extract_8(__vector float arg0, signed int arg1);
double __builtin_spu_extract_9(__vector double arg0, signed int arg1);
#if __cplusplus
__vector unsigned int __builtin_spu_gather(__vector signed int arg0);
__vector unsigned int __builtin_spu_gather(__vector unsigned int arg0);
__vector unsigned int __builtin_spu_gather(__vector signed short arg0);
__vector unsigned int __builtin_spu_gather(__vector unsigned short arg0);
__vector unsigned int __builtin_spu_gather(__vector signed char arg0);
__vector unsigned int __builtin_spu_gather(__vector unsigned char arg0);
__vector unsigned int __builtin_spu_gather(__vector float arg0);
#else
void __builtin_spu_gather();
#endif
__vector unsigned int __builtin_spu_gather_0(__vector signed int arg0);
__vector unsigned int __builtin_spu_gather_1(__vector unsigned int arg0);
__vector unsigned int __builtin_spu_gather_2(__vector signed short arg0);
__vector unsigned int __builtin_spu_gather_3(__vector unsigned short arg0);
__vector unsigned int __builtin_spu_gather_4(__vector signed char arg0);
__vector unsigned int __builtin_spu_gather_5(__vector unsigned char arg0);
__vector unsigned int __builtin_spu_gather_6(__vector float arg0);
#if __cplusplus
__vector unsigned int __builtin_spu_genb(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_genb(__vector signed int arg0, __vector signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned int __builtin_spu_genb_0(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_genb_1(__vector signed int arg0, __vector signed int arg1);
#if __cplusplus
__vector unsigned int __builtin_spu_genbx(__vector unsigned int arg0, __vector unsigned int arg1, __vector unsigned int arg2);
__vector signed int __builtin_spu_genbx(__vector signed int arg0, __vector signed int arg1, __vector signed int arg2);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned int __builtin_spu_genbx_0(__vector unsigned int arg0, __vector unsigned int arg1, __vector unsigned int arg2);
__vector signed int __builtin_spu_genbx_1(__vector signed int arg0, __vector signed int arg1, __vector signed int arg2);
#if __cplusplus
__vector signed int __builtin_spu_genc(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_genc(__vector unsigned int arg0, __vector unsigned int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed int __builtin_spu_genc_0(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_genc_1(__vector unsigned int arg0, __vector unsigned int arg1);
#if __cplusplus
__vector signed int __builtin_spu_gencx(__vector signed int arg0, __vector signed int arg1, __vector signed int arg2);
__vector unsigned int __builtin_spu_gencx(__vector unsigned int arg0, __vector unsigned int arg1, __vector unsigned int arg2);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed int __builtin_spu_gencx_0(__vector signed int arg0, __vector signed int arg1, __vector signed int arg2);
__vector unsigned int __builtin_spu_gencx_1(__vector unsigned int arg0, __vector unsigned int arg1, __vector unsigned int arg2);
#if __cplusplus
void __builtin_spu_hcmpeq(signed int arg0, signed int arg1);
void __builtin_spu_hcmpeq(unsigned int arg0, unsigned int arg1);
#else
void __builtin_spu_hcmpeq();
#endif
void __builtin_spu_hcmpeq_0(signed int arg0, signed int arg1);
void __builtin_spu_hcmpeq_1(unsigned int arg0, unsigned int arg1);
#if __cplusplus
void __builtin_spu_hcmpgt(signed int arg0, signed int arg1);
void __builtin_spu_hcmpgt(unsigned int arg0, unsigned int arg1);
#else
void __builtin_spu_hcmpgt();
#endif
void __builtin_spu_hcmpgt_0(signed int arg0, signed int arg1);
void __builtin_spu_hcmpgt_1(unsigned int arg0, unsigned int arg1);
#if __cplusplus
__vector unsigned char __builtin_spu_insert(unsigned char arg0, __vector unsigned char arg1, signed int arg2);
__vector signed char __builtin_spu_insert(signed char arg0, __vector signed char arg1, signed int arg2);
__vector unsigned short __builtin_spu_insert(unsigned short arg0, __vector unsigned short arg1, signed int arg2);
__vector signed short __builtin_spu_insert(signed short arg0, __vector signed short arg1, signed int arg2);
__vector unsigned int __builtin_spu_insert(unsigned int arg0, __vector unsigned int arg1, signed int arg2);
__vector signed int __builtin_spu_insert(signed int arg0, __vector signed int arg1, signed int arg2);
__vector unsigned long long __builtin_spu_insert(unsigned long long arg0, __vector unsigned long long arg1, signed int arg2);
__vector signed long long __builtin_spu_insert(signed long long arg0, __vector signed long long arg1, signed int arg2);
__vector float __builtin_spu_insert(float arg0, __vector float arg1, signed int arg2);
__vector double __builtin_spu_insert(double arg0, __vector double arg1, signed int arg2);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_insert_0(unsigned char arg0, __vector unsigned char arg1, signed int arg2);
__vector signed char __builtin_spu_insert_1(signed char arg0, __vector signed char arg1, signed int arg2);
__vector unsigned short __builtin_spu_insert_2(unsigned short arg0, __vector unsigned short arg1, signed int arg2);
__vector signed short __builtin_spu_insert_3(signed short arg0, __vector signed short arg1, signed int arg2);
__vector unsigned int __builtin_spu_insert_4(unsigned int arg0, __vector unsigned int arg1, signed int arg2);
__vector signed int __builtin_spu_insert_5(signed int arg0, __vector signed int arg1, signed int arg2);
__vector unsigned long long __builtin_spu_insert_6(unsigned long long arg0, __vector unsigned long long arg1, signed int arg2);
__vector signed long long __builtin_spu_insert_7(signed long long arg0, __vector signed long long arg1, signed int arg2);
__vector float __builtin_spu_insert_8(float arg0, __vector float arg1, signed int arg2);
__vector double __builtin_spu_insert_9(double arg0, __vector double arg1, signed int arg2);
#if __cplusplus
__vector signed int __builtin_spu_madd(__vector signed short arg0, __vector signed short arg1, __vector signed int arg2);
__vector float __builtin_spu_madd(__vector float arg0, __vector float arg1, __vector float arg2);
__vector double __builtin_spu_madd(__vector double arg0, __vector double arg1, __vector double arg2);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed int __builtin_spu_madd_0(__vector signed short arg0, __vector signed short arg1, __vector signed int arg2);
__vector float __builtin_spu_madd_1(__vector float arg0, __vector float arg1, __vector float arg2);
__vector double __builtin_spu_madd_2(__vector double arg0, __vector double arg1, __vector double arg2);
#if __cplusplus
__vector unsigned char __builtin_spu_maskb(unsigned short arg0);
__vector unsigned char __builtin_spu_maskb(signed short arg0);
__vector unsigned char __builtin_spu_maskb(unsigned int arg0);
__vector unsigned char __builtin_spu_maskb(signed int arg0);
#else
void __builtin_spu_maskb();
#endif
__vector unsigned char __builtin_spu_maskb_0(unsigned short arg0);
__vector unsigned char __builtin_spu_maskb_1(signed short arg0);
__vector unsigned char __builtin_spu_maskb_2(unsigned int arg0);
__vector unsigned char __builtin_spu_maskb_3(signed int arg0);
#if __cplusplus
__vector unsigned short __builtin_spu_maskh(unsigned char arg0);
__vector unsigned short __builtin_spu_maskh(signed char arg0);
__vector unsigned short __builtin_spu_maskh(unsigned short arg0);
__vector unsigned short __builtin_spu_maskh(signed short arg0);
__vector unsigned short __builtin_spu_maskh(unsigned int arg0);
__vector unsigned short __builtin_spu_maskh(signed int arg0);
#else
void __builtin_spu_maskh();
#endif
__vector unsigned short __builtin_spu_maskh_0(unsigned char arg0);
__vector unsigned short __builtin_spu_maskh_1(signed char arg0);
__vector unsigned short __builtin_spu_maskh_2(unsigned short arg0);
__vector unsigned short __builtin_spu_maskh_3(signed short arg0);
__vector unsigned short __builtin_spu_maskh_4(unsigned int arg0);
__vector unsigned short __builtin_spu_maskh_5(signed int arg0);
#if __cplusplus
__vector unsigned int __builtin_spu_maskw(unsigned char arg0);
__vector unsigned int __builtin_spu_maskw(signed char arg0);
__vector unsigned int __builtin_spu_maskw(unsigned short arg0);
__vector unsigned int __builtin_spu_maskw(signed short arg0);
__vector unsigned int __builtin_spu_maskw(unsigned int arg0);
__vector unsigned int __builtin_spu_maskw(signed int arg0);
#else
void __builtin_spu_maskw();
#endif
__vector unsigned int __builtin_spu_maskw_0(unsigned char arg0);
__vector unsigned int __builtin_spu_maskw_1(signed char arg0);
__vector unsigned int __builtin_spu_maskw_2(unsigned short arg0);
__vector unsigned int __builtin_spu_maskw_3(signed short arg0);
__vector unsigned int __builtin_spu_maskw_4(unsigned int arg0);
__vector unsigned int __builtin_spu_maskw_5(signed int arg0);
#if __cplusplus
__vector unsigned int __builtin_spu_mhhadd(__vector unsigned short arg0, __vector unsigned short arg1, __vector unsigned int arg2);
__vector signed int __builtin_spu_mhhadd(__vector signed short arg0, __vector signed short arg1, __vector signed int arg2);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned int __builtin_spu_mhhadd_0(__vector unsigned short arg0, __vector unsigned short arg1, __vector unsigned int arg2);
__vector signed int __builtin_spu_mhhadd_1(__vector signed short arg0, __vector signed short arg1, __vector signed int arg2);
#if __cplusplus
__vector float __builtin_spu_msub(__vector float arg0, __vector float arg1, __vector float arg2);
__vector double __builtin_spu_msub(__vector double arg0, __vector double arg1, __vector double arg2);
#else
  /* No generic function generated since return types differ */
#endif
__vector float __builtin_spu_msub_0(__vector float arg0, __vector float arg1, __vector float arg2);
__vector double __builtin_spu_msub_1(__vector double arg0, __vector double arg1, __vector double arg2);
#if __cplusplus
__vector float __builtin_spu_mul(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_mul(__vector double arg0, __vector double arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector float __builtin_spu_mul_0(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_mul_1(__vector double arg0, __vector double arg1);
#if __cplusplus
__vector unsigned int __builtin_spu_mule(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed int __builtin_spu_mule(__vector signed short arg0, __vector signed short arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned int __builtin_spu_mule_0(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed int __builtin_spu_mule_1(__vector signed short arg0, __vector signed short arg1);
#if __cplusplus
__vector signed int __builtin_spu_mulo(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_mulo(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed int __builtin_spu_mulo(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_mulo(__vector unsigned short arg0, unsigned short arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed int __builtin_spu_mulo_0(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_mulo_1(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed int __builtin_spu_mulo_2(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_mulo_3(__vector unsigned short arg0, unsigned short arg1);
#if __cplusplus
__vector signed long long __builtin_spu_nand(__vector signed long long arg0, __vector signed long long arg1);
__vector unsigned long long __builtin_spu_nand(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed int __builtin_spu_nand(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_nand(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed short __builtin_spu_nand(__vector signed short arg0, __vector signed short arg1);
__vector unsigned short __builtin_spu_nand(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed char __builtin_spu_nand(__vector signed char arg0, __vector signed char arg1);
__vector unsigned char __builtin_spu_nand(__vector unsigned char arg0, __vector unsigned char arg1);
__vector float __builtin_spu_nand(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_nand(__vector double arg0, __vector double arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed long long __builtin_spu_nand_0(__vector signed long long arg0, __vector signed long long arg1);
__vector unsigned long long __builtin_spu_nand_1(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed int __builtin_spu_nand_2(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_nand_3(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed short __builtin_spu_nand_4(__vector signed short arg0, __vector signed short arg1);
__vector unsigned short __builtin_spu_nand_5(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed char __builtin_spu_nand_6(__vector signed char arg0, __vector signed char arg1);
__vector unsigned char __builtin_spu_nand_7(__vector unsigned char arg0, __vector unsigned char arg1);
__vector float __builtin_spu_nand_8(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_nand_9(__vector double arg0, __vector double arg1);
#if __cplusplus
__vector float __builtin_spu_nmsub(__vector float arg0, __vector float arg1, __vector float arg2);
__vector double __builtin_spu_nmsub(__vector double arg0, __vector double arg1, __vector double arg2);
#else
  /* No generic function generated since return types differ */
#endif
__vector float __builtin_spu_nmsub_0(__vector float arg0, __vector float arg1, __vector float arg2);
__vector double __builtin_spu_nmsub_1(__vector double arg0, __vector double arg1, __vector double arg2);
#if __cplusplus
__vector signed long long __builtin_spu_nor(__vector signed long long arg0, __vector signed long long arg1);
__vector unsigned long long __builtin_spu_nor(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed int __builtin_spu_nor(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_nor(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed short __builtin_spu_nor(__vector signed short arg0, __vector signed short arg1);
__vector unsigned short __builtin_spu_nor(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed char __builtin_spu_nor(__vector signed char arg0, __vector signed char arg1);
__vector unsigned char __builtin_spu_nor(__vector unsigned char arg0, __vector unsigned char arg1);
__vector float __builtin_spu_nor(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_nor(__vector double arg0, __vector double arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed long long __builtin_spu_nor_0(__vector signed long long arg0, __vector signed long long arg1);
__vector unsigned long long __builtin_spu_nor_1(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed int __builtin_spu_nor_2(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_nor_3(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed short __builtin_spu_nor_4(__vector signed short arg0, __vector signed short arg1);
__vector unsigned short __builtin_spu_nor_5(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed char __builtin_spu_nor_6(__vector signed char arg0, __vector signed char arg1);
__vector unsigned char __builtin_spu_nor_7(__vector unsigned char arg0, __vector unsigned char arg1);
__vector float __builtin_spu_nor_8(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_nor_9(__vector double arg0, __vector double arg1);
#if __cplusplus
__vector unsigned char __builtin_spu_or(__vector unsigned char arg0, __vector unsigned char arg1);
__vector signed char __builtin_spu_or(__vector signed char arg0, __vector signed char arg1);
__vector unsigned short __builtin_spu_or(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_or(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_or(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_or(__vector signed int arg0, __vector signed int arg1);
__vector unsigned long long __builtin_spu_or(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed long long __builtin_spu_or(__vector signed long long arg0, __vector signed long long arg1);
__vector float __builtin_spu_or(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_or(__vector double arg0, __vector double arg1);
__vector unsigned char __builtin_spu_or(__vector unsigned char arg0, unsigned char arg1);
__vector signed char __builtin_spu_or(__vector signed char arg0, signed char arg1);
__vector unsigned short __builtin_spu_or(__vector unsigned short arg0, unsigned short arg1);
__vector signed short __builtin_spu_or(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_or(__vector unsigned int arg0, unsigned int arg1);
__vector signed int __builtin_spu_or(__vector signed int arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_or_0(__vector unsigned char arg0, __vector unsigned char arg1);
__vector signed char __builtin_spu_or_1(__vector signed char arg0, __vector signed char arg1);
__vector unsigned short __builtin_spu_or_2(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_or_3(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_or_4(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_or_5(__vector signed int arg0, __vector signed int arg1);
__vector unsigned long long __builtin_spu_or_6(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed long long __builtin_spu_or_7(__vector signed long long arg0, __vector signed long long arg1);
__vector float __builtin_spu_or_8(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_or_9(__vector double arg0, __vector double arg1);
__vector unsigned char __builtin_spu_or_10(__vector unsigned char arg0, unsigned char arg1);
__vector signed char __builtin_spu_or_11(__vector signed char arg0, signed char arg1);
__vector unsigned short __builtin_spu_or_12(__vector unsigned short arg0, unsigned short arg1);
__vector signed short __builtin_spu_or_13(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_or_14(__vector unsigned int arg0, unsigned int arg1);
__vector signed int __builtin_spu_or_15(__vector signed int arg0, signed int arg1);
#if __cplusplus
__vector signed long long __builtin_spu_orc(__vector signed long long arg0, __vector signed long long arg1);
__vector unsigned long long __builtin_spu_orc(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed int __builtin_spu_orc(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_orc(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed short __builtin_spu_orc(__vector signed short arg0, __vector signed short arg1);
__vector unsigned short __builtin_spu_orc(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed char __builtin_spu_orc(__vector signed char arg0, __vector signed char arg1);
__vector unsigned char __builtin_spu_orc(__vector unsigned char arg0, __vector unsigned char arg1);
__vector float __builtin_spu_orc(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_orc(__vector double arg0, __vector double arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed long long __builtin_spu_orc_0(__vector signed long long arg0, __vector signed long long arg1);
__vector unsigned long long __builtin_spu_orc_1(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed int __builtin_spu_orc_2(__vector signed int arg0, __vector signed int arg1);
__vector unsigned int __builtin_spu_orc_3(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed short __builtin_spu_orc_4(__vector signed short arg0, __vector signed short arg1);
__vector unsigned short __builtin_spu_orc_5(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed char __builtin_spu_orc_6(__vector signed char arg0, __vector signed char arg1);
__vector unsigned char __builtin_spu_orc_7(__vector unsigned char arg0, __vector unsigned char arg1);
__vector float __builtin_spu_orc_8(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_orc_9(__vector double arg0, __vector double arg1);
#if __cplusplus
__vector signed int __builtin_spu_orx(__vector signed int arg0);
__vector unsigned int __builtin_spu_orx(__vector unsigned int arg0);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed int __builtin_spu_orx_0(__vector signed int arg0);
__vector unsigned int __builtin_spu_orx_1(__vector unsigned int arg0);
#if __cplusplus
__vector unsigned char __builtin_spu_promote(unsigned char arg0, signed int arg1);
__vector signed char __builtin_spu_promote(signed char arg0, signed int arg1);
__vector unsigned short __builtin_spu_promote(unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_promote(signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_promote(unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_promote(signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_promote(unsigned long long arg0, signed int arg1);
__vector signed long long __builtin_spu_promote(signed long long arg0, signed int arg1);
__vector float __builtin_spu_promote(float arg0, signed int arg1);
__vector double __builtin_spu_promote(double arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_promote_0(unsigned char arg0, signed int arg1);
__vector signed char __builtin_spu_promote_1(signed char arg0, signed int arg1);
__vector unsigned short __builtin_spu_promote_2(unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_promote_3(signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_promote_4(unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_promote_5(signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_promote_6(unsigned long long arg0, signed int arg1);
__vector signed long long __builtin_spu_promote_7(signed long long arg0, signed int arg1);
__vector float __builtin_spu_promote_8(float arg0, signed int arg1);
__vector double __builtin_spu_promote_9(double arg0, signed int arg1);
#if __cplusplus
__vector unsigned short __builtin_spu_rl(__vector unsigned short arg0, __vector signed short arg1);
__vector signed short __builtin_spu_rl(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_rl(__vector unsigned int arg0, __vector signed int arg1);
__vector signed int __builtin_spu_rl(__vector signed int arg0, __vector signed int arg1);
__vector unsigned short __builtin_spu_rl(__vector unsigned short arg0, signed short arg1);
__vector signed short __builtin_spu_rl(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_rl(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rl(__vector signed int arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned short __builtin_spu_rl_0(__vector unsigned short arg0, __vector signed short arg1);
__vector signed short __builtin_spu_rl_1(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_rl_2(__vector unsigned int arg0, __vector signed int arg1);
__vector signed int __builtin_spu_rl_3(__vector signed int arg0, __vector signed int arg1);
__vector unsigned short __builtin_spu_rl_4(__vector unsigned short arg0, signed short arg1);
__vector signed short __builtin_spu_rl_5(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_rl_6(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rl_7(__vector signed int arg0, signed int arg1);
#if __cplusplus
__vector unsigned short __builtin_spu_rlmask(__vector unsigned short arg0, __vector signed short arg1);
__vector signed short __builtin_spu_rlmask(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_rlmask(__vector unsigned int arg0, __vector signed int arg1);
__vector signed int __builtin_spu_rlmask(__vector signed int arg0, __vector signed int arg1);
__vector unsigned short __builtin_spu_rlmask(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlmask(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlmask(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlmask(__vector signed int arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned short __builtin_spu_rlmask_0(__vector unsigned short arg0, __vector signed short arg1);
__vector signed short __builtin_spu_rlmask_1(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_rlmask_2(__vector unsigned int arg0, __vector signed int arg1);
__vector signed int __builtin_spu_rlmask_3(__vector signed int arg0, __vector signed int arg1);
__vector unsigned short __builtin_spu_rlmask_4(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlmask_5(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlmask_6(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlmask_7(__vector signed int arg0, signed int arg1);
#if __cplusplus
__vector unsigned short __builtin_spu_rlmaska(__vector unsigned short arg0, __vector signed short arg1);
__vector signed short __builtin_spu_rlmaska(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_rlmaska(__vector unsigned int arg0, __vector signed int arg1);
__vector signed int __builtin_spu_rlmaska(__vector signed int arg0, __vector signed int arg1);
__vector unsigned short __builtin_spu_rlmaska(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlmaska(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlmaska(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlmaska(__vector signed int arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned short __builtin_spu_rlmaska_0(__vector unsigned short arg0, __vector signed short arg1);
__vector signed short __builtin_spu_rlmaska_1(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_rlmaska_2(__vector unsigned int arg0, __vector signed int arg1);
__vector signed int __builtin_spu_rlmaska_3(__vector signed int arg0, __vector signed int arg1);
__vector unsigned short __builtin_spu_rlmaska_4(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlmaska_5(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlmaska_6(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlmaska_7(__vector signed int arg0, signed int arg1);
#if __cplusplus
__vector unsigned char __builtin_spu_rlmaskqw(__vector unsigned char arg0, signed int arg1);
__vector signed char __builtin_spu_rlmaskqw(__vector signed char arg0, signed int arg1);
__vector unsigned short __builtin_spu_rlmaskqw(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlmaskqw(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlmaskqw(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlmaskqw(__vector signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_rlmaskqw(__vector unsigned long long arg0, signed int arg1);
__vector signed long long __builtin_spu_rlmaskqw(__vector signed long long arg0, signed int arg1);
__vector float __builtin_spu_rlmaskqw(__vector float arg0, signed int arg1);
__vector double __builtin_spu_rlmaskqw(__vector double arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_rlmaskqw_0(__vector unsigned char arg0, signed int arg1);
__vector signed char __builtin_spu_rlmaskqw_1(__vector signed char arg0, signed int arg1);
__vector unsigned short __builtin_spu_rlmaskqw_2(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlmaskqw_3(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlmaskqw_4(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlmaskqw_5(__vector signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_rlmaskqw_6(__vector unsigned long long arg0, signed int arg1);
__vector signed long long __builtin_spu_rlmaskqw_7(__vector signed long long arg0, signed int arg1);
__vector float __builtin_spu_rlmaskqw_8(__vector float arg0, signed int arg1);
__vector double __builtin_spu_rlmaskqw_9(__vector double arg0, signed int arg1);
#if __cplusplus
__vector unsigned char __builtin_spu_rlmaskqwbyte(__vector unsigned char arg0, signed int arg1);
__vector signed char __builtin_spu_rlmaskqwbyte(__vector signed char arg0, signed int arg1);
__vector unsigned short __builtin_spu_rlmaskqwbyte(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlmaskqwbyte(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlmaskqwbyte(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlmaskqwbyte(__vector signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_rlmaskqwbyte(__vector unsigned long long arg0, signed int arg1);
__vector signed long long __builtin_spu_rlmaskqwbyte(__vector signed long long arg0, signed int arg1);
__vector float __builtin_spu_rlmaskqwbyte(__vector float arg0, signed int arg1);
__vector double __builtin_spu_rlmaskqwbyte(__vector double arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_rlmaskqwbyte_0(__vector unsigned char arg0, signed int arg1);
__vector signed char __builtin_spu_rlmaskqwbyte_1(__vector signed char arg0, signed int arg1);
__vector unsigned short __builtin_spu_rlmaskqwbyte_2(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlmaskqwbyte_3(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlmaskqwbyte_4(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlmaskqwbyte_5(__vector signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_rlmaskqwbyte_6(__vector unsigned long long arg0, signed int arg1);
__vector signed long long __builtin_spu_rlmaskqwbyte_7(__vector signed long long arg0, signed int arg1);
__vector float __builtin_spu_rlmaskqwbyte_8(__vector float arg0, signed int arg1);
__vector double __builtin_spu_rlmaskqwbyte_9(__vector double arg0, signed int arg1);
#if __cplusplus
__vector unsigned char __builtin_spu_rlmaskqwbytebc(__vector unsigned char arg0, signed int arg1);
__vector signed char __builtin_spu_rlmaskqwbytebc(__vector signed char arg0, signed int arg1);
__vector unsigned short __builtin_spu_rlmaskqwbytebc(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlmaskqwbytebc(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlmaskqwbytebc(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlmaskqwbytebc(__vector signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_rlmaskqwbytebc(__vector unsigned long long arg0, signed int arg1);
__vector signed long long __builtin_spu_rlmaskqwbytebc(__vector signed long long arg0, signed int arg1);
__vector float __builtin_spu_rlmaskqwbytebc(__vector float arg0, signed int arg1);
__vector double __builtin_spu_rlmaskqwbytebc(__vector double arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_rlmaskqwbytebc_0(__vector unsigned char arg0, signed int arg1);
__vector signed char __builtin_spu_rlmaskqwbytebc_1(__vector signed char arg0, signed int arg1);
__vector unsigned short __builtin_spu_rlmaskqwbytebc_2(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlmaskqwbytebc_3(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlmaskqwbytebc_4(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlmaskqwbytebc_5(__vector signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_rlmaskqwbytebc_6(__vector unsigned long long arg0, signed int arg1);
__vector signed long long __builtin_spu_rlmaskqwbytebc_7(__vector signed long long arg0, signed int arg1);
__vector float __builtin_spu_rlmaskqwbytebc_8(__vector float arg0, signed int arg1);
__vector double __builtin_spu_rlmaskqwbytebc_9(__vector double arg0, signed int arg1);
#if __cplusplus
__vector unsigned char __builtin_spu_rlqw(__vector unsigned char arg0, signed int arg1);
__vector signed char __builtin_spu_rlqw(__vector signed char arg0, signed int arg1);
__vector unsigned short __builtin_spu_rlqw(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlqw(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlqw(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlqw(__vector signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_rlqw(__vector unsigned long long arg0, signed int arg1);
__vector signed long long __builtin_spu_rlqw(__vector signed long long arg0, signed int arg1);
__vector float __builtin_spu_rlqw(__vector float arg0, signed int arg1);
__vector double __builtin_spu_rlqw(__vector double arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_rlqw_0(__vector unsigned char arg0, signed int arg1);
__vector signed char __builtin_spu_rlqw_1(__vector signed char arg0, signed int arg1);
__vector unsigned short __builtin_spu_rlqw_2(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlqw_3(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlqw_4(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlqw_5(__vector signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_rlqw_6(__vector unsigned long long arg0, signed int arg1);
__vector signed long long __builtin_spu_rlqw_7(__vector signed long long arg0, signed int arg1);
__vector float __builtin_spu_rlqw_8(__vector float arg0, signed int arg1);
__vector double __builtin_spu_rlqw_9(__vector double arg0, signed int arg1);
#if __cplusplus
__vector unsigned char __builtin_spu_rlqwbyte(__vector unsigned char arg0, signed int arg1);
__vector signed char __builtin_spu_rlqwbyte(__vector signed char arg0, signed int arg1);
__vector unsigned short __builtin_spu_rlqwbyte(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlqwbyte(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlqwbyte(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlqwbyte(__vector signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_rlqwbyte(__vector unsigned long long arg0, signed int arg1);
__vector signed long long __builtin_spu_rlqwbyte(__vector signed long long arg0, signed int arg1);
__vector float __builtin_spu_rlqwbyte(__vector float arg0, signed int arg1);
__vector double __builtin_spu_rlqwbyte(__vector double arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_rlqwbyte_0(__vector unsigned char arg0, signed int arg1);
__vector signed char __builtin_spu_rlqwbyte_1(__vector signed char arg0, signed int arg1);
__vector unsigned short __builtin_spu_rlqwbyte_2(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlqwbyte_3(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlqwbyte_4(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlqwbyte_5(__vector signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_rlqwbyte_6(__vector unsigned long long arg0, signed int arg1);
__vector signed long long __builtin_spu_rlqwbyte_7(__vector signed long long arg0, signed int arg1);
__vector float __builtin_spu_rlqwbyte_8(__vector float arg0, signed int arg1);
__vector double __builtin_spu_rlqwbyte_9(__vector double arg0, signed int arg1);
#if __cplusplus
__vector unsigned char __builtin_spu_rlqwbytebc(__vector unsigned char arg0, signed int arg1);
__vector signed char __builtin_spu_rlqwbytebc(__vector signed char arg0, signed int arg1);
__vector unsigned short __builtin_spu_rlqwbytebc(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlqwbytebc(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlqwbytebc(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlqwbytebc(__vector signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_rlqwbytebc(__vector unsigned long long arg0, signed int arg1);
__vector signed long long __builtin_spu_rlqwbytebc(__vector signed long long arg0, signed int arg1);
__vector float __builtin_spu_rlqwbytebc(__vector float arg0, signed int arg1);
__vector double __builtin_spu_rlqwbytebc(__vector double arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_rlqwbytebc_0(__vector unsigned char arg0, signed int arg1);
__vector signed char __builtin_spu_rlqwbytebc_1(__vector signed char arg0, signed int arg1);
__vector unsigned short __builtin_spu_rlqwbytebc_2(__vector unsigned short arg0, signed int arg1);
__vector signed short __builtin_spu_rlqwbytebc_3(__vector signed short arg0, signed int arg1);
__vector unsigned int __builtin_spu_rlqwbytebc_4(__vector unsigned int arg0, signed int arg1);
__vector signed int __builtin_spu_rlqwbytebc_5(__vector signed int arg0, signed int arg1);
__vector unsigned long long __builtin_spu_rlqwbytebc_6(__vector unsigned long long arg0, signed int arg1);
__vector signed long long __builtin_spu_rlqwbytebc_7(__vector signed long long arg0, signed int arg1);
__vector float __builtin_spu_rlqwbytebc_8(__vector float arg0, signed int arg1);
__vector double __builtin_spu_rlqwbytebc_9(__vector double arg0, signed int arg1);
#if __cplusplus
__vector signed long long __builtin_spu_sel(__vector signed long long arg0, __vector signed long long arg1, __vector unsigned long long arg2);
__vector unsigned long long __builtin_spu_sel(__vector unsigned long long arg0, __vector unsigned long long arg1, __vector unsigned long long arg2);
__vector signed int __builtin_spu_sel(__vector signed int arg0, __vector signed int arg1, __vector unsigned int arg2);
__vector unsigned int __builtin_spu_sel(__vector unsigned int arg0, __vector unsigned int arg1, __vector unsigned int arg2);
__vector signed short __builtin_spu_sel(__vector signed short arg0, __vector signed short arg1, __vector unsigned short arg2);
__vector unsigned short __builtin_spu_sel(__vector unsigned short arg0, __vector unsigned short arg1, __vector unsigned short arg2);
__vector signed char __builtin_spu_sel(__vector signed char arg0, __vector signed char arg1, __vector unsigned char arg2);
__vector unsigned char __builtin_spu_sel(__vector unsigned char arg0, __vector unsigned char arg1, __vector unsigned char arg2);
__vector float __builtin_spu_sel(__vector float arg0, __vector float arg1, __vector unsigned int arg2);
__vector double __builtin_spu_sel(__vector double arg0, __vector double arg1, __vector unsigned long long arg2);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed long long __builtin_spu_sel_0(__vector signed long long arg0, __vector signed long long arg1, __vector unsigned long long arg2);
__vector signed long long __builtin_spu_sel_0o(__vector signed long long arg0, __vector signed long long arg1, __vector unsigned char arg2);
__vector unsigned long long __builtin_spu_sel_1(__vector unsigned long long arg0, __vector unsigned long long arg1, __vector unsigned long long arg2);
__vector unsigned long long __builtin_spu_sel_1o(__vector unsigned long long arg0, __vector unsigned long long arg1, __vector unsigned char arg2);
__vector signed int __builtin_spu_sel_2(__vector signed int arg0, __vector signed int arg1, __vector unsigned int arg2);
__vector signed int __builtin_spu_sel_2o(__vector signed int arg0, __vector signed int arg1, __vector unsigned char arg2);
__vector unsigned int __builtin_spu_sel_3(__vector unsigned int arg0, __vector unsigned int arg1, __vector unsigned int arg2);
__vector unsigned int __builtin_spu_sel_3o(__vector unsigned int arg0, __vector unsigned int arg1, __vector unsigned char arg2);
__vector signed short __builtin_spu_sel_4(__vector signed short arg0, __vector signed short arg1, __vector unsigned short arg2);
__vector signed short __builtin_spu_sel_4o(__vector signed short arg0, __vector signed short arg1, __vector unsigned char arg2);
__vector unsigned short __builtin_spu_sel_5(__vector unsigned short arg0, __vector unsigned short arg1, __vector unsigned short arg2);
__vector unsigned short __builtin_spu_sel_5o(__vector unsigned short arg0, __vector unsigned short arg1, __vector unsigned char arg2);
__vector signed char __builtin_spu_sel_6(__vector signed char arg0, __vector signed char arg1, __vector unsigned char arg2);
__vector unsigned char __builtin_spu_sel_7(__vector unsigned char arg0, __vector unsigned char arg1, __vector unsigned char arg2);
__vector float __builtin_spu_sel_8(__vector float arg0, __vector float arg1, __vector unsigned int arg2);
__vector float __builtin_spu_sel_8o(__vector float arg0, __vector float arg1, __vector unsigned char arg2);
__vector double __builtin_spu_sel_9(__vector double arg0, __vector double arg1, __vector unsigned long long arg2);
__vector double __builtin_spu_sel_9o(__vector double arg0, __vector double arg1, __vector unsigned char arg2);
#if __cplusplus
__vector unsigned char __builtin_spu_shuffle(__vector unsigned char arg0, __vector unsigned char arg1, __vector unsigned char arg2);
__vector signed char __builtin_spu_shuffle(__vector signed char arg0, __vector signed char arg1, __vector unsigned char arg2);
__vector unsigned short __builtin_spu_shuffle(__vector unsigned short arg0, __vector unsigned short arg1, __vector unsigned char arg2);
__vector signed short __builtin_spu_shuffle(__vector signed short arg0, __vector signed short arg1, __vector unsigned char arg2);
__vector unsigned int __builtin_spu_shuffle(__vector unsigned int arg0, __vector unsigned int arg1, __vector unsigned char arg2);
__vector signed int __builtin_spu_shuffle(__vector signed int arg0, __vector signed int arg1, __vector unsigned char arg2);
__vector unsigned long long __builtin_spu_shuffle(__vector unsigned long long arg0, __vector unsigned long long arg1, __vector unsigned char arg2);
__vector signed long long __builtin_spu_shuffle(__vector signed long long arg0, __vector signed long long arg1, __vector unsigned char arg2);
__vector float __builtin_spu_shuffle(__vector float arg0, __vector float arg1, __vector unsigned char arg2);
__vector double __builtin_spu_shuffle(__vector double arg0, __vector double arg1, __vector unsigned char arg2);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_shuffle_0(__vector unsigned char arg0, __vector unsigned char arg1, __vector unsigned char arg2);
__vector signed char __builtin_spu_shuffle_1(__vector signed char arg0, __vector signed char arg1, __vector unsigned char arg2);
__vector unsigned short __builtin_spu_shuffle_2(__vector unsigned short arg0, __vector unsigned short arg1, __vector unsigned char arg2);
__vector signed short __builtin_spu_shuffle_3(__vector signed short arg0, __vector signed short arg1, __vector unsigned char arg2);
__vector unsigned int __builtin_spu_shuffle_4(__vector unsigned int arg0, __vector unsigned int arg1, __vector unsigned char arg2);
__vector signed int __builtin_spu_shuffle_5(__vector signed int arg0, __vector signed int arg1, __vector unsigned char arg2);
__vector unsigned long long __builtin_spu_shuffle_6(__vector unsigned long long arg0, __vector unsigned long long arg1, __vector unsigned char arg2);
__vector signed long long __builtin_spu_shuffle_7(__vector signed long long arg0, __vector signed long long arg1, __vector unsigned char arg2);
__vector float __builtin_spu_shuffle_8(__vector float arg0, __vector float arg1, __vector unsigned char arg2);
__vector double __builtin_spu_shuffle_9(__vector double arg0, __vector double arg1, __vector unsigned char arg2);
#if __cplusplus
__vector unsigned short __builtin_spu_sl(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_sl(__vector signed short arg0, __vector unsigned short arg1);
__vector unsigned int __builtin_spu_sl(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_sl(__vector signed int arg0, __vector unsigned int arg1);
__vector unsigned short __builtin_spu_sl(__vector unsigned short arg0, unsigned int arg1);
__vector signed short __builtin_spu_sl(__vector signed short arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_sl(__vector unsigned int arg0, unsigned int arg1);
__vector signed int __builtin_spu_sl(__vector signed int arg0, unsigned int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned short __builtin_spu_sl_0(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_sl_1(__vector signed short arg0, __vector unsigned short arg1);
__vector unsigned int __builtin_spu_sl_2(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_sl_3(__vector signed int arg0, __vector unsigned int arg1);
__vector unsigned short __builtin_spu_sl_4(__vector unsigned short arg0, unsigned int arg1);
__vector signed short __builtin_spu_sl_5(__vector signed short arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_sl_6(__vector unsigned int arg0, unsigned int arg1);
__vector signed int __builtin_spu_sl_7(__vector signed int arg0, unsigned int arg1);
#if __cplusplus
__vector signed long long __builtin_spu_slqw(__vector signed long long arg0, unsigned int arg1);
__vector unsigned long long __builtin_spu_slqw(__vector unsigned long long arg0, unsigned int arg1);
__vector signed int __builtin_spu_slqw(__vector signed int arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_slqw(__vector unsigned int arg0, unsigned int arg1);
__vector signed short __builtin_spu_slqw(__vector signed short arg0, unsigned int arg1);
__vector unsigned short __builtin_spu_slqw(__vector unsigned short arg0, unsigned int arg1);
__vector signed char __builtin_spu_slqw(__vector signed char arg0, unsigned int arg1);
__vector unsigned char __builtin_spu_slqw(__vector unsigned char arg0, unsigned int arg1);
__vector float __builtin_spu_slqw(__vector float arg0, unsigned int arg1);
__vector double __builtin_spu_slqw(__vector double arg0, unsigned int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed long long __builtin_spu_slqw_0(__vector signed long long arg0, unsigned int arg1);
__vector unsigned long long __builtin_spu_slqw_1(__vector unsigned long long arg0, unsigned int arg1);
__vector signed int __builtin_spu_slqw_2(__vector signed int arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_slqw_3(__vector unsigned int arg0, unsigned int arg1);
__vector signed short __builtin_spu_slqw_4(__vector signed short arg0, unsigned int arg1);
__vector unsigned short __builtin_spu_slqw_5(__vector unsigned short arg0, unsigned int arg1);
__vector signed char __builtin_spu_slqw_6(__vector signed char arg0, unsigned int arg1);
__vector unsigned char __builtin_spu_slqw_7(__vector unsigned char arg0, unsigned int arg1);
__vector float __builtin_spu_slqw_8(__vector float arg0, unsigned int arg1);
__vector double __builtin_spu_slqw_9(__vector double arg0, unsigned int arg1);
#if __cplusplus
__vector signed long long __builtin_spu_slqwbyte(__vector signed long long arg0, unsigned int arg1);
__vector unsigned long long __builtin_spu_slqwbyte(__vector unsigned long long arg0, unsigned int arg1);
__vector signed int __builtin_spu_slqwbyte(__vector signed int arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_slqwbyte(__vector unsigned int arg0, unsigned int arg1);
__vector signed short __builtin_spu_slqwbyte(__vector signed short arg0, unsigned int arg1);
__vector unsigned short __builtin_spu_slqwbyte(__vector unsigned short arg0, unsigned int arg1);
__vector signed char __builtin_spu_slqwbyte(__vector signed char arg0, unsigned int arg1);
__vector unsigned char __builtin_spu_slqwbyte(__vector unsigned char arg0, unsigned int arg1);
__vector float __builtin_spu_slqwbyte(__vector float arg0, unsigned int arg1);
__vector double __builtin_spu_slqwbyte(__vector double arg0, unsigned int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed long long __builtin_spu_slqwbyte_0(__vector signed long long arg0, unsigned int arg1);
__vector unsigned long long __builtin_spu_slqwbyte_1(__vector unsigned long long arg0, unsigned int arg1);
__vector signed int __builtin_spu_slqwbyte_2(__vector signed int arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_slqwbyte_3(__vector unsigned int arg0, unsigned int arg1);
__vector signed short __builtin_spu_slqwbyte_4(__vector signed short arg0, unsigned int arg1);
__vector unsigned short __builtin_spu_slqwbyte_5(__vector unsigned short arg0, unsigned int arg1);
__vector signed char __builtin_spu_slqwbyte_6(__vector signed char arg0, unsigned int arg1);
__vector unsigned char __builtin_spu_slqwbyte_7(__vector unsigned char arg0, unsigned int arg1);
__vector float __builtin_spu_slqwbyte_8(__vector float arg0, unsigned int arg1);
__vector double __builtin_spu_slqwbyte_9(__vector double arg0, unsigned int arg1);
#if __cplusplus
__vector signed long long __builtin_spu_slqwbytebc(__vector signed long long arg0, unsigned int arg1);
__vector unsigned long long __builtin_spu_slqwbytebc(__vector unsigned long long arg0, unsigned int arg1);
__vector signed int __builtin_spu_slqwbytebc(__vector signed int arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_slqwbytebc(__vector unsigned int arg0, unsigned int arg1);
__vector signed short __builtin_spu_slqwbytebc(__vector signed short arg0, unsigned int arg1);
__vector unsigned short __builtin_spu_slqwbytebc(__vector unsigned short arg0, unsigned int arg1);
__vector signed char __builtin_spu_slqwbytebc(__vector signed char arg0, unsigned int arg1);
__vector unsigned char __builtin_spu_slqwbytebc(__vector unsigned char arg0, unsigned int arg1);
__vector float __builtin_spu_slqwbytebc(__vector float arg0, unsigned int arg1);
__vector double __builtin_spu_slqwbytebc(__vector double arg0, unsigned int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed long long __builtin_spu_slqwbytebc_0(__vector signed long long arg0, unsigned int arg1);
__vector unsigned long long __builtin_spu_slqwbytebc_1(__vector unsigned long long arg0, unsigned int arg1);
__vector signed int __builtin_spu_slqwbytebc_2(__vector signed int arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_slqwbytebc_3(__vector unsigned int arg0, unsigned int arg1);
__vector signed short __builtin_spu_slqwbytebc_4(__vector signed short arg0, unsigned int arg1);
__vector unsigned short __builtin_spu_slqwbytebc_5(__vector unsigned short arg0, unsigned int arg1);
__vector signed char __builtin_spu_slqwbytebc_6(__vector signed char arg0, unsigned int arg1);
__vector unsigned char __builtin_spu_slqwbytebc_7(__vector unsigned char arg0, unsigned int arg1);
__vector float __builtin_spu_slqwbytebc_8(__vector float arg0, unsigned int arg1);
__vector double __builtin_spu_slqwbytebc_9(__vector double arg0, unsigned int arg1);
#if __cplusplus
__vector unsigned char __builtin_spu_splats(unsigned char arg0);
__vector signed char __builtin_spu_splats(signed char arg0);
__vector unsigned short __builtin_spu_splats(unsigned short arg0);
__vector signed short __builtin_spu_splats(signed short arg0);
__vector unsigned int __builtin_spu_splats(unsigned int arg0);
__vector signed int __builtin_spu_splats(signed int arg0);
__vector unsigned long long __builtin_spu_splats(unsigned long long arg0);
__vector signed long long __builtin_spu_splats(signed long long arg0);
__vector float __builtin_spu_splats(float arg0);
__vector double __builtin_spu_splats(double arg0);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_splats_0(unsigned char arg0);
__vector signed char __builtin_spu_splats_1(signed char arg0);
__vector unsigned short __builtin_spu_splats_2(unsigned short arg0);
__vector signed short __builtin_spu_splats_3(signed short arg0);
__vector unsigned int __builtin_spu_splats_4(unsigned int arg0);
__vector signed int __builtin_spu_splats_5(signed int arg0);
__vector unsigned long long __builtin_spu_splats_6(unsigned long long arg0);
__vector signed long long __builtin_spu_splats_7(signed long long arg0);
__vector float __builtin_spu_splats_8(float arg0);
__vector double __builtin_spu_splats_9(double arg0);
#if __cplusplus
__vector unsigned short __builtin_spu_sr(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_sr(__vector signed short arg0, __vector unsigned short arg1);
__vector unsigned int __builtin_spu_sr(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_sr(__vector signed int arg0, __vector unsigned int arg1);
__vector unsigned short __builtin_spu_sr(__vector unsigned short arg0, unsigned int arg1);
__vector signed short __builtin_spu_sr(__vector signed short arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_sr(__vector unsigned int arg0, unsigned int arg1);
__vector signed int __builtin_spu_sr(__vector signed int arg0, unsigned int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned short __builtin_spu_sr_0(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_sr_1(__vector signed short arg0, __vector unsigned short arg1);
__vector unsigned int __builtin_spu_sr_2(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_sr_3(__vector signed int arg0, __vector unsigned int arg1);
__vector unsigned short __builtin_spu_sr_4(__vector unsigned short arg0, unsigned int arg1);
__vector signed short __builtin_spu_sr_5(__vector signed short arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_sr_6(__vector unsigned int arg0, unsigned int arg1);
__vector signed int __builtin_spu_sr_7(__vector signed int arg0, unsigned int arg1);
#if __cplusplus
__vector unsigned short __builtin_spu_sra(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_sra(__vector signed short arg0, __vector unsigned short arg1);
__vector unsigned int __builtin_spu_sra(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_sra(__vector signed int arg0, __vector unsigned int arg1);
__vector unsigned short __builtin_spu_sra(__vector unsigned short arg0, unsigned int arg1);
__vector signed short __builtin_spu_sra(__vector signed short arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_sra(__vector unsigned int arg0, unsigned int arg1);
__vector signed int __builtin_spu_sra(__vector signed int arg0, unsigned int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned short __builtin_spu_sra_0(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_sra_1(__vector signed short arg0, __vector unsigned short arg1);
__vector unsigned int __builtin_spu_sra_2(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_sra_3(__vector signed int arg0, __vector unsigned int arg1);
__vector unsigned short __builtin_spu_sra_4(__vector unsigned short arg0, unsigned int arg1);
__vector signed short __builtin_spu_sra_5(__vector signed short arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_sra_6(__vector unsigned int arg0, unsigned int arg1);
__vector signed int __builtin_spu_sra_7(__vector signed int arg0, unsigned int arg1);
#if __cplusplus
__vector signed long long __builtin_spu_srqw(__vector signed long long arg0, unsigned int arg1);
__vector unsigned long long __builtin_spu_srqw(__vector unsigned long long arg0, unsigned int arg1);
__vector signed int __builtin_spu_srqw(__vector signed int arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_srqw(__vector unsigned int arg0, unsigned int arg1);
__vector signed short __builtin_spu_srqw(__vector signed short arg0, unsigned int arg1);
__vector unsigned short __builtin_spu_srqw(__vector unsigned short arg0, unsigned int arg1);
__vector signed char __builtin_spu_srqw(__vector signed char arg0, unsigned int arg1);
__vector unsigned char __builtin_spu_srqw(__vector unsigned char arg0, unsigned int arg1);
__vector float __builtin_spu_srqw(__vector float arg0, unsigned int arg1);
__vector double __builtin_spu_srqw(__vector double arg0, unsigned int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed long long __builtin_spu_srqw_0(__vector signed long long arg0, unsigned int arg1);
__vector unsigned long long __builtin_spu_srqw_1(__vector unsigned long long arg0, unsigned int arg1);
__vector signed int __builtin_spu_srqw_2(__vector signed int arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_srqw_3(__vector unsigned int arg0, unsigned int arg1);
__vector signed short __builtin_spu_srqw_4(__vector signed short arg0, unsigned int arg1);
__vector unsigned short __builtin_spu_srqw_5(__vector unsigned short arg0, unsigned int arg1);
__vector signed char __builtin_spu_srqw_6(__vector signed char arg0, unsigned int arg1);
__vector unsigned char __builtin_spu_srqw_7(__vector unsigned char arg0, unsigned int arg1);
__vector float __builtin_spu_srqw_8(__vector float arg0, unsigned int arg1);
__vector double __builtin_spu_srqw_9(__vector double arg0, unsigned int arg1);
#if __cplusplus
__vector signed long long __builtin_spu_srqwbyte(__vector signed long long arg0, unsigned int arg1);
__vector unsigned long long __builtin_spu_srqwbyte(__vector unsigned long long arg0, unsigned int arg1);
__vector signed int __builtin_spu_srqwbyte(__vector signed int arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_srqwbyte(__vector unsigned int arg0, unsigned int arg1);
__vector signed short __builtin_spu_srqwbyte(__vector signed short arg0, unsigned int arg1);
__vector unsigned short __builtin_spu_srqwbyte(__vector unsigned short arg0, unsigned int arg1);
__vector signed char __builtin_spu_srqwbyte(__vector signed char arg0, unsigned int arg1);
__vector unsigned char __builtin_spu_srqwbyte(__vector unsigned char arg0, unsigned int arg1);
__vector float __builtin_spu_srqwbyte(__vector float arg0, unsigned int arg1);
__vector double __builtin_spu_srqwbyte(__vector double arg0, unsigned int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed long long __builtin_spu_srqwbyte_0(__vector signed long long arg0, unsigned int arg1);
__vector unsigned long long __builtin_spu_srqwbyte_1(__vector unsigned long long arg0, unsigned int arg1);
__vector signed int __builtin_spu_srqwbyte_2(__vector signed int arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_srqwbyte_3(__vector unsigned int arg0, unsigned int arg1);
__vector signed short __builtin_spu_srqwbyte_4(__vector signed short arg0, unsigned int arg1);
__vector unsigned short __builtin_spu_srqwbyte_5(__vector unsigned short arg0, unsigned int arg1);
__vector signed char __builtin_spu_srqwbyte_6(__vector signed char arg0, unsigned int arg1);
__vector unsigned char __builtin_spu_srqwbyte_7(__vector unsigned char arg0, unsigned int arg1);
__vector float __builtin_spu_srqwbyte_8(__vector float arg0, unsigned int arg1);
__vector double __builtin_spu_srqwbyte_9(__vector double arg0, unsigned int arg1);
#if __cplusplus
__vector signed long long __builtin_spu_srqwbytebc(__vector signed long long arg0, unsigned int arg1);
__vector unsigned long long __builtin_spu_srqwbytebc(__vector unsigned long long arg0, unsigned int arg1);
__vector signed int __builtin_spu_srqwbytebc(__vector signed int arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_srqwbytebc(__vector unsigned int arg0, unsigned int arg1);
__vector signed short __builtin_spu_srqwbytebc(__vector signed short arg0, unsigned int arg1);
__vector unsigned short __builtin_spu_srqwbytebc(__vector unsigned short arg0, unsigned int arg1);
__vector signed char __builtin_spu_srqwbytebc(__vector signed char arg0, unsigned int arg1);
__vector unsigned char __builtin_spu_srqwbytebc(__vector unsigned char arg0, unsigned int arg1);
__vector float __builtin_spu_srqwbytebc(__vector float arg0, unsigned int arg1);
__vector double __builtin_spu_srqwbytebc(__vector double arg0, unsigned int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector signed long long __builtin_spu_srqwbytebc_0(__vector signed long long arg0, unsigned int arg1);
__vector unsigned long long __builtin_spu_srqwbytebc_1(__vector unsigned long long arg0, unsigned int arg1);
__vector signed int __builtin_spu_srqwbytebc_2(__vector signed int arg0, unsigned int arg1);
__vector unsigned int __builtin_spu_srqwbytebc_3(__vector unsigned int arg0, unsigned int arg1);
__vector signed short __builtin_spu_srqwbytebc_4(__vector signed short arg0, unsigned int arg1);
__vector unsigned short __builtin_spu_srqwbytebc_5(__vector unsigned short arg0, unsigned int arg1);
__vector signed char __builtin_spu_srqwbytebc_6(__vector signed char arg0, unsigned int arg1);
__vector unsigned char __builtin_spu_srqwbytebc_7(__vector unsigned char arg0, unsigned int arg1);
__vector float __builtin_spu_srqwbytebc_8(__vector float arg0, unsigned int arg1);
__vector double __builtin_spu_srqwbytebc_9(__vector double arg0, unsigned int arg1);
#if __cplusplus
__vector unsigned short __builtin_spu_sub(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_sub(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_sub(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_sub(__vector signed int arg0, __vector signed int arg1);
__vector float __builtin_spu_sub(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_sub(__vector double arg0, __vector double arg1);
__vector unsigned short __builtin_spu_sub(unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_sub(signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_sub(unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_sub(signed int arg0, __vector signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned short __builtin_spu_sub_0(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_sub_1(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_sub_2(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_sub_3(__vector signed int arg0, __vector signed int arg1);
__vector float __builtin_spu_sub_4(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_sub_5(__vector double arg0, __vector double arg1);
__vector unsigned short __builtin_spu_sub_6(unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_sub_7(signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_sub_8(unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_sub_9(signed int arg0, __vector signed int arg1);
#if __cplusplus
__vector unsigned int __builtin_spu_subx(__vector unsigned int arg0, __vector unsigned int arg1, __vector unsigned int arg2);
__vector signed int __builtin_spu_subx(__vector signed int arg0, __vector signed int arg1, __vector signed int arg2);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned int __builtin_spu_subx_0(__vector unsigned int arg0, __vector unsigned int arg1, __vector unsigned int arg2);
__vector signed int __builtin_spu_subx_1(__vector signed int arg0, __vector signed int arg1, __vector signed int arg2);
#if __cplusplus
__vector unsigned char __builtin_spu_xor(__vector unsigned char arg0, __vector unsigned char arg1);
__vector signed char __builtin_spu_xor(__vector signed char arg0, __vector signed char arg1);
__vector unsigned short __builtin_spu_xor(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_xor(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_xor(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_xor(__vector signed int arg0, __vector signed int arg1);
__vector unsigned long long __builtin_spu_xor(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed long long __builtin_spu_xor(__vector signed long long arg0, __vector signed long long arg1);
__vector float __builtin_spu_xor(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_xor(__vector double arg0, __vector double arg1);
__vector unsigned char __builtin_spu_xor(__vector unsigned char arg0, unsigned char arg1);
__vector signed char __builtin_spu_xor(__vector signed char arg0, signed char arg1);
__vector unsigned short __builtin_spu_xor(__vector unsigned short arg0, unsigned short arg1);
__vector signed short __builtin_spu_xor(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_xor(__vector unsigned int arg0, unsigned int arg1);
__vector signed int __builtin_spu_xor(__vector signed int arg0, signed int arg1);
#else
  /* No generic function generated since return types differ */
#endif
__vector unsigned char __builtin_spu_xor_0(__vector unsigned char arg0, __vector unsigned char arg1);
__vector signed char __builtin_spu_xor_1(__vector signed char arg0, __vector signed char arg1);
__vector unsigned short __builtin_spu_xor_2(__vector unsigned short arg0, __vector unsigned short arg1);
__vector signed short __builtin_spu_xor_3(__vector signed short arg0, __vector signed short arg1);
__vector unsigned int __builtin_spu_xor_4(__vector unsigned int arg0, __vector unsigned int arg1);
__vector signed int __builtin_spu_xor_5(__vector signed int arg0, __vector signed int arg1);
__vector unsigned long long __builtin_spu_xor_6(__vector unsigned long long arg0, __vector unsigned long long arg1);
__vector signed long long __builtin_spu_xor_7(__vector signed long long arg0, __vector signed long long arg1);
__vector float __builtin_spu_xor_8(__vector float arg0, __vector float arg1);
__vector double __builtin_spu_xor_9(__vector double arg0, __vector double arg1);
__vector unsigned char __builtin_spu_xor_10(__vector unsigned char arg0, unsigned char arg1);
__vector signed char __builtin_spu_xor_11(__vector signed char arg0, signed char arg1);
__vector unsigned short __builtin_spu_xor_12(__vector unsigned short arg0, unsigned short arg1);
__vector signed short __builtin_spu_xor_13(__vector signed short arg0, signed short arg1);
__vector unsigned int __builtin_spu_xor_14(__vector unsigned int arg0, unsigned int arg1);
__vector signed int __builtin_spu_xor_15(__vector signed int arg0, signed int arg1);
/* END: Generated from spu-builtins.def */

#endif /* COVERITY_SPU_COMPILER_2_5 */
#if __GNUC__ >= 4
int __builtin_va_arg_pack();
int __builtin_va_arg_pack_len();

//Added with GCC 4.7
void *__builtin_assume_aligned (const void *exp, __COVERITY_SIZE_TYPE__ align, ...);
#endif

#endif /* __COVERITY_DISABLE_BUILTIN_DECLS */

/* ARM neon SIMD compat */
#ifdef __ARM_NEON__
typedef __int8 __builtin_neon_qi;
typedef __int16 __builtin_neon_hi;
typedef __int32 __builtin_neon_si;
typedef __int64 __builtin_neon_di;
typedef __int128 __builtin_neon_ti;
typedef unsigned __int8 __builtin_neon_uqi;
typedef unsigned __int16 __builtin_neon_uhi;
typedef unsigned __int32 __builtin_neon_usi;
typedef unsigned __int64 __builtin_neon_udi;
typedef __int32 __builtin_neon_ei __attribute__ ((__vector_size__(32)));
typedef __int32 __builtin_neon_oi __attribute__ ((__vector_size__(32)));
typedef __int32 __builtin_neon_ci __attribute__ ((__vector_size__(64)));
typedef __int32 __builtin_neon_xi __attribute__ ((__vector_size__(64)));
typedef __int8 __builtin_neon_poly8;
typedef __int16 __builtin_neon_poly16;
typedef float __builtin_neon_sf;
#endif // __ARM_NEON__

#pragma builtin end

