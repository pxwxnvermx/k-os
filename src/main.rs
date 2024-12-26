#![no_std]
#![no_main]

mod vga_buffer;

use core::panic::PanicInfo;

use vga_buffer::print_something;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

static HELLO: &[u8] = b"HELLO WORLD!";
#[no_mangle]
pub extern "C" fn _start() -> ! {
    print_something();
    loop {}
}
