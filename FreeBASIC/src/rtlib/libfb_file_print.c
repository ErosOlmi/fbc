/*
 *  libfb - FreeBASIC's runtime library
 *	Copyright (C) 2004-2005 Andre Victor T. Vicentini (av1ctor@yahoo.com.br)
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

/*
 *	file_print - print # function (formating is done at io_prn)
 *
 * chng: oct/2004 written [v1ctor]
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include "fb.h"
#include "fb_rterr.h"

/*:::::*/
int fb_hFilePrintBufferUnlocked( int fnum, const void *buffer, size_t len )
{
    size_t i;
    const char *pachText = (const char *) buffer;

	if( fnum < 1 || fnum > FB_MAX_FILES )
		return fb_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL );

	if( fb_fileTB[fnum-1].f == NULL ) {
		return fb_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL );
	}

    /* writing all data at once might give a performance improvement */
	if( fwrite( buffer, len, 1, fb_fileTB[fnum-1].f ) != 1 ) {
		return fb_ErrorSetNum( FB_RTERROR_FILEIO );
    }

#if FB_NATIVE_TAB==0
    /* search for last printed CR or LF */
    i=len;
    while (i--) {
        char ch = pachText[i];
        if (ch=='\n' || ch=='\r') {
            break;
        }
    }
    ++i;
    if (i==0) {
        fb_fileTB[fnum-1].line_length += len;
    } else {
        fb_fileTB[fnum-1].line_length = len - i;
    }
    fb_fileTB[fnum-1].line_length %= FB_TAB_WIDTH;
#endif

    return fb_ErrorSetNum( FB_RTERROR_OK );
}

/*:::::*/
int fb_hFilePrintBufferEx( int fnum, const void *buffer, size_t len )
{
    int result;

    FB_LOCK();

    result = fb_hFilePrintBufferUnlocked( fnum, buffer, len );

    FB_UNLOCK();

    return result;
}

/*:::::*/
int fb_hFilePrintBuffer( int fnum, const char *buffer )
{
    return fb_hFilePrintBufferEx( fnum, buffer, strlen( buffer ) );
}
