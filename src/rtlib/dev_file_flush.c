/* file device */

#include "fb.h"

int fb_DevFileFlush( FB_FILE *handle )
{
    FILE *fp;

    FB_LOCK();

    fp = (FILE*) handle->opaque;

	if( fp == NULL ) {
		FB_UNLOCK();
		return fb_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL );
	}

    fflush( fp );

	FB_UNLOCK();

	return fb_ErrorSetNum( FB_RTERROR_OK );
}
