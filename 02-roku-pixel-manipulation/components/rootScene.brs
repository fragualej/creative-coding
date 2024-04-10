function init()
    print "rootScene [creative coding - pixel manipulation]"
    pixelManipulation()
end function

function pixelManipulation()
    n = 150
    resolution = getResolution()

    width = 1080
    height = 1080

    cols = n
    rows = n

    numCells = cols * rows

    gridw = width * 0.9
    gridh = height * 0.9

    cellw = gridw / cols
    cellh = gridh / rows

    ix = (resolution.width - width) * 0.5
    iy = (resolution.height - height) * 0.5

    bitMap = createObject("roBitmap", "pkg:/images/test-03.png")
    print bitMap.getWidth(), bitMap.getHeight()
    xOff = bitMap.getWidth() * 0.025
    yOff = bitMap.getHeight() * 0.025
    byteArray = bitMap.getByteArray(xOff, yOff, cols, rows)

    rectangle = m.top.createChild("rectangle")
    rectangle.width = width
    rectangle.height = height
    rectangle.translation = [ix, iy]
    rectangle.color = "#FFFFFF"

    cx = (width - gridw) * 0.5
    cy = (height - gridh) * 0.5

    gapx = cellw * 0.5
    gapy = cellh * 0.5

    print cellw, cellh

    for i = 0 to numCells - 1
        col = i mod cols
        row = fix(i / rows)

        x = cx + gapx + (col * cellw)
        y = cy + gapy + (row * cellh)

        r = byteArray[i * 4 + 0]
        g = byteArray[i * 4 + 1]
        b = byteArray[i * 4 + 2]
        a = byteArray[i * 4 + 3]

        glyph = getGlyph(g)

        label = rectangle.createChild("simplelabel")
        label.translation = [x, y]
        label.horizOrigin = "center"
        label.vertOrigin = "center"
        label.fontUri = "font:SystemFontFile"
        label.fontSize = rnd(15) * cellh
        label.color = "#000000"
        label.text = glyph
    end for
end function

function getResolution()
    devInfo = createObject("roDeviceInfo")
    return devInfo.getUIResolution()
end function

function getGlyph(v)
    if (v < 51) return " "
    if (v < 204) return "·"
    if (v < 255) return " "
end function