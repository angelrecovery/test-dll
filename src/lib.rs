use windows::Win32::{
    Foundation::{HINSTANCE, TRUE},
    System::LibraryLoader::DisableThreadLibraryCalls,
    System::SystemServices::DLL_PROCESS_ATTACH,
    UI::WindowsAndMessaging::{MB_ICONINFORMATION, MB_OK, MessageBoxW},
};
use windows::core::{BOOL, w};

#[unsafe(no_mangle)]
#[allow(non_snake_case)]
pub extern "system" fn DllMain(hinstDLL: HINSTANCE, fdwReason: u32, _: usize) -> BOOL {
    if fdwReason == DLL_PROCESS_ATTACH {
        _ = unsafe { DisableThreadLibraryCalls(hinstDLL.into()) };
        std::thread::spawn(|| unsafe {
            MessageBoxW(None, w!("Attached!"), w!("DLL"), MB_ICONINFORMATION | MB_OK)
        });
    }
    TRUE
}
