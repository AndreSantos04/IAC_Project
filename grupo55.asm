; *********************************************************************************
; * Constantes
; *********************************************************************************
DEFINE_LINHA    		EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU 600CH      ; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU 6012H      ; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 			EQU 6002H      ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO EQU 6042H      ; endereço do comando para selecionar uma imagem de fundo
NUMERO_VEZES_PLAY		EQU 6058H	   ; endereço do comando para definir o numero de vezes que um som deve ser tocado
PLAY					EQU 605AH	   ; endereço do comando para começar a reproduçao do som especificado
STOP					EQU 6068H	   ; endereço do comando para terminar a reproduçao de todos os sons
ATRASO					EQU	3H

DISPLAYS		EQU  0A000H	; endereço do periférico que liga aos displays
TEC_LIN			EQU  0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL			EQU  0E000H	; endereço das colunas do teclado (periférico PIN)
LINHA_TECLADO	EQU  0010H	; linha a testar 1 bit a esquerda da linha maxima (8b)
MASCARA			EQU	 0FH	; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TECLA_0			EQU     0	; tecla 0
TECLA_1			EQU     1	; tecla 1 
TECLA_2			EQU     2	; tecla 2
TECLA_C			EQU 	12	; tecla C
TECLA_D			EQU 	13	; tecla D
TECLA_E			EQU 	14	; tecla E

LINHA_ANCORA_ROVER		EQU  28		; linha canto superior esquerdo rover
COLUNA_ANCORA_ROVER		EQU  30		; coluna canto superior esquerdo do rover 

LINHA_MISSIL			EQU  27		; linha inicial do missil
COLUNA_MISSIL			EQU  32     ; coluna inicial do missil
PIXEL_MISSIL			EQU  0FFF0H ; cor do missil
ALCANCE_MISSIL			EQU  12		; alcance do missil

LINHA_INICIAL   EQU 0		; número da linha onde os meteoros aparecem
MIN_COLUNA		EQU 0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA		EQU 63      ; número da coluna mais à direita que o objeto pode ocupar
MAX_LINHA_METEOROS	EQU 30		;numero maximo da linha que os meteoros podem atingir

ALTURA_ROVER		EQU	4		; largura do rover
LARGURA_ROVER		EQU 5		; altura do rover
METEORO_ALTURA		EQU 1		; altura do meteoro
METEORO_LARGURA		EQU 1		; largura do meteoro
METEORO_LARGURA2	EQU 2
METEORO_ALTURA2		EQU 2
METEORO_LARGURA5	EQU 3
METEORO_ALTURA5		EQU 3
METEORO_LARGURA9	EQU 4
METEORO_ALTURA9		EQU 4
METEORO_LARGURA14	EQU 5
METEORO_ALTURA14	EQU 5

METEORO_BOM		EQU 1
METEORO_MAU		EQU 0

PRIMEIRA_COLUNA  EQU 1
SEGUNDA_COLUNA	 EQU 10
TERCEIRA_COLUNA  EQU 19
QUARTA_COLUNA    EQU 28
QUINTA_COLUNA	 EQU 37
SEXTA_COLUNA	 EQU 46
SETIMA_COLUNA    EQU 55

COR_PIXEL_ROVER  EQU 0F0FFH 	; cor do pixel do rover

COR_PIXEL		EQU	0FF00H	; cor do pixel : vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
COR_METEOR		EQU 0F0F0H  ; cor do pixel do meteoro em ARGB (opaco e verde no máximo, vermelho e azul a 0)
COR_LONGE		EQU 08FFFH	; cor do pixel do meteoro nas 2 primeiras fases
COR_EXPLOSAO    EQU 0FFFFh	; cor do pixel da explosao


; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H

; Reserva do espaço para as pilhas dos processos
	STACK 100H			; espaço reservado para a pilha do processo "programa principal"
SP_inicial_prog_princ:		; este é o endereço com que o SP deste processo deve ser inicializado


	STACK 100H			; espaço reservado para a pilha do processo "teclado"
SP_inicial_teclado:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H 			; espaço reservado para a pilha do processo "display"
SP_inicial_display:

	STACK 100H			; espaço reservado para a pilha do processo rover
SP_inicial_rover:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H			; espaço reservado para a pilha do processo meteoro
SP_inicial_meteoro:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H			; espaço reservado para a pilha do processo colisoes
SP_inicial_colisoes: 

	STACK 100H			; espaço reservado para a pilha do processo de final do jogo
SP_inicial_end:			; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H			; espaço reservado para a pilha do processo missil
SP_inicial_missil:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H			; espaço reservado para a pilha do processo colisao missil
SP_inicial_colisao_missil:		; este é o endereço com que o SP deste processo deve ser inicializado

tecla_carregada:
	LOCK 0				; LOCK para o teclado comunicar aos restantes processos que tecla detetou,
						; uma vez por cada tecla carregada
							
tecla_continuo:
	LOCK 0				; LOCK para o teclado comunicar aos restantes processos que tecla detetou,
						; enquanto a tecla estiver carregada

missil_lancado:				; LOCK para comunicar que missil foi disparado
	WORD 0		

linha_teste_meteoros:
	WORD 0	

linha_meteoros:
	LOCK 0				; LOCK para se saber a altura dos meteoros durante o programa todo

energia_rover:
	WORD 0064H			; WORD para a energia que o rover tem

coluna_rover:
	WORD 0 				; WORD para a coluna do rover
	
estado_jogo:
	WORD 0				; WORD para o estado do jogo (se for 1 perdeu sem energia e 2 se perdeu por colisão e 3 se o jogo esta pausado)

verifica_energia:
	LOCK 0
	
jogo_pausado:
	LOCK 0

game_over:
	LOCK 0

espera_tecla_recomeçar:
	LOCK 0

reinicializa_desenho:			; WORD que diz ao rover para reinicializar ao recomeçar o jogo
	WORD 0

; Tabela das rotinas de interrupção
tabela_rot_int:
	WORD rot_int_0			; rotina de atendimento da interrupção 0
	WORD rot_int_1			; rotina de atendimento da interrupção 1 - missil
	WORD rot_int_2			; rotina de atendimento da interrupção 2

evento_int_meteoro:
	LOCK 0			; LOCK para a rotina de interrupção 1

evento_int_display:
	LOCK 0			; LOCK para a rotina de interrupção 2

evento_int_missil:
	LOCK 0			; LOCK para a rotina de interrupçao 1 

DEF_MISSIL:			; tabela que define missil
	WORD 		LINHA_MISSIL
	WORD		COLUNA_MISSIL

DEF_MISSIL_DISPARO:
	WORD		LINHA_MISSIL
	WORD 		COLUNA_MISSIL

DEF_ROVER:				; tabela que define o Rover (cor, largura, pixels)
	WORD		ALTURA_ROVER
	WORD		LARGURA_ROVER
	WORD		0, 0, COR_PIXEL_ROVER, 0, 0 
	WORD 		COR_PIXEL_ROVER, 0, COR_PIXEL_ROVER, 0, COR_PIXEL_ROVER
	WORD 		COR_PIXEL_ROVER, COR_PIXEL_ROVER, COR_PIXEL_ROVER, COR_PIXEL_ROVER, COR_PIXEL_ROVER
	WORD		0, COR_PIXEL_ROVER, 0, COR_PIXEL_ROVER, 0

DEF_METEORO:			; tabela que define o Meteoro na linha 0
	WORD		METEORO_ALTURA
	WORD		METEORO_LARGURA
	WORD		COR_LONGE

DEF_METEORO2:			; tabela que define o Meteoro na linha 2
	WORD		METEORO_ALTURA2
	WORD		METEORO_LARGURA2
	WORD		COR_LONGE, COR_LONGE
	WORD		COR_LONGE, COR_LONGE

DEF_METEORO5:			; tabela que define o Meteoro na linha 5
	WORD		METEORO_ALTURA5
	WORD		METEORO_LARGURA5
	WORD		0, COR_METEOR, 0
	WORD		COR_METEOR, COR_METEOR, COR_METEOR
	WORD		0, COR_METEOR, 0

DEF_METEORO9:			; tabela que define o Meteoro na linha 9
	WORD		METEORO_ALTURA9
	WORD		METEORO_LARGURA9
	WORD		0, COR_METEOR, COR_METEOR, 0
	WORD		COR_METEOR, COR_METEOR, COR_METEOR, COR_METEOR
	WORD		COR_METEOR, COR_METEOR, COR_METEOR, COR_METEOR
	WORD		0, COR_METEOR, COR_METEOR, 0

DEF_METEORO14:			; tabela que define o Meteoro na linha 14
	WORD		METEORO_ALTURA14
	WORD		METEORO_LARGURA14
	WORD		0, COR_METEOR, COR_METEOR, COR_METEOR, 0
	WORD		COR_METEOR, COR_METEOR, COR_METEOR, COR_METEOR, COR_METEOR
	WORD		COR_METEOR, COR_METEOR, COR_METEOR, COR_METEOR, COR_METEOR
	WORD		COR_METEOR, COR_METEOR, COR_METEOR, COR_METEOR, COR_METEOR
	WORD		0, COR_METEOR, COR_METEOR, COR_METEOR, 0

DEF_NAVE5:				; tabela que define a Nave inimiga na linha 5
	WORD		METEORO_ALTURA5
	WORD		METEORO_LARGURA5
	WORD		COR_PIXEL, 0, COR_PIXEL
	WORD		0, COR_PIXEL, 0
	WORD		COR_PIXEL, 0, COR_PIXEL

DEF_NAVE9:				; tabela que define a Nave inimiga na linha 9
	WORD		METEORO_ALTURA9
	WORD		METEORO_LARGURA9
	WORD		COR_PIXEL, 0, 0, COR_PIXEL
	WORD		COR_PIXEL, 0, 0, COR_PIXEL
	WORD		0, COR_PIXEL, COR_PIXEL, 0
	WORD		COR_PIXEL, 0, 0, COR_PIXEL

DEF_NAVE14:				; tabela que define a Nave inimiga na linha 14
	WORD		METEORO_ALTURA14
	WORD		METEORO_LARGURA14
	WORD		COR_PIXEL, 0, 0, 0, COR_PIXEL
	WORD		COR_PIXEL, 0, COR_PIXEL, 0, COR_PIXEL
	WORD		0, COR_PIXEL, COR_PIXEL, COR_PIXEL, 0
	WORD		COR_PIXEL, 0, COR_PIXEL, 0, COR_PIXEL
	WORD		COR_PIXEL, 0, 0, 0, COR_PIXEL

DEF_EXPLOSAO:
	WORD		METEORO_LARGURA14
	WORD		METEORO_ALTURA14
	WORD		0, COR_EXPLOSAO, 0, COR_EXPLOSAO, 0
	WORD		COR_EXPLOSAO, 0, COR_EXPLOSAO, 0, COR_EXPLOSAO
	WORD		0, COR_EXPLOSAO, 0, COR_EXPLOSAO, 0
	WORD		COR_EXPLOSAO, 0, COR_EXPLOSAO, 0, COR_EXPLOSAO
	WORD		0, COR_EXPLOSAO, 0, COR_EXPLOSAO, 0

DEF_METEOROS:
	WORD		1	; se o meteoro existe ou n (0/1)
	WORD		0	; bom ou mao (0/1)
	WORD		1	; coluna em que se encontra 

	WORD		1	; resto dos valores com o minimo das suas colunas em que podem aparecer
	WORD		0
	WORD		10

	WORD		1
	WORD		0
	WORD		19

	WORD		1
	WORD		0
	WORD		28

	WORD		1
	WORD		0
	WORD		37

	WORD		1
	WORD		0
	WORD		46

	WORD		1
	WORD		0
	WORD		55
DEF_FINAL_METEOROS:

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                     ; o código tem de começar em 0000H
inicio:
	MOV  SP, SP_inicial_prog_princ		; inicializa SP do programa principal
	MOV  BTE, tabela_rot_int			; inicializa BTE (registo de Base da Tabela de Exceções)
	
	MOV  [APAGA_AVISO], R1				; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1				; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, 3							; cenário de fundo número 3
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	MOV  R1, 1							; tocar o som uma vez
	MOV  [NUMERO_VEZES_PLAY], R1		; define que os sons serao tocados uma vez so
	ADD  R1, 1
	MOV  [PLAY], R1					; toca o som inicial
	
	MOV R4, DEF_MISSIL
	MOV R1, LINHA_MISSIL
	MOV [R4], R1			; inicializar a liha do missil
	ADD R4, 2
	MOV R2, COLUNA_MISSIL
	MOV [R4], R2			; inicializar a coluna do missil onde o rover se encontra
	
	EI2					; permite interrupções 2
	EI1					; permite interrupçoes  1
	EI0					; permite interrupções 0
	EI					; permite interrupções (geral)
						; a partir daqui, qualquer interrupção que ocorra usa
						; a pilha do processo que estiver a correr nessa altura
						
	; cria processos. O CALL não invoca a rotina, apenas cria um processo executável
	
	CALL	teclado			; cria o processo teclado
	JMP     espera_inicio
inicia:
	MOV     R1, 0
	MOV     [SELECIONA_CENARIO_FUNDO], R1	; seleciona o ecra de fundo certo
	MOV 	[STOP], R1						; para o som inicial
	CALL 	display			; cria o processo display
	CALL 	rover			; cria processo rover
	CALL 	meteoros		; cria processo meteoros
	CALL    missil			; cria processo missil
	CALL	colisoes		; cria o processo colisoes
	CALL    colisao_missil	; cria o processo colisao com o missil
	CALL	acaba_jogo		; cria o processo acaba_jogo

	EI2					; permite interrupções 2
	EI1					; permite interrupçoes  1
	EI0					; permite interrupções 0
	EI					; permite interrupções (geral)
						; a partir daqui, qualquer interrupção que ocorra usa
						; a pilha do processo que estiver a correr nessa altura

espera_inicio:
	MOV R9, [tecla_carregada]	; espera pelo user clicar na tecla C
	MOV R8, TECLA_C
	CMP R8, R9
	JZ  inicia					; se clicar na tecla C começa o jogo
	JMP espera_inicio			; se nao volta a ficar a espera

; **********************************************************************
; Processo
;
; ROVER - Processo que desenha o ROVER, o move horizontalmente e detecta as suas colisoes
;		 
;		R1 - linha ancora do rover, canto superior esquerdo na tela
;		R2 - coluna ancora do rover, canto superior esquerdo na tela
;		R4 - tabela que define rover
;		R7 - direçao com que o rover vai se mexer
;		R9 - tabela do missil
;		R11 - Valor da linha dos meteoros
; **********************************************************************

PROCESS SP_inicial_rover	; indicação de que a rotina que se segue é um processo,
						; com indicação do valor para inicializar o SP

rover:					; processo que implementa o comportamento do rover
						; desenha o boneco na sua posição inicial

	MOV R0, 0					
	MOV [reinicializa_desenho], R0	; reinicializar para so ser usada quando recomeça o jogo

    MOV R1, LINHA_ANCORA_ROVER			; linha na tela rover
	MOV	R2, COLUNA_ANCORA_ROVER			; coluna na tela do rover
	MOV	R4, DEF_ROVER		; endereço da tabela que define o boneco
	MOV R8, DEF_MISSIL		; endereço da tabela que define o missil
	ADD R8, 2				; endereço da coluna do missil
	MOV R9,[R8]				; coluna inicial do missil
	
ciclo_rover:
	
	MOV  R10, [estado_jogo]			; move para R10 o estado do jogo
	CMP	 R10, 1
	JZ   game_over_apaga_rover		; se o estado do jogo estiver a 1 (perdeu sem energia), salta para game_over_apaga_rover
	CMP  R10, 2
	JZ	 game_over_apaga_rover		; se o estado do jogo estiver a 2 (perdeu por colisao), salta para game_over_apaga_rover
	CMP  R10, 3
	JZ 	 pausa_rover				; se o estado do jogo estiver a 3 (jogo pausado), salta para pausa_rover
	CALL desenha_boneco		; desenha o boneco a partir da tabela


espera_movimento_rover:

	MOV R10, [reinicializa_desenho]		; vamos ver se o jogo foi recomeçado
	CMP R10, 1	
	JZ rover							; se sim, temos de por o rover na posicao original

	MOV	R3, [tecla_continuo]	; lê o LOCK e bloqueia até o teclado escrever nele novamente
	CMP	R3, TECLA_2			
	JZ 	avanca_rover_direita	; carregou na tecla 2
	CMP R3, TECLA_0
	JZ	avanca_rover_esquerda	; carregou tecla 0
	JNZ espera_movimento_rover  ; se não é, ignora e continua à espera
	

avanca_rover_direita:
	MOV R7, 1			; rover avanca 1 para a direita
	JMP apaga_rover

avanca_rover_esquerda:
	MOV R7, -1			; rover avanca 1 para a esquerda

apaga_rover:
	CALL	apaga_boneco		; apaga o boneco na sua posição corrente

	MOV	R6, LARGURA_ROVER	    ; obtém a largura do rover
	CALL	testa_limites		; vê se chegou aos limites do ecrã e nesse caso inverte o sentido
	
	ADD	R2, R7			; para desenhar objeto na coluna seguinte (direita ou esquerda)
	MOV	[coluna_rover], R2	; atualiza a coluna do rover para o LOCK
	ADD R9, R7			; 
	MOV [R8], R9        ; muda a coluna do missil na tabela
	JMP	ciclo_rover		; esta "rotina" nunca retorna porque nunca termina
						; Se se quisesse terminar o processo, era deixar o processo chegar a um RET

game_over_apaga_rover:		; para o rover
	MOV	 R10, [game_over]
	JMP  rover

pausa_rover:				; pausa o rover
	MOV	R10, [jogo_pausado]
	JMP ciclo_rover

; **********************************************************************
; APAGA_BONECO - Apaga um boneco na linha e coluna indicadas
;			  com a forma definida na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
;
; **********************************************************************

apaga_boneco:
	PUSH    R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH 	R6
	PUSH    R7
	PUSH    R8

	MOV	R5, [R4]	    ; obtém a altura do boneco (R5)
	ADD R4, 2			; como e uma tabela precisamos de avançar 2 endereços para obter largura
	MOV R7, [R4]		; obtem largura do boneco - contador das colunas
	MOV R8, R2			; guardo coluna inicial em R8 porque R2 vai ser modificado no loop
	MOV	R3, 0			; poe cor do pixel a 0

loop_inicializa_coluna_apaga: 			
	MOV R2, R8			;  reinicializa R2
	MOV R6, R7			; inicializo contador de colunas

apaga_pixels:       		; desenha os pixels do boneco a partir da tabela
	CALL	escreve_pixel		; escreve cada pixel do boneco - usa R1 linha, R2 coluna e R4 (word dos pixeis)
    ADD  R2, 1          ; próxima coluna (tela)
    SUB  R6, 1			; menos uma coluna para tratar - contador colunas
    JNZ  apaga_pixels      ; continua até percorrer toda a largura do objeto
	ADD  R1, 1			;passar a linha seguinte (tela)
	SUB  R5,1			; diminuir contador das linhas
	CMP  R5, 0
	JNZ	 loop_inicializa_coluna_apaga

saida_apaga:
	POP R8
	POP R7
	POP R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	POP R1
	RET





; **********************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas
;			    com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
;
; **********************************************************************
desenha_boneco:
	PUSH    R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH 	R6
	PUSH    R7
	PUSH    R8

	MOV	R5, [R4]	    ; obtém a altura do boneco (R5)
	ADD R4, 2			; como e uma tabela precisamos de avançar 2 endereços para obter largura
	MOV R7, [R4]		; obtem largura do boneco - contador das colunas
	MOV R8, R2			; guardo coluna inicial em R8 porque R2 vai ser modificado no loop
	ADD	R4, 2			; endereço da cor do 1º pixel (2 porque a largura é uma word)

loop_inicializa_coluna: 			
	MOV R2, R8			;  reinicializa R2
	MOV R6, R7			; inicializo contador de colunas

desenha_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	R3, [R4]			; obtém a cor do próximo pixel do boneco
	CALL	escreve_pixel		; escreve cada pixel do boneco - usa R1 linha, R2 coluna e  
								; R3 cor do pixel 
	ADD	 R4, 2			; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD  R2, 1          ; próxima coluna (tela)
    SUB  R6, 1			; menos uma coluna para tratar - contador colunas
    JNZ  desenha_pixels      ; continua até percorrer toda a largura do objeto
	ADD  R1, 1			;passar a linha seguinte (tela)
	SUB  R5,1			; diminuir contador das linhas
	CMP  R5, 0
	JNZ	 loop_inicializa_coluna

saida_desenha:
	POP R8
	POP R7
	POP R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	POP R1
	RET



; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************
escreve_pixel:
	PUSH R1
	PUSH R2
	PUSH R3
	MOV  [DEFINE_LINHA], R1		; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna já selecionadas
	POP R3
	POP R2 
	POP R1 
	RET

; **********************************************************************
; TESTA_LIMITES - Testa se o boneco chegou aos limites do ecrã e nesse caso
;			   impede o movimento (força R7 a 0)
; Argumentos:	
;			R2 - coluna em que a ancora do objeto está na tela
;			R6 - largura do boneco
;			R7 - sentido de movimento do boneco (valor a somar à coluna
;				em cada movimento: +1 para a direita, -1 para a esquerda)
;
; Retorna: 	R7 - 0 se já tiver chegado ao limite, inalterado caso contrário	
; **********************************************************************
testa_limites:
	PUSH	R5
	PUSH	R6

testa_limite_esquerdo:		; vê se o boneco chegou ao limite esquerdo
	MOV	R5, MIN_COLUNA
	CMP	R2, R5
	JGT	testa_limite_direito  ; entre limites. Mantém o valor do R7
	CMP	R7, 0			; estamos no limite esquerdo
						; queremos ir para direita se R7 = 1
						; se R7 = -1 queremos ir para esquerda
	JGE	sai_testa_limites ; se esta no limite esquerdo mas queremos ir para direita
	JMP	impede_movimento	

testa_limite_direito:		; vê se o boneco chegou ao limite direito
	ADD	R6, R2			; posição do boneco no seu extremo direito
	MOV	R5, MAX_COLUNA
	CMP	R6, R5
	JLE	sai_testa_limites	; entre limites. Mantém o valor do R7
	CMP	R7, 0			 ; estamos no limite direito
					     ; queremos ir para direita R7 = 1
						 ; queremos ir para esquerda R7 = -1
	JGT	impede_movimento  ; se maior que 0, queremos ir para direita, impossivel
	JMP	sai_testa_limites

impede_movimento:
	MOV	R7, 0			; impede o movimento, forçando R7 a 0

sai_testa_limites:	
	POP	R6
	POP	R5
	RET

; **********************************************************************
; Processo
;
; DISPLAY - Processo que faz as coisas aparecerem no display 
;
; **********************************************************************

PROCESS SP_inicial_display	; indicação de que a rotina que se segue é um processo,
						; com indicação do valor para inicializar o SP

display:
	MOV  R1, 0064H			; valor inicial de energia que vai ser mostrado nos displays
	MOV  R0, DISPLAYS        ; endereço do periférico que liga aos displays

atualiza_energia:
	CALL converte_Hex_Decimal	           	
	MOV [R0], R5 			; mostra o valor de energia em forma decimal (em cada nibble) no display
	MOV [verifica_energia], R1
	CMP R1, 0
	JZ sem_energia					; se energia estiver a 0 salta para sem_energia
	MOV R9, [estado_jogo]
	CMP R9, 2
	JZ  game_over_energia			; se o estado do jogo estiver a 2 (colisao com nave inimiga)
	CMP R9, 3
	JZ  pausa_energia				; se o estado do jogo estiver a 3 (jogo pausado)
	MOV	R2, [evento_int_display]	; bloqueia neste LOCK
	MOV	R5, [energia_rover]		; recebe o valor de energia passado
	SUB	R1, 5
	MOV	[energia_rover], R1		; coloca a energia que o rover tem na memoria LOCK dele
	JMP	atualiza_energia

sem_energia:			; se o jogador perdeu sem energia
	MOV R2, 1
	MOV [estado_jogo], R2		; muda o estado do jogo para 1 (perdeu sem energia)
	MOV R1, 0064H						; da reset no valor do display, sem escrever
	MOV R2, [game_over]					; pausa a rotina
	JMP atualiza_energia

game_over_energia:		; se o jogador perder sem ser por ficar sem energia
	MOV R2, [game_over]
	MOV R1, 0064H
	MOV R5, 100H
	JMP display

pausa_energia:			; pausa o processo energia
	MOV R9, [jogo_pausado]
	JMP atualiza_energia

; **********************************************************************
; ROTINA
;
; converte_Hex_Decimal - Converte um numero hexadecimal para decimal,
;						de forma a que cada nibble do display mostre um digito
;
; Parametros: R1 - numero em hexadecimal
;
; Variaveis:
;			  R2 - numero 
;			  R3 - fator 
;			  R4 - digito
;		      R5 - resultado 
;			  R7 - temporario
;
; Retorna R5 - cada nibble com um digito
; **********************************************************************


converte_Hex_Decimal:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4

	MOV R4, 0
	MOV R5, 0H
	MOV R3, 1000		; o fator começa em 1000
ciclo_converte_hex:
	MOD R1, R3 			; numero = numero MOD Fator
	MOV R6, 10				
	DIV R3, R6			; fator = fator DIV 10

	MOV R7, R1			;  
	DIV R7, R3			; digito = numero DIV fator
	MOV R4, R7

	SHL R5, 4			; resultado = resultado SHL 4
						; desloca para cada nibble ter um digito
	OR R5,R4			; resultado = resultado OR digito
						; adiciona novo digito ao nible com menos peso

	MOV R7,R3			
	SUB R7, 1			; Ver se factor é igual a 1
	JNZ ciclo_converte_hex

	POP R4 
	POP R3
	POP R2 
	POP R1
	RET 



; **********************************************************************
; Processo
;
; TECLADO - Processo que deteta quando se carrega numa tecla e coloca o valor no LOCK
;		  	tecla_carregada, e pausa o programa quando o utilizador clica na tecla D
;		
;		R2 - endereço periferico das linhas 
;		R3 - endereço periferico das colunas
;		R5 - mascara
; **********************************************************************

PROCESS SP_inicial_teclado	; indicação de que a rotina que se segue é um processo,
						; com indicação do valor para inicializar o SP
teclado:					; processo que implementa o comportamento do teclado
	MOV  R2, TEC_LIN		; endereço do periférico das linhas
	MOV  R3, TEC_COL		; endereço do periférico das colunas
	MOV  R4, 0
	MOV  R5, MASCARA		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

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

    CALL converte_numero   ; retorna R9 com a tecla premida

	MOV R8, TECLA_D		   ; se clicar na tecla D, pausa o jogo
	CMP R9, R8
	JZ  pausa
			
	MOV	[tecla_carregada], R9	; informa quem estiver bloqueado neste LOCK que uma tecla foi carregada
							; ( o valor escrito e a tecla carregada)

reinicializa_jogo:
	MOV R4, [estado_jogo]   ; se estado de jogo = 2 e carregou em tecla C
							; sigifica que perdeu o jogo e quer voltar a jogar
	CMP R4, 2				; testar se morreu por colisao com meteoro mau
	JZ  carregou_C			; vamos testar se carregou na tecla C
	CMP R4, 1				; vamos testar se morreu por perda de energia
	JZ carregou_C	
	JMP ha_tecla		

carregou_C:
	MOV R4, R9				; nao podemos alterar R9
	SUB R4, 4				; SUB so pode ir de -8 a 7
	SUB R4, 4				; transformo C ( = 12 ou -4 em Complemeto para 2) 
	CMP R4, 4				; no simetrico, ie, 4
	JNZ ha_tecla
	MOV R4, 0				; se estamos nas condicoes altero o estado de jogo
	MOV [estado_jogo], R4 	; para o rover ser desenhado no inicio do novo jogo
	MOV R4, 1
	MOV [reinicializa_desenho], R4
	JMP teclado 

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

	


pausa:						; muda o ESTADO_JOGO para 3 (jogo pausado) e se ja estiver a 3,
	CMP R4, 3				; salta para o ciclo sai_pausa
	JZ sai_pausa
	MOV R4, 3
	MOV [estado_jogo], R4
	JMP ha_tecla

sai_pausa:					; tira a pausa de todos os processos que estavam pausados
	MOV R4, 0
	MOV [estado_jogo], R4
	MOV [jogo_pausado], R4
	JMP ha_tecla

; **********************************************************************
; Rotina
;
; Converte_numero - converte o numero da linha e da coluna da tecla premida
;		            no numero/letra premida
;
;PARAMETROS: R1 - numero da linha premida
;            R0 - nnumero da coluna
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
; Processo
;
; METEOROS - Processo que desenha os METEOROS e os move de acordo com a interrupçao 2
;		 
;		R1 - linha dos meteoro
;		R2 - coluna do meteoro
;		R3 - endereço do periferico das colunas do teclado
;		R4 - tabela que define meteoro
;		R11 - endereço da tabela que define os meteoros
;		R8 - numero de meteoros a trabalhar com
;		R9 - temporario
;		R7 - valor maximo que o meteoro pode ir
; **********************************************************************

PROCESS SP_inicial_meteoro			; indicação de que a rotina que se segue é um processo

meteoros:					; com indicação do valor para inicializar o SP

	MOV	R7, MAX_LINHA_METEOROS		; valor maximo que o meteoro pode atingir ate spawnar outros

define_meteoros:				; processo que implementa o comportamento dos meteoros

	MOV	R1, 0

	MOV	R3, TEC_COL			; um meteoro e definido por 3 valores 1 (se existe ou n), 2 (se e bom ou n) e o 3 (a sua coluna)

	MOV	R11, DEF_METEOROS		; inicializa o ponteiro do conteudo dos meteoros

; nesta zona defenimos os meteoros colocando as colunas na tabela.
; Dividimos o num maximo de colunas da tela em 7 com pelo menos 1 coluna de 
; intervalo entre meteoros.
; dentro de cada intervalo de 9 espaços, a coluna superior esquerda de cada meteoro
; pode tomar um valor aleatorio: Valor original + valor aleatorio de 0 a 3

	MOV	R9, PRIMEIRA_COLUNA				; primeira coluna 
	CALL	set_meteoro
	MOV	R9, SEGUNDA_COLUNA				; segunda coluna
	CALL	set_meteoro
	MOV	R9, TERCEIRA_COLUNA				; terceira coluna
	CALL	set_meteoro
	MOV	R9, QUARTA_COLUNA				; quarta coluna
	CALL	set_meteoro
	MOV	R9, QUINTA_COLUNA				; quinta coluna
	CALL	set_meteoro
	MOV	R9, SEXTA_COLUNA				; sexta coluna
	CALL	set_meteoro
	MOV	R9, SETIMA_COLUNA				; setima coluna
	CALL	set_meteoro



ciclo_meteoros:		; este ciclo desenha os meteoros a partir da tabela e depois fica a espera de os poder descer

	MOV 	R9, [estado_jogo]
	CMP		R9, 1
	JZ 		game_over_apaga_meteoros
	CMP		R9, 2
	JZ		game_over_apaga_meteoros
	CMP		R9, 3
	JZ 		pausa_meteoros
	CALL	desenha_meteoros	; desenha os meteoros todos

meteoro_existe:
	MOV 	R6, [evento_int_meteoro]	; ve se ja pode mover
	CALL	apaga_meteoros		; se sim apaga os meteoros anteriores
	CMP	R1, R7			; compara o valor para ver se ja atingiu o maximo
	JZ	novos_meteoros		; e se ja cria os meteoros todos de novo
	ADD	R1, 1			; adiciona 1 a linha
	MOV	[linha_meteoros], R1	; coloca a linha em que os meteoros tao na memoria WORD dele
	JMP	ciclo_meteoros		; se n continua a desce-los

novos_meteoros:
	CALL apaga_meteoros		; apaga os meteoros atuais
	JMP	 define_meteoros			; e manda criar novos la em cima

game_over_apaga_meteoros:		; apaga os meteoros apos o jogo acabar
	CALL apaga_meteoros
	MOV	 R9, [game_over]
	JMP  meteoros

pausa_meteoros:					; pausa o movimento dos meteoros
	CALL desenha_meteoros
	MOV	R9, [jogo_pausado]
	JMP ciclo_meteoros

; ***************************************************
; Rotina - desenha_meteoros
; nesta rotina os meteoros sao desenhados de acordo com os valores da tabela de meteoros
; Desenha todos os meteoros na linha R1
; Distribuindo pela tabela de ponteiro R11
; R11 - Tabela que define meteoros ( se existe, bom ou mau, coluna )
;
; ***************************************************

desenha_meteoros:

	PUSH	R7
	PUSH	R8
	PUSH	R10
	MOV	R8, 0					; define a linha em que estamos
	MOV	R11, DEF_METEOROS		; volta atraz na memoria para desenhalos

ciclo_meteoro:

	CMP	R8, 7				; pergunta se e o ultimo meteoro
	JZ	fim					; se sim para

	MOV	R10, [R11]			; move o valor do meteoro
	CMP	R10, 0				; pergunta se o meteoro existe ou n
	JZ	nao_meteoro			; se n existir manda para o proximo

	ADD	R11, 2				; proxima memoria meteoro bom ou mau
	MOV	R10, [R11]			; move o valor do meteoro
	CMP	R10, 1				; pergunta se e bom
	JZ	bom_meteoro			; se sim define como meteoro bom
	JMP	mau_meteoro			; se n define como nave inimiga (mau meteoro)

coluna_do_meteoro:

	ADD	R11, 2				; vai para a memoria com a coluna
	MOV	R2, [R11]			; coloca a coluna

	CALL 	desenha_boneco			; desenha o meteoro
	ADD	R8, 1				; diz que desenhou mais 1
	ADD	R11, 2				; proxima memoria
	JMP	ciclo_meteoro			; desenha +1

nao_meteoro:
	ADD 	R11, 6				; proximo meteoro
	ADD	R8, 1				; mais 1 meteoro processado
	JMP	ciclo_meteoro			

bom_meteoro:					; este parte escolhe qual e o desenho de meteoro a escolher
	MOV	R7, 14				
	CMP	R1, R7				; compara o valor da linha
	JGE	bom_meteoro_14			; e manda para o desenho especifico
	MOV	R7, 9
	CMP	R1, R7
	JGE	bom_meteoro_9
	CMP	R1, 5
	JGE	bom_meteoro_5
	CMP	R1, 2
	JGE	bom_meteoro_2
	CMP	R1, 1
	JGE	bom_meteoro_1

bom_meteoro_1:
	MOV	R4, DEF_METEORO			; define o meteoro com o desenho especifico
	JMP	coluna_do_meteoro		; volta ao processo de o desenhar

bom_meteoro_2:
	MOV	R4, DEF_METEORO2
	JMP	coluna_do_meteoro

bom_meteoro_5:
	MOV	R4, DEF_METEORO5
	JMP	coluna_do_meteoro

bom_meteoro_9:
	MOV	R4, DEF_METEORO9
	JMP	coluna_do_meteoro
	
bom_meteoro_14:
	MOV	R4, DEF_METEORO14
	JMP	coluna_do_meteoro

mau_meteoro:					; este parte escolhe qual e o desenho de meteoro a escolher
	MOV	R7, 14
	CMP	R1, R7				; compara o valor da linha
	JGE	mau_meteoro_14			; e manda para o desenho especifico
	MOV	R7, 9
	CMP	R1, R7
	JGE	mau_meteoro_9
	CMP	R1, 5
	JGE	mau_meteoro_5
	CMP	R1, 2
	JGE	mau_meteoro_2
	CMP	R1, 1
	JGE	mau_meteoro_1

mau_meteoro_1:
	MOV	R4, DEF_METEORO			; define o meteoro com o desenho especifico
	JMP	coluna_do_meteoro		; volta ao processo de o desenhar

mau_meteoro_2:
	MOV	R4, DEF_METEORO2
	JMP	coluna_do_meteoro

mau_meteoro_5:
	MOV	R4, DEF_NAVE5
	JMP	coluna_do_meteoro

mau_meteoro_9:
	MOV	R4, DEF_NAVE9
	JMP	coluna_do_meteoro
	
mau_meteoro_14:
	MOV	R4, DEF_NAVE14
	JMP	coluna_do_meteoro
	
fim:
	POP	R10
	POP	R8
	POP	R7
	RET

; ***************************************************
; Rotina - apaga_meteoro
; nesta rotina todos os meteoros sao apagados independetemente se existem ou n
; Apaga todos os meteoros na linha R1
; Distribuindo pela tabela de ponteiro R11
; ***************************************************

apaga_meteoros:

	PUSH	R8
	PUSH 	R10
	MOV	R8, 0				; numero de meteoros apagados
	MOV	R11, DEF_METEOROS		; volta atraz na memoria para apagalos

ciclo_meteoro_a:

	CMP	R8, 7				; pergunta se e o ultimo meteoro
	JZ	fim_a				; se sim para

	MOV	R4, DEF_NAVE14			; apaga um 5x5

coluna_do_meteoro_a:

	MOV	R10, [R11]			; coloca o valor que representa a existencia do meteoro
	CMP	R10, 0				; se n existir
	JZ	proximo_meteoro			; salta para o proximo
	ADD	R11, 4				; vai para a memoria com a coluna
	MOV	R2, [R11]			; coloca a coluna

	CALL 	apaga_boneco			; apaga o meteoro
	ADD	R8, 1				; diz que apagou mais 1
	ADD	R11, 2				; proxima memoria
	JMP	ciclo_meteoro_a			; apaga +1
	
proximo_meteoro:
	ADD	R11, 6				; proximo meteoro
	JMP	ciclo_meteoro_a			; apagar proximo meteoro

fim_a:
	POP	R10
	POP	R8
	RET					; termina por agora

; ***************************************************
; Rotina - set_meteoro
; Coloca os valores do meteoro que comeca na coluna R9 na tabela de meteoros
; colocando 1, depois 0 ou 1 aleatoriamente e depois juntando um valor aleatorio entre 0 a 3 ao R9
; Distribuindo pela tabela de ponteiro R11
; ***************************************************

set_meteoro:

	MOV	R10, 1				; registo a 1
	MOV	[R11], R10			; inicaliza a existencia do meteoro a 1
	ADD	R11, 2				; proxima sitio da memoria
	MOV 	R10, [R3]			; obter um valor aleatorio
	SHR 	R10, 14				; resto 4
	CMP	R10, 1				; escolher 1 deles para fazer 25% chance de ser bom
	JZ	set_bom_meteoro			; salta para onde se coloca o valor a 1
	MOV	R10, 0				; valor a 0 (meteoro mau)
	MOV	[R11], R10			; se nao coloca a 0
	JMP	resto_meteoro

set_bom_meteoro:
	MOV	[R11], R10			; coloca a 1	

resto_meteoro:
	ADD	R11, 2				; coluna do meteoro
	MOV R10, [R3]			; obter um valor aleatorio
	SHR R10, 14				; resto 4
	ADD	R10, R9				; coloca aleatorio a primeira variante
	MOV	[R11], R10			; coloca o valor na memoria
	ADD	R11, 2				; proximo meteoro
	RET

; **********************************************************************
; Processo
;
; MISSIL - Processo que deteta quando se carrega na tecla 1 e 
;			faz disparar o missil
;		
;		
;		R1 - linha do missil
;		R2 - coluna do missil
;		R4 - endereço da tabelo do missil
;		R8 - alcance do missil
;		
; **********************************************************************

PROCESS SP_inicial_missil	; indicação de que a rotina que se segue é um processo,
							; com indicação do valor para inicializar o SP	

missil:
	MOV 	R9, [estado_jogo]		; poe em R9 o estado do jogo e vai comparando
	CMP		R9, 1
	JZ 		game_over_missil		; se o jogo tiver acabado por ficar sem energia
	CMP		R9, 2
	JZ		game_over_missil		; se o jogo acabar por ter colidido com uma nave
	CMP		R9, 3
	JZ 		pausa_missil			; se o jogo tiver pausado
	MOV R10, 0
	MOV [missil_lancado], R10	; inicializar missil lançado a 0
	MOV R0, [tecla_carregada] 
	CMP R0, TECLA_1				; checar se tecla foi carregada
	JNZ missil

	; actualizar valores de MISSIL DISPARADO para nao afetar as colunas
	; do colisao missil, pois DEF_MISSIL tem as colunas alteradas pelo Rover

	MOV R7, 0			; move para R7 o numero do som que vai ser tocado (disparo)
	MOV [PLAY], R7		; toca o som do disparo
	
	MOV R6, DEF_MISSIL_DISPARO ; R6 tem endereço missil apos disparo
	MOV R8, ALCANCE_MISSIL	; alcance do missil (12 interrupçoes) 
	MOV R4, DEF_MISSIL		; R4 tem endereço da tabela do Missil

	MOV R1, LINHA_MISSIL	; linha onde o missil se encontra inicialmente (reinicializar linha)

	MOV [R4], R1
	MOV [R6], R1			; actualizar linha missil disparo 
				

	ADD R4, 2				; proxima WORD (+2 bytes) para encontrar coluna do missil
	ADD R6, 2

	MOV R2, [R4]			; coluna atual do missil
	MOV [R6], R2			; coluna actual do missil disparo 

	MOV R4, DEF_MISSIL_DISPARO	; Actualizar R4 com novo endereço missil disparo
	
	MOV [missil_lancado], R0	; ativar WORD para processo colisao

	MOV R6, [linha_meteoros]	; ver qual a linha dos meteoros quando missil e 
								; disparado
	

ciclo_missil:

	MOV  R3, PIXEL_MISSIL
	CALL escreve_pixel				; desenha o missil
	MOV  R5, [evento_int_missil]
	MOV R3, 0						; poe pixel do missil a 0
	CALL escreve_pixel				; apaga o missil
	SUB  R1, 1
	MOV  [R4], R1					; actualiza valor corrente da linha do missil

	MOV R9, R6
	CMP R1, R9						; ve se linha do missil e igual a linha dos meteoros
	JLE  reiniciliza_linha_missil

	ADD R6, 1						; atualizar linha dos meteoros

	SUB R8, 1						; subtrai 1 ao alcance do missil
	CMP R8,0						; ve se chegou a 0
	JNZ ciclo_missil

reiniciliza_linha_missil:
	MOV R1, LINHA_MISSIL	
	MOV [R4], R1 					; reinicializar linha do missil
	JMP missil

game_over_missil:			; para o processo no caso de o jogador perder
	MOV R0, [game_over]
	MOV R10, 0
	JMP	missil

pausa_missil:				; pausa o processo
	CALL escreve_pixel
	MOV R0, [jogo_pausado]
	JMP missil

; **********************************************************************
; PROCESSO
;
; COLISAO_MISSIL - deteta a colisao do missil com um meteoro bom ou mau
;
;
; VARIAVEIS - 
;				R1 - Linha do missil
;				R2 - Coluna do missil
;				R4 - endereço da tabela do missil

; **********************************************************************

PROCESS SP_inicial_colisao_missil       ; indicação de que a rotina que se segue é um processo,
										; com indicação do valor para inicializar o SP

	

colisao_missil:
	MOV 	R9, [estado_jogo]			; poe em R9 o estado do jogo e vai comparando
	CMP		R9, 1
	JZ 		game_over_colisao_missil	; se o jogo tiver acabado por ficar sem energia
	CMP		R9, 2
	JZ		game_over_colisao_missil	; se o jogo acabar por ter colidido com uma nave
	CMP		R9, 3
	JZ 		pausa_colisao_missil		; se o jogo tiver pausado
	MOV R0, [missil_lancado]
	CMP R0, 1					; se missil ja foi lançado checar colisoes
	JZ  inicio_colisao
	YIELD
	JMP colisao_missil 
	
inicio_colisao:
	MOV	R6, [linha_meteoros]	; escreve o valor da linha dos meteoros
	ADD R6, 7					; parte da frente do meteoro
	MOV R4, DEF_MISSIL_DISPARO			; escreve o endereço da tabela do missil
	MOV R1, [R4]				; guarda a linha actual do missil
	ADD R4, 2					; avança para a WORD seguinte
	MOV R2, [R4]				; guarda a coluna actual do missil
	CMP R6, R1					; compara linha do missil com a linha dos meteoros
	JGE  inicializa_metereo_missil			; se e menor ou iguais, ir a procura da coluna
	JMP colisao_missil			; se nao, espera ate ser 


inicializa_metereo_missil:

	MOV	R11, DEF_FINAL_METEOROS		; inicializa o R11 sob a forma de um apontador para o final da tabela de meteoros
	ADD	R11, -2				; colocar o ponteiro no final da tabela
	MOV R7, 7				; unmero de mteoros a checar se ha colisao 

procura_coluna: 

	MOV	R10, [R11]			; coloca a coluna do meteoro no registo 10
	MOV R5, 5				; contador de colunas no meteoro, 5 porque é o tamanho maximo

ciclo_colisao_missil:
	CMP	R2, R10				; compara a coluna do meteoro com a coluna do missil
	JZ ha_colisao			; vai a procura de que tipo de meteoro
	SUB R5, 1				; diminui contador de colunas do meteoro
	ADD R10, 1				; tenta coluna ao lado
	CMP R5, 0				; chegamos ao fim do meteoro
	JNZ  ciclo_colisao_missil ; nao, vamos tentar outra vez no mesmo meteoro, coluna ao lado
	ADD	R11, -6				; vai para a proxima memoria de uma coluna de um meteoro

	SUB R7, 1				; ver proximo meteoro
	CMP R7, 0
	JZ  colisao_missil		; nao houve colisao 

	JMP	procura_coluna			; e volta a checkar os seus valores


ha_colisao:
	MOV R2, [R11]			; poe o valor inicial da coluna do meteoro - 
							;para usar em apaga_boneco
	SUB	R11, 2				; proxima memoria meteoro bom ou mau
	MOV	R10, [R11]			; move o valor do meteoro
	CMP	R10, 1				; pergunta se e bom
	JZ	bom_meteoro_missil			; se sim define como meteoro bom
	JMP	mau_meteoro_missil			; se n define como nave inimiga (mau meteoro)


bom_meteoro_missil:					; este parte escolhe qual e o desenho de meteoro a escolher
	MOV	R7, 14				
	CMP	R1, R7						; compara o valor da linha do meteoro com 
									;respectivo meteoro de cada linha
	JGE	bom_meteoro_missil_14		; e manda para o desenho especifico
	MOV	R7, 9
	CMP	R1, R7
	JGE	bom_meteoro_missil_9
	CMP	R1, 5
	JGE	bom_meteoro_missil_5
	CMP	R1, 2
	JGE	bom_meteoro_missil_2
	CMP	R1, 1
	JGE	bom_meteoro_missil_1


bom_meteoro_missil_1:
	MOV	R4, DEF_METEORO			; define o meteoro com o desenho especifico
	JMP	apaga_meteoro_missil		; volta ao processo de o desenhar

bom_meteoro_missil_2:
	MOV	R4, DEF_METEORO2
	JMP	apaga_meteoro_missil

bom_meteoro_missil_5:
	MOV	R4, DEF_METEORO5
	JMP	apaga_meteoro_missil

bom_meteoro_missil_9:
	MOV	R4, DEF_METEORO9
	JMP	apaga_meteoro_missil
	
bom_meteoro_missil_14:
	MOV	R4, DEF_METEORO14
	JMP	apaga_meteoro_missil


mau_meteoro_missil:					; este parte escolhe qual e o desenho de meteoro a escolher
	MOV	R7, 14
	CMP	R1, R7				; compara o valor da linha
	JGE	mau_meteoro_missil_14			; e manda para o desenho especifico
	MOV	R7, 9
	CMP	R1, R7
	JGE	mau_meteoro_missil_9
	CMP	R1, 5
	JGE	mau_meteoro_missil_5
	CMP	R1, 2
	JGE	mau_meteoro_missil_2
	CMP	R1, 1
	JGE	mau_meteoro_missil_1

mau_meteoro_missil_1:
	MOV	R4, DEF_METEORO				; define o meteoro com o desenho especifico
	JMP	apaga_meteoro_missil		; volta ao processo de o desenhar

mau_meteoro_missil_2:
	MOV	R4, DEF_METEORO2
	JMP	apaga_meteoro_missil

mau_meteoro_missil_5:
	MOV	R4, DEF_NAVE5
	JMP	apaga_meteoro_missil

mau_meteoro_missil_9:
	MOV	R4, DEF_NAVE9
	JMP	apaga_meteoro_missil
	
mau_meteoro_missil_14:
	MOV	R4, DEF_NAVE14
	JMP	apaga_meteoro_missil

apaga_meteoro_missil:
	MOV R1, [linha_meteoros]
	CALL apaga_boneco

	SUB R11, 2				; volta endereço de memoria que diz se meteoro
							; existe ou nao - para ser desenhado
	MOV R7, 0
	MOV [R11], R7			; muda memoria para meteoro nao existe

	MOV R4, DEF_EXPLOSAO	; cria explosao 
	CALL desenha_boneco

	MOV 	R7, [evento_int_meteoro]	; pausa para efeito explosao

	CALL apaga_boneco		; apaga explosao

	MOV R7, 0
	MOV [missil_lancado], R7	; por missil lannçado a 0
	
	JMP colisao_missil

game_over_colisao_missil:
	MOV R3, [game_over]
	MOV R0, 0
	JMP colisao_missil

pausa_colisao_missil:
	MOV R3, [jogo_pausado]
	JMP colisao_missil

; **********************************************************************
; Processo
;
; COLISOES - Processo que checka as colisoes entre os meteoros e o Rover
;
;		R8 - coluna do rover
;		R9 - temporario
;		R10 - Valor da linha dos meteoros
;		R11 - endereço da tabela que define os meteoros
;
; **********************************************************************

PROCESS SP_inicial_colisoes			; indicação de que a rotina que se segue é um processo


colisoes:
	YIELD
	MOV	R10, [linha_meteoros]	; escreve o valor da linha dos meteoros
	MOV	R3, R10			; memoriza o valor da linha dos meteoros
	MOV	R9, LINHA_ANCORA_ROVER	; escreve o valor da linha do rover
	ADD	R10, 5			; R10 vira a altura do meteoro em baixo
	CMP	R10, R9			; compara esse valor com o altura do rover 
	JGE	checka_colunas		; se for igual ou superior entao vamos descobrir em que meteoro esta
	JMP	colisoes		; se n fica a espera de ser

checka_colunas:
	MOV	R11, DEF_FINAL_METEOROS		; inicializa o R11 sob a forma de um apontador para o final da tabela de meteoros
	ADD	R11, -2				; colocar o ponteiro no final da tabela
	
	MOV	R8, [coluna_rover]		; coloca o registo 8 como a coluna do rover
	MOV	R5, R8				; guarda o valor inicial
	ADD	R8, 4				; adiciona 4 para estar na ultima coluna do rover (checkar as colisoes pela parte direita do rover)
checka_coluna:
	MOV	R10, [R11]			; coloca a coluna do meteoro no registo 10
	CMP	R8, R10				; compara se a distancia e inferior a 5
	JGE	colisao_meteoro			; faz as acoes necessarias para quando atinge um meteoro
	ADD	R11, -6				; vai para a proxima memoria de uma coluna de um meteoro
	JMP	checka_coluna			; e volta a checkar os seus valores

colisao_meteoro:
	MOV	R2, [R11]			; guarda a coluna do meteoro
	ADD	R11, -2				; coloca a memoria na qualidade do meteoro (se e bom ou mau)
	MOV	R10, [R11]			; coloca em R10 o valor que representa a qualidade do meteoro
	CMP	R10, 0				; compara o valor para saber se o meteoro e mau
	JZ	colisoes_morte			; e se for salta para o fim do jogo
	ADD	R11, -2				; se nao vamos ver se o meteoro existe
	MOV	R10, [R11]			; coloca o R10 com o valor que representa a existencia do meteoro
	CMP	R10, 0				; se o meteoro n existe 
	JZ	colisoes_esquerda		; checka a colisao a esquerda
						; se existir aumenta a energia e coloca a existencia do meteoro a 0
	MOV	R10, [energia_rover]		; coloca no R10 o valor da energia
	ADD R10, 5H				; adiciona 10 de energia
	ADD R10, 5H				; ...
	MOV	[energia_rover], R10		; volta a colocar o valor la
	MOV  	R0, DISPLAYS       		; endereço do periférico que liga aos displays
	MOV	R1, R10				; coloca o valor no R1 para a rotina de conversao
	CALL	converte_Hex_Decimal		; converte R1 em Decimal para R5
	MOV	[R0], R5			; mostra no display o aumento
	MOV	R10, 0				; coloca r10 com 0 para inserir na tabela de meteoros
	MOV	[R11], R10			; ...
	MOV	R1, R3				; define a linha do meteoro a apagar
	MOV	R4, DEF_METEORO14		; 
	CALL	apaga_boneco			; apaga o meteoro

	JMP	colisoes_esquerda		; checka a colisao a esquerda do rover

colisoes_esquerda:
	CMP	R5, R8				; compara se o r8 com que veio e o inicila significando que ja checko a parte da direita e da esquerda
	JZ	colisoes			; se sim volta a esperar por colisoes verticais
	ADD	R8, -4				; volta para a esquerda do rover
	ADD	R11, -2				; vai para a coluna do meteoro anterior
	MOV	R10, [R11]			; coloca no R10
	SUB	R10, R8				; pergunta se estao a uma distancia de 5 ou menos
	CMP	R10, -5				; ...
	JGE	colisao_meteoro		; se sim checka as coisas outra vez
	JMP	colisoes			; se n voltamos a esperar por colisoes

colisoes_morte:
	ADD	R11, -2				; vai para a memoria que checka se o meteoro existe
	MOV	R10, [R11]			; receb o valor
	CMP	R10, 0				; compara para saber se n existe
	JZ	colisoes			; e se n existir continua
						; otherwise termina o jogo
	MOV R4, 2
	MOV [estado_jogo], R4
	JMP	colisoes

; **********************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
;			Faz simplesmente uma escrita no LOCK que o processo meteoro lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************

rot_int_0:
	PUSH R2
	MOV R2, evento_int_meteoro
	MOV [R2], R1
	POP R2
	RFE

; **********************************************************************
; ROT_INT_1 - 	Rotina de atendimento da interrupção 1
;			Faz simplesmente uma escrita no LOCK que o processo meteoro lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************

rot_int_1:
	PUSH R2
	MOV R2, evento_int_missil
	MOV [R2], R1
	POP R2
	RFE

; **********************************************************************
; ROT_INT_2 - 	Rotina de atendimento da interrupção 2
;			Faz simplesmente uma escrita no LOCK que o processo display lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************
rot_int_2:
	PUSH R1
	MOV  R1, evento_int_display
	MOV	[R1], R0	; desbloqueia processo display (qualquer registo serve)
	POP	R1
	RFE

; **********************************************************************
; Processo
;
; ACABA_JOGO - Processo que verifica as condições de final de jogo
;
;		R1 - energia do rover
;		R2, R3, R4, R8, R9 - temporarios
; **********************************************************************

PROCESS SP_inicial_end
	
	MOV R9, 1	
acaba_jogo:
	YIELD
	MOV R1, [verifica_energia]		; move para R1 a energia atual do rover	
	CMP R1, 0						; compara com 0
	JZ  perdeu_jogo_energia			; se for 0 perdeu o jogo
	
	MOV R2, [estado_jogo]	; move para R2 o estado do jogo
	CMP R2, 2						; compara com 2
	JZ  perdeu_jogo_colisao			; se o estado for 2, perdeu por colisao com uma nave inimiga
		
	CMP R2, 3						; compara com 3
	JZ esta_pausado					; se o estado do jogo for 3, o jogo esta pausado

	JMP acaba_jogo					; se o estado nao coincidir com nenhum destes, volta a testar

esta_pausado:
	YIELD
	MOV R4, 0						; poe em R4 o estado de jogo 0
	MOV R3, [estado_jogo]			; poe em R3 o estado atual do jogo
	CMP R3, R4						; compara os dois
	JZ  acaba_jogo					; se o estado for 0, o jogo saiu da pausa e volta a testar o estado do jogo
	JMP esta_pausado				; se nao, espera ate ja nao estar pausado

perdeu_jogo_colisao:
	MOV R9, 1							; move para R9 o numero do som de game over
	MOV [PLAY], R9						; toca o som de game over
	ADD R9, 1							; passa R9 a 2
	MOV [SELECIONA_CENARIO_FUNDO], R9	; seleciona o ecra de fundo 2 (ecra de game over por colisao)
	JMP espera_tecla_c					; salto incondicional para espera_tecla_c

perdeu_jogo_energia:
	MOV R9, 1							; move para R9 o numero do som de game over
	MOV [PLAY], R9						; toca o som de game over
	MOV [SELECIONA_CENARIO_FUNDO], R9	; seleciona o ecra de fundo 1 (ecra de game over por ficar sem energia)
										; passa para espera_tecla_c
	
espera_tecla_c:
	YIELD
	MOV	[APAGA_ECRÃ], R9				; apaga o ecra inteiro
	MOV R9, [tecla_carregada]			; espera por um clique numa tecla
	MOV R8, TECLA_C						; move para R8 a tecla C
	CMP R9, R8							; compara a tecla premida com a tecla C
	JZ  recomeca						; se for premida a tecla C, vai recomeçar o jogo
	JMP espera_tecla_c					; se nao continua a espera da tecla C

recomeca:

	MOV R4, DEF_MISSIL
	MOV R1, LINHA_MISSIL
	MOV [R4], R1			; inicializar a linha do missil
	ADD R4, 2
	MOV R2, COLUNA_MISSIL
	MOV [R4], R2			; inicializar a coluna do missil onde o rover se encontra
	

	MOV R9, 0							; move para R9 o estado do jogo correto
	MOV [estado_jogo], R9		; poe na memoria o estado do jogo
	MOV [SELECIONA_CENARIO_FUNDO], R9	; seleciona o ecra de fundo 0 (ecra de fundo do jogo)
	MOV [game_over], R9					; desbloqueia todos os processos que estavam bloqueados em game_over
	JMP acaba_jogo						; vai voltar a testar as condiçoes do estado do jogo
