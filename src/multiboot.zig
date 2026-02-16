const console = @import("./console.zig");

pub const MultibootInfo = packed struct {
    flags: u32,
    mem_lower: u32,
    mem_upper: u32,
    boot_device: u32,
    cmdline: u32,
    mods_count: u32,
    mods_addr: u32,

    u: packed union {
        aout_sym: packed struct {
            tabsize: u32,
            strsize: u32,
            addr: u32,
            reserved: u32,
        },
        elf_sec: packed struct {
            num: u32,
            size: u32,
            addr: u32,
            shndx: u32,
        },
    },

    mmap_length: u32,
    mmap_addr: u32,
    drives_length: u32,
    drives_addr: u32,
    config_table: u32,
    boot_loader_name: *const [4]u8,

    apm_table: u32,

    vbe_control_info: u32,
    vbe_mode_info: u32,
    vbe_mode: u16,
    vbe_interface_seg: u16,
    vbe_interface_off: u16,
    vbe_interface_len: u16,

    framebuffer_addr: u64,
    framebuffer_pitch: u32,
    framebuffer_width: u32,
    framebuffer_height: u32,
    framebuffer_bpe: u8,
    framebuffer_type: u8,
    f: packed union {
        a: packed struct {
            framebuffer_palette_addr: u32,
            framebuffer_palette_num_colors: u16,
        },
        b: packed struct {
            framebuffer_red_field_position: u8,
            framebuffer_red_mask_size: u8,
            framebuffer_green_field_position: u8,
            framebuffer_green_mask_size: u8,
            framebuffer_blue_field_position: u8,
            framebuffer_blue_mask_size: u8,
        },
    },

    pub fn print_mem(self: *const MultibootInfo) void {
        console.print("Available MEM: {}\n", .{self.mem_upper - self.mem_lower});
        console.print("MMAP Length: {}\n", .{self.mmap_length});
        console.print("MMAP Addr: {}\n", .{self.mmap_addr});
    }
};

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
