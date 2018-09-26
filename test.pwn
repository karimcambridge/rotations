// generated by "sampctl package generate"

#include "rotation.inc"
#include "rotation_misc.inc"

#define RUN_TESTS

#include <YSI\y_testing>

// Most cases should be tested but no guarantee for completeness

#define EPSILON 0.0001

bool: CheckOrPrintEuler(comment[], Float: x1, Float: y1, Float: z1, Float: x2, Float: y2, Float: z2) {
    new
        Float: x = x1 - x2,
        Float: y = y1 - y2,
        Float: z = z1 - z2
    ;
    while(x >= 360.0) x -= 360.0;
    while(y >= 360.0) y -= 360.0;
    while(z >= 360.0) z -= 360.0;
    while(x <= -EPSILON) x += 360.0;
    while(y <= -EPSILON) y += 360.0;
    while(z <= -EPSILON) z += 360.0;

    return (
        -EPSILON < x < EPSILON && -EPSILON < y < EPSILON && -EPSILON < z < EPSILON
    ) || printf("%s\n%4.4f %4.4f %4.4f\n%4.4f %4.4f %4.4f\n%4.4f %4.4f %4.4f", comment, x1, y1, z1, x2, y2, z2, x, y, z);
}

bool: CheckOrPrintMatrix(comment[], Float: matrix1[4][4], Float: matrix2[4][4]) {
    new
        Float: matrix[4][4]
    ;
    MatrixSub(matrix1, matrix2, matrix);

    return (
        -EPSILON < matrix[0][0] < EPSILON && -EPSILON < matrix[0][1] < EPSILON && -EPSILON < matrix[0][2] < EPSILON &&
        -EPSILON < matrix[1][0] < EPSILON && -EPSILON < matrix[1][1] < EPSILON && -EPSILON < matrix[1][2] < EPSILON &&
        -EPSILON < matrix[2][0] < EPSILON && -EPSILON < matrix[2][1] < EPSILON && -EPSILON < matrix[2][2] < EPSILON
    ) || printf("%s\n%4.4f %4.4f %4.4f\n%4.4f %4.4f %4.4f\n%4.4f %4.4f %4.4f", comment,
            matrix[0][0], matrix[0][1], matrix[0][2],
            matrix[1][0], matrix[1][1], matrix[1][2],
            matrix[2][0], matrix[2][1], matrix[2][2]
        )
    ;
}

bool: CheckOrPrintQuat(comment[], Float: w1, Float: x1, Float: y1, Float: z1, Float: w2, Float: x2, Float: y2, Float: z2) {
    new
        Float: w,
        Float: x,
        Float: y,
        Float: z
    ;
    if((w1 * w2) < 0.0) {
        w = w1 + w2;
        x = x1 + x2;
        y = y1 + y2;
        z = z1 + z2;
    } else {
        w = w1 - w2;
        x = x1 - x2;
        y = y1 - y2;
        z = z1 - z2;
    }
    return (
        -EPSILON < w < EPSILON && -EPSILON < x < EPSILON && -EPSILON < y < EPSILON && -EPSILON < z < EPSILON
    ) || printf("%s\n%4.4f %4.4f %4.4f %4.4f\n%4.4f %4.4f %4.4f %4.4f\n%4.4f %4.4f %4.4f %4.4f", comment, w1, x1, y1, z1, w2, x2, y2, z2, w, x, y, z);
}

bool: CheckOrPrintAxisAngle(comment[], Float: a1, Float: x1, Float: y1, Float: z1, Float: a2, Float: x2, Float: y2, Float: z2) {
    new
        Float: a,
        Float: x,
        Float: y,
        Float: z
    ;
    if((x1 * x2) < 0.0) {
        a = 360.0 - a1 - a2;
        x = x1 + x2;
        y = y1 + y2;
        z = z1 + z2;
    } else {
        a = a1 - a2;
        x = x1 - x2;
        y = y1 - y2;
        z = z1 - z2;
    }
    return (
        -EPSILON < a < EPSILON && -EPSILON < x < EPSILON && -EPSILON < y < EPSILON && -EPSILON < z < EPSILON
    ) || printf("%s\n%4.4f %4.4f %4.4f %4.4f\n%4.4f %4.4f %4.4f %4.4f\n%4.4f %4.4f %4.4f %4.4f", comment, a1, x1, y1, z1, a2, x2, y2, z2, a, x, y, z);
}

Test:Rotation() {
    new
        Float: matrix1[4][4],
        Float: matrix2[4][4],
        Float: rX1 = random(360),
        Float: rY1 = random(360),
        Float: rZ1 = random(360),
        Float: rX2,
        Float: rY2,
        Float: rZ2,
        Float: w1,
        Float: x1,
        Float: y1,
        Float: z1,
        Float: w2,
        Float: x2,
        Float: y2,
        Float: z2,
        Float: oX = random(500) / 100.0,
        Float: oY = random(500) / 100.0,
        Float: oZ = random(500) / 100.0,		
        Float: X1,
        Float: Y1,
        Float: Z1,		
        Float: X2,
        Float: Y2,
        Float: Z2,
        Float: pitch1,
        Float: roll1,
        Float: yaw1,
        Float: pitch2,
        Float: roll2,
        Float: yaw2,
        Float: angle1,
        Float: aX1,
        Float: aY1,
        Float: aZ1,
        Float: angle2,
        Float: aX2,
        Float: aY2,
        Float: aZ2
    ;
    GetEulerFromEuler(rX1, rY1, rZ1, euler_samp, rX1, rY1, rZ1); // get calculated values (usually different form random values)
    GetRotationMatrixFromEuler(matrix1, rX1, rY1, rZ1);
    GetEulerFromMatrix(matrix1, rX2, rY2, rZ2);
    GetRotationMatrixFromEuler(matrix2, rX2, rY2, rZ2);

    ASSERT(CheckOrPrintEuler("Euler -> Matrix -> Euler", rX1, rY1, rZ1, rX2, rY2, rZ2));
    ASSERT(CheckOrPrintMatrix("Matrix -> Euler -> Matrix", matrix1, matrix2));

    GetEulerFromMatrix(matrix1, pitch1, roll1, yaw1, euler_zyx);
    GetRotationMatrixFromEuler(matrix2, pitch1, roll1, yaw1, euler_zyx);

    ASSERT(CheckOrPrintMatrix("Matrix -> Euler (euler_zyx) -> Matrix", matrix1, matrix2));

    GetQuatFromMatrix(matrix1, w1, x1, y1, z1);
    GetQuatFromEuler(rX1, rY1, rZ1, w2, x2, y2, z2);

    ASSERT(CheckOrPrintQuat("Matrix -> Quat | Euler -> Quat", w1, x1, y1, z1, w2, x2, y2, z2));

    GetQuatFromEuler(pitch1, roll1, yaw1, w2, x2, y2, z2, euler_zyx);

    ASSERT(CheckOrPrintQuat("Matrix -> Quat | Euler (euler_zyx) -> Quat", w1, x1, y1, z1, w2, x2, y2, z2));

    GetAxisAngleFromQuat(w1, x1, y1, z1, angle1, aX1, aY1, aZ1);
    GetQuatFromAxisAngle(angle1, aX1, aY1, aZ1, w2, x2, y2, z2);

    ASSERT(CheckOrPrintQuat("Quat -> Axis Angle -> Quat", w1, x1, y1, z1, w2, x2, y2, z2));

    GetRotationMatrixFromQuat(matrix2, w1, x1, y1, z1);

    ASSERT(CheckOrPrintMatrix("Matrix -> Quat -> Matrix", matrix1, matrix2));

    GetEulerFromQuat(w1, x1, y1, z1, rX2, rY2, rZ2);

    ASSERT(CheckOrPrintEuler("Euler -> Quat -> Euler", rX1, rY1, rZ1, rX2, rY2, rZ2));

    GetEulerFromEuler(pitch1, roll1, yaw1, euler_zyx, rX2, rY2, rZ2);

    ASSERT(CheckOrPrintEuler("Euler -> Matrix -> Euler (euler_zyx) -> Euler", rX1, rY1, rZ1, rX2, rY2, rZ2));

    GetEulerFromQuat(w1, x1, y1, z1, pitch2, roll2, yaw2, euler_zyx);

    ASSERT(CheckOrPrintEuler("Euler -> Quat -> Euler (euler_zyx)", pitch1, roll1, yaw1, pitch2, roll2, yaw2));

    GetEulerFromEuler(rX1, rY1, rZ1, euler_samp, pitch2, roll2, yaw2, euler_zyx);

    ASSERT(CheckOrPrintEuler("Euler -> Matrix -> Euler (euler_zyx) | Euler -> Euler (euler_zyx)", pitch1, roll1, yaw1, pitch2, roll2, yaw2));

    MatrixRotate(matrix1, oX, oY, oZ, 0.0, X1, Y1, Z1);
    EulerRotate(rX1, rY1, rZ1, oX, oY, oZ, X2, Y2, Z2);

    ASSERT(CheckOrPrintEuler("MatrixRotate | EulerRotate", X1, Y1, Z1, X2, Y2, Z2));

    X2 = Y2 = Z2 = 0.0;

    QuatRotate(w1, x1, y1, z1, oX, oY, oZ, X2, Y2, Z2);

    ASSERT(CheckOrPrintEuler("MatrixRotate | QuatRotate", X1, Y1, Z1, X2, Y2, Z2));

    X2 = Y2 = Z2 = 0.0;

    EulerRotate(pitch1, roll1, yaw1, oX, oY, oZ, X2, Y2, Z2, euler_zyx);

    ASSERT(CheckOrPrintEuler("MatrixRotate | EulerRotate (euler_zyx)", X1, Y1, Z1, X2, Y2, Z2));

    X2 = Y2 = Z2 = 0.0;

    AxisAngleRotate(angle1, aX1, aY1, aZ1, oX, oY, oZ, X2, Y2, Z2);

    ASSERT(CheckOrPrintEuler("MatrixRotate | AxisAngleRotate", X1, Y1, Z1, X2, Y2, Z2));

    GetRotationMatrixFromAxisAngle(matrix2, angle1, aX1, aY1, aZ1);

    ASSERT(CheckOrPrintMatrix("Matrix -> Axis Angle -> Matrix", matrix1, matrix2));

    GetEulerFromAxisAngle(angle1, aX1, aY1, aZ1, rX2, rY2, rZ2);

    ASSERT(CheckOrPrintEuler("Euler -> Matrix -> Quat -> Axis Angle -> Euler", rX1, rY1, rZ1, rX2, rY2, rZ2));

    GetAxisAngleFromEuler(rX1, rY1, rZ1, angle2, aX2, aY2, aZ2);

    ASSERT(CheckOrPrintAxisAngle("Euler -> Matrix -> Quat -> Axis Angle | Euler ->  Axis Angle", angle1, aX1, aY1, aZ1, angle2, aX2, aY2, aZ2));

    GetAxisAngleFromMatrix(matrix1, angle2, aX2, aY2, aZ2);

    ASSERT(CheckOrPrintAxisAngle("Matrix -> Quat -> Axis Angle | Matirx -> Axis Angle", angle1, aX1, aY1, aZ1, angle2, aX2, aY2, aZ2));
}

Test:EulerTest() {
    new
        Float: matrix1[4][4],
        Float: matrix2[4][4],
        Float: matrix3[4][4],
        Float: rX = random(360),
        Float: rY = random(360),
        Float: rZ = random(360);

    GetRotMatX(matrix1, rX);
    GetRotMatZ(matrix2, rZ);
    MatrixMulMatrix(matrix1, matrix2, matrix3);
    GetRotMatY(matrix2, rY);
    MatrixMulMatrix(matrix3, matrix2, matrix1);

    GetRotationMatrixFromEuler(matrix2, rX, rY, rZ, euler_xzy);

    ASSERT(CheckOrPrintMatrix("euler_xzy", matrix1, matrix2));
    
    GetRotMatX(matrix1, rX);
    GetRotMatY(matrix2, rY);
    MatrixMulMatrix(matrix1, matrix2, matrix3);
    GetRotMatZ(matrix2, rZ);
    MatrixMulMatrix(matrix3, matrix2, matrix1);

    GetRotationMatrixFromEuler(matrix2, rX, rY, rZ, euler_xyz);

    ASSERT(CheckOrPrintMatrix("euler_xyz", matrix1, matrix2));

    GetRotMatY(matrix1, rY);
    GetRotMatX(matrix2, rX);
    MatrixMulMatrix(matrix1, matrix2, matrix3);
    GetRotMatZ(matrix2, rZ);
    MatrixMulMatrix(matrix3, matrix2, matrix1);

    GetRotationMatrixFromEuler(matrix2, rX, rY, rZ, euler_yxz);

    ASSERT(CheckOrPrintMatrix("euler_yxz", matrix1, matrix2));

    GetRotMatY(matrix1, rY);
    GetRotMatZ(matrix2, rZ);
    MatrixMulMatrix(matrix1, matrix2, matrix3);
    GetRotMatX(matrix2, rX);
    MatrixMulMatrix(matrix3, matrix2, matrix1);

    GetRotationMatrixFromEuler(matrix2, rX, rY, rZ, euler_yzx);

    ASSERT(CheckOrPrintMatrix("euler_yzx", matrix1, matrix2));

    GetRotMatZ(matrix1, rZ);
    GetRotMatY(matrix2, rY);
    MatrixMulMatrix(matrix1, matrix2, matrix3);
    GetRotMatX(matrix2, rX);
    MatrixMulMatrix(matrix3, matrix2, matrix1);

    GetRotationMatrixFromEuler(matrix2, rX, rY, rZ, euler_zyx);

    ASSERT(CheckOrPrintMatrix("euler_zyx", matrix1, matrix2));

    GetRotMatZ(matrix1, rZ);
    GetRotMatX(matrix2, rX);
    MatrixMulMatrix(matrix1, matrix2, matrix3);
    GetRotMatY(matrix2, rY);
    MatrixMulMatrix(matrix3, matrix2, matrix1);

    GetRotationMatrixFromEuler(matrix2, rX, rY, rZ, euler_zxy);

    ASSERT(CheckOrPrintMatrix("euler_zxy", matrix1, matrix2));

    GetRotMatX(matrix1, rX);
    GetRotMatZ(matrix2, rY);
    MatrixMulMatrix(matrix1, matrix2, matrix3);
    GetRotMatX(matrix2, rZ);
    MatrixMulMatrix(matrix3, matrix2, matrix1);

    GetRotationMatrixFromEuler(matrix2, rX, rY, rZ, euler_xzx);

    ASSERT(CheckOrPrintMatrix("euler_xzx", matrix1, matrix2));

    GetRotMatX(matrix1, rX);
    GetRotMatY(matrix2, rY);
    MatrixMulMatrix(matrix1, matrix2, matrix3);
    GetRotMatX(matrix2, rZ);
    MatrixMulMatrix(matrix3, matrix2, matrix1);

    GetRotationMatrixFromEuler(matrix2, rX, rY, rZ, euler_xyx);

    ASSERT(CheckOrPrintMatrix("euler_xyx", matrix1, matrix2));

    GetRotMatY(matrix1, rX);
    GetRotMatX(matrix2, rY);
    MatrixMulMatrix(matrix1, matrix2, matrix3);
    GetRotMatY(matrix2, rZ);
    MatrixMulMatrix(matrix3, matrix2, matrix1);

    GetRotationMatrixFromEuler(matrix2, rX, rY, rZ, euler_yxy);

    ASSERT(CheckOrPrintMatrix("euler_yxy", matrix1, matrix2));

    GetRotMatY(matrix1, rX);
    GetRotMatZ(matrix2, rY);
    MatrixMulMatrix(matrix1, matrix2, matrix3);
    GetRotMatY(matrix2, rZ);
    MatrixMulMatrix(matrix3, matrix2, matrix1);

    GetRotationMatrixFromEuler(matrix2, rX, rY, rZ, euler_yzy);

    ASSERT(CheckOrPrintMatrix("euler_yzy", matrix1, matrix2));

    GetRotMatZ(matrix1, rX);
    GetRotMatY(matrix2, rY);
    MatrixMulMatrix(matrix1, matrix2, matrix3);
    GetRotMatZ(matrix2, rZ);
    MatrixMulMatrix(matrix3, matrix2, matrix1);

    GetRotationMatrixFromEuler(matrix2, rX, rY, rZ, euler_zyz);

    ASSERT(CheckOrPrintMatrix("euler_zyz", matrix1, matrix2));

    GetRotMatZ(matrix1, rX);
    GetRotMatX(matrix2, rY);
    MatrixMulMatrix(matrix1, matrix2, matrix3);
    GetRotMatZ(matrix2, rZ);
    MatrixMulMatrix(matrix3, matrix2, matrix1);

    GetRotationMatrixFromEuler(matrix2, rX, rY, rZ, euler_zxz);

    ASSERT(CheckOrPrintMatrix("euler_zxz", matrix1, matrix2));
}

Test:ConversionTest() {
    new
        Float: matrix1[4][4],
        Float: matrix2[4][4],
        Float: rX1 = random(360),
        Float: rY1 = random(360),
        Float: rZ1 = random(360),
        Float: rX2,
        Float: rY2,
        Float: rZ2,
        Float: w1,
        Float: x1,
        Float: y1,
        Float: z1,
        Float: w2,
        Float: x2,
        Float: y2,
        Float: z2,
        comment[8]
    ;
    GetRotationMatrixFromEuler(matrix1, rX1, rY1, rZ1);
    GetEulerFromMatrix(matrix1, rX1, rY1, rZ1);
    GetQuatFromEuler(rX1, rY1, rZ1, w1, x1, y1, z1);

    for(new i; i < _: eulermode; ++i) {
        valstr(comment[1], i);

        GetEulerFromMatrix(matrix1, rX2, rY2, rZ2, eulermode: i);
        GetRotationMatrixFromEuler(matrix2, rX2, rY2, rZ2, eulermode: i);

        ASSERT(CheckOrPrintMatrix((comment[0] = 'M', comment), matrix1, matrix2));

        GetQuatFromEuler(rX2, rY2, rZ2, w2, x2, y2, z2, eulermode: i);
        GetEulerFromQuat(w2, x2, y2, z2, rX2, rY2, rZ2);

        ASSERT(CheckOrPrintQuat((comment[0] = 'Q', comment), w1, x1, y1, z1, w2, x2, y2, z2));
        ASSERT(CheckOrPrintEuler((comment[0] = 'E', comment), rX1, rY1, rZ1, rX2, rY2, rZ2));
    }
}