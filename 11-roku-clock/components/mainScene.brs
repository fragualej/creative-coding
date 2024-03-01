sub init()
    m.hoursLabel = m.top.findNode("hoursLabel")
    m.minsLabel = m.top.findNode("minsLabel")
    m.secsLabel = m.top.findNode("secsLabel")
    m.meridiemLabel = m.top.findNode("meridiemLabel")

    m.dateTime = createObject("roDateTime")

    m.timer = m.top.findNode("timer")
    m.timer.duration = 1 / 60
    m.timer.repeat = true
    m.timer.control = "start"
    m.timer.observeField("fire", "draw")
end sub


sub draw()
    setClock()
end sub


sub setClock()
    m.dateTime.mark()
    m.dateTime.toLocalTime()

    hh = m.dateTime.asTimeStringLoc("hh")
    mm = m.dateTime.asTimeStringLoc("mm")
    meridiem = m.dateTime.asTimeStringLoc("a")

    ss = m.dateTime.GetSeconds()
    if ss < 10
        ss = substitute(("0{0}"), ss.toStr())
    else
        ss = ss.toStr()
    end if

    m.hoursLabel.text = hh
    m.minsLabel.text = mm
    m.secsLabel.text = ss
    m.meridiemLabel.text = meridiem
end sub