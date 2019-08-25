/client/verb/ToggleFullscreen()
    set name = "Toggle Fullscreen"
    set category = "Preferences"
    set hidden = TRUE
    if(fullscreen)
        winset(src, "mainwindow", "is-maximized=false;can-resize=false;titlebar=false;menu=")
        winset(src, "mainwindow", "is-maximized=true")
    else
        winset(src, "mainwindow", "is-maximized=false;can-resize=true;titlebar=true;menu=menu")