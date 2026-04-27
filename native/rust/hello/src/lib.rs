use std::ffi::{CStr, CString};
use std::os::raw::c_char;

#[unsafe(no_mangle)] // Keep function name, // extern "C": use C ABI (Application Binary Interface)
pub extern "C" fn quick_hello(cname: *const c_char) {
    let c_str = unsafe { CStr::from_ptr(cname) };
    let name = c_str.to_str().unwrap_or("null");
    println!("Hello from Rust!, {}!", name);
}

#[unsafe(no_mangle)]
pub extern "C" fn full_hello(cname: *const c_char) -> *mut c_char {
    let c_str = unsafe {
        if cname.is_null() {
            return std::ptr::null_mut();
        }
        CStr::from_ptr(cname)
    };
    
    let name = c_str.to_str().unwrap_or("null");
    let greeting = format!("Hello from Rust!, {}!", name);
    
    match CString::new(greeting) {
        Ok(c_string) => c_string.into_raw(),
        Err(_) => std::ptr::null_mut(),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn free_string(ptr: *mut c_char) {
    if ptr.is_null() { return; }
    unsafe {
        let _ = CString::from_raw(ptr);
    }
}
