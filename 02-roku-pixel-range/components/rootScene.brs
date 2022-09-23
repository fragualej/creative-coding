function init()
    print "rootScene [creative coding - pixel manipulation]"
    pixelManipulation()
end function

function pixelManipulation()
    n = 48
    resolution = getResolution()
   
    width  = 1080
    height = 1080
    
    cols  = n
    rows  = n

    numCells = cols * rows

    gridw = width  * 0.9
    gridh = height * 0.9

    cellw = gridw / cols
    cellh = gridh / rows

    ix = (resolution.width  - width)  * 0.5
    iy = (resolution.height - height) * 0.5

    bitMap = createObject("roBitmap", "pkg:/images/image-01.jpeg")
    byteArray = bitMap.getByteArray(0, 0, bitMap.getWidth(), bitMap.getHeight())

    black = "#000000"
    white = "#FFFFFF"

    rectangle                  = m.top.createChild("rectangle")
    rectangle.width            = width
    rectangle.height           = height
    rectangle.translation      = [ix, iy]
    rectangle.color            = black

    cx = (width  - gridw) * 0.5
    cy = (height - gridh) * 0.5

    gapx = cellw * 0.5
    gapy = cellh * 0.5
    
    for i = 0 to numCells - 1
        col = i mod cols
        row = fix(i / rows)

        x = cx + gapx + (col * cellw)
        y = cy + gapy + (row * cellh)

        rx = fix((x / width)  * bitMap.getWidth())
        ry = fix((y / height) * bitMap.getHeight())
        idx = (ry * bitMap.getWidth() + rx) * 4
        
        r = byteArray[idx + 0]
        g = byteArray[idx + 1]
        b = byteArray[idx + 2]

        glyph = getGlyph(r)
        fontSize = mapRange(r, 0, 255, cellh * 0, cellh * 1)
        color = intToHex(r,g,b)
        print i, glyph, r, fontSize, color
        if fontSize > cellh * 0.5
            label               = rectangle.createChild("simplelabel")
            label.translation   = [x, y]
            label.horizOrigin   = "center"
            label.vertOrigin    = "center"
            label.fontUri       = "font:BoldSystemFontFile"
            label.fontSize      = fontSize
            label.color         = color
            label.text          = glyph
            label.rotation      = setRotation()
        end if
    end for
end function

function getResolution()
    devInfo = createObject("roDeviceInfo")
    return devInfo.getUIResolution()
end function

function getGlyph(v)
    chars = " 01101".split("")
    idx = mapRange(v, 0, 255, 0, chars.count() - 1)
    value = chars[idx]
    return value
end function 

function mapRange(value, inputMin, inputMax, outputMin, outputMax)
    s = (outputMax - outputMin) / (inputMax - inputMin) 
    return outputMin + (value - inputMin) * s
end function

function intToHex(r,g,b)
    return substitute("#{0}{1}{2}", strI(r, 16), strI(g, 16), strI(b, 16)) 
end function

function setRotation()
    r = [0, 90, 180, 360]
    return (r[rnd(0) * r.count() - 1] * 3.141592654) / 180
end function