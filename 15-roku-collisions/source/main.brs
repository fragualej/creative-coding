library "v30/bslCore.brs"

sub main()
    print "[DEBUG] Main function started."

    m.screen = createObject("roScreen")
    port = createObject("roMessagePort")
    timer = createObject("roTimeSpan")

    m.screen.setMessagePort(port)
    m.screen.setAlphaEnable(true)

    width = 1080
    height = 1080
    gridw = width * 0.95
    gridh = height * 0.95
    threshold = 1.000
    numBlobs = 4
    gridSize = 24

    n = 24
    numCells = (n - 1) * (n - 1)

    ix = (m.screen.getWidth() - gridw) * 0.5
    iy = (m.screen.getHeight() - gridh) * 0.5

    cellw = gridw / n
    cellh = gridh / n

    blobs = []
    for i = 0 to numBlobs - 1
        while true
            x = ix + gridw * randomRange(0.1, 0.9)
            y = iy + gridh * randomRange(0.1, 0.9)
            size = randomRange(cellh * 1, cellh * 5)
            if not checkPosition(x, y, size, blobs) then exit while
        end while
        blobs.push(_blob(x, y, size))
    end for

    while true
        msg = wait(1, port)
        msgType = type(msg)
        ms = timer.totalMilliseconds()

        if ms mod 30 = 0 ' 30 frames/sec
            m.screen.clear(colorUtils_getByName("black"))
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
    m.screen.drawLine(x0, y0, x1, y1, colorUtils_getByName("white"))
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

