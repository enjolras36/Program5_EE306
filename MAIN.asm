; Main.asm
; Name:
; UTEid: 
; Continuously reads from x4600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
        .ORIG x4000
	LD R6, ORI	; initialize the stack pointer (R6)
	LD R0, IVT 	
	LD R1, INT
	STR R1, R0, #0	; set up the keyboard interrupt vector table entry
	LD R1, MASK
	ST R1, KBSR	; enable keyboard interrupts; set bit 14 of KBSR 
	AND R1, R1, #0	; clears R1	
; R1 = FIRST NUCLEOTIDE
; R2 = SECOND NUCLEOTIDE
; R3 = THIRD NUCLEOTIDE
WAITING	LDI R4, KBSR
	ADD R0, R4, #0
	BRz WAITING
	AND R0, R0, #0		; CLEARS KBSR
	ST R0, KBSR
	JSR FILLREG
	ADD R0, R1, #0		; LOADS FIRST LETTER TO R0,  CHEK FOR START CODON
	JSR CHECKA		; CHECK IF AUG
	ADD R0, R0, #0
	BRnp WAITING
	ADD R0, R2, #0
	JSR CHECKU	
	ADD R0, R0, #0
	BRnp WAITING
	JSR CHECKG
	ADD R0, R0, #0
	BRnp WAITING
	ADD R0, R1, #0		; AUG PASSED SO PRINT AUG|
	TRAP x21
	ADD R0, R2, #0
	TRAP x21
	ADD R0, R3, #0
	TRAP x21
	LD R0, LINE
	TRAP x21
	AND R1, R1, #0	
	AND R2, R2, #0
	AND R3, R3, #0		; CLEAR REGISTERS TO START PATTERNS OVER
GO	LDI R4, KBSR
	ADD R0, R4, #0
	BRz GO
	TRAP x21
	AND R0, R0, #0		; CLEARS KBSR
	ST R0, KBSR
	JSR FILLREG
	ADD R0, R1, #0
	JSR CHECKU
	ADD R0, R0, #0
	BRnp GO
	ADD R0, R2, #0
	JSR CHECKG
	ADD R0, R0, #0
	BRnp UA
	ADD R0, R3, #0
	JSR CHECKA
	ADD R0, R0, #0		; UGA STOP
 	BRnp GO
	BRnzp STOP
UA	ADD R0, R3, #0
	JSR CHECKG
	ADD R0, R0, #0		; UAG STOP
	BRz STOP
	ADD R0, R3, #0
	JSR CHECKA
	ADD R0, R0, #0
	BRz STOP		; UAA STOP
	BRnzp GO
KBSR 	.FILL xFE00
LINE 	.FILL x7C
IVT	.FILL x180
INT	.FILL x2600
ORI 	.FILL X4000
MASK	.FILL x4000			
STOP	TRAP x25

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FILLREG
; INPUT: R4 HOLDS LETTER
; OUTPUTS: R1, R2, R3, HOLD LIST OF LAST THREE NUCS
	ADD R1, R1, #0		; CHECKS IF FIRST NUC 
	BRnp SEC
	ADD R1, R4, #0
	BRnzp MOR
SEC	ADD R2, R2, #0		; CHECKS IF SEC NUC
	BRnp THIR
	ADD R2, R4, #0
	BRnzp MOR
THIR	ADD R3, R3, #0		; CHECKS IF THIRDNUC
	BRnp MOR
	ADD R3, R4, #0
MOR 	ADD R1, R2, #0		; MORE THAN 3 SO MOVE REGISTERS
	ADD R2, R3, #0
	ADD R3, R4, #0
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
CHECKU

	LD R4, U 
	NOT R4, R4 
	ADD R4, R4, #1 
	ADD R0, R4, R0 
	BRz EXIT2 
	BRnp storeneg1 
storeneg1	
	LD R0, neg1
	BRnzp EXIT2
EXIT1 
	LD R0, 0 
EXIT2
	RET
U	.FILL x0055
A	.FILL x0041
G	.FILL x0047
neg1	.FILL xFFFF
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CHECKA

	LD R4, A
	NOT R4, R4 
	ADD R4, R4, #1 
	ADD R0, R4, R0 
	BRz EXIT21
	BRnp storeneg1_2
storeneg1_2
	LD R0, neg1 
	BRnzp EXIT22

EXIT21
	LD R0, 0 
EXIT22
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CHECKG

	LD R4, G 
	NOT R4, R4 
	ADD R4, R4, #1 
	ADD R0, R4, R0 
	BRz EXIT31
	BRnp storeneg1_3
storeneg1_3
	LD R0, neg1
	BRnzp EXIT32

EXIT31
	LD R0, 0 
EXIT32	
	RET	
.END
