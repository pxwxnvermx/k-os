#![no_std]
#![no_main]

mod multiboot;
mod vga_buffer;

use core::fmt::Write;
use core::{arch::global_asm, panic::PanicInfo};
use multiboot::{MultibootInfo, MultibootMMapEntry};
use vga_buffer::Writer;

global_asm!(include_str!("boot.S"), options(att_syntax));

#[no_mangle]
pub extern "C" fn kernel_main(multiboot_info: *const MultibootInfo, magic: u32) -> ! {
    let mut writer = Writer::new();
    writer.clean_buffer();
    unsafe {
        for i in 0..(*multiboot_info).mmap_addr {
            let mmmt = ((*multiboot_info).mmap_addr
                + core::mem::size_of::<MultibootMMapEntry>() as u32 * i)
                as *const MultibootMMapEntry;
            let len = (*mmmt).len_low;
            let size = (*mmmt).size;
            if size == 0 {
                break;
            }
            writeln!(
                writer,
                "size: {}, len: {}, addr: {}, type: {}",
                size,
                len,
                (*mmmt).addr_low,
                (*mmmt).mem_type
            )
            .unwrap();
        }
    }
    loop {}
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
