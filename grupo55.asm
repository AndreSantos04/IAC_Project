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
LINHA_ASTEROIDE         EQU  0      ; 1ª linha do asteroide 
COLUNA_ASTEROIDE	    EQU  0      ; 1ª coluna do asteroide 
LINHA_NAVE              EQU  27     ; 1ª linha da nave 
COLUNA_NAVE             EQU  25     ; 1ª coluna da nave 
LINHA_PAINEL_CONTROLO   EQU 29     ; 1ª linha do painel de controlo da nave 
COLUNA_PAINEL_CONTROLO  EQU 29      ; 1ª coluna do painel de controlo da nave 
LINHA_SONDA             EQU 26      ; linha da sonda 
COLUNA_SONDA            EQU 32      ; coluna da sonda 
MIN_COLUNA		        EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA		        EQU  63        ; número da coluna mais à direita que o objeto pode ocupar

ATRASO			EQU	5H		; (inicialmente a 400) atraso para limitar a velocidade de movimento do asteroide/nave

; * Dimensões dos bonecos
LARGURA_ASTEROIDE		EQU	5
ALTURA			        EQU	5		; altura do asteroide e da nave
LARGURA_NAVE            EQU 15
LARGURA_SONDA           EQU 1
ALTURA_SONDA            EQU 1

; * Constantes - cores
VERMELHO	  EQU 0FF00H ; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
LARANJA       EQU 0FFA0H ; cor do pixel: laranja em ARGB (opaco e vermelho no máximo, verde a 10 e azul a 0)
VERDE         EQU 0F5F2H ; cor do pixel: verde em ARGB (opaco e verde no máximo, vermelho e azul a 0)
AZUL_CIANO    EQU 0F0FFH ; cor do pixel: verde em ARGB (opaco, verde e azul no máximo, vermelho a 0)
CINZENTO      EQU 0F999H ; cor do pixel: verde em ARGB (opaco no máximo, vermelho, verde e azul a 9)
PRETO         EQU 0F000H ; cor do pixel: preto em ARGB (opaco no máximo, vermelho, verde e azul a 0)
ROSA          EQU 0FF3FH ; cor do pixel: rosa em ARGB (opaco e vermelho no máximo, verde e azul a 7)


VALOR_INICIAL_DISPLAY   EQU 0064H   ; valor inicial do display (100 EM DECIMAL)
INCREMENTO_DISPLAY      EQU 000BH    ; tecla que incrementa o valor do display
DECREMENTO_DISPLAY      EQU 000FH    ; tecla que decremento o valor do display
SONDA_CIMA              EQU 000AH    ; tecla que move a sonda para cima
ASTEROIDE_BAIXO         EQU 0002H   ; tecla que move o asteroide para baixo

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

DEF_NAVE:   
  WORD    LARGURA_NAVE
  WORD    ALTURA
  WORD    0, 0, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, 0, 0
  WORD    0, VERMELHO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, VERMELHO, 0
  WORD    VERMELHO, PRETO, PRETO, PRETO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, PRETO, PRETO, PRETO, VERMELHO
  WORD    VERMELHO, PRETO, PRETO, PRETO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, PRETO, PRETO, PRETO, VERMELHO
  WORD    VERMELHO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, VERMELHO

DEF_SONDA:
  WORD    LARGURA_SONDA
  WORD    ALTURA_SONDA
  WORD    ROSA

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
    
    CALL rotina_desenha_bonecos  

repete: 

    MOV R2, DEF_ASTEROIDE_N_MINERAVEL   ; Define qual o boneco que vai ser desenhado no ecrã
    CALL rotina_desenha_bonecos ; desenha o asteroide se ainda não estiver desenhado
  

    CALL rotina_movimento_e_desenhos


    CALL	teclado			; leitura às teclas

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
; PARAMETROS: R2 - tipo da tabela (nave, asteroide não minerável, 
;asteroide minerável ou explosão de asteroide)
;
;RETORNA: R10 - Registo para controlar se já existe asteroide ou não 
; **********************************************************************
rotina_desenha_bonecos: ; Deposita os valores dos registos abaixo no stack

    PUSH R1 
    PUSH R3
    PUSH R4 
    PUSH R5
    PUSH R6
    PUSH R7
    
    CMP R10, 1
    JZ desenha_bonecos
    CALL rotina_posicao_atual ; neste caso (por ser a primeira chamada) irá criar a posição do boneco a desenhar


    desenha_bonecos:       		; desenha o asteroide/nave/sonda(bonecos) a partir da tabela

        MOV	R5, [R2]			; obtém a largura do boneco
        ADD R2, 2               ; endereço da altura do boneco
        MOV R6, [R2]            ; obtém a altura
        ADD	R2, 2			; endereço da cor do 1º pixel (2 porque a largura é uma word)



    desenha_todos_pixels:
        CMP R6, 0           ;verifica se a altura é 0, se sim termina
        JZ final_desenha_bonecos

        MOV R4, R7           ;reinicia a coluna para o seu valor inicial
        CALL desenha_pixels_coluna           ; se a altura não for 0 vai desenhar os pixels da primeira linha livre
        ADD R1, 1           ; próxima linha
        
        SUB R6, 1           ; menos uma linha para tratar

        JMP desenha_todos_pixels        ; continua até percorrer toda a tabela 
    


    final_desenha_bonecos: ; volta a atribuir os valores acumulados no stack aos devidos registos
        
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
    PUSH R5
    PUSH R6
    PUSH R7


    MOV R0, INCREMENTO_DISPLAY  ; tecla referente ao incremento do display
    MOV R1, DECREMENTO_DISPLAY  ; tecla referente ao decremento do display
    MOV R2, SONDA_CIMA          ; tecla referente ao movimento da sonda para cima
    MOV R3, ASTEROIDE_BAIXO     ; tecla referente ao movimento do asteroide para baixo
    MOV R4, DISPLAYS            ; endereço do display
    MOV R6, 0000H               ; valor minimo do display
    MOV R7, 03E7H                ; valor maximo do display

    CMP R9, R0
    JZ incrementa_display       ; procede ao incremento do valor do display
    CMP R9, R1
    JZ decrementa_display       ; procede ao decremento do valor do display
    CMP R9, R2
    JZ movimento_sonda_cima     ; procede ao movimento da sonda para cima
    JMP fim_rotina_acoes_teclado

incrementa_display:
    CMP R11,  R7           ; valor maximo a apresentar no display
    JGE fim_rotina_acoes_teclado ; se o valor do display for o maximo, não incrementa
    ADD R11, 1                  ; incrementa o valor do display
;    CALL rotina_converte_hexdec      ; converte o valor do display para decimal
    MOV [R4], R11             ; atualiza o valor do display
    JMP fim_rotina_acoes_teclado

decrementa_display:
    CMP R11, R6             ; valor minimo a apresentar no display
    JLE fim_rotina_acoes_teclado ; se o valor do display for o minimo, não decrementa
    SUB R11, 1                  ; decrementa o valor do display
;    CALL rotina_converte_hexdec      ; converte o valor do display para decimal
    MOV [R4], R11             ; atualiza o valor do display
    JMP fim_rotina_acoes_teclado
    
movimento_sonda_cima:

    CALL rotina_movimento_e_desenhos
    
fim_rotina_acoes_teclado:

    POP R8
    POP R7
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET


;; **********************************************************************
; Rotina (auxiliar para outras)
; - Gera números pseudo-aleatórios entre 0 e 4 (5 números) que irão corresponder 
;; a uma cor cada de modo a ser possível colorir o painel de controlo da nave 
;;
;; -RETORNA: R3
;; **********************************************************************
;;ACABAR___________________________________
;rotina_pinta_painel_controlo:
;    PUSH R1
;    PUSH R3
;    PUSH R4
;
;    posicao_painel: ; posição do primeiro pixel do painel de controlo da nave
;        MOV  R1, LINHA_PAINEL_CONTROLO
;        MOV  R4, COLUNA_PAINEL_CONTROLO	 
;        MOV  R7, R4
;
;    muda_cor_pixeis:
;    CALL rotina_pseudo_aleatorios_0a4
;    
;
;    MOV  [DEFINE_LINHA], R1	; seleciona a linha
;    MOV  [DEFINE_COLUNA], R4	; seleciona a coluna
;    MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas
;    ADD  R4, 1               ; próxima coluna
;    SUB  R5, 1			; menos uma coluna para tratar
;
;    POP R4 
;    POP R3
;    POP R1
;    RET
;
;; **********************************************************************
;; Rotina (auxiliar para outras)
;; - Gera números pseudo-aleatórios entre 0 e 4 (5 números) que irão corresponder 
;; a uma cor cada de modo a ser possível colorir o painel de controlo da nave 
;;
;; -RETORNA: R3
;; **********************************************************************
;rotina_pseudo_aleatorios_0a4:
;
;	MOV		R3, PC            ; Carrega o valor do Program Counter
;	AND		R3, 7             ; Aplica uma máscara para obter apenas os 3 bits menos significativos (pois 7 corresponde a 0...0111)
;	ADD		R3, 1             ; Incrementa em 1 (agora R2 contém um valor entre 1 e 8)
;	SHR		R3, 1             ; Divide por 2  ao andar um bit para a direita (agora R2 contém um valor entre 0 e 4)

;    RET

rotina_movimento_e_desenhos:

    PUSH R0
    PUSH R1
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8

    CALL rotina_posicao_atual ; atualiza a posição ou dos asteroides ou da sonda
 
    CALL rotina_apaga_boneco ; Apaga o asteroide/sonda da posição anterior

    MOV R2, DEF_ASTEROIDE_N_MINERAVEL
    CALL rotina_desenha_bonecos ; desenha o asteróide/sonda
    

    final_rotinha_mov_e_des: ; volta a atribuir os valores acumulados no stack aos devidos registos
        
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R1 
    POP R0
    RET

; **********************************************************************
; Rotina auxiliar
; esta rotina auxiliar vai à posição anterior apagar o desenho, ou da sonda ou do asteroide,
; pois quando é chamada já se indicou a próxima posição
;
; PARAMETROS: R2 - tipo da tabela (nave, asteroide não minerável, 
;asteroide minerável ou explosão de asteroide)
;
;
; **********************************************************************
rotina_apaga_boneco:

    PUSH R7
    PUSH R9
    PUSH R10
    PUSH R11

    posicao_anterior:
        MOV R9, DEF_SONDA ; guarda a tabela no registo para ser possível comparar com a tabela em R2
        CMP R2, R9
        JNZ caso_asteroide

        

        caso_sonda:
            ADD R1, 1 ; Se for a sonda a posição anterior é a linha de baixo(+1) na mesma coluna
            JMP acessos

        caso_asteroide: ; Se for asteroide, a posição anterior é na diagonal anterior (-1 em cada uma das componentes)
            MOV R11, R1 ; Guarda o valor da próxima linha para depois servir de linha de começo do próximo boneco
            SUB R1, 1 
            SUB R7, 1
        
    acessos:
        MOV R4, R7 ; guarda a coluna inicial
	    MOV	R5, [R2]		; obtém a largura do asteroide/sonda
        ADD R2, 2           ; endereço da altura do asteroide/sonda
        MOV R6, [R2]        ; obtem a altura
        MOV R10, R5         ; guarda o valor da largura para depois

    apaga_todos_pixels:     ; desenha os pixels do boneco a partir da tabela
        CMP R6, 0
        JZ final_apaga_boneco

        MOV R7, R4          ; reinicia a coluna para o seu valor inicial
        

    loop_apaga_colunas:
        MOV	R3, 0			; para apagar, a cor do pixel é sempre 0 (transparente)

        MOV  [DEFINE_LINHA], R1	    ; seleciona a linha com o comando define_linha
        MOV  [DEFINE_COLUNA], R7	; seleciona a coluna com o comando respetivo
        MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas para 0
        
        ADD  R7, 1                  ; próxima coluna
        SUB  R5, 1			        ; menos uma coluna para tratar
        JNZ  loop_apaga_colunas		    ; continua até percorrer toda a largura do objeto
        
        ADD R1, 1                   ; próxima linha
        SUB R6, 1                   ; menos uma linha por fazer
        MOV R5, R10         ; Reestabelece o valor da largura para o inicial

        JMP apaga_todos_pixels

    final_apaga_boneco:

        MOV R1, R11         ; devolve o valor da próxima linha a R1 para ser usado por outras rotinas
        POP R11
        POP R10
        POP R9
        POP R7
        RET

;; **********************************************************************
;; Rotina (auxiliar para outras)
;;  
;;
;; -RETORNA: R1 como a próxima linha do boneco
;;           R7 como a próxima coluna 
;;           R10 como variável de controlo para verificar se já existe asteroide
;; **********************************************************************
rotina_posicao_atual:

    PUSH R8
    
    CMP R10, 1 ; No caso de já estar desenhado
    JZ incrementa_posicao

    MOV R7, DEF_NAVE ; Servirá para comparar com o input para verificar se é nave ou não
    CMP R2, R7 ; Faz a verificação
    JZ posicao_inicial_nave ; Salta para a etiqueta que tem os dados da nave

    MOV R7, DEF_SONDA ; Servirá para comparar com o input para verificar se é sonda
    CMP R2, R7 ; Faz a verificação
    JZ posicao_sonda ; Salta para a etiqueta que tem os dados da nave

;; **********************************************************************
    

    posicao_inicial_asteroide:
        MOV  R1, LINHA_ASTEROIDE			; linha do asteroide
        MOV  R7, COLUNA_ASTEROIDE		  ; coluna do asteroide
;       MOV  R7, R4                   ; registo para armazenar a coluna inicial
        MOV R10, 1 ; Diz à variável de controlo que após esta rotina haverá um asteroide desenhado 

        JMP fim_rotina

    posicao_inicial_nave:
        MOV  R1, LINHA_NAVE			; linha da nave
        MOV  R7, COLUNA_NAVE	  ; coluna da nave
;        MOV  R7, R4                   ; registo para armazenar a coluna inicial
        JMP fim_rotina
        
    posicao_sonda:
        MOV  R1, LINHA_SONDA		; linha da nave
        MOV  R7, COLUNA_SONDA	  ; coluna da nave
;       MOV  R7, R4                   ; registo para armazenar a coluna inicial
        

    incrementa_posicao:
        MOV R8, DEF_SONDA ; Verifica se é sonda de novo
        CMP R2, R8 
        JZ sobe_sonda ; Se for sonda sobre uma linha (-1 linha)

    movimento_asteroide: ; asteroide move-se na diagonal
        ADD R1, 1 ; Se for asteroide aumenta uma linha e uma coluna para andar na diagonal
        ADD R7, 1
        JMP fim_rotina

    sobe_sonda:
        SUB R1, 1 ; diminui uma linha (sobe no ecrã)

    fim_rotina:
        POP R8
        RET