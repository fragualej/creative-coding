function _agent(x, y)
    m = {
        pos: vector(x, y),
        vel: vector(0, 0),
        screen: m.screen,
        draw: sub()
            m.screen.drawPoint(m.pos.x, m.pos.y, 10, colorUtils_getByName("white"))
        end sub
        update: sub()
            ' m.screen.drawPoint(m.pos.x, m.pos.y, 10, colorUtils_getByName("white"))
        end sub
    }
    return m
end function