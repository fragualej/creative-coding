library "v30/bslCore.brs"

sub main()
    screen = createObject("roScreen")
    port = createObject("roMessagePort")
    timer = createObject("roTimeSpan")

    screen.setMessagePort(port)
    screen.setAlphaEnable(true)

    width = 1080
    height = 1080

    n = 2

    white = &hFFFFFFFF
    black = &h000000FF
    gray = &hD4D4D4FF
    purple = &h8A2BE2FF

    gridw = width * 0.8
    gridh = height * 0.8

    ix = (screen.getWidth() - width) * 0.5
    iy = (screen.getHeight() - height) * 0.5

    points = []
    for i = 0 to n - 1
        x = ix + gridw * 0.5
        y = iy + gridh * 0.5
        points.push(agent(x, y, points))
    end for

    while true
        msg = wait(1, port)
        msgType = type(msg)

        ms = timer.totalMilliseconds()
        if ms mod 33 = 0 ' 30 frames/sec
            screen.clear(gray)
            for each point in points
                screen.drawPoint(point.pos.x, point.pos.y, point.size, black)
                point.update()
                point.bounce(ix, iy, width, height)
                point.collision()
            end for

            for i = 0 to points.count() - 1
                startPoint = points[i]
                for j = i + 1 to points.count() - 1
                    endPoint = points[j]
                    ' startPoint.collision(endPoint.pos.x, endPoint.pos.y)
                    ' endPoint.collision(startPoint.pos.x, startPoint.pos.y)
                    distance = getDistance(startPoint.pos, endPoint.pos)
                    if distance < 10
                        screen.drawLine(startPoint.pos.x, startPoint.pos.y, endPoint.pos.x, endPoint.pos.y, black)
                        ' startPoint.collision()
                        ' endPoint.collision()
                    end if
                end for
            end for

            screen.swapbuffers()
            print "[timer]", ms
        end if
    end while
end sub

function agent(x, y, agents)
    m = {
        size: 2.5 + rnd(35)
        pos: vector(x, y)
        vel: vector(10 * rnd(1), 0)
        agents: agents
        update: sub()
            m.pos.x += m.vel.x
            m.pos.y += m.vel.y
        end sub
        bounce: sub(ix, iy, width, height)
            if m.pos.x <= ix or m.pos.x >= ix + width then m.vel.x *= -1
            if m.pos.y <= iy or m.pos.y >= iy + height then m.vel.y *= -1
        end sub
        collision: sub()
            m.vel.x *= -1
            print m.agents
        end sub
    }
    return m
end function

function vector(x, y)
    return { x: x, y: y }
end function

function getDistance(startPoint, endPoint)
    dx = startPoint.x - endPoint.x
    dy = startPoint.y - endPoint.y
    return (sqr(dx * dx + dy * dy))
end function