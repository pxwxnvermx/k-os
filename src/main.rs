#![no_std]
#![no_main]

mod multiboot;
mod mutex;
mod vga_buffer;

use core::{arch::global_asm, panic::PanicInfo};
use multiboot::MultibootInfo;

global_asm!(include_str!("boot.S"), options(att_syntax));

extern "C" {
    static end_of_kernel: u32;
}

#[no_mangle]
pub extern "C" fn kernel_main(multiboot_info: *const MultibootInfo, magic: u32) -> ! {
    vga_buffer::WRITER.lock().clean_buffer();
    unsafe { (*multiboot_info).print_info() };
    println!("Magic bytes: {}", magic);
    unsafe {
        print!("Kernel End: {:p}", &end_of_kernel);
    };
    loop {}
}

#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    print!("Panicked at {}", info);
    loop {}
}
