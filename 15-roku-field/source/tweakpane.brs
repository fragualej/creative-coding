function _tweakpane(params as object, screen) as object
    m = {
        _id: "tweakpane",
        _idx: 0,
        _screen: screen,
        _keys: params.keys,
        _font: invalid,
        _params: params,

        init: sub()
            fontReg = createObject("roFontRegistry")
            m._font = fontReg.GetDefaultFont(25, false, false)
        end sub

        update: sub(msg as object)
            buttonId = msg.GetInt()
            press = msg.isPress()
            _keys = m._params.keys()
            if press
                if buttonId = 2
                    m._idx -= 1
                    if m._idx <= 0 then m._idx = 0
                else if buttonId = 3
                    m._idx += 1
                    if m._idx >= m._params.count() - 1 then m._idx = m._params.count() - 1
                else if buttonId = 5
                    key = _keys[m._idx]
                    m._params[key].value += m._params[key].step
                else if buttonId = 4
                    key = _keys[m._idx]
                    m._params[key].value -= m._params[key].step
                end if
            end if
        end sub

        draw: sub()
            i = 0
            keys = m._params.keys()
            for each key in keys
                param = m._params[key]
                txt = param.id + chr(9) + left(str(param.value), 6)
                i += 50
                m._screen.drawText(txt, 100, i, param.color, m._font)
            end for
        end sub
    }
    m.init()
    return m
end function