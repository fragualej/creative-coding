function _blob(x, y, size)
    m = {
        radius: size
        pos: vector(x, y)
        vel: vector(randomRange(-5, 5), randomRange(-5, 5))
        mass: size * 0.1
        screen: m.screen
        draw: sub()
            slides = 12
            angleStep = 2 * 3.14159 / slides
            for i = 0 to slides - 1
                x1 = m.pos.x + m.radius * cos(i * angleStep)
                y1 = m.pos.y + m.radius * sin(i * angleStep)
                x2 = m.pos.x + m.radius * cos((i + 1) * angleStep)
                y2 = m.pos.y + m.radius * sin((i + 1) * angleStep)
                m.screen.drawLine(x1, y1, x2, y2, &hFFFFFFFF)
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
        collision: sub(other as object)
            ' Calculate the distance between the two blobs
            d = dist(other.pos.x, other.pos.y, m.pos.x, m.pos.y)

            ' Check if the distance is less than the sum of the radius
            if d < m.radius + other.radius then
                ' The blobs are colliding, calculate the collision response
                pi = math_pi()
                m1 = m.mass
                m2 = other.mass

                dx = m.pos.x - other.pos.x
                dy = m.pos.y - other.pos.y
                phi = math_atan2(dy, dx)

                v1i = sqr(m.vel.x ^ 2 + m.vel.y ^ 2)
                v2i = sqr(other.vel.x ^ 2 + other.vel.y ^ 2)

                angle1 = math_atan2(m.vel.y, m.vel.x)
                angle2 = math_atan2(other.vel.y, other.vel.x)

                v1xr = v1i * cos(angle1 - phi)
                v1yr = v2i * sin(angle2 - phi)

                v2xr = v2i * cos(angle2 - phi)
                v2yr = v1i * sin(angle1 - phi)

                v1fxr = ((m1 - m2) * v1xr + (m2 + m2) * v2xr) / (m1 + m2)
                v2fxr = ((m1 + m1) * v1xr + (m2 - m1) * v2xr) / (m1 + m2)

                v1fyr = v1yr
                v2fyr = v2yr

                v1fx = cos(phi) * v1fxr + cos(phi + pi / 2) * v1fyr
                v1fy = sin(phi) * v1fxr + sin(phi + pi / 2) * v1fyr
                v2fx = cos(phi) * v2fxr + cos(phi + pi / 2) * v2fyr
                v2fy = sin(phi) * v2fxr + sin(phi + pi / 2) * v2fyr

                m.vel.x = v1fx
                m.vel.y = v1fy

                other.vel.x = v2fx
                other.vel.y = v2fy
            end if
        end sub
    }
    return m
end function