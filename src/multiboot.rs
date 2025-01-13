// https://www.gnu.org/software/grub/manual/multiboot/html_node/multiboot_002eh.html
// https://www.gnu.org/software/grub/manual/multiboot/multiboot.html

#[repr(C)]
pub struct MultibootInfo {
    /* Multiboot info version number */
    flags: u32,

    /* Available memory from BIOS */
    mem_lower: u32,
    mem_upper: u32,

    /* "root" partition */
    boot_device: u32,

    /* Kernel command line */
    cmdline: u32,

    /* Boot-Module list */
    mods_count: u32,
    mods_addr: u32,

    padding: [u8; 16],
    // union
    // {
    //   multiboot_aout_symbol_table_t aout_sym;
    //   multiboot_elf_section_header_table_t elf_sec;
    // } u;

    /* Memory Mapping buffer */
    pub mmap_length: u32,
    pub mmap_addr: u32,

    /* Drive Info buffer */
    drives_length: u32,
    drives_addr: u32,

    /* ROM configuration table */
    config_table: u32,

    /* Boot Loader Name */
    pub boot_loader_name: *const u8,

    /* APM table */
    apm_table: u32,

    /* Video */
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
    framebuffer_bpp: u8,
    framebuffer_type: u8,
    // union
    // {
    //   struct
    //   {
    //
    //     framebuffer_palette_addr;
    //     multiboot_uint16_t framebuffer_palette_num_colors;
    //   };
    //   struct
    //   {
    //     multiboot_uint8_t framebuffer_red_field_position;
    //     multiboot_uint8_t framebuffer_red_mask_size;
    //     multiboot_uint8_t framebuffer_green_field_position;
    //     multiboot_uint8_t framebuffer_green_mask_size;
    //     multiboot_uint8_t framebuffer_blue_field_position;
    //     multiboot_uint8_t framebuffer_blue_mask_size;
    //   };
    // };
}

#[repr(C)]
pub struct MultibootMMapEntry {
    pub size: u32,
    pub addr_low: u32,
    pub addr_high: u32,
    pub len_low: u32,
    pub len_high: u32,
    pub mem_type: u32,
}
