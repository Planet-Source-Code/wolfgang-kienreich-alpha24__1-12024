

;
; Declare public variables
;

[SECTION .bss]

SrcBase:	resd	1				; Base adress of data for source
SrcX:		resd	1				; X position within destination
SrcY:		resd	1				; Y position within destination
SrcWidth:	resd	1				; Width of source
SrcHeight:	resd	1				; Height of source
SrcPitch:	resd	1				; Source pitch (offset for one line)
DstBase:	resd	1				; Base adress of data for destination
DstX:		resd	1				; X position within destination
DstY:		resd	1				; Y position within destination
DstPitch:	resd	1				; Destination pitch (offset for one line)
Mode:		resd	1				; Transformation mode 
Amount:		resd	1				; Transformation amount

;
; Declare 32-Bit-Mode
;

SEGMENT	code USE32


;
; Standard Win32 DLL convention
;

GLOBAL	_DllMain				

_DllMain:	
	
	mov	eax,1
	retn	12
		
;
; Alpha24: Blitting routine
;

GLOBAL	Alpha24
		
Alpha24:

	; Initialize routine
	
	enter	0,0					; Save stack
	push ebx					; Save ebx register

	; Gather passed parameters 
		
	mov 	eax,[ebp+8]				; Gather source base
	mov	[SrcBase],eax
	
	mov 	eax,[ebp+12]				; Gather source X position
	mov	[SrcX],eax
	
	mov 	eax,[ebp+16]				; Gather source Y position
	mov	[SrcY],eax
	
	mov 	eax,[ebp+20]				; Gather source width
	mov	[SrcWidth],eax
	
	mov 	eax,[ebp+24]				; Gather source height
	mov	[SrcHeight],eax

	mov 	eax,[ebp+28]				; Gather source pitch
	mov	[SrcPitch],eax
	
	mov 	eax,[ebp+32]				; Gather destination base
	mov	[DstBase],eax
	
	mov 	eax,[ebp+36]				; Gather destination X position
	mov	[DstX],eax
	
	mov 	eax,[ebp+40]				; Gather destination Y position
	mov	[DstY],eax
	
	mov 	eax,[ebp+44]				; Gather destination pitch
	mov	[DstPitch],eax
	
	mov 	eax,[ebp+48]				; Gather mode of tranformation
	mov	[Mode],eax

	mov 	eax,[ebp+52]				; Gather amount of tranformation
	mov	[Amount],eax

	; Adjust passed destination parameters to match position
	
	mov	eax, [DstPitch]				; Load destination pitch into eax
	mov	ecx, [DstY]				; Load destination line position into ecx
	mul	ecx					; Multiply the two
	add	eax, [DstX]				; Add destination column position to result
	add	eax, [DstX]				; (Do it three times, as we are in 24 color mode
	add	eax, [DstX]				;  and one pixel consists of three bytes)
	add	eax, [DstBase]				; Add the calculated offset to the destination base
	mov	[DstBase], eax				; And set the destination base!

	; Adjust passed source parameters to match position	

	mov	eax, [SrcPitch]				; Load source pitch into eax
	mov	ecx, [SrcY]				; Load source line position into ecx
	mul	ecx					; Multiply the two
	add	eax, [SrcX]				; Add source column position to result
	add	eax, [SrcX]				; (Do it three times, as we are in 24 color mode
	add	eax, [SrcX]				;  and one pixel consists of three bytes)
	add	eax, [SrcBase]				; Add the calculated offset to the source base
	mov	[SrcBase], eax				; And set the source base!
		
	; Run over source lines 
			
	mov ecx,[SrcHeight]				; Load source height into loop register
	dec ecx						; Start at source height minus one
	RunOverX:					; Loop over source height
	mov [SrcHeight],ecx				; Load loop register into source height

		; Calculate current source line position
		
		mov	eax,[SrcHeight]			; Load eax with current source line
		mov	ecx,[SrcPitch]			; Load ecx with source pitch
		mul	ecx				; Multiply the two, store result in eax
		add	eax,[SrcBase]			; Add source base adress to result
		mov	ebx,eax				; Store result, equaling current source base adress, in edi register
	
		; Calculate current destination line position

		mov	eax,[SrcHeight]			; Load eax with current source line
		mov	ecx,[DstPitch]			; Load ecx with destination pitch
		mul	ecx				; Multiply the two, store result in eax
		add	eax,[DstBase]			; Add destination base adress to result
		mov	edx,eax				; Store result, equaling current destination base adress, in edx register

		; Run over bytes within line
			
		mov ecx, [SrcWidth]			; Load source width into loop register
		dec ecx					; Start at source width minus one 
		RunOverY:				; Loop over source width

			; Choose mode to use			
			
			cmp	BYTE [Mode], 0		; Mode 0 ?
			jz	Mode0
			
			cmp	BYTE [Mode], 1		; Mode 1 ?
			jz	Mode1

			cmp	BYTE [Mode], 2		; Mode 2 ?
			jz	Mode2

			cmp	BYTE [Mode], 3		; Mode 3 ?
			jz	Mode3
			
			jmp short EndMode		; Invalid mode ?
			
			; Manipulate values depending on mode
						
			Mode0:					; Brighten destination
			
				mov	al,BYTE [edx+ecx]	
				add	al,BYTE [Amount]
				jnc short EndMode
				mov	al,255			
				jmp short EndMode
				
			Mode1:					; Darken destination	
			
				mov	al,BYTE [edx+ecx]	
				sub	al,BYTE [Amount]
				jnc short EndMode
				mov	al,0			
				jmp short EndMode
								
			Mode2:					; Combine source and destination
			
				mov	al, BYTE [ebx+ecx]
				cmp	al,0
				jnz short Mode2A
				mov	al, BYTE [edx+ecx]
				jmp short EndMode
			Mode2A:	sub	al, BYTE [Amount]
				jnc short Mode2B
				mov	al, 0
			Mode2B:	jz short EndMode
				add	al,BYTE [edx+ecx]
				jnc short EndMode
				mov	al,255
				jmp short EndMode
				
			Mode3:					; Copy source to destination
				mov	al, BYTE [ebx+ecx]
				
			EndMode:

			; Render to destination
			
			mov	[edx+ecx], BYTE al	; Store manipulated data in destination	

		loop	RunOverY			; Loop until zero

	mov ecx,[SrcHeight]				; Load source height into loop register		
	dec ecx						; Decrease source height by one
	cmp ecx,0					; Compare if zero
	jnz near RunOverX				; Loop while not zero		

	pop ebx						; Restore ebx register
	leave						; Restore stack
	retn	48					; Pop all passed parameters, return
		
ENDS
