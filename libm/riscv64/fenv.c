/*
 * Copyright (C) 2020 The Android Open Source Project
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include <stdint.h>
#include <fenv.h>

# define __get_fcw(cw) __asm__ volatile ("frsr %0" : "=r" (cw))
# define __set_fcw(cw) __asm__ volatile ("fssr %z0" : : "r" (cw))

const fenv_t __fe_dfl_env = 0;

int fegetenv (fenv_t *envp)
{
  __get_fcw(*envp);
  return 0;
}

int fesetenv(const fenv_t* envp)
{
  long int env;

  __get_fcw(env);
  if (*envp != env)
	__set_fcw(env);
  return 0;
}


int feclearexcept(int excepts)
{
  asm volatile ("csrc fflags, %0" : : "r" (excepts));
  return 0;
}

int fegetexceptflag(fexcept_t* flagp, int excepts)
{
  int flags;
  asm volatile ("frflags %0" : "=r" (flags));
  *flagp = flags & excepts;
  return 0;
}

int fesetexceptflag(const fexcept_t* flagp, int excepts)
{
  fexcept_t flags = *flagp;
  asm volatile ("csrc fflags, %0" : : "r" (excepts));
  asm volatile ("csrs fflags, %0" : : "r" (flags & excepts));
  return 0;
}

int feraiseexcept(int excepts)
{
  asm volatile ("csrs fflags, %0" : : "r" (excepts));
  return 0;
}

int fetestexcept(int excepts)
{
  int flags;
  asm volatile ("frflags %0" : "=r" (flags));
  return flags & excepts;
}

int fegetround(void)
{
  int rm;
  asm volatile ("frrm %0" : "=r" (rm));
  return rm;
}

int fesetround(int round)
{
  round &= FE_UPWARD;
  asm volatile ("fsrm %z0" : : "r" (round));
  return 0;
}

int feholdexcept(fenv_t* envp)
{
  asm volatile ("csrrc %0, fcsr, %1" : "=r" (*envp) : "i" (FE_ALL_EXCEPT));
  return 0;
}

int feupdateenv(const fenv_t* envp)
{
  long int env;

  asm volatile ("frflags %0" : "=r" (env));
  env |= *envp;
  __set_fcw(env);

  return 0;
}

int feenableexcept(int mask __unused)
{
  return 0;
}

int fedisableexcept(int mask __unused)
{
  return 0;
}

int fegetexcept(void)
{
  return 0;
}
