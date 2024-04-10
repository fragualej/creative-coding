function _tweakpane(params as object, screen) as object
    m = {
        _id: "tweakpane",
        _idx: 0,
        _screen: screen,
        _keys: params.keys,
        _font: invalid,
        _params: params,
        _items: []
        _colors: {
            white: &hFFFFFFFF
            black: &h000000FF
            gray: &h969696FF
            green: &h00FF00FF
        },

        init: sub()
            fontReg = createObject("roFontRegistry")
            m._font = fontReg.GetDefaultFont(28, false, false)
        end sub

        update: sub(msg as object)
            btnIndex = msg.GetInt()
            press = msg.isPress()
            _keys = m._params.keys()
            if press
                print "[DEBUG] btnIndex: ", btnIndex
                if btnIndex = 2
                    m._idx -= 1
                    if m._idx <= 0 then m._idx = 0
                else if btnIndex = 3
                    m._idx += 1
                    if m._idx >= m._params.count() - 1 then m._idx = m._params.count() - 1
                else if btnIndex = 5
                    key = _keys[m._idx]
                    m._params[key].value += m._params[key].step
                else if btnIndex = 4
                    key = _keys[m._idx]
                    m._params[key].value -= m._params[key].step
                end if
            end if
        end sub

        draw: sub()
            i = 0
            keys = m._params.keys()
            w = 250
            h = 40
            ix = 75
            iy = 75
            dy = 50
            i = 0
            for each key in m._params.keys()
                val = m._params[key].toStr()

                x0 = m._font.GetOneLineWidth(key, m._screen.GetWidth())
                x2 = m._font.GetOneLineWidth(val, m._screen.GetWidth())
                x1 = w - (x0 + x2)

                keyTxt = key
                valTxt = m._params[key].toStr()
                focusedColor = m._colors.white
                if (m._idx = i)
                    focusedColor = m._colors.green
                end if
                m._screen.drawRect(ix, iy, w, h, focusedColor)
                m._screen.drawText(keyTxt, ix, iy, m._colors.black, m._font)
                m._screen.drawText(valTxt, ix + (x0 + x1), iy, m._colors.black, m._font)

                iy += dy
                i++
            end for
        end sub
    }
    m.init()
    return m
end function