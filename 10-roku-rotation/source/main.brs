sub main()
    screen  = createObject("roScreen")
    port    = createObject("roMessagePort")
    timer   = createObject("roTimeSpan")
    math    = mathUtils()

    screen.setMessagePort(port)

    width  = 1080
    height = 1080
    
    black   = &h000000FF
    white   = &hFFFFFFFF

    screen.clear(black)

    PI = math.PI()

    t = {}
    t.x = 0.5 * screen.getWidth()
    t.y = 0.5 * screen.getHeight()

    r       = 300
    alpha   = 0
    n       = 64
    delta   = 2 * PI / n
    vectors = []

    for i = 0 to n - 1
        x = r * cos(alpha)
        y = r * sin(alpha)
        z = 0
        vectors.push({ x: x, y: y, z: z })
        vectors.push({ x: 0.5 * x, y: 0.5 * y, z: 0 })
        alpha += delta
    end for

    deltaBeta = 0
    while true
        msg = port.getMessage()
        ms = timer.totalMilliSeconds()
        if ms mod 128 = 0
            screen.clear(black) 
            for each vector in vectors
                r = rotationXYZ(vector, deltaBeta)
                screen.drawPoint(r.x + t.x, r.y + t.y, 20 * rnd(0), white)
            end for
            deltaBeta += PI/32
        end if  
        screen.finish() 
    end while
end sub

function mathUtils()
    m = {
        PI: function()
            return 3.1415926535897932384626433832795
        end function
    }
    return m
end function

function rotationXYZ(vector, alpha)
    RX = [
        [ 1,    0         ,     0           ]
        [ 0,    cos(alpha),     -sin(alpha) ]
        [ 0,    sin(alpha),     cos(alpha)  ]
    ]
    RY = [
        [ cos(alpha),    0,  sin(alpha) ]
        [ 0         ,   1,  0           ]
        [ -sin(alpha),   0,  cos(alpha) ]
    ]
    RZ = [
        [ cos(alpha),  -sin(alpha)  , 0 ]
        [ sin(alpha),   cos(alpha)  , 0 ]
        [ 1         ,   0           , 0 ]
    ]

    U = matMul(RX, RY)
    V = matMul(U, RZ)

    W = []
    for each row in V
        W.push(row[0] * vector.x + row[1] * vector.y + row[2] * vector.z)
    end for
   return {x: W[0], y: W[1], z: W[2]}
end function

function matMul(A, B)
    C = [[],[],[]]
    for i = 0 to A.count() - 1
        for j = 0 to B.count() - 1
            C[i][j] = 0
            for k = 0 to 2
                C[i][j] += A[i][k] * B[k][j]
            end for
        end for
    end for
    return C
end function
