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

; * Constantes - posição
LINHA_ASTEROIDE       EQU  0      ; 1ª linha do asteroide 
COLUNA_ASTEROIDE			EQU  0      ; 1ª coluna do asteroide 
LINHA_NAVE            EQU  27     ; 1ª linha da nave
COLUNA_NAVE           EQU  25     ; 1ª coluna da nave   
MIN_COLUNA		EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA		EQU  63        ; número da coluna mais à direita que o objeto pode ocupar

ATRASO			EQU	400H		; atraso para limitar a velocidade de movimento do asteroide/nave

LARGURA_ASTEROIDE			EQU	5
ALTURA			EQU	5		; altura do asteroide e da nave
LARGURA_NAVE        EQU 15


; * Constantes - cores
VERMELHO			EQU	0FF00H ; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
LARANJA       EQU 0FFA0H ; cor do pixel: laranja em ARGB (opaco e vermelho no máximo, verde a 10 e azul a 0)
VERDE         EQU 0F5F2H ; cor do pixel: verde em ARGB (opaco e verde no máximo, vermelho e azul a 0)
AZUL_CIANO    EQU 0F0FFH ; cor do pixel: verde em ARGB (opaco, verde e azul no máximo, vermelho a 0)
CINZENTO      EQU 0F999H ; cor do pixel: verde em ARGB (opaco no máximo, vermelho, verde e azul a 9)
PRETO         EQU 0F000H ; cor do pixel: preto em ARGB (opaco no máximo, vermelho, verde e azul a 0)

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
; * Registos usados globalmente: (Vamos escrevendo para termos noção dos registos já utilizados)
; Como input: R0, R1, R2 (podem ser alterados após o seu uso nas rotinas)
; Como output: R9, R10, R11 (não convém serem alterados)

; *********************************************************************************

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
	WORD		 LARGURA_ASTEROIDE
  WORD    ALTURA
	WORD		VERMELHO , 0 , VERMELHO , 0 , VERMELHO 		
  WORD		0 , VERMELHO , LARANJA , VERMELHO , 0
  WORD    VERMELHO , LARANJA , 0 , LARANJA , VERMELHO 
  WORD		0 , VERMELHO , LARANJA , VERMELHO , 0
	WORD		VERMELHO , 0 , VERMELHO , 0 , VERMELHO 
  

DEF_ASTEROIDE_MINERAVEL:					; tabela que define o asteroide minerável 
	WORD		 LARGURA_ASTEROIDE
  WORD    ALTURA
	WORD		0 , VERDE , VERDE , VERDE , 0		
  WORD		VERDE , VERDE , VERDE , VERDE , VERDE 
  WORD    VERDE , VERDE , VERDE , VERDE , VERDE 
  WORD		VERDE , VERDE , VERDE , VERDE , VERDE 
	WORD		0 , VERDE , VERDE , VERDE , 0	

DEF_EXPLOSAO_ASTEROIDE:					; tabela que define o asteroide quando explode 
	WORD		LARGURA_ASTEROIDE
  WORD    ALTURA
	WORD		0 , AZUL_CIANO , 0 , AZUL_CIANO , 0		
  WORD		AZUL_CIANO , 0, AZUL_CIANO , 0, AZUL_CIANO 
  WORD    0 , AZUL_CIANO , 0 , AZUL_CIANO , 0
  WORD		AZUL_CIANO , 0, AZUL_CIANO , 0, AZUL_CIANO 
	WORD		0 , AZUL_CIANO , 0 , AZUL_CIANO , 0	

DEF_NAVE:   
  WORD    LARGURA_NAVE
  WORD    ALTURA
  WORD    0, 0, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, 0, 0
  WORD    0, VERMELHO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, VERMELHO, 0
  WORD    VERMELHO, PRETO, PRETO, PRETO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, PRETO, PRETO, PRETO, VERMELHO
  WORD    VERMELHO, PRETO, PRETO, PRETO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, PRETO, PRETO, PRETO, VERMELHO
  WORD    VERMELHO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, VERMELHO

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
    
    MOV R10, 0 ; Inicializa o registo 10 que vai servir para controlo do desenho do asteroide 
    MOV R2, DEF_NAVE ; Inicializa o registo 2 que vai indicar que boneco desenhar
    
    CALL rotina_nave_asteroides  

repete: 

    MOV R2, DEF_ASTEROIDE_N_MINERAVEL
    CALL rotina_nave_asteroides ; desenha o asteroide se ainda não estiver desenhado
    
espera_tecla:   
    CALL teclado			; leitura às teclas
    CMP R1, 0
    JZ espera_tecla

    CALL converte_numero   ; retorna R9 com a tecla premida
	
    CALL rotina_acoes_teclado   ;executa as acoes de acordo com a tecla premida

    

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

    MOV R1, LINHA_TECLADO   ; por linha a 0001 0000 - para testar qual das linhas foi clicada

loop_linha:
    SHR R1, 1           ; dividir por 2 para testar as varias linhas do teclado
    CMP R1, 0
    JZ exit
	 
	MOV  R2, TEC_LIN   ; endereço do periférico das linhas
	MOV  R3, TEC_COL   ; endereço do periférico das colunas
	MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOVB [R2], R1      ; escrever no periférico de saída (linhas)
	MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
	AND  R0, R5        ; elimina bits para além dos bits 0-3
	CMP	R0, 0
	JZ loop_linha		; se nenhuma tecla premida, testa linha seguinte

tecla_premida:
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R9, [R3]
    AND R9, R5
    CMP R0, R9          ; testar se a coluna e igual
    JZ tecla_premida


exit:
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
; PARAMETROS: R2 - tipo da tabela (nave, asteroide não minerável, 
;asteroide minerável ou explosão de asteroide)
;
;RETORNA: R10 - Registo para controlar se já existe asteroide ou não 
; **********************************************************************
rotina_nave_asteroides: ; Deposita os valores dos registos abaixo no stack
    PUSH R1 
    PUSH R3
    PUSH R4 
    PUSH R5
    PUSH R6
    PUSH R7
 

    CMP R10, 1 ; No caso de já estar desenhado
    JZ final_desenha_asteroide_nave

    MOV R7, DEF_NAVE ; Servirá para comparar com o input para verificar se é nave ou não
    CMP R2, R7 ; Faz a verificação
    JZ posicao_inicial_nave ; Salta para a etiqueta que tem os dados da nave


    ; **********************************************************************
    

    posicao_inicial_asteroide:
        MOV  R1, LINHA_ASTEROIDE			; linha do asteroide
        MOV  R4, COLUNA_ASTEROIDE		  ; coluna do asteroide
        MOV  R7, R4                   ; registo para armazenar a coluna inicial
        MOV R10, 1 ; Diz à variável de controlo que após esta rotina haverá um asteroide desenhado 

        JMP desenha_asteroide_nave

    posicao_inicial_nave:
        MOV  R1, LINHA_NAVE			; linha da nave
        MOV  R4, COLUNA_NAVE	  ; coluna da nave
        MOV  R7, R4                   ; registo para armazenar a coluna inicial
        
    desenha_asteroide_nave:       		; desenha o asteroide/nave a partir da tabela

        MOV	R5, [R2]			; obtém a largura do asteroide/nave
        ADD R2, 2               ; endereço da altura do asteroide/nave
        MOV R6, [R2]            ; obtém a altura
        ADD	R2, 2			; endereço da cor do 1º pixel (2 porque a largura é uma word)

    desenha_todos_pixels:
        CMP R6, 0           ;verifica se a altura é 0, se sim termina
        JZ final_desenha_asteroide_nave

        MOV R4, R7           ;reinicia a coluna para o seu valor inicial
        CALL desenha_pixels_coluna           ; se a altura não for 0 vai desenhar os pixels da primeira linha livre
        ADD R1, 1           ; próxima linha
        
        SUB R6, 1           ; menos uma linha para tratar

        JMP desenha_todos_pixels        ; continua até percorrer toda a tabela 
    
    

    final_desenha_asteroide_nave: ; volta a atribuir os valores acumulados no stack aos devidos registos

        POP R7
        POP R6
        POP R5
        POP R4
        POP R3
        POP R1 
        RET

desenha_pixels_coluna:       		; desenha os pixels do asteroide/nave a partir da tabela
    PUSH R1
    PUSH R3
    PUSH R4
    PUSH R5


preenche_pixel:
    MOV	R3, [R2]			; obtém a cor do próximo pixel do asteroide/nave
    MOV  [DEFINE_LINHA], R1	; seleciona a linha
    MOV  [DEFINE_COLUNA], R4	; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas
    ADD	R2, 2			; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD  R4, 1               ; próxima coluna
    SUB  R5, 1			; menos uma coluna para tratar
    JNZ  preenche_pixel      ; continua até percorrer toda a largura do objeto

    POP R5
    POP R4
    POP R3
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
