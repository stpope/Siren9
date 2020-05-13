/*
 *  SirenDLLCC.h - Debug macros for Siren DLLCC API sources
 *  Created by Stephen  Pope on 3/25/07.
 */

/* Includes */

#include "userprim.h"		// VisualWorks includes
//#include "oeAPI.h"
#include <stdio.h>			// UNIX includes
#include <string.h>			// for memcpy, bzero, etc.
#include "stdlib.h"			// UNIX includes
#include "stdio.h"
#include "string.h"
#include "assert.h"

/* Verbose logging to stdout (set from makefile) */

#ifdef DEBUG_SIREN
	#define DEBUG_P(aaa) printf(aaa)
	#define DEBUG_P2(aaa, bbb) printf(aaa, bbb)
	#define DEBUG_P3(aaa, bbb, ccc) printf(aaa, bbb, ccc)
#else
	#define DEBUG_P(aaa)			// no-op 
	#define DEBUG_P2(aaa, bbb)
	#define DEBUG_P3(aaa, bbb, ccc)
#endif
