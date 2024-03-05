sub init()
    m.dateTime = createObject("roDateTime")
    m.rectangle = m.top.findNode("rectangle")
    m.freqLabel = m.top.findNode("freqLabel")
    m.ampLabel = m.top.findNode("ampLabel")

    m.width = 1080
    m.height = 1080
    m.frameCount = 0

    n = 15
    m.cols = n
    m.rows = n
    m.freq = 0.1
    m.amp = 1.0


    m.freqLabel.text = "freq: " + Str(m.freq)
    m.ampLabel.text = "amp: " + Str(m.amp)

    m.top.setFocus(true)
    setGrid()
end sub



sub setGrid()
    r = getResolution()

    numCells = m.cols * m.rows

    gridw = m.width * 0.8
    gridh = m.height * 0.8

    m.cellw = gridw / m.cols
    m.cellh = gridh / m.rows

    ix = (r.width - m.width) * 0.5
    iy = (r.height - m.height) * 0.5

    cx = (m.width - gridw) * 0.5
    cy = (m.height - gridh) * 0.5

    m.rectangle.width = m.width
    m.rectangle.height = m.height
    m.rectangle.translation = [ix, iy]

    for i = 0 to numCells - 1
        col = i mod m.cols
        row = fix(i / m.rows)

        x = cx + (col * m.cellw)
        y = cy + (row * m.cellh)

        w = m.cellw * 0.85
        h = m.cellh * 0.15

        gapx = m.cellw * 0.15 * 0.5
        gapy = m.cellh * 0.85 * 0.5

        rectangle = m.rectangle.createChild("rectangle")
        rectangle.color = "#eeeeee"
        rectangle.width = w
        rectangle.height = h
        rectangle.scaleRotateCenter = [w * 0.5, h * 0.5]
        rectangle.translation = [x + gapx, y + gapy]
    end for

    setTimer()
end sub



sub setTimer()
    m.timer = m.top.findNode("timer")
    m.timer.duration = 1 / 30
    m.timer.repeat = true
    m.timer.control = "start"
    m.timer.observeField("fire", "draw")
end sub



sub draw()
    m.frameCount++
    for i = 0 to m.rectangle.getChildCount() - 1
        child = m.rectangle.getChild(i)

        p = child.translation

        d = dist(p[0], p[1], 0, 0)
        angle = (m.frameCount + (m.freq * d)) * (3.141592654 / 180)
        n = m.amp * sin(angle)
        if n < 0 then n *= -1

        child.rotation = (3.141592654) * n
        child.opacity = n
    end for
end sub



function onKeyEvent(key as string, press as boolean) as boolean
    handled = false
    if press
        if press
            if key = "up"
                m.freq += 0.1
                if m.freq > 2 then m.freq = 2
            else if key = "down"
                m.freq -= 0.1
                if m.freq < 0 then m.freq = 0
            else if key = "right"
                m.amp += 0.1
                if m.amp > 2 then m.amp = 2
            else if key = "left"
                m.amp -= 0.1
                if m.amp < 0 then m.amp = 0
            end if
            handled = true
            m.freqLabel.text = "freq: " + Str(m.freq)
            m.ampLabel.text = "amp:  " + Str(m.amp)
        end if
        return handled
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