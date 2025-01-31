.set ALIGN,    1<<0             
.set MEMINFO,  1<<1             
.set FLAGS,    ALIGN  
.set MAGIC,    0x1BADB002       
.set CHECKSUM, -(MAGIC + FLAGS) 


# Multiboot Header
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM


.section .bss
.align 16
stack_bottom:
.skip 16384
stack_top:


# start
.section .text
.global _start
.type _start, @function
_start:
	mov $stack_top, %esp

	# When GRUB runs, it loads the multiboot_info structure into memory and
	# leaves the address of this structure in the EBX register. 
	# https://wiki.osdev.org/Detecting_Memory_(x86)#Memory_Map_Via_GRUB
	push %eax
	push %ebx

	call kernel_main

	cli
1:	hlt
	jmp 1b

.size _start, . - _start

.section .kend
.global end_of_kernel
end_of_kernel:
