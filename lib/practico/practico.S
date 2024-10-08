/* En este archivo escribirás tu solución.
 * Para ello deberás completar las rutinas en código
 * ensamblador.
 * Puedes usar los registros R0 a R12 pues ya está preservado
 * el valor de los registros que deben mantenerse.
 * Los registros R0 a R3 contienen los argumentos al entrar a
 * la rutina y contendrán el valor devuelto al salir.
 * Si realizas un llamado a subrutina, los registros R0 a R3 y el
 * registro R12 pueden cambiar su valor (y en particular, R0 contiene 
 * normalmente el valor devuelto), los registros R4 a R11 preservan
 * su valor.
 */
.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.macro defun nombre
    .section .text.\nombre
    .global \nombre
    .type \nombre, %function
\nombre:
.endm

.macro endfun nombre
    .size \nombre, . - \nombre
.endm


/**
 * Sumar dos enteros de 32 bit
 *  suma(2,3) => 5
 * Entrada
 *  a->R0, b->R1 : sumandos, enteros de 32 bit con signo 
 * Salida
 *  R0     : suma, entero de 32 bit con signo
 */
defun suma
    push {r4-r11,lr}   // Instruccion de suma para a y b
    ADD R0, R0, R1     // Retorno, antes R0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun suma

/**
 * Sumar los números de un arreglo en memoria de enteros de
 * 32 bit con resultado de 64 bit.
 *
 * sumatoria(5,(uint32_t[]){1,2,3,4,5}) => 15
 *
 * Entrada 
 *  n->R0    : Cantidad de números en registro R0, entero de 32 bit
 *  b->R1    : Dirección en memoria del primer número, puntero a
 *             entero de 32 bit con signo.
 * Salida
 *  R1:R0 : Sumatoria, entero de 64 bit con signo 
 */
defun sumatoria
    push {r4-r11,lr}
    // Insertar código a continuación
    //Muevo los valores que tengo almacenados en R0  y R1 de manera que queden libres y sean usado solo para los resultados 
    MOV R3 ,R0 // muevo el valor n que estaba en el registro R0 al registro R3
    MOV R4 ,R1 // muevo el valor de n que estaba en el registro R1 al registro R4
    // Ya tengo liberados los registros reservados para resultados, veo como inicializo los registros 
    MOV R0, #0
    MOV R1, #0
    MOV R5, #0 //registro para indice del arreglo
    B 3f

0:
    LDR R2,[R4,R5,LSL#2]
    CMP R2, #0
    BLT 1f
    ADDS R0, R2
    ADC R1, #0
    B 1f

1:
    ADDS R0, R2
    ADC R1, #-1

2: 
    ADD R5, #1

3:
    CMP R5,R3
    BLT 0b
    //retorno, antes R0:R1 debe tener el valor correcto
    pop {r4-r11,pc}
    endfun sumatoria




/**
 * Encuentra la posicion del máximo elemento de un arreglo
 *
 * posicion_maximo(4,(uint32_t[]){1,4,2,3}) => 1
 *
 * Entrada:
 *  n->R0 : cantidad de números en el arreglo, entero de 32 bit
 *  b->R1 : posición en memoria del primer número, puntero
 *          a entero de 32 bit con signo.
 * Salida:
 *  R0 : posición del máximo elemento en el arreglo, entero
 *       de 32 bit.
 */
defun posicion_maximo
    push {r4-r11,lr}
    // Insertar código a continuación
    MOV R3, R0 // n pasa a R3
    MOV R0, #0 // inicializo R0=0
    MOV R4, #0 // inicializo R4=0 para indice
    MOV R5, #0 
    B 3f

0:
    LDR R2, [R1,R4,LSL#2]
    CMP R2,R5
    BGE 1f
    B 2f

1: 
    MOV R0,R4

2:
    ADD R4,#1

3:
    CMP R4, R3
    BLT 0b
    pop {r4-r11,pc}

    
    // Retorno, antes R0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun posicion_maximo

/**
 * Ordenar de menor a mayor un arreglo de números en memoria.
 * La ordenación es en el lugar, sobreescribiendo el arreglo
 * original.
 *
 * uint32_t vals[]={4,1,3,5,2,6,7};
 * ordenar_en_sitio_menor_a_mayor(7,vals)
 * luego vals contendrá {1,2,3,4,5,6,7}
 *
 * Entrada:
 *  n->R0 : Cantidad de números en el arreglo, entero de 32 bit
 *  b->R1 : Dirección del primer número, puntero a entero de
 *          32 bit con signo.
 * Salida:
 *  Sin valor de salida. El arreglo dado debe haber sido ordenado
 *  sobreescribiendo los valores originales.
 */
defun ordenar_en_sitio_menor_a_mayor
    push {r4-r11,lr}
    // Insertar código a continuación
defun ordenar_en_sitio_menor_a_mayor
    push {r4-r11,lr}
    // Insertar código a continuación
    MOV R4, #0   // Índice i
0:
    CMP R4, R0
    BGE 4f
    MOV R5, #0   // Índice j
1:
    CMP R5, R0
    BGE 3f
    LDR R2, [R1, R4, LSL#2]   // Calcula la direccion como R1 + 4*R4
    LDR R3, [R1, R5, LSL#2]
    CMP R2, R3
    BGE 2f
    STR R2, [R1, R5, LSL#2]  //Guardo los elementos en la memoria
    STR R3, [R1, R4, LSL#2]
2:
    ADD R5, #1
    B 1b
3:
    ADD R4, #1
    B 0b
4:
    // Retorno
    pop {r4-r11,pc}
endfun ordenar_en_sitio_menor_a_mayor
    
