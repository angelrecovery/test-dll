const windows = @cImport({
    @cInclude("windows.h");
});

pub export fn DllMain(hinstDLL: *anyopaque, fdwReason: windows.DWORD, _: ?*anyopaque) callconv(.C) windows.BOOL {
    if (fdwReason == windows.DLL_PROCESS_ATTACH) {
        _ = windows.DisableThreadLibraryCalls(@ptrCast(@alignCast(hinstDLL)));

        const thread = windows.CreateThread(
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

fn showMessageBoxThread(_: ?*anyopaque) callconv(.C) windows.DWORD {
    _ = windows.MessageBoxA(
        null,
        "Loaded",
        "Loaded",
        windows.MB_ICONINFORMATION | windows.MB_OK,
    );

    return 0;
}
