--------------------------------------------------------------------------------

local Panel = {}

--------------------------------------------------------------------------------

function Panel:vertical(options)
    local panel = display.newImageRect(
        options.parent,
        'cherry/_images/gui/panels/panel.vertical.png',
        options.width,
        options.height
    );

    panel.anchorX = options.anchorX or 0.5
    panel.anchorY = options.anchorY or 0.5
    panel.x       = options.x
    panel.y       = options.y

    return panel
end

function Panel:horizontal(options)
    local panel = display.newImageRect(
        options.parent,
        'cherry/_images/gui/panels/panel.horizontal.png',
        options.width,
        options.height
    );

    panel.anchorX = options.anchorX or 0.5
    panel.anchorY = options.anchorY or 0.5
    panel.x       = options.x
    panel.y       = options.y

    return panel
end

function Panel:small(options)
    local panel = display.newImageRect(
        options.parent,
        'cherry/_images/gui/panels/panel.horizontal.png',
        options.width,
        options.height
    );

    panel.anchorX = options.anchorX or 0.5
    panel.anchorY = options.anchorY or 0.5
    panel.x       = options.x
    panel.y       = options.y

    return panel
end

function Panel:level(options)
    local panel = display.newImage(
        options.parent,
        'cherry/_images/gui/panels/level.panel.' .. options.status .. '.png'
    );

    panel.anchorX = options.anchorX or 0.5
    panel.anchorY = options.anchorY or 0.5
    panel.x       = options.x
    panel.y       = options.y

    return panel
end

function Panel:chapter(options)
    local panel = display.newImageRect(
        options.parent,
        'cherry/_images/gui/panels/chapter.panel.' .. options.status .. '.png',
        options.width,
        options.height
    );

    panel.anchorX = options.anchorX or 0.5
    panel.anchorY = options.anchorY or 0.5
    panel.x       = options.x
    panel.y       = options.y

    return panel
end

--------------------------------------------------------------------------------

return Panel