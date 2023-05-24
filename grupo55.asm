;   GRUPO 55
;   107041- André Antunes Santos
;   107052 - Tomás Maria Agostinho Bernardino
;   88571 - Artur Miguel e Gaio Lopes dos Santos Pinto



; *********************************************************************************
; * Constantes
; *********************************************************************************
DISPLAYS		    EQU  0A000H	; endereço do periférico que liga aos displays
TEC_LIN				EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL				EQU 0E000H	; endereço das colunas do teclado (periférico PIN)
LINHA_TECLADO	    EQU  0010H	; linha a testar 1 bit a esquerda da linha maxima (8b)
MASCARA				EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TECLA_ESQUERDA			EQU 1		; tecla na primeira coluna do teclado (tecla C)
TECLA_DIREITA			EQU 2		; tecla na segunda coluna do teclado (tecla D)

COMANDOS				EQU	6000H			; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    		EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
TOCA_SOM				EQU COMANDOS + 5AH		; endereço do comando para tocar um som


LINHA        		EQU  0        ; linha do asteroide (a meio do ecrã)
COLUNA			EQU  0        ; coluna do asteroide (a meio do ecrã)

MIN_COLUNA		EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA		EQU  63        ; número da coluna mais à direita que o objeto pode ocupar
ATRASO			EQU	400H		; atraso para limitar a velocidade de movimento do asteroide

LARGURA			EQU	5		; largura do asteroide
ALTURA			EQU	5		; altura do asteroide

VERMELHO_PIXEL			EQU	0FF00H	; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
LARANJA_PIXEL       EQU 0FFA0H ; cor do pixel: laranja em ARGB (opaco e vermelho no máximo, verde a 10 e azul a 0)
VERDE_PIXEL         EQU 0F5F2H ; cor do pixel: verde em ARGB (opaco e verde no máximo, vermelho e azul a 0)
AZUL_CIANO_PIXEL      EQU 0F0FFH

VALOR_INICIAL_DISPLAY EQU 0064H   ; valor inicial do display (100 EM DECIMAL)
INCREMENTO_DISPLAY EQU 000BH    ; tecla que incrementa o valor do display
DECREMENTO_DISPLAY EQU 000FH    ; tecla que decremento o valor do display
SONDA_CIMA         EQU 000AH    ; tecla que move a sonda para cima
ASTEROIDE_BAIXO    EQU 0002H   ; tecla que move o asteroide para baixo
; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H
pilha:
	STACK 100H			; espaço reservado para a pilha 
						; (200H bytes, pois são 100H words)
SP_inicial:				; este é o endereço (1200H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 11FEH (1200H-2)
							
DEF_ASTEROIDE_N_MINERAVEL:					; tabela que define o asteroide não minerável (largura, altura, pixels e sua cor)
	WORD		LARGURA
  WORD    ALTURA
	WORD		VERMELHO_PIXEL, 0, VERMELHO_PIXEL, 0, VERMELHO_PIXEL		
  WORD		0, LARANJA_PIXEL, LARANJA_PIXEL, LARANJA_PIXEL, 0
  WORD    VERMELHO_PIXEL,LARANJA_PIXEL,0,LARANJA_PIXEL,VERMELHO_PIXEL
  WORD		0, LARANJA_PIXEL, LARANJA_PIXEL, LARANJA_PIXEL, 0
	WORD		VERMELHO_PIXEL, 0, VERMELHO_PIXEL, 0, VERMELHO_PIXEL
  

DEF_ASTEROIDE_MINERAVEL:					; tabela que define o asteroide minerável 
	WORD		LARGURA
  WORD    ALTURA
	WORD		0, VERDE_PIXEL, VERDE_PIXEL, VERDE_PIXEL, 0		
  WORD		VERDE_PIXEL, VERDE_PIXEL, VERDE_PIXEL, VERDE_PIXEL, VERDE_PIXEL
  WORD    VERDE_PIXEL, VERDE_PIXEL, VERDE_PIXEL, VERDE_PIXEL, VERDE_PIXEL
  WORD		VERDE_PIXEL, VERDE_PIXEL, VERDE_PIXEL, VERDE_PIXEL, VERDE_PIXEL
	WORD		0, VERDE_PIXEL, VERDE_PIXEL, VERDE_PIXEL, 0	

DEF_EXPLOSAO_ASTEROIDE:					; tabela que define o asteroide quando explode 
	WORD		LARGURA
  WORD    ALTURA
	WORD		0, AZUL_CIANO_PIXEL, 0, AZUL_CIANO_PIXEL, 0		
  WORD		AZUL_CIANO_PIXEL, 0, AZUL_CIANO_PIXEL, 0, AZUL_CIANO_PIXEL
  WORD    0, AZUL_CIANO_PIXEL, 0, AZUL_CIANO_PIXEL, 0
  WORD		AZUL_CIANO_PIXEL, 0, AZUL_CIANO_PIXEL, 0, AZUL_CIANO_PIXEL
	WORD		0, AZUL_CIANO_PIXEL, 0, AZUL_CIANO_PIXEL, 0	


; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                     ; o código tem de começar em 0000H
inicio:
	MOV  SP, SP_inicial		; inicializa SP para a palavra a seguir
						; à última da pilha
                            
     MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
     MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	 MOV	R1, 0			; cenário de fundo número 0
     MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
     MOV R11, VALOR_INICIAL_DISPLAY            
     MOV [DISPLAYS], R11     ; inicializa o display com o valor inicial
    CALL rotina_desenha_asteroide
repete:   
	CALL    teclado			; leitura às teclas

    CALL converte_numero   ; retorna R9 com a tecla premida

    CALL rotina_acoes_teclado   ;executa as acoes de acordo com a tecla premida
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
	JMP repete




; **********************************************************************
; TECLADO - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido
;
;
; Retorna: 	R0 - valor lido das colunas do teclado (0, 1, 2, 4, ou 8)
;			R1 - Valor das linhas	
; **********************************************************************
teclado:
	PUSH	R2
	PUSH	R3
	PUSH	R5


loop_linha:
    MOV R1, LINHA_TECLADO   ; por linha a 0001 0000 - para testar qual das linhas foi clicada

espera_tecla:
    SHR R1, 1           ; dividir por 2 para testar as varias linhas do teclado
	JZ  loop_linha      ; se for zero recomeçar o ciclo, caso contrario testar colunas 


	MOV  R2, TEC_LIN   ; endereço do periférico das linhas
	MOV  R3, TEC_COL   ; endereço do periférico das colunas
	MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOVB [R2], R1      ; escrever no periférico de saída (linhas)
	MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
	AND  R0, R5        ; elimina bits para além dos bits 0-3
	CMP	R0, 0
	JZ espera_tecla		; se nenhuma tecla premida, repete

	POP	R5
	POP	R3
	POP	R2
	RET


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

converte_numero:
    PUSH R0
    PUSH R1
    PUSH R2
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
    JZ final_converte
    ADD R10, 1
    JMP ciclo_converte_coluna

final_converte:

    MUL R9, R2      ; Usando a expressao: 
                    ;Tecla = 4 x Num_decimal_linha + num_decimal_col
    ADD R9, R10     ; retorno o R9 
    POP R2
    POP R1
    POP R0
    RET


; **********************************************************************
; Rotina
; desenha asteroide dos não mineráveis
;
;PARAMETROS: R1 - numero da linha premida
;            R0 - numero da coluna
;
; **********************************************************************
rotina_desenha_asteroide:
    PUSH R1 
    PUSH R3
    PUSH R4 
    PUSH R5
    PUSH R6

    posição_inicial_asteroide:
        MOV  R1, LINHA			; linha do asteroide
        MOV  R2, COLUNA		; coluna do asteroide

    desenha_asteroide:       		; desenha o asteroide a partir da tabela
        MOV	R4, DEF_ASTEROIDE_N_MINERAVEL	; endereço da tabela que define o asteroide
        MOV	R5, [R4]			; obtém a largura do asteroide´
        ADD R4, 2               ; endereço da altura do asteroide
        MOV R6, [R4]            ; obtém a altura
        ADD	R4, 2			; endereço da cor do 1º pixel (2 porque a largura é uma word)

    desenha_todos_pixels:
        CMP R6, 0           ;verifica se a altura é 0, se sim termina
        JZ final_desenha_asteroide

        MOV R2, COLUNA           ;reinicia a coluna para o seu valor inicial
        CALL desenha_pixels_coluna           ; se a altura não for 0 vai desenhar os pixels da primeira linha livre
        ADD R1, 1           ; próxima linha
        
        SUB R6, 1           ; menos uma linha para tratar

        JMP desenha_todos_pixels        ; continua até percorrer toda a tabela 

    final_desenha_asteroide:

        POP R6
        POP R5
        POP R4
        POP R3
        POP R1 
        RET

    desenha_pixels_coluna:       		; desenha os pixels do asteroide a partir da tabela
        PUSH R1
        PUSH R2
        PUSH R3
        PUSH R5

    preenche_pixel:
        MOV	R3, [R4]			; obtém a cor do próximo pixel do asteroide
        MOV  [DEFINE_LINHA], R1	; seleciona a linha
        MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
        MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas
        ADD	R4, 2			; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
        ADD  R2, 1               ; próxima coluna
        SUB  R5, 1			; menos uma coluna para tratar
        JNZ  preenche_pixel      ; continua até percorrer toda a largura do objeto

    POP R5
    POP R3
    POP R2
    POP R1
    RET

; **********************************************************************



; **********************************************************************
; Rotina
; Executa a acao correspondente a tecla premida
;
;PARAMETROS: R9 - tecla clicada
;            R11 - valor apresentado no display (hexadecimal)
; **********************************************************************

rotina_acoes_teclado:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4

    MOV R0, INCREMENTO_DISPLAY  ; tecla referente ao incremento do display
    MOV R1, DECREMENTO_DISPLAY  ; tecla referente ao decremento do display
    MOV R2, SONDA_CIMA          ; tecla referente ao movimento da sonda para cima
    MOV R3, ASTEROIDE_BAIXO     ; tecla referente ao movimento do asteroide para baixo
    MOV R4, DISPLAYS            ; endereço do display

    CMP R9, R0
    JZ incrementa_display       ; procede ao incremento do valor do display
    CMP R9, R1
    JZ decrementa_display       ; procede ao decremento do valor do display
    JMP fim_rotina_acoes_teclado

incrementa_display:
    ADD R11, 1                  ; incrementa o valor do display
    MOV [R4], R11               ; atualiza o valor do display
    JMP fim_rotina_acoes_teclado
decrementa_display:
    SUB R11, 1                  ; decrementa o valor do display
    MOV [R4], R11               ; atualiza o valor do display
    JMP fim_rotina_acoes_teclado

fim_rotina_acoes_teclado:

    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET
