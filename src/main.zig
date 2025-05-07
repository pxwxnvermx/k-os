const console = @import("./console.zig");
const multiboot_types = @import("./multiboot.zig");

const MULTIBOOT_BOOTLOADER_MAGIC = @as(u32, 0x2BADB002);

export fn kernel_main(magic: u32, info: *const multiboot_types.MultibootInfo) void {
    console.initialize();

    console.printf("magic valid: {}\n", .{magic == MULTIBOOT_BOOTLOADER_MAGIC});
    console.printf("info={}\n", .{info});
    console.printf("info={s}\n", .{info.boot_loader_name});

    while (true) {}
}
