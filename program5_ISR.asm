; ISR.asm
; Name:
; UTEid: 
; Keyboard ISR runs when a key is struck
; Checks for a valid RNA symbol and places it at x4600
               .ORIG x2600
LOOP	LDI R0, KBSR
	BRzp LOOP
	LDI R2, KBDR

	LD R1, NEGA
	ADD R1, R1, R0
	BRz VALID
	LD R1, NEGU
	ADD R1, R1, R0
	BRz VALID
	LD R1, NEGC
	ADD R1, R1, R0
	BRz VALID
	LD R1, NEGG
	ADD R1, R1, R0
	BRz VALID
	BRnzp FIN
VALID	LD R1, RNA
	STR R0, R1, #0
FIN	RTI
RNA	.FILL X4600
NEGA	.FILL X-41
NEGU	.FILL X-55
NEGC	.FILL X-43
NEGG	.FILL X-47
KBSR	.FILL XFE00
KBDR	.FILL XFE02
	
.END
