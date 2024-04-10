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
        ' collision: sub(other as object)
        '     ' Calculate the distance between the two blobs
        '     d = dist(other.pos.x, other.pos.y, m.pos.x, m.pos.y)

        '     ' Check if the distance is less than the sum of the radii
        '     if d < m.radius + other.radius then
        '         ' The blobs are colliding, swap their velocities
        '         temp = m.vel
        '         m.vel = other.vel
        '         other.vel = temp
        '     end if
        ' end sub

        collision: sub(other as object)
            ' Calculate the distance between the two blobs
            d = dist(other.pos.x, other.pos.y, m.pos.x, m.pos.y)

            ' ' Check if the distance is less than the sum of the radius
            if d < m.radius + other.radius then
                ' The blobs are colliding, calculate the collision response
                PI = Math_PI()
                dx = m.pos.x - other.pos.x
                dy = m.pos.y - other.pos.y
                collisionAngle = Math_atan2(dy, dx)

                magnitude1 = sqr(m.vel.x ^ 2 + m.vel.y ^ 2)
                magnitude2 = sqr(other.vel.x ^ 2 + other.vel.y ^ 2)

                direction1 = Math_atan2(m.vel.y, m.vel.x)
                direction2 = Math_atan2(other.vel.y, other.vel.x)


                new_xspeed1 = magnitude1 * cos(direction1 - collisionAngle)
                new_yspeed1 = magnitude2 * sin(direction2 - collisionAngle)
                new_xspeed2 = magnitude2 * cos(direction2 - collisionAngle)
                new_yspeed2 = magnitude1 * sin(direction1 - collisionAngle)

                final_xspeed1 = cos(collisionAngle) * new_xspeed1 + cos(collisionAngle + PI / 2) * new_yspeed1
                final_yspeed1 = sin(collisionAngle) * new_xspeed1 + sin(collisionAngle + PI / 2) * new_yspeed1
                final_xspeed2 = cos(collisionAngle) * new_xspeed2 + cos(collisionAngle + PI / 2) * new_yspeed2
                final_yspeed2 = sin(collisionAngle) * new_xspeed2 + sin(collisionAngle + PI / 2) * new_yspeed2

                m.vel.x = final_xspeed1
                m.vel.y = final_yspeed1
                other.vel.x = final_xspeed2
                other.vel.y = final_yspeed2

                print dx, dy, collisionAngle, direction1, direction2, formatJson(m.vel), formatJson(other.vel)
            end if
            print "------------------------"
        end sub
    }
    return m
end function