================================================================================

A L P H A   2 4

Native assembler coded library supporting alpha-translucent blits

(C) 1999 NLS - Nonlinear Solutions
This program is freeware - spread and use at will. But please 
contact the author before implementing it within a commercial.

This program is provided as-is, with no guarantees or promises 
of further support. But mail the author if you experience any
problems. I will be there.

Contact NLS at nls@inode.at, or visit us under www.inode.at/nls

================================================================================



================================================================================
Description (Visual Basic)
================================================================================

First of all, you have to declare the function as follows...

Public Declare Sub Alpha24 Lib "alpha24.dll" (ByVal lpSrc As Long, ByVal nSrcX As Long, ByVal nSrcY As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal nSrcPitch As Long, ByVal lpDst As Long, ByVal nDstX As Long, ByVal nDstY As Long, ByVal nDstPitch As Long, ByVal nMode As Long, ByVal nAmount As Long)

... where Private/Public is up to you, as well as the parameter names, BUT NOT THE 
PARAMETER TYPES AND THE BYVAL STATEMENT! Leave them alone! The library must reside 
in the same directory as your application, or within one of the system directories 
windows searches for dlls, as for example C:\WINDOWS\SYSTEM. NOTE: YOU MUST USE THE 
LIBRARY UNDER 24-BIT-COLORMODE, OR YOUR PROGRAM WILL CRASH.

Parameters explained...

lpSrc		Pointer to the start of the source data. The bitmap data pointer BITMAP.bmBits,
		or the surface pointer obtained by locking a DirectX surface

nSrcX		Source column - or X - position ... IN BYTES! (Multiply pixel position by three!)

nSrcY		Source row - or Y - position ... INVERTED (Assign HEIGHT-position to get standard
		windows coordinates where Y runs from top to bottom)

nSrcWidth	Width of source snippet ... IN BYTES! (Multiply pixel width by three!)

nSrcHeight	Height of source snippets in rows

nSrcPitch	Source pitch: Number of bytes to skip to get from line n, col x to line n+1,
		column x. The BITMAP.bmWidthBytes parameter or the pitch returned by locking
		a DirectX surface.

lpDst		Pointer to the start of the destination data. The bitmap data pointer BITMAP.bmBits,
		or the surface pointer obtained by locking a DirectX surface

nDstX		Destination column - or X - position ... IN BYTES! (Multiply pixel position by three!)

nDstY		Destination row - or Y - position ... INVERTED (Assign HEIGHT-position to get standard
		windows coordinates where Y runs from top to bottom)

nDstPitch	Destination pitch: Number of bytes to skip to get from line n, col x to line n+1,
		column x. The BITMAP.bmWidthBytes parameter or the pitch returned by locking
		a DirectX surface.

nMode		Blit Mode to use: 0 = Brighten destination, ignore source
				  1 = Darken destination, ignore source
				  2 = Overlay source onto destination
				  3 = Copy source onto destination

nAmount		Amount to use in mode 0-2: Value range is 0 to 255