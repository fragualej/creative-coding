function Math_PI()
    return 3.14159265358979323846
end function

function Math_atan2(y as float, x as float) as float
    PI = Math_PI()
    if x > 0 then
        return atn(y / x)
    else if x < 0 then
        if y >= 0 then
            return atn(y / x) + PI
        else
            return atn(y / x) - PI
        end if
    else
        if y > 0 then
            return PI / 2
        else if y < 0 then
            return -PI / 2
        else
            return 0 ' Undefined, you can return whatever you like
        end if
    end if
end function
