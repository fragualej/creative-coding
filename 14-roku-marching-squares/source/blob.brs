function _blob(x, y, cellh)
    m = {
        radius: cellh * randomRange(0.5, 1.25)
        pos: vector(x, y)
        vel: vector(randomRange(-5, 5), randomRange(-5, 5))
        screen: m.screen
        draw: sub()
            slides = 12
            angleStep = 2 * 3.14159 / slides
            for i = 0 to slides - 1
                x = m.pos.x + m.radius * cos(i * angleStep)
                y = m.pos.y + m.radius * sin(i * angleStep)
                m.screen.drawPoint(x, y, m.radius * 0.05, &hFFFFFFFF)
            end for
        end sub
        update: sub()
            m.pos.x += m.vel.x
            m.pos.y += m.vel.y
        end sub
        bounce: sub(ix, iy, width, height)
            if m.pos.x - m.radius <= ix or m.pos.x >= ix + width - m.radius then m.vel.x *= -1
            if m.pos.y - m.radius <= iy or m.pos.y >= iy + height - m.radius then m.vel.y *= -1
        end sub
    }
    return m
end function