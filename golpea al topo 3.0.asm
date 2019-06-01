.model small
.stack
.data 

    cantidad       db "Digite la cantidad de jugadores:" ,"$"         
    
    caract         db "Digite el caracter que desea utilizar","$"
                             
    dos            db "J1:      J2:              ","$"
    tres           db "J1:      J2:      J3:     ","$"
   
    topo           db "Digite el caracter del topo:","$" 
    
    puntaje        db "Puntajes:","$"  
    
    puntos         db ":","$" 
      
    turno1         db "Jugador 1:" ,"$"  
    turno2         db "Jugador 2:" ,"$"   
    turno3         db "Jugador 3:" ,"$"                
    
    player1        db 1              ;Guardan cual jugador esta en turno
    player2        db 0
    player3        db 0
    
    cop_player1    db 1              ;Guardan cual jugador esta en turno copias de player
    cop_player2    db 0              ;para saber a quien sumarle puntos
    cop_player3    db 0
    
   
    
    
    nivel          db 1
    
    nivel1         db "Nivel 1","$"
    nivel2         db "Nivel 2","$"
    nivel3         db "Nivel 3","$" 
    nivel4         db "Nivel 4","$" 
    nivel5         db "Nivel 5","$" 
      
    op2            db "Rendirse:L   Reset:R   Quit:Q   ","$" 
    op3            db "Reset:R      Quit:Q             ","$" 
    
    
    estad          db           "Estadisticas","$"
    estad_JP       db        "Jugador    Puntaje","$"
    empata2        db          "Juego empatado","$"
    op_end         db   "Salir:S   Volver a jugar:V","$"
         
    car1           db ?              ;Guarda caracter de jugador 1
    car2           db ?              ;Guarda caracter de jugador 2
    car3           db ?              ;Guarda caracter de jugador 3  
    
    puntaje1a       db 0       ;Se crean variables puntaje
    puntaje1b       db 0
    puntaje1c       db 0
    
    puntaje2a       db 0       ;Se crean variables puntaje
    puntaje2b       db 0
    puntaje2c       db 0
    
    puntaje3a       db 0       ;Se crean variables puntaje
    puntaje3b       db 0
    puntaje3c       db 0
    
        
    var_cant       db ?              ;Guarda el numero de jugadores 
                                  
    car_topo       db ?              ;Guarda el caracter del topo    

    columna        db 0              ;Posicion de la columna para los topos
    fila           db 7              ;Posicion de la fila para los topos
    cont_topos     db 0              ;Cuenta la cantidad de topos por fila
    
    pos_clic_x     dw 0              ;Variables para la posicion de x,y en pixeles
    pos_clic_y     dw 0
    pos_texto_x    db 0              ;Variables para la posicion de x,y en pixeles de texto
    pos_texto_y    db 0
    
    caracter       db 0              ;Guarda el caracter que marco con el mouse
    
    color_topo     db 0              ;Guarda el caracter del caracter que se marco
    
    random_fila    db 0              ;Guarda el numero random para la fila de los topos
    random_topos   db 0              ;Guarda el numero random para la cantidad de topos
    
    lineah         db "************","$"
    lineav         db "*          * ","$"
               
    fila_linea      db 7                  ;Se usa para imprimir los marcos de la matriz
    
    cant_filas      db 0
    
    segundos    db 0 
    
    cont_apariciones  db 0
    
    comparar_caracter db 0
    
    comparar_fila     db 0
    comparar_columna  db 0
    
    comparar3 db 1
    
    
    
    
    
.code     

    mov_cursor macro x,y             ;Mueve el cursor a la pocision 
        mov ah, 02h                  ;x,y de la pantalla
        mov bh, 0
        mov dh, y
        mov dl, x
        int 10h   
    endm  
    
    imprimir macro texto             ;Imprime una cadena de caracteres 
                                     ;en la direccion que contiene DX 
        lea dx, texto
        mov ah, 9
        int 21h      
    endm  
    
    lee_caracter macro               ;Espera por un caracter del teclado
	    mov  ah,01h
   	    int  21h
	endm
    
    fin macro                        ;Finaliza el macro
	    mov ax,4c00h
	    int 21h
	endm
    
    limpiar_pantalla macro color     ;Limpia la pantalla un color
        mov ax,0600h   
        mov bh,color     
        mov cx,0000h   
        mov dx,184fh   
        int 10h
    endm
    
    imprimir_var macro var            ;Imprime lo guardado en una variable
	    mov dl,var 
	    mov ah,2
	    int 21h
    endm 
    
    colores macro color              ;Cambia de color el texto
        mov ah,09
        mov bx,color
        mov cx,20h
        int 10h
    endm
    
    color_letra macro color,var      ;Cambia el color a una variable
    	mov bx, color
    	mov cx, 01h  
    	mov al, var
    	mov ah, 09h
    	int 10h
    endm   
    
    obt_pos_texto macro pos_clic, pos_texto  ;Obtiene la posicion del mouse en pixeles texto
        
        mov ax, pos_clic        
        mov bl, 8
        div bl        
        mov pos_texto, al 
        
    endm   
    
    leer_caracter macro caracter            ;Lee un caracter pulsado con el mouse, se puede 
        mov ah,08h                          ;recuperar el caracter en al y el color en ah
        mov bh, 0
        int 10h
        
        mov caracter, al             
    endm 
    
   
    borrar_caracter macro                   ;Borra el caracter marcado con el mouse
        mov ah, 02h         
        mov dl, 20h         
        int 21h
    endm 
    
    beep macro                              ;Produce un pitido
        mov ah,2
        mov dl,7 
        int 21h
    endm 
    
    imprimir_puntaje macro var_puntaje
        mov  dl,var_puntaje
        add dl,30h
        mov ah,02
	    int 21h
    endm 
         
    imprimir_caracter macro caracter 
        
        mov ah, 09h             ;Imprime un caracter
        mov al, caracter        ;Caracter ascii del topo
        mov bh, 00h             ;Pagina del modo texto
        mov bl, 0fh             ;Color del caracter a imprimir
        mov cx, 01              ;Cantidad de veces a imprimir el caracter
        int 10h 
        
    endm
    
    imprimir_estd_tres macro c1,p1a,p1b,c2,p2a,p2b,c3,p3a,p3b
        mov_cursor 14,6 
       imprimir estad
       
       mov_cursor 10,9
       imprimir estad_jp
          
       
       mov_cursor 10,11
       imprimir_caracter c1
       mov_cursor 21,11
       imprimir_puntaje p1a
       mov_cursor 22,11
       imprimir_puntaje p1b
        
       
       mov_cursor 10,13
       imprimir_caracter c2
       mov_cursor 21,13
       imprimir_puntaje p2a
       mov_cursor 22,13
       imprimir_puntaje p2b
       
       mov_cursor 10,15
       imprimir_caracter c3
       mov_cursor 21,15
       imprimir_puntaje p3a
       mov_cursor 22,15
       imprimir_puntaje p3b
       
    
       mov_cursor 5,18
       imprimir op_end
   endm 
        
inicio:
    mov dx,@data
    mov ds,dx
    
    mov ah,00h      
    mov al,00h                       ;Establece modo texto 40x25
    mov bh,00         
    int 10h   
    
    limpiar_pantalla 0fh   
       
pide_caracter_topo:                  ;Pide el caracter para el topo
    
    limpiar_pantalla 0fh
    
    mov_cursor 0,0
    imprimir topo
    
    mov_cursor 28,0     
    lee_caracter                     ;Espera entrada del teclado

    mov car_topo,al                  ;Guarda el caracter en la variable

   
pide_cantidad_jugadores:             ;Pide la cantidad de jugadores
    
    mov_cursor 0,3 
    imprimir cantidad  
    
    mov_cursor 33,3     
    lee_caracter                     ;Espera entrada del teclado
    
    mov var_cant,al                  ;Guarda la cantidad de jugadores
                                 
    cmp var_cant,50                  ;Compara si la cantidad de jugadores 
    je  pide_caracter_dos_jugadores  ;es igual a 2
    
    cmp var_cant,51                  ;Compara si la cantidad de jugadores
    je  pide_caracter_tres_jugadores                             ;es igual a 3

    jne sonido_cantidad_jugadores


sonido_cantidad_jugadores:           ;Produce sonido cuando el dato ingresado
                                     ;no es el correcto
    beep

    jmp pide_cantidad_jugadores


pide_caracter_dos_jugadores:         ;Pide el caracter a dos jugadores
    
    limpiar_pantalla 0fh
                                     
    mov_cursor 0,0
    imprimir caract
    
    mov_cursor 0,1
    imprimir dos
    
    mov_cursor 3,1
    lee_caracter                     ;Espera entrada del teclado
    mov car1,al                      ;Guarda el caracter del jugador 1
    
    mov_cursor 12,1
    lee_caracter                     ;Espera entrada del teclado
    mov car2,al                      ;Guarda el caracter del jugador 2
    
    limpiar_pantalla 0fh             ;Limpia la pantalla
     
    jmp pantalla_dos_jugadores


pantalla_dos_jugadores:              ;Imprime en una nueva pantalla las  
                                     ;variables de los jugadores y las opciones
    mov_cursor 0,0
    imprimir puntaje

    mov_cursor 11,0
    color_letra 03h,car1 
    imprimir_var car1
    imprimir puntos
    mov_cursor 13,0
    imprimir_puntaje puntaje1a
    imprimir_puntaje puntaje1b 
   
    mov_cursor 18,0
    color_letra 05h,car2
    imprimir_var car2
    imprimir puntos
    mov_cursor 20,0
    imprimir_puntaje puntaje2a
    imprimir_puntaje puntaje2b                           
                               
    mov_cursor 0,23
    colores 0ch 
    imprimir op2

    jmp imprimir_lineash


pide_caracter_tres_jugadores:         ;Pide el caracter a dos jugadores
    
    limpiar_pantalla 0fh
                                     
    mov_cursor 0,0
    imprimir caract
    
    mov_cursor 0,1
    imprimir tres
    
    mov_cursor 3,1
    lee_caracter                     ;Espera entrada del teclado
    mov car1,al                      ;Guarda el caracter del jugador 1
    
    mov_cursor 12,1
    lee_caracter                     ;Espera entrada del teclado
    mov car2,al                      ;Guarda el caracter del jugador 2
     
    mov_cursor 21,1
    lee_caracter                     ;Espera entrada del teclado
    mov car3,al                      ;Guarda el caracter del jugador 3
     
    limpiar_pantalla 0fh             ;Limpia la pantalla
     
    jmp pantalla_tres_jugadores


pantalla_tres_jugadores:              ;Imprime en una nueva pantalla las  
                                      ;variables de los jugadores y las opciones
    mov_cursor 0,0
    imprimir puntaje

    mov_cursor 11,0
    color_letra 03h,car1 
    imprimir_var car1
    imprimir puntos
    mov_cursor 13,0
    imprimir_puntaje puntaje1a
    imprimir_puntaje puntaje1b
    
    mov_cursor 18,0 
    color_letra 05h,car2
    imprimir_var car2
    imprimir puntos
    mov_cursor 20,0
    imprimir_puntaje puntaje2a
    imprimir_puntaje puntaje2b
    
    mov_cursor 25,0
    color_letra 06h,car3
    imprimir_var car3
    imprimir puntos
    mov_cursor 27,0
    imprimir_puntaje puntaje3a
    imprimir_puntaje puntaje3b 
   
    mov_cursor 0,23
    colores 0ch 
    imprimir op3

    jmp imprimir_lineash

               
    
imprimir_lineash:            ;Imprime los marcos horizontales de la matriz
    mov_cursor 13,6 
    imprimir lineah 
    
    mov_cursor 13,17 
    imprimir lineah


imprimir_lineasv:           ;Imprime los marcos verticales de la matriz

    cmp fila_linea,17                     ;Crea un ciclo para imprimir cada caracter del marco
    je  comparar_cantidad_jugadores
    
    mov_cursor 13,fila_linea
    imprimir lineav 
    
    add fila_linea,1
    jmp imprimir_lineasv


comparar_cantidad_jugadores:
    mov nivel,1
    
    cmp var_cant,02h
    je  turno_dos_jugadores
    
    jmp turno_tres_jugadores

turno_dos_jugadores:
   cmp player1,01h
   je  turno_jugador1
   
   cmp player2,01h
   je  turno_jugador2
    jmp salir

turno_tres_jugadores:
   cmp player1,01h
   je  turno_jugador1
   
   cmp player2,01h
   je  turno_jugador2
   
   cmp player3,01h     
   je  turno_jugador3 
   
   jmp salir

turno_jugador1:
   
   add player2,1
   sub player1,1
   
    
   mov_cursor 13,18 
   imprimir turno1
   
   mov_cursor 24,18
   color_letra 03h,car1 
   imprimir_var car1
   
   
   jmp niveles
   
turno_jugador2:
   
   sub player2,1
   add player3,1
   
   sub cop_player1,1
   add cop_player2,1
   
   
               
   mov_cursor 13,18 
   imprimir turno2
   
   mov_cursor 24,18
   color_letra 05h,car2
   imprimir_var car2
   
   jmp niveles
   
turno_jugador3:

   sub cop_player2,1
   add cop_player3,1
    
    
   mov_cursor 13,18 
   imprimir turno3   
   
   mov_cursor 24,18
   color_letra 06h,car3
   imprimir_var car3
   
   
   jmp niveles


    
niveles: 
   
    cmp nivel,01h
    je nivel_1
    
    cmp nivel,02h
    je nivel_2 
    
    cmp nivel,03h
    je nivel_3 
     
    cmp nivel,04h
    je nivel_4 
    
    cmp nivel,05h
    je nivel_5


   
nivel_1:
 
   mov_cursor 15,5
   imprimir nivel1 
   
   add cont_apariciones,1
   mov segundos,10
   jmp reiniciar_variable_topos_rojos  
   
   
    
nivel_2:
 
   mov_cursor 15,5
   imprimir nivel2
   
   add cont_apariciones,1 
   mov segundos,9

   jmp reiniciar_variable_topos_rojos
   
   
    
nivel_3:
 
   mov_cursor 15,5
   imprimir nivel3
   
   add cont_apariciones,1
   mov segundos,8
   jmp reiniciar_variable_topos_rojos
   
   
    
nivel_4:
 
   mov_cursor 15,5
   imprimir nivel4
   
   add cont_apariciones,1
   mov segundos,6
   jmp reiniciar_variable_topos_rojos
   
   
    
nivel_5:
 
   mov_cursor 15,5
   imprimir nivel5
   mov segundos,3
   add cont_apariciones,1

   jmp reiniciar_variable_topos_rojos


reiniciar_variable_topos_rojos: ;Reinicia los valores de las variables para usarlas nuevamente

    mov fila,7
    mov cont_topos,0   
    mov columna,0    
                 
    mov random_fila,0    
    mov random_topos,0                
    mov cant_filas,0
    mov fila_linea,0
    
    jmp fila_random_rojos  
                

fila_random_rojos:
    
    
    
    mov fila,7
    
    mov ah,2ch                       ;Genera el numero random para la fila en la que se va a imprimir
    int 21h 
    mov al,dl
    
    add fila,al
     
    cmp fila,7d
    jl  fila_random_rojos
     
    cmp fila,17d
    jl  crear_topos_rojos
           
    jmp fila_random_rojos     
    
       

crear_topos_rojos:               ;Crea los topos de color rojo
    
    mov ah,2ch                       ;Genera el numero random
    int 21h
    mov columna,dl                   ;Guarda el numero random en una variable
    
    cmp columna,24d                   ;Compara el numero para que no se salga de la matriz
    jg crear_topos_rojos 
    
    cmp columna,14d                   ;Compara el numero para que no se salga de la matriz
    jl  crear_topos_rojos
    
      
    cmp cont_topos,0                 ;Compara si ya se imprimieron todos los topos por fila
    jle  comprobar_topos_rojos
    
    
    
    cmp cant_filas,2d                      ;Compara si ya se cumplieron las filas
    jl  sumarle_fila_topos_rojos
    
    cmp cant_filas,2d
    je reiniciar_variable_topos_azules
    

   
    
sumarle_fila_topos_rojos:        ;Se le suma a la fila el numero random y el conteo de topos se reinicia 
    
    mov cont_topos,0 

    jmp fila_random_rojos
       
       
comprobar_topos_rojos:           ;Establece posicion del cursor para imprimir el topo
    
    mov_cursor columna,fila    
    
    mov al,columna
    mov comparar_columna,al
    
    mov al,fila
    mov comparar_fila,al    
    
    
    leer_caracter comparar_caracter
    
    mov al,car_topo
    cmp comparar_caracter,al
    je  fila_random_rojos
    
    
    ;sub comparar_columna,1
;    mov_cursor comparar_columna,comparar_fila
;    mov al,car_topo
;    cmp comparar_caracter,al
;    je  fila_random_rojos
;    
;    add comparar_columna,2
;    mov_cursor comparar_columna,comparar_fila
;    mov al,car_topo
;    cmp comparar_caracter,al
;    je  fila_random_rojos
;    
;    
;    sub comparar_columna,1
;    sub comparar_fila,1
;    mov_cursor comparar_columna,comparar_fila
;    mov al,car_topo
;    cmp comparar_caracter,al
;    je  fila_random_rojos
;    
;    
;    add comparar_fila,2
;    mov_cursor comparar_columna,comparar_fila
;    mov al,car_topo
;    cmp comparar_caracter,al
;    je  fila_random_rojos   
    
    mov_cursor columna,fila
                          
    jmp imprimir_topos_rojos
    
     
imprimir_topos_rojos:            ;Imprime los topos de color rojo
   
    add cont_topos,1
    
    add cant_filas,1
    
    color_letra 04h,car_topo
    imprimir_var car_topo  
    
    
    jmp fila_random_rojos
    


reiniciar_variable_topos_azules: ;Reinicia los valores de las variables para usarlas nuevamente

    mov fila,7
    mov cont_topos,0   
    mov columna,0    
                 
    mov random_fila,0    
    mov random_topos,0                
    mov cant_filas,0
    mov fila_linea,0             
                 
    jmp fila_random_azules



fila_random_azules:
    
    
    mov fila,7
    
    
    mov ah,2ch                       ;Genera el numero random para la fila en la que se va a imprimir
    int 21h 
    mov al,dl
    
    add fila,al
     
    cmp fila,7d
    jl  fila_random_azules
     
    cmp fila,17d
    jl  crear_topos_azules
    
        
    
    jmp fila_random_azules     
    
       

crear_topos_azules:               ;Crea los topos de color rojo
    
    mov ah,2ch                       ;Genera el numero random
    int 21h
    mov columna,dl                   ;Guarda el numero random en una variable
    
    cmp columna,23d                   ;Compara el numero para que no se salga de la matriz
    jg crear_topos_azules 
    
    cmp columna,14d                   ;Compara el numero para que no se salga de la matriz
    jl  crear_topos_azules
    
      
    cmp cont_topos,0                 ;Compara si ya se imprimieron todos los topos por fila
    jle  comprobar_topos_azules
    
    
    
    cmp cant_filas,2d                      ;Compara si ya se cumplieron las 10 filas
    jl  sumarle_fila_topos_azules
    
    cmp cant_filas,2d
    je mouse
    

   
    
sumarle_fila_topos_azules:        ;Se le suma a la fila el numero random y el conteo de topos se reinicia 
    
    mov cont_topos,0 

    jmp fila_random_azules
       
       
comprobar_topos_azules:           ;Establece posicion del cursor para imprimir el topo
    
    mov_cursor columna,fila
    
    mov al,columna
    mov comparar_columna,al
    
    mov al,fila
    mov comparar_fila,al
    
    leer_caracter comparar_caracter
    
    mov al,car_topo
    cmp comparar_caracter,al
    je  fila_random_azules
    
    
   ; sub comparar_columna,1
;    mov_cursor comparar_columna,comparar_fila
;    mov al,car_topo
;    cmp comparar_caracter,al
;    je  fila_random_rojos
;    
;    add comparar_columna,2
;    mov_cursor comparar_columna,comparar_fila
;    mov al,car_topo
;    cmp comparar_caracter,al
;    je  fila_random_rojos
;    
;    
;    sub comparar_columna,1
;    sub comparar_fila,1
;    mov_cursor comparar_columna,comparar_fila
;    mov al,car_topo
;    cmp comparar_caracter,al
;    je  fila_random_rojos
;    
;    
;    add comparar_fila,2
;    mov_cursor comparar_columna,comparar_fila
;    mov al,car_topo
;    cmp comparar_caracter,al
;    je  fila_random_rojos   
    
    mov_cursor columna,fila      
    
    jmp imprimir_topos_azules
    
     
imprimir_topos_azules:            ;Imprime los topos de color rojo
   
    add cont_topos,1
    
    add cant_filas,1
    
    color_letra 01h,car_topo
    imprimir_var car_topo  
    
    
    jmp fila_random_azules  
            
mouse: 

    mov ax, 00h                      ;Utilizar mouse
    int 33h    
                                   
    mov ax, 02h                      ;Mostrar puntero del mouse
    int 33h
            
    mov ax, 3
    int 33h  
    
    mov pos_clic_x, cx               ;Guardar posicion x del cursor
    mov pos_clic_y, dx               ;Guardar posicion y del cursor 
                   
    shl bl, 2                        ;Corrimiento a la izquierda para obtener los clics
                          
    cmp bl, 0100b                    ;Clic izquierdo presionado 
    je clic_izq
    
    cmp bl, 1000b                    ;Clic derecho presionado
    je clic_der 
    
    mov ah, 86h                 ;Permite poner el procesador en espera la cantidad de tiempo indicada en cx:dx
    mov cx, 0Fh
    mov dx, 4240h               ;Espera 1000000 de microsegundos = 1 segundo => 0F4240h en cx:dx
    int 15h
  
    dec segundos
    
    cmp segundos,0
    je limpiar_pantalla


    mov ah, 1
    int 16h
    jz mouse
    
    
    mov ah, 0
    int 16h

    cmp var_cant,50
    je  comparar_op2
    
    cmp var_cant,51
    je  comparar_op3
          
    jmp mouse


comparar_op2:
    
    ;cmp al,76
;    je  rendirse
;    
;    cmp al,108
;    je  rendirse
;    
    cmp al,82
    je  reset
    
    cmp al,114
    je  reset
    
    cmp al,81
    je  salir
    
    cmp al,113
    je  salir
    
    jmp mouse
    
comparar_op3:
    
    cmp al,82
    je  reset
    
    cmp al,114
    je  reset
    
    cmp al,81
    je  salir
    
    cmp al,113
    je  salir

    jmp mouse
    
clic_izq:  ;azul

    obt_pos_texto pos_clic_x, pos_texto_x   ;Da las coordenadas de los pixeles en texto
    obt_pos_texto pos_clic_y, pos_texto_y  
 
    mov_cursor pos_texto_x, pos_texto_y    
    leer_caracter caracter                  ;Lee el caracter seleccionado con el mouse
    
 ;   cmp pos_texto_x,14
;    jl  sonido_fuera_matriz_ops
;    
;    cmp pos_texto_x,24
;    jg  sonido_fuera_matriz_ops
;    
;    cmp pos_texto_y,6
;    jl  sonido_fuera_matriz_ops
;    
;    cmp pos_texto_y,17
;    jl  sonido_fuera_matriz_ops
    
    
    mov color_topo,ah                       ;Mueve el color del caracter a la varaible
    
    cmp color_topo,01h                      ;Compara el color del topo seleccionado
    je  borrar_topo_azul     ;con el color azul
     
    cmp color_topo,0Fh                       ;Compara que el color no sea blanco para que no borre 
    je  sonido_fuera_matriz_ops                  ;los demas caracteres de la pantalla
    
    cmp color_topo,03h                       ;Compara que el color no sea cian para que no borre
    je  sonido_fuera_matriz_ops
    
    cmp color_topo,05h                       ;Compara que el color no sea magenta para que no borre
    je  sonido_fuera_matriz_ops
    
    cmp color_topo,06h                       ;Compara que el color no sea marron para que no borre
    je  sonido_fuera_matriz_ops
    
    cmp color_topo,0Ch                       ;Compara que el color no sea rojo claro para que no borre
    je  sonido_fuera_matriz_ops
    
    cmp color_topo,04h                       ;Compara que el color no sea rojo claro para que no borre
    je  sonido_clic
    
    cmp caracter," "
    je  mouse                  ;los demas caracteres de la pantalla
    
    
              
                              
borrar_topo_azul:              ;Borra el topo azul de la pantalla
         
    imprimir_caracter " "            
    
    call comparar_sumar_puntaje_j1
    call comparar_sumar_puntaje_j2
    call comparar_sumar_puntaje_j3
    
    jmp mouse
    
    
clic_der:  ;rojo

    obt_pos_texto pos_clic_x, pos_texto_x    ;Da las coordenadas de los pixeles en texto
    obt_pos_texto pos_clic_y, pos_texto_y 
    
    mov_cursor pos_texto_x, pos_texto_y
    leer_caracter caracter                   ;Lee el caracter seleccionado con el mouse
    
    mov color_topo,ah                        ;Mueve el color del caracter a la varaible
    
    cmp color_topo,0Fh                       ;Compara que el color no sea blanco para que no borre 
    je  sonido_fuera_matriz_ops                 ;los demas caracteres de la pantalla
    
    cmp color_topo,0Ch                       ;Compara que el color no sea rojo claro para que no borre
    je  sonido_fuera_matriz_ops                  ;los demas caracteres de la pantalla
    
    cmp color_topo,03h                       ;Compara que el color no sea cian para que no borre
    je  sonido_fuera_matriz_ops
    
    cmp color_topo,05h                       ;Compara que el color no sea magenta para que no borre
    je  sonido_fuera_matriz_ops
    
    cmp color_topo,06h                       ;Compara que el color no sea marron para que no borre
    je  sonido_fuera_matriz_ops 
     
     
    cmp color_topo,04h                       ;Compara el color del topo seleccionado
    je  borrar_topo_rojo      ;con el color rojo
    
    cmp caracter," "
    je  mouse
    
    jmp sonido_clic  
    
                                             ;Borra el topo azul de la pantalla
borrar_topo_rojo: 
    
    imprimir_caracter " "            
    
    call comparar_sumar_puntaje_j1
    call comparar_sumar_puntaje_j2
    call comparar_sumar_puntaje_j3            

    jmp mouse
     
sonido_fuera_matriz_ops:
    beep
    jmp mouse

    
sonido_clic:                   ;Reproduce sonido y borra topo al presionar erronamente
  
    imprimir_caracter " "
    beep
    
    call comparar_restar_puntaje_j1
    call comparar_restar_puntaje_j2
    call comparar_restar_puntaje_j3 
    
    jmp mouse   



limpiar_pantalla:            ;Limpia la pantalla de la matriz
   
     mov ax,0600h   
     mov bh,0fh     
     mov cx,070eh   
     mov dx,1017H   
     int 10h
     
     cmp cont_apariciones,1
     je sumar_niveles
     
     jmp niveles

sumar_niveles:
    
    mov cont_apariciones,0
    add nivel,1
    
    cmp nivel,06h
    je  comparar_pase_todos_jugadores
    jmp niveles
    
comparar_pase_todos_jugadores:

    cmp var_cant,32h
    je  comparar_pase_dos_jugadores
    
    cmp var_cant,33h
    je  comparar_pase_tres_jugadores 
    
    
comparar_pase_dos_jugadores:

    cmp cop_player2, 01h
    je  comparar_puntajes_dos
    
    jmp comparar_cantidad_jugadores


comparar_pase_tres_jugadores:

    cmp cop_player3, 01h
    je  comparar_puntajes_tres
    
    jmp comparar_cantidad_jugadores


comparar_puntajes_dos:

    mov al,puntaje2c
    
    cmp puntaje1c,al
    je  empate_dos_jugadores
    jg  gana_jugador1_dos_jugadores
    jl  gana_jugador2_dos_jugadores

empate_dos_jugadores:
                          
                          
   limpiar_pantalla 0fh   
  
   mov_cursor 14,6 
   imprimir estad
   
   mov_cursor 10,9
   imprimir estad_jp 
   
   mov_cursor 10,11
   imprimir_caracter car1
   mov_cursor 21,11
   imprimir_puntaje puntaje1a
   mov_cursor 22,11
   imprimir_puntaje puntaje1b
   
   mov_cursor 10,13
   imprimir_caracter car2
   mov_cursor 21,13
   imprimir_puntaje puntaje2a
   mov_cursor 22,13
   imprimir_puntaje puntaje2b
    
   mov_cursor 12,15
   imprimir empata2
   
   mov_cursor 5,18
   imprimir op_end  
    
   jmp esperar_letra_fin_juego
   
     
esperar_letra_fin_juego:   
   
   mov_cursor 32,18                                 
   lee_caracter
    
   cmp al,83
   je salir
   
   cmp al,115
   je salir
   
   cmp al,86
   je reset
   
   cmp al,118
   je reset
   
   jmp esperar_letra_fin_juego  



gana_jugador1_dos_jugadores:

   limpiar_pantalla 0fh   
  
   mov_cursor 14,6 
   imprimir estad
   
   mov_cursor 10,9
   imprimir estad_jp 
   
   mov_cursor 10,11
   imprimir_caracter car1
   mov_cursor 21,11
   imprimir_puntaje puntaje1a
   mov_cursor 22,11
   imprimir_puntaje puntaje1b
   
   mov_cursor 10,13
   imprimir_caracter car2
   mov_cursor 21,13
   imprimir_puntaje puntaje2a
   mov_cursor 22,13
   imprimir_puntaje puntaje2b
    

   mov_cursor 5,18
   imprimir op_end  
    
   jmp esperar_letra_fin_juego



gana_jugador2_dos_jugadores:

   limpiar_pantalla 0fh   
  
   mov_cursor 14,6 
   imprimir estad
   
   mov_cursor 10,9
   imprimir estad_jp
      
   
   mov_cursor 10,11
   imprimir_caracter car2
   mov_cursor 21,11
   imprimir_puntaje puntaje2a
   mov_cursor 22,11
   imprimir_puntaje puntaje2b
    
   
   mov_cursor 10,13
   imprimir_caracter car1
   mov_cursor 21,13
   imprimir_puntaje puntaje1a
   mov_cursor 22,13
   imprimir_puntaje puntaje1b
   

   mov_cursor 5,18
   imprimir op_end  
    
   jmp esperar_letra_fin_juego



comparar_puntajes_tres:

    cmp comparar3,01h
    je  pos_123
    
    cmp comparar3,02h
    je  pos_132
    
    cmp comparar3,03h
    je  pos_213            
    
    cmp comparar3,04h
    je  pos_231
    
    cmp comparar3,05h
    je  pos_312   
    
    cmp comparar3,06h
    je  pos_321
   
    
comparar_1y2:
    mov al,puntaje2c
                 
    cmp puntaje1c,al     
    jle  comparar_puntajes_tres 
    
    ret
comparar_2y3:    
    mov al,puntaje3c
                 
    cmp puntaje2c,al     
    jle  comparar_puntajes_tres
    
    ret
comparar_1y3:

    mov al,puntaje3c
                 
    cmp puntaje1c,al     
    jle  comparar_puntajes_tres
    
    ret 
    
comparar_2y1:

    mov al,puntaje1c
                 
    cmp puntaje2c,al     
    jle  comparar_puntajes_tres
    
    ret
    
comparar_3y2:

    mov al,puntaje2c
                 
    cmp puntaje3c,al     
    jle  comparar_puntajes_tres
    
    ret 
    
comparar_3y1:

    mov al,puntaje1c
                 
    cmp puntaje3c,al     
    jle  comparar_puntajes_tres
    
    ret    
         
pos_123:
    add comparar3,1
    call comparar_1y2
    call comparar_2y3
    call comparar_1y3
    
    jmp imprimir_123     
    
     
imprimir_123:
   limpiar_pantalla 0fh
   imprimir_estd_tres car1,puntaje1a,puntaje1b,car2,puntaje2a,puntaje2b,car3,puntaje3a,puntaje3b 
   
   jmp esperar_letra_fin_juego
   
;***************************    

pos_132:
    add comparar3,1
    call comparar_1y3
    call comparar_3y2
    call comparar_1y2
    
    jmp imprimir_132     
    
     
imprimir_132:
   limpiar_pantalla 0fh
   imprimir_estd_tres car1,puntaje1a,puntaje1b,car3,puntaje3a,puntaje3b,car2,puntaje2a,puntaje2b 
    
   jmp esperar_letra_fin_juego 
    
;***************************    

pos_213:
    add  comparar3,1
    call comparar_2y1
    call comparar_1y3
    call comparar_2y3
    
    jmp imprimir_213     
    
     
imprimir_213:
   limpiar_pantalla 0fh
   imprimir_estd_tres car2,puntaje2a,puntaje2b,car1,puntaje1a,puntaje1b,car3,puntaje3a,puntaje3b 
   
   jmp esperar_letra_fin_juego
        
;***************************    

pos_231:
    add  comparar3,1
    call comparar_2y3
    call comparar_3y1
    call comparar_2y1
    
    jmp imprimir_231     
    
     
imprimir_231:
   limpiar_pantalla 0fh
   imprimir_estd_tres car2,puntaje2a,puntaje2b,car3,puntaje3a,puntaje3b,car1,puntaje1a,puntaje1b 
   
   jmp esperar_letra_fin_juego
   
;***************************    

pos_312:
    add  comparar3,1
    call comparar_3y1
    call comparar_3y2
    call comparar_3y2
    
    jmp imprimir_312     
    
     
imprimir_312:
   limpiar_pantalla 0fh
   imprimir_estd_tres car3,puntaje3a,puntaje3b,car1,puntaje1a,puntaje1b,car2,puntaje2a,puntaje2b 

   jmp esperar_letra_fin_juego
   
;***************************    

pos_321:
    add  comparar3,1
    call comparar_3y2
    call comparar_2y1
    call comparar_3y1
    
    jmp imprimir_321    
    
     
imprimir_321:
   limpiar_pantalla 0fh
   imprimir_estd_tres car3,puntaje3a,puntaje3b,car2,puntaje2a,puntaje2b,car1,puntaje1a,puntaje1b 
   
   jmp esperar_letra_fin_juego                  

;; 123.
;; 132.
;; 213.
;; 231.
;; 312
;; 321
























   

comparar_sumar_puntaje_j1:
    
    cmp cop_player1,1d
    je sumar_puntaje_j1  
     
    ret  
    
sumar_puntaje_j1:

    inc puntaje1c
    
    cmp puntaje1b,9d
    jge incrementar_puntaje1a
    
    inc puntaje1b
    mov_cursor 14,0
    imprimir_puntaje puntaje1b  
    
    jmp mouse

incrementar_puntaje1a:
   
    mov puntaje1b,0
    inc puntaje1a
   
    mov_cursor 13,0
    imprimir_puntaje puntaje1a
   
    mov_cursor 14,0
    imprimir_puntaje puntaje1b
   
    jmp mouse
   
comparar_sumar_puntaje_j2:
    
    cmp cop_player2,1d
    je sumar_puntaje_j2  
     
    ret    
    
sumar_puntaje_j2:

    inc puntaje2c
    
    cmp puntaje2b,9d
    jge incrementar_puntaje2a    
    
    inc puntaje2b
    mov_cursor 21,0
    imprimir_puntaje puntaje2b 
    
    jmp mouse

incrementar_puntaje2a:

    mov puntaje2b,0
    inc puntaje2a
    
    mov_cursor 20,0
    imprimir_puntaje puntaje2a
    
    mov_cursor 21,0
    imprimir_puntaje puntaje2b 
   
    jmp mouse

             
comparar_sumar_puntaje_j3:
    
    cmp cop_player3,1d
    je sumar_puntaje_j3  
     
    ret    
    
sumar_puntaje_j3:

    inc puntaje3c
    
    cmp puntaje2b,9d
    jge incrementar_puntaje3a
    
    inc puntaje3b
    mov_cursor 28,0
    imprimir_puntaje puntaje3b
    
    jmp mouse             

incrementar_puntaje3a:

    mov puntaje3b,0
    inc puntaje3a
    
    mov_cursor 27,0
    imprimir_puntaje puntaje3a
    
    mov_cursor 28,0
    imprimir_puntaje puntaje3b
   
   
    jmp mouse

          
comparar_restar_puntaje_j1:
    
    cmp cop_player1,1d
    je restar_puntaje_j1  
     
    ret

restar_puntaje_j1:             

    dec puntaje1c 
    
    cmp puntaje1b,0
    je decrementar_puntaje1a
    
    dec puntaje1b
    mov_cursor 14,0
    imprimir_puntaje puntaje1b
    
    jmp mouse

decrementar_puntaje1a:
    
    cmp puntaje1a,0
    je  mantener_puntaje_cero_j1
    
    mov puntaje1b,9
    dec puntaje1a
    
    mov_cursor 13,0
    imprimir_puntaje puntaje1a
    
    mov_cursor 14,0
    imprimir_puntaje puntaje1b
   
   
    jmp mouse

comparar_restar_puntaje_j2:
    
    cmp cop_player2,1d
    je restar_puntaje_j2  
     
    ret

restar_puntaje_j2:             

    dec puntaje2c 
    
    cmp puntaje2b,0
    je decrementar_puntaje2a
    
    dec puntaje2b
    mov_cursor 21,0
    imprimir_puntaje puntaje2b
    
    jmp mouse

decrementar_puntaje2a:
    
    cmp puntaje2a,0
    je  mantener_puntaje_cero_j2
    
    mov puntaje2b,9
    dec puntaje2a
    
    mov_cursor 20,0
    imprimir_puntaje puntaje2a
   
   
    
    mov_cursor 21,0
    imprimir_puntaje puntaje2b
   
   
    jmp mouse

comparar_restar_puntaje_j3:
    
    cmp cop_player3,1d
    je restar_puntaje_j3  
     
    ret
    
restar_puntaje_j3:             

    dec puntaje3c 
    
    cmp puntaje3b,0
    je decrementar_puntaje3a
    
    dec puntaje3b
    mov_cursor 28,0
    imprimir_puntaje puntaje3b
    
    jmp mouse

decrementar_puntaje3a:
    
    cmp puntaje3a,0
    je  mantener_puntaje_cero_j3
    
    mov puntaje3b,9
    dec puntaje3a
    
    mov_cursor 27,0
    imprimir_puntaje puntaje3a
   
   
    
    mov_cursor 28,0
    imprimir_puntaje puntaje3b
   
    jmp mouse

mantener_puntaje_cero_j1:
   
   mov puntaje1a,0
   mov puntaje1b,0
   mov puntaje1c,0
   
   mov_cursor 13,0
   imprimir_puntaje puntaje1a
    
   mov_cursor 14,0
   imprimir_puntaje puntaje1b
      
   jmp mouse 
   
mantener_puntaje_cero_j2:
   
   mov puntaje2a,0
   mov puntaje2b,0
   mov puntaje2c,0
   
   mov_cursor 20,0
   imprimir_puntaje puntaje2a
    
   mov_cursor 21,0
   imprimir_puntaje puntaje2b
      
   jmp mouse    

mantener_puntaje_cero_j3:
   
   mov puntaje3a,0
   mov puntaje3b,0
   mov puntaje3c,0
   
   mov_cursor 27,0
   imprimir_puntaje puntaje3a
    
   mov_cursor 28,0
   imprimir_puntaje puntaje3b
      
   jmp mouse 






reset:

    mov player1,1       
    mov player2,0              
    mov player3,0        
    
    mov cop_player1,1   
    mov cop_player2,0    
    mov cop_player3,0   
    
    mov nivel,1        
    
    mov car1,0    
    mov car2,0
    mov car3,0
        
    mov puntaje1a,0
    mov puntaje1b,0    
    mov puntaje1c,0 
    
    mov puntaje2a,0    
    mov puntaje2b,0
    mov puntaje2c,0
        
    mov puntaje3a,0
    mov puntaje3b,0    
    mov puntaje3c,0
    
    mov var_cant,0    
    mov car_topo,0
    mov columna,0
    mov fila,7    
    mov cont_topos,0
    mov caracter,0
    mov color_topo,0    
    mov random_fila,0
    mov random_topos,0
    mov fila_linea,7    
    mov cant_filas,0
    mov segundos,0
    mov cont_apariciones,0    
    mov comparar_fila,0
    mov comparar_columna,0
 
    cmp var_cant,50
    je  pide_caracter_dos_jugadores
    
    cmp var_cant,51
    je  pide_caracter_tres_jugadores
    
    jmp pide_caracter_topo
 
rendirse:





                                             
salir:                                       ;Termina el programa
    fin










