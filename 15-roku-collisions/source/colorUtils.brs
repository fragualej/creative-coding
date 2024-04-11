function colorUtils_getByName(name as string) as integer
    colors = {
        "white": &hFFFFFFFF,
        "black": &h000000FF,
        "red": &hFF0000FF,
        "green": &h00FF00FF,
        "blue": &h0000FFFF,
        "gray": &h969696FF,
        "purple": &h8A2BE2FF,
        "orange": &hFFA500FF,
        "yellow": &hFFFF00FF,
        "cyan": &h00FFFFFF
        "violet": &hEE82EEFF,
    }

    if colors.doesExist(name) then
        return colors[name]
    else
        print "Color not found. Returning default (white)."
        return colors["white"]
    end if
end function
