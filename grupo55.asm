;   GRUPO 55
;   107041- André Antunes Santos
;   107052 - Tomás Maria Agostinho Bernardino
;   88571 - Artur Miguel e Gaio Lopes dos Santos Pinto


; COMANDOS:
; 2 - Movimenta o asteroide
; A - Movimenta a sonda
; B - Aumenta o valor do display
; C - Começa o jogo
; D - Pausa o jogo
; E - Terminar o jogo

; F - Diminui o valor do display




; *********************************************************************************
; * Constantes
; *********************************************************************************
DISPLAYS		    EQU 0A000H	; endereço do periférico que liga aos displays
TEC_LIN				EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL				EQU 0E000H	; endereço das colunas do teclado (periférico PIN ao qual vão ser acedidos os bits de 0 a 3)
PIN                 EQU 0E000H  ; endereço do periférico PIN ao qual vão ser acedidos os bits de 4 a 7
LINHA_TECLADO	    EQU 0010H	; linha a testar 1 bit a esquerda da linha maxima (8b)
MASCARA				EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
MASCARA_2_BITS      EQU 03E7H   ; para isolar os 2 bits de menor peso
TECLA_ESQUERDA			EQU 1		; tecla na primeira coluna do teclado (tecla C)
TECLA_DIREITA			EQU 2		; tecla na segunda coluna do teclado (tecla D)

COMANDOS				EQU	6000H			; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    			EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   			EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    			EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     			EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 				EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  	EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
TOCA_SOM					EQU COMANDOS + 5AH		; endereço do comando para tocar um som

; * Constantes - posição
LINHA_ASTEROIDE         EQU  0      ; 1ª linha do asteroide 
COLUNA_ASTEROIDE_ESQ	EQU  0      ; 1ª coluna do asteroide
COLUNA_ASTEROIDE_MEIO   EQU  30     ; coluna onde começar a desenhar para o asteroide ficar centralizado
LINHA_NAVE              EQU  27     ; 1ª linha da nave 
COLUNA_NAVE             EQU  25     ; 1ª coluna da nave 
LINHA_PAINEL			EQU  29
COLUNA_PAINEL			EQU  29
LINHA_SONDA             EQU  26     ; linha da sonda 
COLUNA_SONDA            EQU  32     ; coluna da sonda 
MIN_COLUNA		        EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA		        EQU  63     ; número da coluna mais à direita que o objeto pode ocupar


; * Dimensões dos bonecos

LARGURA_ASTEROIDE		EQU	5
ALTURA			        EQU	5		; altura do asteroide e da nave
LARGURA_NAVE            EQU 15
LARGURA_PAINEL_NAVE		EQU 7
ALTURA_PAINEL_NAVE		EQU 2	

;*Constantes - movimento
ATRASO			EQU	5H		; (inicialmente a 400) atraso para limitar a velocidade de movimento do asteroide/nave
ALCANCE_SONDA			EQU  12		; alcance maximo da sonda
DECREMENTO              EQU  -1     ; indica o decremento da coluna/linha do asteroide/sonda
INCREMENTO              EQU  1      ; indica o incremento da coluna/linha do asteroide/sonda
BAIXO                   EQU  0      ; indica o incremento da coluna do asteroide ao andar para baixo
CIMA                    EQU  0      ; indica o incremento da coluna da sonda ao andar para cima
; * Constantes - cores
VERMELHO	  EQU 0FF00H ; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
LARANJA       EQU 0FFA0H ; cor do pixel: laranja em ARGB (opaco e vermelho no máximo, verde a 10 e azul a 0)
VERDE         EQU 0F5F2H ; cor do pixel: verde em ARGB (opaco e verde no máximo, vermelho e azul a 0)
AZUL_CIANO    EQU 0F0FFH ; cor do pixel: verde em ARGB (opaco, verde e azul no máximo, vermelho a 0)
CINZENTO      EQU 0F999H ; cor do pixel: verde em ARGB (opaco no máximo, vermelho, verde e azul a 9)
PRETO         EQU 0F000H ; cor do pixel: preto em ARGB (opaco no máximo, vermelho, verde e azul a 0)
ROSA          EQU 0FF3FH ; cor do pixel: rosa em ARGB (opaco e vermelho no máximo, verde e azul a 7)
AMARELO		  EQU 0FFF0H ; cor do pixel: amarelo em ARGB (opaco, vermelho e verde no máximo, azul a 0)


; * Constantes - teclado/display
VALOR_INICIAL_DISPLAY EQU 0064H   ; valor inicial do display (100 EM DECIMAL)

INCREMENTO_DISPLAY EQU 000BH    ; tecla que incrementa o valor do display
DECREMENTO_DISPLAY EQU 000FH    ; tecla que decremento o valor do display
SONDA_CIMA         EQU 000AH    ; tecla que move a sonda para cima
ASTEROIDE_BAIXO    EQU 0002H    ; tecla que move o asteroide para baixo

JOGO_COMECA        EQU 000CH    ; tecla que começa o jogo
JOGO_PAUSA         EQU 000DH    ; tecla que pausa o jogo
JOGO_TERMINA       EQU 000EH    ; tecla que termina o jogo

MIN_VALOR_DISPLAY  EQU 0000H    ; valor minimo do display
MAX_VALOR_DISPLAY  EQU 03E7H    ; valor maximo do display

; * Constantes - MEDIA CENTER
SOM_DISPARO        EQU 2
SOM_ASTEROIDE      EQU 1

IMAGEM_INICIO      EQU 0
IMAGEM_JOGO        EQU 1
IMAGEM_PAUSE       EQU 2




; *********************************************************************************
; * Registos usados globalmente: (Vamos escrevendo para termos noção dos registos já utilizados)
; Como input: R0, R1, R2 (podem ser alterados após o seu uso nas rotinas)
; Como output:(não convém serem alterados)
; - R5,R6,R7 ->posição do asteroide(R5 e R6) e posição da sonda(R7)
; - R8: Estado do jogo (POR COMECAR, A JOGAR, PAUSA)
; - R9: Tecla clicada
; - R11: Valor hexadecimal do display 
; - R10 : Descrição do papel de registo de controlo de R10
;         Inicialmente a 0, o registo 10 vai servir para controlo do desenho do asteroide e da sonda, tal que,
;         Se R10 estiver a -1 e alguma das rotinas de desenho for chamada irá apagar o desenho (reescrever os pixels a transparente),
;         se estiver a 0 não está nenhum asteroide ou sonda desenhados, se estiver a 1 está o asteroide apenas,
;         a 2 a sonda apenas e a 3 a sonda e o asteroide.
; *********************************************************************************

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H

; * Reserva do espaço das pilhas 
	STACK 100H			; espaço reservado para a pilha (200H bytes, pois são 100H words)
SP_inicial:				; este é o endereço (1200H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 11FEH (1200H-2)

    STACK 100H			; espaço reservado para a pilha do processo teclado
SP_inicial_teclado:

    STACK 100H          ; 100H bytes reservados para a pilha do processo "spawn_asteroide"
SP_asteroide:           ; endereço inicial da pilha


	STACK 100H			; 100H bytes reservados para a pilha do processo "painel_nave"
SP_painel_nave:			; endereço inicial da pilha


; * ; variáveis dos diferentes processos e rotinas
tecla_carregada:
	LOCK 0				; LOCK para o teclado comunicar aos restantes processos que tecla detetou,
						; uma vez por cada tecla carregada
							
tecla_continuo:
	LOCK 0				; LOCK para o teclado comunicar aos restantes processos que tecla detetou,
						; enquanto a tecla estiver carregada

jogo_pausado:
	LOCK 0

game_over:
	LOCK 0

espera_tecla_recomeçar:
	LOCK 0

estado_jogo:
	WORD 0				; WORD para o estado do jogo (0 - em jogo, 1 - perdeu sem energia, 2 - perdeu por colisão, 3 - em pausa)

nova_nave:
    WORD 0              ; WORD para o redesenhar a nave



linha_asteroide:                ; variável que guarda a linha do asteroide no momento
    WORD LINHA_ASTEROIDE

coluna_asteroide:
    WORD COLUNA_ASTEROIDE_ESQ   ; variável que guarda a linha do asteroide no momento

linha_sonda:
    WORD LINHA_SONDA            ;variável que guarda a linha da sonda



; * Tabelas dos objetos

; Tabela das rotinas de interrupção (por completar)
tabela_rot_int:
	WORD rot_int_0
	WORD 0
	WORD 0
	WORD rot_int_3			; rotina de atendimento da interrupção 3


int_asteroide:
    LOCK 0

int_painel_nave:
	LOCK 0					; controla o processo da mudança de cor do painel de controlo da nave

	
DEF_ASTEROIDE_N_MINERAVEL:					; tabela que define o asteroide não minerável (largura, altura, pixels e sua cor)
	WORD		 LARGURA_ASTEROIDE
    WORD        ALTURA
	WORD		VERMELHO , 0 , VERMELHO , 0 , VERMELHO 		
    WORD		0 , VERMELHO , LARANJA , VERMELHO , 0
    WORD        VERMELHO , LARANJA , 0 , LARANJA , VERMELHO 
    WORD		0 , VERMELHO , LARANJA , VERMELHO , 0
	WORD		VERMELHO , 0 , VERMELHO , 0 , VERMELHO 
  

DEF_ASTEROIDE_MINERAVEL:					; tabela que define o asteroide minerável 
	WORD		LARGURA_ASTEROIDE
    WORD        ALTURA
	WORD		0 , VERDE , VERDE , VERDE , 0		
    WORD		VERDE , VERDE , VERDE , VERDE , VERDE 
    WORD        VERDE , VERDE , VERDE , VERDE , VERDE 
    WORD		VERDE , VERDE , VERDE , VERDE , VERDE 
	WORD		0 , VERDE , VERDE , VERDE , 0	

DEF_EXPLOSAO_ASTEROIDE:					; tabela que define o asteroide quando explode 
	WORD		LARGURA_ASTEROIDE
    WORD        ALTURA
	WORD		0 , AZUL_CIANO , 0 , AZUL_CIANO , 0		
    WORD		AZUL_CIANO , 0, AZUL_CIANO , 0, AZUL_CIANO 
    WORD        0 , AZUL_CIANO , 0 , AZUL_CIANO , 0
    WORD		AZUL_CIANO , 0, AZUL_CIANO , 0, AZUL_CIANO 
	WORD		0 , AZUL_CIANO , 0 , AZUL_CIANO , 0	

DEF_NAVE:					; tabela que define a nave
  	WORD    LARGURA_NAVE
  	WORD    ALTURA
  	WORD    0, 0, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, 0, 0
  	WORD    0, VERMELHO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, VERMELHO, 0
  	WORD    VERMELHO, PRETO, PRETO, PRETO, CINZENTO, LARANJA, AZUL_CIANO, VERMELHO, AZUL_CIANO, VERDE, CINZENTO, PRETO, PRETO, PRETO, VERMELHO
  	WORD    VERMELHO, PRETO, PRETO, PRETO, VERDE, CINZENTO, VERMELHO, CINZENTO, LARANJA, CINZENTO, AZUL_CIANO, PRETO, PRETO, PRETO, VERMELHO
  	WORD    VERMELHO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, VERMELHO


DEF_SONDA:					; tabela que define a sonda (apenas um pixel)
  	WORD    ROSA


tabela_cores:				; Tabela que define as cores possíveis para o painel de controlo					
	WORD 	VERMELHO		
	WORD 	VERDE
	WORD 	AMARELO
	WORD 	AZUL_CIANO
	WORD	CINZENTO

; * Tabelas combinações (Coluna inicial e direção em relação à coluna):

inicio_esquerda_move_direita:
    WORD    MIN_COLUNA
    WORD    INCREMENTO 

inicio_meio_move_esquerda:
    WORD    COLUNA_ASTEROIDE_MEIO
    WORD    DECREMENTO

inicio_meio_move_baixo:
    WORD    COLUNA_ASTEROIDE_MEIO
    WORD    BAIXO

inicio_meio_move_direita:
    WORD    COLUNA_ASTEROIDE_MEIO
    WORD    INCREMENTO

inicio_direita_move_esquerda:
    WORD    MAX_COLUNA
    WORD    DECREMENTO

; Tabela que será acedida para determinar a posição do asteróide a desenhar
tabela_geral_posicao:
    WORD inicio_esquerda_move_direita
    WORD inicio_meio_move_esquerda
    WORD inicio_meio_move_baixo
    WORD inicio_meio_move_direita
    WORD inicio_direita_move_esquerda
;;





; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                     ; o código tem de começar em 0000H
inicio:


    MOV  SP, SP_inicial		; inicializa SP para a palavra a seguir à última da pilha
    MOV BTE, tabela_rot_int ; inicializa BTE (registo de Base da Tabela de Exceções)                        
    
    MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    MOV	R1, IMAGEM_INICIO			; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
    
    MOV R11, VALOR_INICIAL_DISPLAY            
    MOV [DISPLAYS], R11     ; inicializa o display com o valor inicial
    
    EI3
    EI

    ;MOV [estado_jogo], 0 ; Controla se o estado em que está o jogo (0 - jogo terminado, 1 - jogo a decorrer, 2 - jogo parado)
    CALL proc_teclado    ; Cria o processo teclado

    espera_inicio_jogo:
    MOV R1, [tecla_carregada] ; Verifica se alguma tecla foi carregada
    MOV R2, JOGO_COMECA
    CMP R1, R2
    JNZ espera_inicio_jogo

inicia:

    MOV R8, IMAGEM_JOGO                  
    MOV [SELECIONA_CENARIO_FUNDO], R8     ; coloca o ecrã de jogo

    MOV R11, VALOR_INICIAL_DISPLAY            
    MOV [DISPLAYS], R11     ; inicializa o display com o valor inicial 

    MOV R10, 0

;;;;;;; DAR OS CALLS AOS PROCESSOS ;;;;;;;;
    CALL spawn_asteroide
    CALL painel_nave

    EI3
    EI

    
    MOV R2, DEF_NAVE                     ; Inicializa o registo 2 que vai indicar que boneco desenhar
    CALL rot_desenha_asteroide_e_nave ; desenha a nave
    
    MOV R2, DEF_ASTEROIDE_N_MINERAVEL    ; guarda qual a próxima tabela a ser desenhada 
    CALL rot_desenha_asteroide_e_nave ; desenha o asteroide se ainda não estiver desenhado

    MOV R2, DEF_SONDA         ; guarda a próxima tabela a ser desenhada         
    CALL rot_desenha_sonda ; desenha a sonda

;**********************************************************************
; Rotina
;
; Inicia o jogo
;
; PARAMETROS: R8 - estado do jogo
;             R11 - valor apresentado no display (hexadecimal)
;**********************************************************************




; **********************************************************************
; Processo
;
; TECLADO - Processo que deteta quando se carrega numa tecla e coloca o valor no LOCK
;		  	tecla_carregada
;		
;		R2 - endereço periferico das linhas 
;		R3 - endereço periferico das colunas
;		R5 - mascara
; **********************************************************************


PROCESS SP_inicial_teclado	; indicação de que a rotina que se segue é um processo,
						    ; com indicação do valor para inicializar o SP
proc_teclado:
	MOV  R2, TEC_LIN		; endereço do periférico das linhas
	MOV  R3, TEC_COL		; endereço do periférico das colunas
	MOV  R5, MASCARA		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    MOV  R4, [estado_jogo]  ; guarda o estado do jogo
    loop_linha:
       	MOV R1, LINHA_TECLADO ; por linha a 0001 0000 - para testar qual das linhas foi clicada

    espera_tecla:				; neste ciclo espera-se até uma tecla ser premida

    	YIELD				; este ciclo é potencialmente bloqueante, pelo que tem de
    						; ter um ponto de fuga (aqui pode comutar para outro processo)
        SHR R1, 1           ; dividir por 2 para testar as varias linhas do teclado
        JZ  loop_linha      ; se for zero recomeçar o ciclo, caso contrario testar colunas 

    	MOVB [R2], R1			; escrever no periférico de saída (linhas)
    	MOVB R0, [R3]			; ler do periférico de entrada (colunas)
    	AND  R0, R5			; elimina bits para além dos bits 0-3
    	CMP  R0, 0			; há tecla premida?
    	JZ   espera_tecla		; se nenhuma tecla premida, repete

        CALL rot_converte_numero   ; retorna R9 com a tecla premida
    
    	MOV	[tecla_carregada], R9	; informa quem estiver bloqueado neste LOCK que uma tecla foi carregada
    							; ( o valor escrito e a tecla carregada)
    acoes_teclado:
        MOV R6, JOGO_PAUSA
        CMP R9, R6
        JZ pausa_jogo
        MOV R6, JOGO_COMECA
        CMP R9, R6
        JZ novo_jogo

    ha_tecla:					; neste ciclo espera-se até NENHUMA tecla estar premida

    	YIELD				; este ciclo é potencialmente bloqueante, pelo que tem de
    						; ter um ponto de fuga (aqui pode comutar para outro processo)

    	MOV	[tecla_continuo], R9	; informa quem estiver bloqueado neste LOCK que uma tecla está a ser carregada
    							; (o valor escrito é a tecla premida)
        MOVB [R2], R1			; escrever no periférico de saída (linhas)
    							; mantenho mesmo R1 porque esse R1 tem a linha que foi premida em cima
    							; nao preciso de ir a procura outra vez qual linha foi premida
        MOVB R0, [R3]			; ler do periférico de entrada (colunas)
    	AND  R0, R5				; elimina bits para além dos bits 0-3
        CMP  R0, 0				; há tecla premida?
        JNZ  ha_tecla			; se ainda houver uma tecla premida, espera até não haver

    	JMP	espera_tecla		; esta "rotina" nunca retorna porque nunca termina
    						; Se se quisesse terminar o processo, era deixar o processo chegar a um RET

    pausa_jogo:
        
        CMP R4, 3
        JZ  unpause

        CMP R4, 0
        JNZ ha_tecla

        MOV R4, 3
        MOV [estado_jogo], R4

        MOV R7, IMAGEM_PAUSE                       
        MOV [SELECIONA_CENARIO_FUNDO], R7          ;coloca o ecrã de pausa

        JMP ha_tecla
    unpause:
        
        MOV R4, 0
        MOV [estado_jogo], R4

        MOV R7, IMAGEM_JOGO                        
        MOV [SELECIONA_CENARIO_FUNDO], R7          ;volta ao ecrã de jogo 

        JMP ha_tecla

    novo_jogo:
        CMP R4, 1
        JZ comeca_novo_jogo
        CMP R4, 2
        JZ comeca_novo_jogo
        JMP ha_tecla
    comeca_novo_jogo:

        MOV R4, 0
        MOV [estado_jogo], R4
        MOV R4, 1
        MOV [nova_nave], R4

        MOV R7, IMAGEM_JOGO                        
        MOV [SELECIONA_CENARIO_FUNDO], R7          ;volta ao ecrã de jogo 
        JMP ha_tecla


; **********************************************************************
; Rotina
;
; Converte_numero - converte o numero da linha e da coluna da tecla premida
;		            no numero/letra premida
;
;PARAMETROS: R1 - numero da linha premida
;            R0 - numero da coluna
;
;RETORNA: R9 - tecla clicada
; **********************************************************************

rot_converte_numero:
    PUSH R0
    PUSH R1
    PUSH R2
;    PUSH R10
    MOV R9, 0   ; inicializar contador da linha a zero
    MOV R10, 0  ; inicializar contador da coluna a zero
    MOV R2, 4   ; Sera no final usado para multiplicar por 4

    ciclo_converte_linha:
        SHR R1, 1       ;vou dividindo por 2 para ver quantos ciclos se completa até chegar a zero
        CMP R1, 0       ; quando chega a zero, converti de numero binario da linha ( 1 a 8)
                        ; para numero entre 0 a 3
        JZ  ciclo_converte_coluna   ; que vou usar na expressao no final para me dar tecla clicada
        ADD R9, 1          ; vou adicionando 1 ao contador
        JMP ciclo_converte_linha    ; volto ao inicio

    ciclo_converte_coluna:
        SHR R0, 1       ; depois de ter numero das linhas faço o mesmo para as colunas
        CMP R0, 0       ; converto de 1 a 8 binario para 0 a 3 decimal
        JZ fim_converte_numero
        ADD R10, 1
        JMP ciclo_converte_coluna

    fim_converte_numero:

        MUL R9, R2      ; Usando a expressao: 
                        ;Tecla = 4 x Num_decimal_linha + num_decimal_col
        ADD R9, R10     ; retorno o R9 
;        POP R10
        POP R2
        POP R1
        POP R0
        RET



;; ************************************************************************************
;; Rotina
;; desenha asteroide ou nave, dependendo do valor de R2
;;
;; PARÂMETROS:  R2 - tipo da tabela (nave, asteroide não minerável, asteroide 
;;              minerável ou explosão de asteroide), a sonda é tratada noutra rotina
;;              R5 - linha do primeiro píxel do asteroide
;;              R6 - coluna do primeiro píxel do asteroide

;;
;; RETORNA: R5 e R6 no caso de se desenhar um asteroide - linha e coluna respetivamente
;; ************************************************************************************

rot_desenha_asteroide_e_nave: ; Deposita os valores dos registos abaixo no stack

    PUSH R0
    PUSH R1 
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R7
    PUSH R8
    
; as seis intruções seguintes servem para verificar o valor de R10 de acordo com o explicado na descrição 
    CMP R10, 1          
    JZ desenha_asteroide_e_nave
    
    CMP R10, 3
    JZ desenha_asteroide_e_nave
    
    CMP R10, -1
    JZ desenha_asteroide_e_nave

; Os blocos acima tratam os casos em que já existe um asteroide
    MOV R8, DEF_NAVE                    ; guarda o valor da memória na primeira posição da tabela que define a nave 
    CMP R2, R8                          ; verifica se foi pedido para desenhar uma nave
    JNZ posicao_inicial_asteroide       ; se não foi pedida a nave então foi um asteroide

    
    posicao_inicial_nave:
        MOV  R7, LINHA_NAVE			    ; linha da nave
        MOV  R4, COLUNA_NAVE	        ; coluna da nave
        

        JMP desenha_asteroide_e_nave    
    
    posicao_inicial_asteroide:
        
        MOV R7, [linha_asteroide]		; linha do asteroide
        MOV R4, [coluna_asteroide]       ; coluna do asteroide
        ADD R10, 1                      ; Diz ao registo de controlo que já existe 1 asteroide
        

    
    desenha_asteroide_e_nave:   ; desenha o asteroide/nave/sonda(bonecos) a partir da tabela

        MOV	R0, [R2]			; obtém a largura do boneco
        ADD R2, 2               ; endereço da altura do boneco
        MOV R1, [R2]            ; obtém a altura
        ADD	R2, 2			    ; endereço da cor do 1º pixel (2 porque a largura é uma word)

        MOV R8, R4              ; guarda o primeiro valor da coluna para depois


    desenha_todos_pixels:
        CMP R1, 0                               ; verifica se a altura é 0, se sim termina
        JZ teste_apagar

        MOV R4, R8                              ; reinicia a coluna para o seu valor inicial
        
    	MOV R3, 0               ; inicializa o R3 (futura cor dos pixels) a 0
		
		CALL rot_desenha_pixels_linha        ; se a altura não for 0 vai desenhar os pixels da primeira linha livre
        
        ADD R7, 1           ; próxima linha
        SUB R1, 1           ; menos uma linha para tratar

        JMP desenha_todos_pixels        ; continua até percorrer toda a tabela 

    teste_apagar:                       
        CMP R10, -1                         ; se esta rotina foi usada para apagar (R10 = -1) 
        JNZ fim_desenha_asteroide_e_nave
        MOV R10, 3                          ; Põe R10 a 3 de modo a poder desenhar o próximo asteroide

    fim_desenha_asteroide_e_nave: ; volta a atribuir os valores acumulados no stack aos devidos registos
        
        POP R8
        POP R7
        POP R4
        POP R3
        POP R2
        POP R1
        POP R0
        RET


;; ************************************************************************************
;; Rotina
;; preenche os pixeis de uma linha, ou com a cor presente em cada pixel da tabela
;; do objeto, se R10 for diferente de -1 ou com cor 0, ou seja, apaga os pixels
;;
;; PARÂMETROS:  R2 - tipo da tabela (nave, asteroide não minerável, asteroide 
;;              minerável ou explosão de asteroide), a sonda é tratada noutra rotina
;;              R7 - linha do objeto
;;              R4 - coluna do objeto
;;
;; ************************************************************************************

rot_desenha_pixels_linha:       		; desenha os pixels do asteroide/nave a partir da tabela
    
    PUSH R0
    PUSH R1
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R10


    MOV R1, DEF_SONDA       ; guarda o valor incial da tabela da sonda para se poder comparar com o do input(R2)
    MOV R5, tabela_cores    ; guarda o enderço da tabela de cores

    CMP R10, 4              ; verifica se o input foi a tabela de cores 
    JNZ preenche_pixel      ; se não, salta
    MOV R6, 8               ; guarda o número 8 por ser demasiado grande para adicionar diretamente
    ;MOV R10, 0              ; se for tabela de cores é para desenhar por isso R10 não pode ser -1
    ADD R5, R6              ; Guarda em R5 o endereço da última cor da tabela 

    preenche_pixel:

        CMP R10, -1             ; verifica se é suposto apagar o desenho
        JZ pinta_pixels         ; se for para apagar não lê a cor do pixel, pois esta será 0
        
        CMP R2, R5              ; verifica se já chegou á última cor
        JLE continua_preenche
        SUB R2, R6              ; se chegou à última cor reeinicia para o primeiro endereço da tabela (-10)
        SUB R2, 2

    continua_preenche:
        MOV	R3, [R2]			; obtém a cor do próximo pixel do asteroide/nave
        
    pinta_pixels:
        MOV  [DEFINE_LINHA], R7	; seleciona a linha
        MOV  [DEFINE_COLUNA], R4	; seleciona a coluna
        MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas
        
        CMP R2, R1      ; Se for para desenhar uma sonda, apenas preenche o único pixel que tem e sai do loop
        JZ fim_desenha_pixels

        ADD	R2, 2			    ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
        ADD R4, 1               ; próxima coluna
        SUB R0, 1			    ; menos uma coluna para tratar (diminui a Largura restante)
        JNZ preenche_pixel      ; continua até percorrer toda a largura do objeto

    fim_desenha_pixels:
        
        POP R10
        POP R6
        POP R5
        POP R4
        POP R3
        POP R1
        POP R0
        RET

;; **********************************************************************
;; Rotina
;; Serve para desenhar ou apagar a sonda dependendo do valor de R10
;;
;; PARÂMETROS: R2 - enderço inicial da tabela da sonda 
;;             R7 - sua linha no momento
;; 
;; RETORNA: R10 - Registo para controlar o próximo desenho, se R10 veio a -1 (para apagar)
;;               irá devolver R10 com 3, o que indica ao processador que a próxima chamada
;;               desta rotina será para desenhar
;; **********************************************************************
rot_desenha_sonda:
    PUSH R1
    PUSH R2
    PUSH R4
    PUSH R7

    ; as seis intruções seguintes servem para verificar se existe alguma sonda ou se
    ; é para apagar,de acordo com o explicado na descrição de R10

    CMP R10, 3
    JZ coluna_constante

    CMP R10, 2
    JZ coluna_constante

    CMP R10, -1
    JZ coluna_constante

    

    posicao_sonda:

        MOV  R7, [linha_sonda]			; linha da nave
        ADD R10, 2						; Diz à variável de controlo que após esta já rotina haverá uma sonda desenhada
    
    coluna_constante:
        MOV  R4, COLUNA_SONDA			; coluna da nave
         
    desenha_pixels_sonda:
    	MOV R3, 0						; inicializa o R3 (futura cor dos pixels) a 0
        CALL rot_desenha_pixels_linha	; pinta a sonda de rosa, como definido na sua tabela
    
    teste_apaga:
        CMP R10, -1						; verifica se esta rotina foi usada para apagar, se sim, põe o valor de R1 a 3 para poder desenhar de novo
        JNZ fim_desenho_sonda
        MOV R10, 3						; Põe R10 a 3 de modo a poder desenhar a próxima sonda

    fim_desenho_sonda:  
    POP R7                   
    POP R4
    POP R2
    POP R1
    RET





; **********************************************************************
; Rotina
;
; Executa a acao correspondente a tecla clicada
;
; PARAMETROS: R8 - estado do jogo
;             R9 - tecla clicada
;             R11 - valor apresentado no display (hexadecimal)
; **********************************************************************

rot_acoes_teclado:

    PUSH R0
    PUSH R2
    

    MOV R0, JOGO_TERMINA  ; tecla para terminar o jogo
    CMP R9, R0
    JZ jogo_termina       ; procede ao termino do jogo


    MOV R0, INCREMENTO_DISPLAY  ; tecla referente ao incremento do display
    CMP R9, R0
    JZ incrementa_display       ; procede ao incremento do valor do display
    

    MOV R0, DECREMENTO_DISPLAY  ; tecla referente ao decremento do display
    CMP R9, R0
    JZ decrementa_display       ; procede ao decremento do valor do display

    MOV R0, SONDA_CIMA          ; tecla referente ao movimento da sonda para cima
    CMP R9, R0

    JZ movimento_sonda_cima     ; procede ao movimento da sonda para cima

    MOV R0, ASTEROIDE_BAIXO     ; tecla referente ao movimento do asteroide para baixo
    CMP R9, R0
    JZ movimento_asteroide_baixo ; procede ao movimento do asteroide para baixo na diagonal

    JMP fim_acoes_teclado ; caso a tecla clicada não tenha nenhum comando atribuido

    incrementa_display:

        MOV R0, MAX_VALOR_DISPLAY   ; valor maximo do display
        CMP R11,  R0           
        JGE fim_acoes_teclado ; se o valor do display for o maximo, não incrementa
        ADD R11, 1                  ; incrementa o valor do display


        MOV [DISPLAYS], R11             ; atualiza o valor do display
        JMP fim_acoes_teclado

    decrementa_display:

        MOV R0, MIN_VALOR_DISPLAY       ; valor minimo do display
        CMP R11, R0             
        JLE fim_acoes_teclado           ; se o valor do display for o minimo, não decrementa
        SUB R11, 1                      ; decrementa o valor do display

        MOV [DISPLAYS], R11             ; atualiza o valor do display
        JMP fim_acoes_teclado

    movimento_sonda_cima:

        MOV R0, SOM_DISPARO
        MOV [TOCA_SOM], R0              ; toca o som do disparo da sonda

        MOV R2, DEF_SONDA               ; guarda a tabela da sonda que vai ser desenhada no ecrã
        MOV R10, -1                     ; Diz á rotina seguinte que vai apagar a sonda existente
        CALL rot_desenha_sonda
        CALL rot_atualiza_posicao    ; incrementa a posição verticalmente para cima (-1 linha pois a maior(31) é em baixo)

        CALL rot_desenha_sonda

        JMP fim_acoes_teclado

    movimento_asteroide_baixo:

        MOV R0, SOM_ASTEROIDE
        MOV [TOCA_SOM], R0          ; toca o som do movimento do asteroide

        MOV R2, DEF_ASTEROIDE_N_MINERAVEL       ; guarda a tabela do asteroide que vai ser desenhado no ecrã
        MOV R10, -1                             ; Diz á rotina seguinte que vai apagar o asteroide existente
        CALL rot_desenha_asteroide_e_nave
        CALL rot_atualiza_posicao            ; incrementa a posição diagonalmente (+1 coluna +1 linha)

        CALL rot_desenha_asteroide_e_nave    ; desenha o asteroide na nova posição


        JMP fim_acoes_teclado   



    jogo_termina:

        CALL rot_jogo_termina    ;termina o jogo, limpando o ecrã

        JMP fim_acoes_teclado

    fim_acoes_teclado:

        POP R2
        POP R0
        RET


;**********************************************************************
; Rotina
;
; Termina o jogo
;
; PARAMETROS: R8 - estado do jogo
;**********************************************************************

rot_jogo_termina:

    MOV R8, IMAGEM_INICIO                 
    MOV [SELECIONA_CENARIO_FUNDO], R8     ;coloca o ecrã de inicio

    MOV R8, 0                            ;muda o estado do jogo para jogo terminado

    MOV [APAGA_ECRÃ], R8                 ;apaga todos os pixeis desenhados no ecrã
                                ;painel de instrumentos, sondas, asteroides

    RET


;; **********************************************************************
;; Rotina 
;; - indica qual a próxima posição de um determinado objeto
;;  
;; - PARÂMETROS:    R5, R6 (linha e coluna do asteroide)
;;                  R7 (linha da sonda)
;; 
;; - RETORNA: Os registos de posição atualizados (R5 e R6 ou R7 dependendo do tipo do objeto)
;; **********************************************************************

rot_atualiza_posicao:
    PUSH R0
    PUSH R5
    PUSH R6
    PUSH R7

    
    MOV R0, DEF_SONDA           
    MOV R5, [linha_asteroide]
    MOV R6, [coluna_asteroide]
    MOV R7, [linha_sonda]
    CMP R2, R0                          ; verifica se o objeto é uma sonda
    JNZ proxima_posicao_asteroide       ; salta se não for sonda (será asteroide)

    proxima_posicao_sonda:
        SUB R7, 1                       ; decrementa a linha, ou seja sobe no ecrã verticalmente
        JMP fim_atualiza_posicao

    proxima_posicao_asteroide:          ; incrementa a linha e coluna do asteroide (desde a inicial) de modo a andar na diagonal
        ADD R5, 1
        ADD R6, 1
        JMP fim_atualiza_posicao

    
    fim_atualiza_posicao:
        POP R7
        POP R6
        POP R5
        POP R0
        RET

; **********************************************************************
; Processo
;
; painel_nave - Processo que lê o relógio da nave e muda o lock int_painel_nave
;               para que seja possível mudar as cores do painel da nave
;		
;       R0, R1 - largura do painel e altura do painel, respetivamente
;		R2 - endereço da tabela das cores definida no início 
;       R4, R7 - linha e coluna do painel, respetivamente
; **********************************************************************


PROCESS SP_painel_nave		; indicação de que a rotina que se segue é um processo,
							; com indicação do valor para inicializar o SP
painel_nave:

	MOV R2, tabela_cores		; guarda o endereço da tabela das cores para se poder aceder às cores
;	MOV R3, 8				; guarda o número máximo de bits a adicionar ao endereço da tabela das cores
	
	MOV R0, LARGURA_PAINEL_NAVE		;guarda a largura do painel
	MOV R1, ALTURA_PAINEL_NAVE		;guarda a altura do painel
	
    posicao_painel_nave:
        
        MOV R7, LINHA_PAINEL		; linha do painel
        MOV R4, COLUNA_PAINEL       ; coluna do painel
        MOV R10, 4                  ; irá servir para dizer à rot_desenha_pixels_linha que o input é a tabela de cores

    loop_painel:
        YIELD

        CALL rot_desenha_pixels_linha   ; muda a primeira linha do painel
            ADD R7, 1
        CALL rot_desenha_pixels_linha   ; muda a segunda linha do painel
            SUB R7, 1
        JMP loop_painel


; **********************************************************************
; Processo
;
; painel_nave - Processo que lê o relógio da nave e muda o lock int_painel_nave
;               para que seja possível mudar as cores do painel da nave
;		
;       R0, R1 - largura do painel e altura do painel, respetivamente
;		R2 - endereço da tabela das cores definida no início 
;       R4, R7 - linha e coluna do painel, respetivamente
; **********************************************************************
PROCESS SP_asteroide        ; indicação de que a rotina que se segue é um processo,
							; com indicação do valor para inicializar o SP
    
spawn_asteroide:
    MOV R3, tabela_geral_posicao        ; guarda o enderço da tabela das combinações de posições possíveis
    CALL rot_gera_aleatorio             ; recebe dois números pseudoaleatórios: R0 e R1
    CMP R0, 0                           ; se R0 não for 0 é para fazer um não minerável senão o oposto
    JNZ  asteroide_nao_mineravel
    MOV R2, DEF_ASTEROIDE_MINERAVEL     ; no caso de ser minerável, guarda o endereço da sua tabela
    JMP escolhe_tabela_particular

    asteroide_nao_mineravel:
        MOV R2, DEF_ASTEROIDE_N_MINERAVEL   ; no caso de ser não minerável, guarda o endereço da sua tabela

    escolhe_tabela_particular:
        SHL R1, 1               ; multiplica por dois (anda um bit para a direita pois queremos incrementar de 2 em 2 bytes)
        ADD R3, R1              ; vai adicionar um certo valor par de 0 a 8 a R3 de modo a obter o endereço de uma tabela de direção
        MOV R5, [R3]

    loop_movimento:
        YIELD

        MOV R7, [linha_asteroide]
        MOV R4, [R5]
        ADD R5, 2
        MOV R6, [R5]

        JMP loop_movimento
    ; Falta separar a parte do movimento e a parte do desenho dos 4 asteroides


;; **********************************************************************
;; Rotina 
;; - gera dois números aleatórios, um entre 0 e 3, outro entre 0 e 4
;;  
;; - PARÂMETROS:    
;;              R2 - Máscara de 2 bits
;;              R4 - endereço do periférico PIN

;; 
;; - RETORNA: R0 (número entre 0 e 3) e R1 (número entre 0 e 4)
;; **********************************************************************

rot_gera_aleatorio:
    
    PUSH R2
    PUSH R3
    PUSH R4

    MOV R2, MASCARA_2_BITS   ; será utilizado para isolar os 2 bits de menor peso de um valor
    MOV R3, 5
    MOV R4, PIN
    MOVB R0, [R4]           ; lê os bits 4 a 7 do periférico PIN
    SHR R0, 4                ; coloca os bits lidos antes (4 a 7) nos bits 0 a 3, de modo a ficar com um valor entre 0 e 15
    MOV R1, R0

    AND R0, R2               ; isola os 2 bits de menor peso, o que dá 4 hipóteses
    MOD R1, R3                ; R1 = resto da divisão de R1 por 5 de modo a ficarmos com 5 hipóteses (0 a 4)

fim_gera_aleatório:
    POP R4
    POP R3
    POP R2
    RET


;escolhe_cor_pixel:
;	MOV R4, tabela_cores	; guarda o enderço da tabela das cores para se poderem aceder às cores
;	CMP R5, R3				; se R5 for menor que 8, poderá ser adicionado ao endereço da tabela das cores para obter uma cor
;	JLE muda_cor
;	MOV R5, 0
;
;muda_cor:   
;	ADD R4, R5
;	ADD R5, 2
;
;

rot_int_0:
	PUSH R2
	MOV R2, int_asteroide
	MOV [R2], R1
	POP R2
	RFE

;rot_int_1:
;	PUSH R2
;	MOV R2, evento_int_missil
;	MOV [R2], R1
;	POP R2
;	RFE
;

;
; rot_int_2:
; 	PUSH R2
; 	MOV R2, evento_int_missil
; 	MOV [R2], R1
; 	POP R2
; 	RFE
; 

rot_int_3:                      ; rotina que trata a interrupção 3
	PUSH R0
	MOV R0, int_painel_nave
	MOV [R0], R1
	POP R0
	RFE

