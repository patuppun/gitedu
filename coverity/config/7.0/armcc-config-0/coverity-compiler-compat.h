
/*
  (c) 2003-2009,2011,2012, Coverity, Inc. All rights reserved worldwide.
  The information contained in this file is the proprietary and confidential
  information of Coverity, Inc. and its licensors, and is supplied subject to,
  and may be used only by Coverity customers in accordance with the terms and
  conditions of a previously executed license agreement between Coverity and
  that customer.
*/


/* DO NOT MODIFY THE CONTENTS OF THIS FILE */

#define __builtin_va_list va_list

#define __asm__ __asm
#define __asm(x)
/*
  (c) 2003-2013, Coverity, Inc. All rights reserved worldwide.
  The information contained in this file is the proprietary and confidential
  information of Coverity, Inc. and its licensors, and is supplied subject to,
  and may be used only by Coverity customers in accordance with the terms and
  conditions of a previously executed license agreement between Coverity and
  that customer.
*/


/* DO NOT MODIFY THE CONTENTS OF THIS FILE */

#define __global_reg(x)
#define __packed
#define __value_in_regs
#define __pure
#define __softfp
#define __align(x)
#define __signed__ signed
#define __weak
#define __inline__
#define inline
#define __swi(x)
#define __swi_indirect(x)
#define __prettyfunc__ __func__

#define __va_start __builtin_va_start
#define __va_arg __builtin_va_arg
#define __va_end __builtin_va_end

#if !defined(__int32) && !defined(__coverity_undefine___int32)
#define __int32 __int32
#endif
#if !defined(__int64) && !defined(__coverity_undefine___int64)
#define __int64 __int64
#endif

#if !defined(HUGE_VAL) && !defined(__coverity_undefine_HUGE_VAL)
#define HUGE_VAL (1.0/0.0)
#endif

#if !defined(IMPORT_C) && !defined(__coverity_undefine_IMPORT_C)
#define IMPORT_C
#endif

#if !defined(__ESCAPE__) && !defined(__coverity_undefine___ESCAPE__)
#if defined(__ARMCC_VERSION) && __ARMCC_VERSION >= 200000
#define __ESCAPE__(x) (x)
#endif
#endif

#if !defined(__irq) && !defined(__coverity_undefine___irq)
#define __irq
#endif

//We don't have a 16-bit float type, but it shouldn't affect analysis
#if !defined(__fp16) && defined(__coverity_maketype___fp16)
typedef float __fp16;
#endif

extern float __coverity_float_infinity;
extern float __coverity_float_quiet_nan;
extern float __coverity_float_signaling_nan;

extern double __coverity_double_infinity;
extern double __coverity_double_quiet_nan;
extern double __coverity_double_signaling_nan;

extern void                 __breakpoint(int val);
extern void                 __cdp(unsigned int coproc, unsigned int opcode1, unsigned int opcode2);
extern void                 __clrex(void);
extern unsigned char        __clz(unsigned int val);
extern unsigned int         __current_pc(void);
extern unsigned int         __current_sp(void);
extern int                  __disable_fiq(void);
extern int                  __disable_irq(void);
extern void                 __enable_fiq(void);
extern void                 __enable_irq(void);
extern double               __fabs(double val);
extern float                __fabsf(float val);
extern void                 __force_stores(void);
extern unsigned int         __ldrex(volatile void *ptr);
extern unsigned long long   __ldrexd(volatile void *ptr);
extern unsigned int         __ldrt(const volatile void *ptr);
extern void                 __memory_changed(void);
extern void                 __nop(void);
extern void                 __pld(const void *ptr, ...);
extern void                 __pldw(const void *ptr, ...);
extern void                 __pli(const void *ptr, ...);
extern void                 __promise(int expr);
extern int                  __qadd(int val1, int val2);
extern int                  __qdbl(int val);
extern int                  __qsub(int val1, int val2);
extern unsigned int         __rbit(unsigned int val);
extern unsigned int         __rev(unsigned int val);
extern unsigned int         __return_address(void);
extern unsigned int         __ror(unsigned int val, unsigned int shift);
extern void                 __schedule_barrier(void);
extern int                  __semihost(int val, const void *ptr);
extern void                 __sev(void);
extern double               __sqrt(double val);
extern float                __sqrtf(float val);
extern int                  __ssat(int val, unsigned int sat);
extern int                  __strex(unsigned int val, volatile void *ptr);
extern int                  __strexd(unsigned long long val, volatile void *ptr);
extern void                 __strt(unsigned int val, volatile void *ptr);
extern unsigned int         __swp(unsigned int val, volatile void *ptr);
extern int                  __usat(unsigned int val, unsigned int sat);
extern void                 __wfe(void);
extern void                 __wfi(void);
extern void                 __yield(void);
