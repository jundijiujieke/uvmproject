/*
 * The stack starts at the top of memory, defined by __sp, and grows down.
 * Unfortunately this means we must hardcode the size of memory.
 * Here we choose 64K. Change this value to change the working memory size.
 */
__itim  = 0x08000000;
__mem   = 0x80000000; /*This should be set to the beginning of the memory as specified by the device tree, for spike run: "spike --dump-dts a.out"*/
__sram  = 0x80100000; /*This should be set to the beginning of the memory as specified by the device tree, for spike run: "spike --dump-dts a.out"*/
//__stack = 0x002000; /* for 2048x4 ram, This is the offset that the stack is from the start of memory.*/
__stack = 0x008000; /* for 8192x4 ram, This is the offset that the stack is from the start of memory.*/
//__stack = 0x004000; /* for 4096x4 ram, This is the offset that the stack is from the start of memory.*/
//__stack = 0x001000; /* for 1024x4 ram, This is the offset that the stack is from the start of memory.*/
//__stack = 0x000600; /* for 1.5k ram, This is the offset that the stack is from the start of memory.*/
//__stack = 0x100000; /* for 1.5M ram, This is the offset that the stack is from the start of memory.*/
//__stack = 0x10000000; /*This is the offset that the stack is from the start of memory.*/
//__stack = 0x101000; /* for 1024x4 ram, This is the offset that the stack is from the start of memory.*/

SECTIONS
{
    . = __itim;	
    . = __mem;
    .text : {
        *(.text.init) /* add the instruction from init.s*/
        *(.text) /* add the instructions compiled from hello.c*/
    }

    .data : {
        *(.sbss)
        *(COMMON)
        *(.bss)
        *(.sdata)
        *(.rodata)
        *(.data*)
        *(.got*)
    }
}
