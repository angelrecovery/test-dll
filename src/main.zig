const windows = @cImport({
    @cInclude("windows.h");
});

var already_loaded = false;

pub export fn DllMain(hinstDLL: *anyopaque, fdwReason: windows.DWORD, _: ?*anyopaque) callconv(.C) windows.BOOL {
    switch (fdwReason) {
        windows.DLL_PROCESS_ATTACH => {
            _ = windows.DisableThreadLibraryCalls(@ptrCast(@alignCast(hinstDLL)));
            showMessageBox();
            already_loaded = true;
        },
        windows.DLL_PROCESS_DETACH => {
            showMessageBox();
            already_loaded = false;
        },
        else => {},
    }

    return windows.TRUE;
}

fn showMessageBox() void {
    const thread = windows.CreateThread(
        null,
        0,
        showMessageBoxThread,
        null,
        0,
        null,
    );

    if (thread) |t| {
        _ = windows.CloseHandle(t);
    }
}

fn showMessageBoxThread(_: ?*anyopaque) callconv(.C) windows.DWORD {
    const msg = if (already_loaded) "Unload" else "Load";

    _ = windows.MessageBoxA(
        null,
        msg,
        msg,
        windows.MB_ICONINFORMATION | windows.MB_OK,
    );

    return 0;
}
