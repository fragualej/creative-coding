sub init()
    m.rectangle = m.top.findNode("rectangle")
end sub

sub onTranslationSet(event as object)
    t = event.getData()
    w = m.rectangle.width
    h = m.rectangle.height
    m.rectangle.translation = [t[0] - w, t[1] - h]
end sub