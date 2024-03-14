hs.alert.show("Hammerspoon config loaded")

hyper = { "cmd", "ctrl" }

-- bind reload at start in case of error later in config
hs.hotkey.bind(hyper, "R", hs.reload)
hs.hotkey.bind(hyper, "Y", hs.toggleConsole)

function inspect(value)
    hs.alert.show(hs.inspect(value))
end

function openOrFocusChrome()
    local chrome = hs.application.find("Google Chrome")

    if chrome then
        -- If Safari is found, focus the window
        chrome:activate()
    else
        -- If Safari is not running, launch it
        hs.application.launchOrFocus("/Applications/Google Chrome.app")
    end
end

function openOrFocusSafari()
    local safari = hs.application.find("Safari")

    if safari then
        -- If Safari is found, focus the window
        safari:activate()
    else
        -- If Safari is not running, launch it
        hs.application.launchOrFocus("/Applications/Safari.app")
    end
end

function openOrFocusTerminal()
    local terminal = hs.application.find("iTerm")

    if terminal then
        -- If Safari is found, focus the window
        terminal:activate()
    else
        -- If Safari is not running, launch it
        hs.application.launchOrFocus("/Applications/iTerm.app")
    end
end

function openOrFocusSioyek()
    local sio = hs.application.find("sioyek")

    if sio then
        sioyek:activate()
    else
        hs.application.launchOrFocus("sioyek")
    end
end

hs.hotkey.bind(hyper, "S", function()
    openOrFocusSafari()
end)
hs.hotkey.bind(hyper, "C", function()
    openOrFocusChrome()
end)
hs.hotkey.bind(hyper, "D", function()
    openOrFocusTerminal()
end)
hs.hotkey.bind(hyper, "F", function()
    openOrFocusSioyek()
end)
