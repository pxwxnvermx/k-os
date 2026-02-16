const console = @import("./console.zig");
const multiboot_types = @import("./multiboot.zig");
const std = @import("std");

const MULTIBOOT_BOOTLOADER_MAGIC = @as(u32, 0x2BADB002);

var stack_bytes: [16 * 1024]u8 align(16) linksection(".bss") = undefined;

export fn _start() callconv(.naked) noreturn {
    asm volatile (
        \\ movl %[stack_top], %%esp
        \\ movl %%esp, %%ebp
        \\ push %%ebx
        \\ push %%eax
        \\ call %[kernel_main:P]
        :
        : [stack_top] "i" (@as([*]align(16) u8, &stack_bytes) + @sizeOf(@TypeOf(stack_bytes))),
          [kernel_main] "X" (&kernel_main),
    );
}

export fn kernel_main(magic: u32, info: *const multiboot_types.MultibootInfo) void {
    console.initialize();

    console.print("magic valid: {}\n", .{magic == MULTIBOOT_BOOTLOADER_MAGIC});
    console.print("Boot Loader: {s}\n", .{info.boot_loader_name});

    info.print_mem();

    while (true) {}
}
