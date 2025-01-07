#![no_std]
#![no_main]

mod vga_buffer;

use core::{arch::global_asm, panic::PanicInfo};

use vga_buffer::print_something;

global_asm!(include_str!("boot.S"), options(att_syntax));

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn kernel_main() -> ! {
    print_something();
    loop {}
}
