sub init()
    m.top.setFocus(true)
    m.dateTime = createObject("roDateTime")
    m.rectangle = m.top.findNode("rectangle")
    m.width = 1080
    m.height = 1080
    m.frameCount = 0
    m.freq = 0.0

    setGrid()
end sub



sub setGrid()
    n = 14
    r = getResolution()

    cols = n
    rows = n

    numCells = cols * rows

    gridw = m.width * 0.9
    gridh = m.height * 0.9

    m.cellw = gridw / cols
    m.cellh = gridh / rows

    ix = (r.width - m.width) * 0.5
    iy = (r.height - m.height) * 0.5

    m.rectangle.width = m.width
    m.rectangle.height = m.height
    m.rectangle.translation = [ix, iy]

    m.cx = (m.width - gridw) * 0.5
    m.cy = (m.height - gridh) * 0.5

    gapx = m.cellw * 0.5
    gapy = m.cellh * 0.5

    for i = 0 to numCells - 1
        col = i mod cols
        row = fix(i / rows)

        x = m.cx + gapx + (col * m.cellw)
        y = m.cy + gapy + (row * m.cellh)

        poster = m.rectangle.createChild("poster")
        poster.translation = [x - m.cellw * 0.5, y - m.cellh * 0.5]
        poster.loadDisplayMode = "scaleToFit"
        poster.uri = "pkg:/images/circle_3.jpeg"
        ' poster.opacity = 1.0
        poster.blendColor = "#eeeeee"
        poster.width = m.cellw
        poster.height = m.cellh
    end for

    setTimer()
end sub



sub setTimer()
    m.timer = m.top.findNode("timer")
    m.timer.duration = 1 / 60
    m.timer.repeat = true
    m.timer.control = "start"
    m.timer.observeField("fire", "draw")
end sub



sub draw()
    m.frameCount++
    for i = 0 to m.rectangle.getChildCount() - 1
        child = m.rectangle.getChild(i)
        p = child.translation
        d = dist(p[0], p[1], 540 - m.cellw * 0.5, 540 - m.cellh * 0.5)
        angle = (m.frameCount + (m.freq * d)) * (3.141592654 / 180)
        n = sin(angle)
        if n < 0 then n *= -1
        child.opacity = n
        child.width = m.cellw * n
        child.height = m.cellh * n
    end for
end sub



function onKeyEvent(key as string, press as boolean) as boolean
    handled = false
    if press
        if key = "up"
            m.freq += 0.1
            if m.freq > 1 then m.freq = 1
        else if key = "down"
            m.freq -= 0.1
            if m.freq < 0 then m.freq = 0
        end if
        handled = true
        print "freq: "; m.freq
    end if
    return handled
end function



function getResolution()
    devInfo = createObject("roDeviceInfo")
    return devInfo.getUIResolution()
end function



function dist(x1, y1, x2, y2)
    dx = x2 - x1
    dy = y2 - y1
    return sqr(dx * dx + dy * dy)
end function