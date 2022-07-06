sub main()
    screen = createObject("roScreen")
    screen.setAlphaEnable(true)
    port = createObject("roMessagePort")
    screen.setMessagePort(m.port)
    timer = createObject("roTimeSpan")
    timer.mark()

    white  = &hFFFFFFFF
    black  = &h000000FF
    purple = &h9933FFFF  
    mint   = &hDAF7A6FF

    width  = 1080
    height = 1080

    cx = (screen.getWidth()  - width)  * 0.5
    cy = (screen.getHeight() - height) * 0.5

    screen.drawRect(cx, cy, width, height, white)
       
    n = 10
    numCells = n * n

    gridw = width  * 0.9
    gridh = height * 0.9

    cellw = gridw / n
    cellh = gridh / n

    ix = cx + (width  - gridw) * 0.5
    iy = cy + (height - gridh) * 0.5

    linew = 0.15 * cellw

    gapx = cellw - linew
    gapy = cellh - linew
    grid = []
    for i = 0 to numCells - 1
        row = fix(i / n)
        col = i mod n

        x = ix + col * cellw
        y = iy + row * cellh

        cell = newCell(row, col, x, y, cellw, cellh, gapx, gapy, linew, screen, white)
        grid.push(cell)

        screen.drawRect(x                   , y                     , linew     , linew    , mint)
        screen.drawRect(x + linew           , y                     , gapx      , linew    , purple)
        screen.drawRect(x + linew + gapx    , y                     , linew     , linew    , mint)
        screen.drawRect(x + linew + gapx    , y + linew             , linew     , gapx     , purple)
        screen.drawRect(x + linew + gapx    , y + gapy + linew      , linew     , linew    , mint)
        screen.drawRect(x + linew           , y + gapy + linew      , gapx      , linew    , purple)
        screen.drawRect(x                   , y + gapy + linew      , linew     , linew    , mint)
        screen.drawRect(x                   , y + linew , linew     , gapx                 , purple)
    end for

    r = fix(rnd(0) * grid.count())
    currCell = grid[r]
    currCell.visited = true
    stack = []
    while true
        if timer.totalMilliseconds() mod 100 = 0 
            nextCell = checkNextCells(currCell.row, currCell.col, grid, n)
            if nextCell <> invalid 
                stack.push(currCell)
                nextCell.visited = true

                markWalls(currCell, nextCell)
                currCell.removeWalls()
                nextCell.removeWalls()
                
                currCell = nextCell 
                
                screen.finish()
            else if stack.count() > 0 
                currCell = stack.pop()
            else
                msg = wait(0, port)
            end if
        end if
    end while
end sub

function newCell(row, col, x, y, cellw, cellh, gapx, gapy, linew, screen, color)
    m = {
        row: row
        col: col
        x: x
        y: y
        w: x + cellw
        h: y + cellh
        linew : linew
        cellw : cellw
        cellh : cellh
        gapx : gapx
        gapy: gapy
        color: color
        walls: [true, true, true, true]
        visited : false
        screen: screen

        removeWalls: function()
            if not m.walls[0]
                m.screen.drawRect(m.x + m.linew, m.y, m.gapx, m.linew, m.color)
            else if not m.walls[1]
                m.screen.drawRect(m.x + m.linew + m.gapx, m.y + m.linew, m.linew, m.gapx, m.color)
            else if not m.walls[2]
                m.screen.drawRect(m.x + m.linew, m.y + m.gapy + m.linew, m.gapx, m.linew, m.color)
            else if not m.walls[3]
                m.screen.drawRect(m.x, m.y + m.linew, m.linew, m.gapx, m.color)
            end if
        end function
    }
    return m
end function

function checkNextCells(row, col, grid, n)
        minRow = n * row
        maxRow = n * row + n

        top     = n * (row - 1) + col
        right   = n * (row    ) + col + 1
        bottom  = n * (row + 1) + col
        left    = n * (row    ) + col - 1

        nextCells = []

        if                                          grid[top]       <> invalid and not grid[top].visited    then nextCells.push(grid[top])
        if right >= minRow and right < maxRow   and grid[right]     <> invalid and not grid[right].visited  then nextCells.push(grid[right])
        if                                          grid[bottom]    <> invalid and not grid[bottom].visited then nextCells.push(grid[bottom])
        if left  >= minRow and left < maxRow    and grid[left]      <> invalid and not grid[left].visited   then nextCells.push(grid[left])
        
        r = fix(rnd(0) * nextCells.count())
        return nextCells[r]
end function

sub markWalls(currCell, nextCell) 
    if currCell.row - nextCell.row = 1
        currCell.walls[0] = false
        nextCell.walls[2] = false
    else if currCell.row - nextCell.row = -1
        currCell.walls[2] = false
        nextCell.walls[0] = false
    end if

    if currCell.col - nextCell.col = 1
        currCell.walls[3] = false
        nextCell.walls[1] = false
    else if currCell.col - nextCell.col = -1
        currCell.walls[1] = false
        nextCell.walls[3] = false
    end if
end sub