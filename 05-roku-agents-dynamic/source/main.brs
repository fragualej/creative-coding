library "v30/bslCore.brs"

sub main()
    screen  = createObject("roScreen")
    port    = createObject("roMessagePort")
    timer   = createObject("roTimeSpan")

    screen.setMessagePort(port)
    screen.setAlphaEnable(true)
    
    width  = 1080
    height = 1080
    
    n = 50
    
    white   = &hFFFFFFFF
    black   = &h000000FF
    gray    = &h808080FF
    purple  = &h8A2BE2FF

    gridw = width  * 0.8
    gridh = height * 0.8
     
    ix = (screen.getWidth()  - width)  * 0.5
    iy = (screen.getHeight() - height) * 0.5
 
    points = []
    for i = 0 to n - 1
        x = ix + gridw * rnd(0)
        y = iy + gridh * rnd(0)
        point = agent(x, y)
        points.push(point)
    end for

    while true
        msg = port.getMessage() 
        msgType = type(msg)

        ms = timer.totalMilliseconds()
        if ms mod 33 = 0 ' 30 frames/sec
        ' if msgType = "roUniversalControlEvent" and msg.isPress()
            screen.clear(white)
            for each point in points
                screen.drawPoint(point.pos.x, point.pos.y, point.size, black)
                point.update()
                point.bounce(ix, iy, width, height)
            end for

            for i = 0 to points.count() - 1
                startPoint = points[i].pos
                for j = i + 1 to points.count() - 1
                    endPoint = points[j].pos
                    distance = getDistance(startPoint, endPoint)
                    if distance < 150
                        screen.drawLine(startPoint.x, startPoint.y, endPoint.x, endPoint.y, black)
                    end if
                end for
            end for

            screen.finish()
            print "[timer]", ms
        end if
    end while
end sub

function agent(x, y)
    m = {
        size    : 2.5 + rnd(15)
        pos     : vector(x, y)
        vel     : vector(2 * rnd(0), 2 * rnd(0))
        update  : function ()
            m.pos.x += m.vel.x
            m.pos.y += m.vel.y
        end function
        bounce  : function (ix, iy, width, height)
            if m.pos.x <= ix OR m.pos.x >= ix + width  then m.vel.x *= -1
            if m.pos.y <= iy OR m.pos.y >= iy + height then m.vel.y *= -1
        end function   
    }
    return m
end function

function vector (x, y)
    return { x: x, y: y } 
end function

function getDistance(startPoint, endPoint)
    dx = startPoint.x - endPoint.x
    dy = startPoint.y - endPoint.y
    return (sqr(dx * dx + dy * dy))
end function