#![no_std]
#![no_main]

// mod allocator;
mod multiboot;
mod mutex;
mod vga_buffer;

use core::{arch::global_asm, panic::PanicInfo};
use multiboot::MultibootInfo;

global_asm!(include_str!("boot.S"), options(att_syntax));

extern "C" {
    static KERNEL_START: u32;
    static KERNEL_END: u32;
}

#[no_mangle]
pub extern "C" fn kernel_main(multiboot_info: *const MultibootInfo, magic: u32) -> ! {
    vga_buffer::WRITER.lock().clean_buffer();
    unsafe { (*multiboot_info).print_info() };
    println!("Magic bytes: {}", magic);
    unsafe {
        println!("Kernel Start: {:p}", &KERNEL_START as *const u32);
        println!("Kernel End: {:p}", &KERNEL_END as *const u32);
        println!(
            "Reserved Memory: {}",
            (&KERNEL_END as *const u32).offset_from(&KERNEL_START as *const u32)
        );
    };
    loop {}
}

#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    print!("Panicked at {}", info);
    loop {}
}
