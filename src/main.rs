#![no_std]
#![no_main]

mod vga_buffer;

use core::panic::PanicInfo;

use vga_buffer::print_something;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn kernel_main() -> ! {
    print_something();
    loop {}
}
