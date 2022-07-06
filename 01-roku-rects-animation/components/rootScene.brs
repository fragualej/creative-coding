function init()
    print "rootScene [creative coding]"
    m.top.backgroundColor="#FFFFFF"
    m.top.backgroundUri = ""
    resolution = getResolution()
    initAnimation()
    draw(resolution)
end function

sub initAnimation()
    m.animation = m.top.createChild("animation")
    m.animation.duration = 6
    m.animation.easeFunction = "linear"
    m.animation.repeat = true
    m.animation.control = "start" 
end sub

sub draw(resolution)
    n = 16
    width  = resolution.width
    height = resolution.height
    
    cols  = n
    rows  = n
    numCells = cols * rows

    gridw = 1080
    gridh = 1080

    cellw = gridw / cols
    cellh = gridh / rows

    gapx = cellw * 0.1
    gapy = cellh * 0.1

    ix = (width  - gridw) * 0.5
    iy = (height - gridh) * 0.5
    s = 0

    for i = 0 to numCells - 1
        col = i mod cols
        row = fix(i / rows)
        
        x = ix + (col * cellw)
        y = iy + (row * cellh)

        w = cellw * 1.25
        h = cellh * 1.25
        
        rectangle = m.top.createChild("rectangle")
        rectangle.opacity = 0.75
        rectangle.id = "rect-" + i.toStr()
        rectangle.translation = [x, y]
        rectangle.width  = w
        rectangle.height = h

        if i < 16
            hex = "0" + stri(i, 16)
        else
            hex = stri(i, 16)
        end if
        
        R = "#" + hex  + "00" + "00"
        G = "#" + "00" + hex  + "00"
        B = "#" + "00" + "00" + hex

        animate(rectangle, [R, G, B])

        print i, hex, R, G, B
    end for
end sub

sub animate(rectangle as object, keyValue as object)
    interpolator = m.animation.createChild("colorFieldInterpolator")
    interpolator.key = [0.0, 0.5, 1.0]
    interpolator.keyValue = keyValue
    interpolator.fieldToInterp = rectangle.id + ".color" 
end sub

function getResolution()
    devInfo = createObject("roDeviceInfo")
    return devInfo.getUIResolution()
end function