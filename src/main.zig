const console = @import("./console.zig");

const ALIGN = 1 << 0;
const MEMINFO = 1 << 1;
const MAGIC = 0x1BADB002;
const FLAGS = ALIGN | MEMINFO;

const MultibooHeader = packed struct {
    magic: i32 = MAGIC,
    flags: i32,
    checksum: i32,
    padding: u32 = 0,
};

export var multiboot align(4) linksection(".multiboot") = MultibooHeader{
    .flags = FLAGS,
    .checksum = -(MAGIC + FLAGS),
};

var stack_bytes: [16 * 1024]u8 align(16) linksection(".bss") = undefined;

export fn _start() callconv(.Naked) noreturn {
    asm volatile (
        \\ movl %[stack_top], %%esp
        \\ movl %%esp, %%ebp
        \\ push %%eax
        \\ push %%ebx
        \\ call %[kernel_main:P]
        :
        : [stack_top] "i" (@as([*]align(16) u8, &stack_bytes) + @sizeOf(@TypeOf(stack_bytes))),
          [kernel_main] "X" (&kernel_main),
    );
}

extern const KERNEL_START: u32;
extern const KERNEL_END: u32;

const MULTIBOOT_BOOTLOADER_MAGIC = @as(u32, 0x2BADB002);

fn kernel_main(_: u32, magic: u32) void {
    console.initialize();

    console.printf("magic={}\n", .{magic});
    console.printf("magic valid: {}\n", .{magic == MULTIBOOT_BOOTLOADER_MAGIC});
    console.printf("START={}\n", .{KERNEL_START});
    console.printf("END={}\n", .{KERNEL_END});
    while (true) {}
}
