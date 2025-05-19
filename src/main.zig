const windows = @cImport({
    @cInclude("windows.h");
});

export fn DllMain(hinstDLL: windows.HINSTANCE, fdwReason: windows.DWORD, _: windows.LPVOID) callconv(.C) windows.BOOL {
    if (fdwReason == windows.DLL_PROCESS_ATTACH) {
        _ = windows.DisableThreadLibraryCalls(hinstDLL);

        const thread: windows.HANDLE = windows.CreateThread(
            null,
            0,    
            showMessageBoxThread, 
            null, 
            0,    
            null,
        );

        if (thread != null) {
            _ = windows.CloseHandle(thread);
        }
    }

    return windows.TRUE;
}

fn showMessageBoxThread(lpParameter: ?*anyopaque) callconv(.C) windows.DWORD {
    _ = lpParameter;

    _ = windows.MessageBoxA(
        null,
        "Loaded",
        "Loaded",
        windows.MB_ICONINFORMATION | windows.MB_OK,
    );

    return 0;
}
