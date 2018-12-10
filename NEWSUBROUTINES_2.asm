; Main.asm
; Name: Ananya Dwivedi, Annaclaire Kepple 
; UTEid: 
; Continuously reads from x4600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
               .ORIG x4000
; initialize the stack pointer


; set up the keyboard interrupt vector table entry



; enable keyboard interrupts



; start of actual program

checkU
LD R7, SAVEU 
LD R4, U 
NOT R4, R4 
ADD R4, R4, #1 
ADD R0, R4, R0 
BRz exitthissubroutine 
BRnp storeneg1 


storeneg1 
LD R0, neg1 
BRnzp exitthissubroutine 

exitthissubroutine 
LD R0, 0 
LD R7, SAVEU
RET 

U	.FILL x0055
A	.FILL x0041
G	.FILL x0047
SAVEU	.BLKW 1 
SAVEA 	.BLKW 1
SAVEG	.BLKW 1
neg1	.FILL xFFFF


checkA
LD R7, SAVEA 
LD R4, A
NOT R4, R4 
ADD R4, R4, #1 
ADD R0, R4, R0 
BRz exitthissubroutine1
BRnp storeneg1_2


storeneg1_2
LD R0, neg1 
BRnzp exitthissubroutine1

exitthissubroutine1 
LD R0, 0 
LD R7, SAVEA
RET



checkG 
LD R7, SAVEG 
LD R4, G 
NOT R4, R4 
ADD R4, R4, #1 
ADD R0, R4, R0 
BRz exitthissubroutine2 
BRnp storeneg1_3


storeneg1_3
LD R0, neg1
BRnzp exitthissubroutine2 

exitthissubroutine2 
LD R0, 0 
LD R7, SAVEG
RET
		.END


