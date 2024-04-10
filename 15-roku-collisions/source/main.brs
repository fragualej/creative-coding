library "v30/bslCore.brs"

sub main()
    print "[DEBUG] Main function started."

    m.screen = createObject("roScreen")
    port = createObject("roMessagePort")
    timer = createObject("roTimeSpan")

    m.screen.setMessagePort(port)
    m.screen.setAlphaEnable(true)

    white = &hFFFFFFFF
    black = &h000000FF
    red = &hFF0000FF
    green = &h00FF00FF
    blue = &h0000FFFF
    gray = &h969696FF
    purple = &h8A2BE2FF
    orange = &hFFA500FF
    yellow = &hFFFF00FF

    params = {
        "ftr": 100000
        "num": 1.024
        "dim": 4.0034
        "scale": 100
    }

    tweakpane = _tweakpane(params, m.screen)

    width = 1080
    height = 1080
    gridw = width * 0.95
    gridh = height * 0.95
    threshold = 1.000
    numBlobs = 5
    gridSize = 24

    n = 24
    numCells = (n - 1) * (n - 1)

    ix = (m.screen.getWidth() - gridw) * 0.5
    iy = (m.screen.getHeight() - gridh) * 0.5

    cellw = gridw / n
    cellh = gridh / n

    blobs = []
    blobs.push(_blob(ix + gridw * 0.25, iy + gridh * 0.45, cellh * 3))
    blobs.push(_blob(ix + gridw * 0.75, iy + gridh * 0.50, cellh * 2))

    blobs[0].vel.x = 5
    blobs[0].vel.y = 0

    blobs[1].vel.x = 0
    blobs[1].vel.y = 0
    ' for i = 0 to numBlobs - 1
    '     while true
    '         x = ix + gridw * randomRange(0.1, 0.9)
    '         y = iy + gridh * randomRange(0.1, 0.9)
    '         if not checkPosition(x, y, cellh, blobs) then exit while
    '     end while
    '     blobs.push(_blob(x, y, cellh))
    ' end for

    while true
        msg = wait(1, port)
        msgType = type(msg)
        ms = timer.totalMilliseconds()
        if msgType = "roUniversalControlEvent"
            tweakpane.update(msg)
        end if

        if ms mod 30 = 0 ' 30 frames/sec
            m.screen.clear(black)
            tweakpane.draw()
            for each blob in blobs
                blob.draw()
                blob.update()
                blob.bounce(ix, iy, gridw, gridh)
            end for

            for i = 0 to blobs.count() - 1
                for j = i + 1 to blobs.count() - 1
                    blobs[i].collision(blobs[j])
                end for
            end for

            m.screen.swapbuffers()
        end if
    end while
end sub


function vector(x, y)
    return { x: x, y: y }
end function


function dist(x0, y0, x1, y1)
    dx = x0 - x1
    dy = y0 - y1
    return (sqr(dx * dx + dy * dy))
end function


function midpoint(x0, y0, x1, y1)
    dx = (x0 + x1) * 0.5
    dy = (y0 + y1) * 0.5
    return vector(dx, dy)
end function


function lerp(x0, y0, x1, y1, x)
    if x0 = x1
        return (y0 + y1) * 0.5
    end if
    return y0 + (y1 - y0) * ((x - x0) / (x1 - x0))
end function


sub line(x0, y0, x1, y1)
    m.screen.drawLine(x0, y0, x1, y1, &hFFFFFFFF)
end sub


function randomRange(min as float, max as float) as float
    return min + rnd(0) * (max - min)
end function

function checkPosition(x, y, size, blobs) as boolean
    for each blob in blobs
        d = dist(blob.pos.x, blob.pos.y, x, y)
        if d < blob.radius + size then return true
    end for
    return false
end function

