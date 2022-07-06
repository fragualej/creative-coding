sub main()
    screen  = createObject("roScreen")
    port    = createObject("roMessagePort")
    timer   = createObject("roTimeSpan")

    screen.setMessagePort(port)

    width  = 1080
    height = 1080
    
    black   = &h000000FF
    white   = &hFFFFFFFF
     
    n = 16
    w = 60      
    h = 60      
    gap = 7.5   

    ix = (screen.getWidth()  - width)  * 0.5
    iy = (screen.getHeight() - height) * 0.5
    
    while true
        ms = timer.totalMilliseconds()
        if ms mod 1000 = 0
            for i = 0 to n
                for j = 0 to n
                    x = ix + i * (w + gap)
                    y = iy + j * (h + gap)
                    screen.drawRect(x, y,  w, h, white)
                    if rnd(0) > 0.5
                        screen.drawRect(x + 10, y + 10,  w - 20, h - 20, black)
                    end if
                end for
            end for     
        end if
        screen.finish()
    end while
end sub