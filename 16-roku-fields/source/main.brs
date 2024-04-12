library "v30/bslCore.brs"

sub main()
    print "[DEBUG] Main function started."

    m.screen = createObject("roScreen")
    m.port = createObject("roMessagePort")
    timer = createObject("roTimeSpan")

    m.screen.setMessagePort(m.port)
    m.screen.setAlphaEnable(true)

    width = 1080
    height = 1080
    gridw = width * 0.95
    gridh = height * 0.95

    n = 24
    numCells = (n - 1) * (n - 1)

    ix = (m.screen.getWidth() - gridw) * 0.5
    iy = (m.screen.getHeight() - gridh) * 0.5

    cellw = gridw / n
    cellh = gridh / n

    agents = []
    for i = 0 to n - 1
        for j = 0 to n - 1
            x = ix + i * cellw
            y = iy + j * cellh
            agents.push(_agent(x, y))
        end for
    end for

    while true
        msg = wait(1, m.port)
        msgType = type(msg)
        ms = timer.totalMilliseconds()

        if ms mod 30 = 0 ' 30 frames/sec
            m.screen.clear(colorUtils_getByName("black"))
            for each agent in agents
                agent.draw()
                agent.update()
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

