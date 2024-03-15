sub main()
    screen = createObject("roScreen")
    port = createObject("roMessagePort")
    timer = createObject("roTimeSpan")
    math = mathUtils()

    screen.setMessagePort(port)

    width = 1080
    height = 1080

    black = &h000000FF
    white = &hFFFFFFFF

    screen.clear(black)

    PI = math.PI()

    cx = 0.5 * screen.getWidth()
    cy = 0.5 * screen.getHeight()

    ' edgeLength = 500 ' cube's edge length
    ' n = 7 ' number of points per edge
    ' vectors = []

    ' for i = 0 to n - 1
    '     for j = 0 to n - 1
    '         for k = 0 to n - 1
    '             x = i * edgeLength / n
    '             y = j * edgeLength / n
    '             z = k * edgeLength / n

    '             vectors.push({ x: x, y: y, z: z })
    '         end for
    '     end for
    ' end for

    n = 20
    angleStep = 2 * PI / n
    r = 100 ' tube radius
    R = 200 ' ring radius
    vectors = []

    for i = 0 to n - 1
        phi = i * angleStep
        for j = 0 to n - 1
            theta = j * angleStep
            x = (R + r * cos(theta)) * cos(phi)
            y = (R + r * cos(theta)) * sin(phi)
            z = r * sin(theta)
            vectors.push({ x: x, y: y, z: z })
        end for
    end for

    rotationStep = 0
    while true
        msg = port.getMessage()
        ms = timer.totalMilliSeconds()
        if ms mod 100 = 0
            screen.clear(black)
            for each vector in vectors
                r = rotationXYZ(vector, rotationStep)
                screen.drawPoint(r.x + cx, r.y + cy, 5, white)
            end for
            rotationStep += PI / 128
        end if
        screen.swapBuffers()
    end while
end sub

function min(a, b)
    if a < b then return a else return b
end function


function mathUtils()
    m = {
        PI: function()
            return 3.1415926535897932384626433832795
        end function
    }
    return m
end function

function rotationXYZ(vector, angle)
    ' Compute the sine and cosine of the angle once

    sinAngle = sin(angle)
    cosAngle = cos(angle)

    ' Create the rotation matrices
    RX = [
        [1, 0, 0],
        [0, cosAngle, -sinAngle],
        [0, sinAngle, cosAngle]
    ]

    RY = [
        [cosAngle, 0, sinAngle],
        [0, 1, 0],
        [-sinAngle, 0, cosAngle]
    ]

    RZ = [
        [cosAngle, -sinAngle, 0],
        [sinAngle, cosAngle, 0],
        [0, 0, 1]
    ]

    RXY = multiplyMatrices(RX, RY)
    RXYZ = multiplyMatrices(RXY, RZ)

    return multiplyMatrixVector(RXYZ, vector)
end function



function multiplyMatrixVector(matrix as object, vector as object) as object
    ' Check if the input parameters are valid
    if type(matrix) <> "roArray" or type(vector) <> "roAssociativeArray" then return invalid

    result = []
    for each row in matrix
        result.push(row[0] * vector.x + row[1] * vector.y + row[2] * vector.z)
    end for

    ' Convert the result array to a vector object
    return { x: result[0], y: result[1], z: result[2] }
end function



function multiplyMatrices(A, B)
    rowsA = A.count()
    colsA = A[0].count()
    colsB = B[0].count()

    ' Initialize C to the correct size
    C = []
    for i = 0 to rowsA - 1
        C.push([])
        for j = 0 to colsB - 1
            C[i].push(0)
        end for
    end for

    ' Perform the matrix multiplication
    for i = 0 to rowsA - 1
        for j = 0 to colsB - 1
            for k = 0 to colsA - 1
                C[i][j] += A[i][k] * B[k][j]
            end for
        end for
    end for

    return C
end function


function dotProduct(vector1 as object, vector2 = { x: 0, y: 1, z: -1 }) as float
    return vector1.x * vector2.x + vector1.y * vector2.y + vector1.z * vector2.z
end function
