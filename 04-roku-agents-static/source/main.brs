library "v30/bslCore.brs"

sub main()
    screen = createObject("roScreen")
    port = createObject("roMessagePort")
    screen.setMessagePort(port)
    timer = createObject("roTimeSpan")
    timer.mark()

    width  = 1080
    height = 1080
    
    n = 40
    
    white = &hFFFFFFFF
    black = &h000000FF

    gridw = width  * 0.8
    gridh = height * 0.8
     
    ix = (screen.getWidth()  - width)  * 0.5
    iy = (screen.getHeight() - height) * 0.5

    screen.drawRect(ix, iy, width, height, white)

    cx = (screen.getWidth()  - gridw) * 0.5
    cy = (screen.getHeight() - gridh) * 0.5

    points = []
    for i = 0 to n - 1
        x = cx + gridw * rnd(0)
        y = cy + gridh * rnd(0)
        points.push([x, y])
        screen.drawPoint(x, y, 5 + rnd(5), black)
    end for

    for i = 0 to points.count() - 1
        startPoint = [points[i][0], points[i][1]]
        for j = i + 1 to points.count() - 1
            endPoint = [points[j][0], points[j][1]]
            distance = getDistance(startPoint, endPoint)
            if distance < 200
                screen.drawLine(startPoint[0], startPoint[1], endPoint[0], endPoint[1], black)
            end if
        end for
    end for
    screen.swapbuffers()

    while (true)
        msg = wait(0, port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        else if msgType = "roUniversalControlEvent"
            print msg.getInt(), msg.getKey()
        end if
    end while
end sub

function getDistance(startPoint, endPoint)
    dx = startPoint[0] - endPoint[0]
    dy = startPoint[1] - endPoint[1]
    return (sqr(dx * dx + dy * dy))
end function
