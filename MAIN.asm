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
	STI R1, KBSR	; enable keyboard interrupts; set bit 14 of KBSR 
	AND R1, R1, #0	; clears R1
	
; R1 = FIRST NUCLEOTIDE
; R2 = SECOND NUCLEOTIDE
; R3 = THIRD NUCLEOTIDE
WAITING	LDI R4, FLAG
	BRz WAITING
	ADD R0, R4, #0
	TRAP x21
	AND R0, R0, #0		; CLEARS KBSR
	STI R0, FLAG
	TRAP x21
	JSR CHECKA		; check if A
	ADD R0,R0, #0
	BRnp WAITING		; if not an A branch to waiting
FNDA	LDI R4, FLAG		; poll FLAG again
	BRz FNDA
	ADD R0, R4, #0
	TRAP x21		
	AND R0, R0, #0
	STI R0, FLAG
	JSR CHECKU		; check U	
	BRz AU
	JSR CHECKA		;if A branch to found A
	ADD R0, R0, #0
	BRz FNDA
	BRnzp WAITING		; if not a then branch to waiting to check for A
AU	LDI R4, FLAG		; poll FLAG again
	BRz AU
	ADD R0, R4 #0
	TRAP x21
	ADD R0, R0, #0
	STI R0, FLAG
	JSR CHECKG		;if G print a | and start checking for stop sequence
	ADD R0, R0, #0
	BRnp A2
	LD R0, LINE
	TRAP x21
	BRnzp START
A2	JSR CHECKA
	ADD R0, R0, #0
	BRz FNDA
	BRnp WAITING		; ME AND MATTHEW WENT OVER THIS SO IM IN THE PROCESS OF CHANGING IT, i'LL EXPLAIN IT ONCE IM DONE
START	
	LDI R4, FLAG		; poll FLAG again
	BRz AU
	ADD R0, R4 #0
	TRAP x21
	ADD R0, R0, #0
	STI R0, FLAG
	JSR CHECKU
	ADD R0, R0, #0
	BRnp START
	LDI R4, FLAG		; poll FLAG again
	BRz AU
	ADD R0, R4 #0
	TRAP x21
	ADD R0, R0, #0
	STI R0, FLAG
	JSR CHECKG		; CHECK FOR G 
	ADD R0, R0, #0
	BRz UGA
	JSR CHECKA		; CHECK FOR A
	ADD R0, R0, #0 
	LDI R4, FLAG		; poll FLAG again
	BRz AU
	ADD R0, R4 #0
	TRAP x21
	ADD R0, R0, #0
	STI R0, FLAG
	JSR CHECKG		; CHECK FOR G, UAG
	ADD R0, R0, #0
	BRz STOP
	JSR CHECKA		; CHECK FOR A, UAA
	ADD R0, R0, #0
	BRz STOP
	BRnp START
UGA	LDI R4, FLAG		; poll FLAG again
	BRz AU
	ADD R0, R4 #0
	TRAP x21
	ADD R0, R0, #0
	STI R0, FLAG
	JSR CHECKA		; CHECK FOR A, UGA
	BRnp START	
KBSR 	.FILL xFE00
KBDR 	.FILL xFE02
LINE 	.FILL x7C
IVT	.FILL x180
INT	.FILL x2600
ORI 	.FILL X4000
MASK	.FILL x4000	
FLAG	.FILL x4600		
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

	LD R0, U 
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
U	.FILL x-0055
A	.FILL x-0041
G	.FILL x-0047
neg1	.FILL x-FFFF
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CHECKA

	LD R0, A 
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

	LD R0, G 
	NOT R4, R4  
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
