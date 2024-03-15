function getDisplaySize()
    return createObject("roDeviceInfo").GetDisplaySize()
end function

function getBinary(a, b, c, d)
    return (a * 8 + b * 4 + c * 2 + d * 1)
end function