library "v30/bslCore.brs"

sub main()
    print "[DEBUG] Main function started."

    m.screen = createObject("roScreen")
    port = createObject("roMessagePort")
    timer = createObject("roTimeSpan")

    m.screen.setMessagePort(port)
    m.screen.setAlphaEnable(true)

    red = &hFF0000FF
    green = &h00FF00FF
    blue = &h0000FFFF
    white = &hFFFFFFFF
    black = &h000000FF
    gray = &h969696FF
    purple = &h8A2BE2FF
    orange = &hFFA500FF
    yellow = &hFFFF00FF

    width = 1080
    height = 1080
    gridw = width * 0.9
    gridh = height * 0.9
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
        blobs.push(_blob(ix + gridw * 0.5, iy + gridh * 0.5, cellh))
    end for

    params = {
        "gridSize": { id: "grid size: ", "value": gridSize, "step": 1, color: white },
        "blobs": { id: "num blobs: ", "value": numBlobs, "step": 1, color: white },
        "threshold": { id: "threshold: ", "value": threshold, "step": 0.025, color: white },
    }
    keys = params.keys()
    idx = 0

    tweakpane = _tweakpane(params, m.screen)

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

            drawMetaballs(n, numCells, cellw, cellh, blobs, ix, iy, gridw, gridh, params["threshold"].value)
            m.screen.swapbuffers()
        end if
    end while
end sub

sub drawMetaballs(n, numCells, cellw, cellh, blobs, ix, iy, gridw, gridh, threshold)
    cells = []
    for i = 0 to n - 1
        for j = 0 to n - 1
            sum = 0
            x = ix + i * cellw
            y = iy + j * cellh

            for each blob in blobs
                if dist(x, y, blob.pos.x, blob.pos.y) > 0
                    sum += blob.radius / dist(x, y, blob.pos.x, blob.pos.y)
                end if
            end for

            state = 0
            if (sum <= threshold) then state = 1

            cells.push(cell(x, y, state, sum))
        end for
    end for

    for i = 0 to numCells - 1
        col = i mod (n - 1)
        row = fix(i / (n - 1))
        p0 = cells[(col + 0) + (row + 0) * (n)]
        p1 = cells[(col + 1) + (row + 0) * (n)]
        p2 = cells[(col + 1) + (row + 1) * (n)]
        p3 = cells[(col + 0) + (row + 1) * (n)]

        state = getBinary(p0.state, p1.state, p2.state, p3.state)
        drawIsoLine(p0, p1, p2, p3, state, threshold)
    end for
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

function cell(x, y, state, sum)
    m = {
        state: state
        sum: sum
    }
    m.append(vector(x, y))
    return m
end function

sub drawIsoLine(p0, p1, p2, p3, state, threshold = 1.5)
    qx = p0.x
    qy = lerp(p0.sum, p0.y, p1.sum, p1.y, threshold)

    px = lerp(p1.sum, p1.x, p2.sum, p2.x, threshold)
    py = p1.y

    rx = p2.x
    ry = lerp(p2.sum, p2.y, p3.sum, p3.y, threshold)

    sx = lerp(p3.sum, p3.x, p0.sum, p0.x, threshold)
    sy = p3.y

    a = vector(qx, qy)
    b = vector(px, py)
    c = vector(rx, ry)
    d = vector(sx, sy)


    if state = 1 or state = 14
        line(d.x, d.y, c.x, c.y)
    else if state = 2 or state = 13
        line(b.x, b.y, c.x, c.y)
    else if state = 3 or state = 12
        line(b.x, b.y, d.x, d.y)
    else if state = 4 or state = 11
        line(a.x, a.y, b.x, b.y)
    else if state = 5
        line(a.x, a.y, d.x, d.y)
        line(b.x, b.y, c.x, c.y)
    else if state = 6 or state = 9
        line(a.x, a.y, c.x, c.y)
    else if state = 7 or state = 8
        line(a.x, a.y, d.x, d.y)
    else if (state = 10)
        line(a.x, a.y, b.x, b.y)
        line(d.x, d.y, c.x, c.y)
    else
        ' No lines to draw
    end if
end sub

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