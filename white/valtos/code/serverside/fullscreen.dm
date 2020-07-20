/client/proc/ToggleFullscreen()
    if(prefs.fullscreen)
        winset(src, "mainwindow", "is-maximized=false;can-resize=false;titlebar=false;menu=\"\"")
        winset(src, "mainwindow", "is-maximized=true")
    else
        winset(src, "mainwindow", "is-maximized=false;can-resize=true;titlebar=true;menu=menu")
        winset(src, "mainwindow", "is-maximized=true")
    addtimer(CALLBACK(src,.verb/fit_viewport,10))
