;   GRUPO 55
;   107041- André Antunes Santos
;   107052 - Tomás Maria Agostinho Bernardino
;   88571 - Artur Miguel e Gaio Lopes dos Santos Pinto


; COMANDOS:
; 0 - Dispara a sonda da esquerda
; 1 - Dispara a sonda do meio
; 2 - Dispara a sonda da direita
; A - Ativa/Desativa o score (desligado por default)
; C - Começa o jogo
; D - Pausa o jogo
; E - Terminar o jogo
; F - Muta/Desmuta o som do jogo


; *********************************************************************************
; * Constantes
; *********************************************************************************
DISPLAYS		    EQU 0A000H	; endereço do periférico que liga aos displays
TEC_LIN				EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL				EQU 0E000H	; endereço das colunas do teclado (periférico PIN ao qual vão ser acedidos os bits de 0 a 3)
PIN                 EQU 0E000H  ; endereço do periférico PIN ao qual vão ser acedidos os bits de 4 a 7
LINHA_TECLADO	    EQU 0010H	; linha a testar 1 bit a esquerda da linha maxima (8b)
MASCARA				EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
MASCARA_2_BITS      EQU 03H     ; para isolar os 2 bits de menor peso
MASCARA_MAIS_SIGNIFICATIVOS           EQU 0F0H    ; para isolar os 4 bits de maior peso
FATOR               EQU 1000    ; fator da divisao para a conversão de hexadecimal para decimal

; * Constantes - Comandos MEDIACENTER
COMANDOS				    EQU	6000H			; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    			EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   			EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    			EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     			EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 				EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  	EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
SELECIONA_CENARIO_FRONTAL   EQU COMANDOS + 46H		; endereço do comando para selecionar uma imagem frontal
TOCA_SOM					EQU COMANDOS + 5AH		; endereço do comando para tocar um som
APAGA_CENARIO_FRONTAL       EQU COMANDOS + 44H      ; endereço do comando para apagar o cenário frontal
SELECIONA_ECRA_PIXEIS       EQU COMANDOS + 04H      ; endereço do comando para selecionar o ecrã de pixeis
TOCA_SOM_LOOP               EQU COMANDOS + 5CH      ; endereço do comando para tocar um som em loop
PAUSA_SOM_LOOP              EQU COMANDOS + 5EH      ; endereço do comando para pausar a reproducao de um som
CONTINUA_SOM_LOOP           EQU COMANDOS + 60H      ; endereço do comando para continuar a tocar um som
TERMINA_SOM_LOOP            EQU COMANDOS + 66H      ; endereço do comando para terminar de tocar um som
TERMINA_TODOS_SONS          EQU COMANDOS + 68H      ; endereço do comando para terminar todos os sons que estejam a tocar
APAGA_UM_ECRA               EQU COMANDOS + 00H      ; endereço do comando para apagar um ecrã
MUTA_SONS                   EQU COMANDOS + 50H      ; endereço do comando para colocar o volume a 0
VOLUME_SONS                 EQU COMANDOS + 52H     ; endereço do comando para retomar o volume dos sons que estao a tocar

; * Constantes - posição
LINHA_ASTEROIDE         EQU  0      ; 1ª linha do asteroide 
COLUNA_ASTEROIDE_MEIO   EQU  30     ; coluna onde começar a desenhar para o asteroide ficar centralizado
LINHA_NAVE              EQU  27     ; 1ª linha da nave 
COLUNA_NAVE             EQU  25     ; 1ª coluna da nave 
LINHA_SONDA             EQU  26     ; 1ª linha das sondas 
COLUNA_SONDA_MEIO       EQU  32     ; 1ª coluna da sonda do meio
COLUNA_SONDA_ESQ        EQU  26     ; 1ª coluna da sonda da esquerda
COLUNA_SONDA_DIR        EQU  37     ; 1ª coluna da sonda da direita
LINHA_PAINEL			EQU  29
COLUNA_PAINEL			EQU  29

MIN_COLUNA		        EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA		        EQU  63     ; número da coluna mais à direita que o objeto pode ocupar
MAX_LINHA               EQU  31     ; maior valor de linha dentro do ecrã visível
MAX_COLUNA_ASTEROIDE    EQU  59     ; numero da coluna mais à direita que permite desenhar um asteroide completo
PROXIMO_ASTEROIDE       EQU  2      ; valor que é preciso adicionar à tabela de controlo de asteroides para 
                                    ; obter a tabela do próximo asteroide

; * Dimensões dos bonecos

LARGURA_ASTEROIDE		EQU	5
ALTURA			        EQU	5		; altura do asteroide e da nave
LARGURA_NAVE            EQU 15
LARGURA_PAINEL_NAVE		EQU 7
ALTURA_PAINEL_NAVE		EQU 2	
ALTURA_LARGURA_3x3      EQU 3
;*Constantes - movimento
ATRASO			EQU	0005H		; (inicialmente a 400) atraso para limitar a velocidade de movimento do asteroide/nave
ALCANCE_SONDA   EQU 000CH 		; alcance maximo da sonda


;*Constantes - movimento
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
BRANCO        EQU 0FFFFH ; cor do pixel: branco em ARGB, todas as componentes no máximo

; * Constantes - teclado/display

TECLA_JOGO_COMECA         EQU 000CH    ; tecla que começa o jogo
TECLA_JOGO_PAUSA          EQU 000DH    ; tecla que pausa o jogo
TECLA_JOGO_TERMINA        EQU 000EH    ; tecla que termina o jogo
TECLA_DISPARO_FRENTE      EQU 0001H    ; tecla que dispara para a frente
TECLA_DISPARO_ESQUERDA    EQU 0000H    ; tecla que dispara para a esquerda
TECLA_DISPARO_DIREITA     EQU 0002H    ; tecla que dispara para a direita
TECLA_MUTED               EQU 000FH    ; tecla que muda o estado do som
TECLA_SCORES              EQU 000BH    ; tecla que faz mostrar os scores no fim do jogo

JOGO                      EQU 0    ; estado do jogo: jogo
SEM_ENERGIA               EQU 1    ; estado do jogo: perdeu sem energia
COLISAO                   EQU 2    ; estado do jogo: perdeu por colisão
PAUSA                     EQU 3    ; estado do jogo: pausa
TERMINADO                 EQU 4    ; estado do jogo: terminado

VALOR_INICIAL_DISPLAY_HEX EQU 0064H   ; valor inicial do display (64 EM HEXADECIMAL)
VALOR_INICIAL_DISPLAY     EQU 0100H   ; valor inicial do display (100 EM DECIMAL)
MIN_VALOR_DISPLAY         EQU 0000H   ; valor minimo do display
MAX_VALOR_DISPLAY         EQU 03E7H   ; valor maximo do display

DIMINUI_ENERGIA_INT       EQU 0003H   ; valor que diminui a energia devido a interrupcao
AUMENTA_ENERGIA           EQU 0019H   ; valor que aumenta a energia devido a uma asteroide mineravel
DIMINUI_ENERGIA_SONDA     EQU 0005H   ; valor que diminui a energia devido a sonda

DISPLAY_ENERGIA_INT       EQU 0       ; indica ao processo display que a energia diminui devido a interrupcao
DISPLAY_AUMENTA_ENERGIA   EQU 1       ; indica ao processo display que a energia aumenta
DISPLAY_ENERGIA_SONDA     EQU 2       ; indica ao processo display que a energia diminui devido a sonda

MOVIMENTACAO_SONDAS       EQU 4        ; valor que indica que ao processo que deve mover as sondas

DESATIVA_SCORE            EQU 0        ; valor que indica que o score nao deve ser atualizado
ATIVA_SCORE               EQU 1        ; valor que indica que o score deve ser atualizado

; * Constantes - MEDIA CENTER - SONS/IMAGENS
SOM_INICIO              EQU 0
SOM_DISPARO             EQU 1
SOM_ASTEROIDEDESTRUIDO  EQU 2
SOM_UNPAUSE             EQU 3
SOM_PAUSE               EQU 4
SOM_COLISAOFIM          EQU 5
SOM_SEMENERGIA          EQU 6
SOM_TERMINADO           EQU 7
SOM_JOGO                EQU 8
SOM_ASTEROIDEMINERAVEL  EQU 9

PLAYING                 EQU 3   ; estado do som: a tocar

IMAGEM_INICIO           EQU 0
IMAGEM_JOGO             EQU 1
IMAGEM_PAUSE            EQU 2
IMAGEM_TERMINADO        EQU 3
IMAGEM_SEMENERGIA       EQU 4
IMAGEM_COLISAO          EQU 5

ECRA_PIXEIS_SONDA_NAVE  EQU 4


; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H

; * Reserva do espaço das pilhas dos diferentes processos

	STACK 100H			; espaço reservado para a pilha (200H bytes, pois são 100H words)
SP_inicial:				; este é o endereço (1200H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 11FEH (1200H-2)

	STACK 100H			; 100H bytes reservados para a pilha do processo "painel_nave"
SP_painel_nave:			; endereço inicial da pilha

    STACK 100H			; espaço reservado para a pilha do processo teclado
SP_teclado:

    STACK 100H		     ; espaço reservado para a pilha do processo DISPLAY
SP_display:    

    STACK 100H          ; 100H bytes reservados para a pilha do processo "spawn_asteroide"
SP_asteroide:           ; endereço inicial da pilha

    STACK 100H          ; 100H bytes reservados para a pilha do processo pause
SP_pause:

    STACK 100H          ; 100H bytes reservados para a pilha do processo gameover
SP_game_over:

    STACK 100H          ; 100H bytes reservados para a pilha do processo sonda
SP_sonda:


    STACK 100H
SP_colisoes:

    STACK 10H           ; 10H bytes reservados para a pilha do processo som, este processo e muito simples
SP_handle_som_score:    ; pelo que nao necessita de muita memoria para a pilha




; LOCKS dos diferentes processos e rotinas

LOCK_tecla_carregada:
	LOCK 0				; LOCK para o teclado comunicar aos restantes processos que tecla detetou,
						; uma vez por cada tecla carregada
							
LOCK_jogo_pausado:      ; LOCK para comunicar aos processos que o jogo está em pausa
    LOCK 0               


int_energia_display:    ; LOCK para bloquear o processo DISPLAY e comunicar qual a alteração a fazer 
    LOCK 0              ; se o LOCK estiver a 0, a energia diminui (RELOGIO DE INTERRUPCAO)
                        ; se o LOCK estiver a 1, a energia aumenta (ASTEROIDE MINERAVEL)
                        ; se o LOCK estiver a 2, a energia diminui (SONDA)

int_asteroide:          ; LOCK para controlar o processo de movimentacao dos asteroides
    LOCK 0

LOCK_game_over:         ; LOCK para comunicar aos processos que o jogo terminou
    LOCK 0

int_painel_nave:
	LOCK 0			    ; LOCK para controlar o processo da mudança de cor do painel de controlo da nave

int_movimenta_gera_sonda:
    LOCK 0              ; controla o processo de movimentação e geração da sonda
                        ; se o LOCK estiver a 0,1,2 dispara uma sonda na posição correspondente
                        ; 0 - esquerda; 1 - frente; 2 - direita
                        ; se estiver a 4 movimenta as sondas disparadas

LOCK_colisoes:
    LOCK 0              ; LOCK para chamar o processo que verifica se ocorreu colisão sempre que haja possibilidade de tal ocorrer

;colisao_sonda_asteroide:          ; controla o processo da testagem de possíveis colisões
;    LOCK 0


score:
    WORD 0              ; WORD para o score do jogo
    WORD 0              ; WORD para verificar se é suposto mostrar o score ou nao (0 - nao mostrar, 1 - mostrar)

display_HEX:
    WORD 0064H          ; WORD para o valor do display em hexadecimal

estado_jogo:
	WORD 0				; WORD para o estado do jogo (0 - em jogo, 1 - perdeu sem energia, 
                        ; 2 - perdeu por colisão, 3 - em pausa)

tecla:
    WORD 0              ; WORD para a tecla carregada, o valor e o mesmo do LOCK_tecla_carregada, 
                        ; mas nao bloqueia os processo onde e lida

mute:
    WORD 0              ; WORD para o mute do som (0 - som ligado, 1 - som desligado)

; Tabela das rotinas de interrupção
tabela_rot_int:
	WORD rot_int_0      ; rotina de atendimento da interrupção 0 (asteroides)
	WORD rot_int_1      ; rotina de atendimento da interrupção 1 (sondas)
	WORD rot_int_2      ; rotina de atendimento da interrupção 2 (energia)
	WORD rot_int_3		; rotina de atendimento da interrupção 3 (painel nave)

; * Tabelas dos objetos
	
DEF_ASTEROIDE_N_MINERAVEL:			; tabela que define o asteroide não minerável (largura, altura, pixels e sua cor)
	WORD		 LARGURA_ASTEROIDE
    WORD        ALTURA
	WORD		VERMELHO , 0 , VERMELHO , 0 , VERMELHO 		
    WORD		0 , VERMELHO , LARANJA , VERMELHO , 0
    WORD        VERMELHO , LARANJA , 0 , LARANJA , VERMELHO 
    WORD		0 , VERMELHO , LARANJA , VERMELHO , 0
	WORD		VERMELHO , 0 , VERMELHO , 0 , VERMELHO 
  

DEF_ASTEROIDE_MINERAVEL:			; tabela que define o asteroide minerável 
	WORD		LARGURA_ASTEROIDE
    WORD        ALTURA
	WORD		0 , VERDE , VERDE , VERDE , 0		
    WORD		VERDE , VERDE , VERDE , VERDE , VERDE 
    WORD        VERDE , VERDE , AMARELO , VERDE , VERDE 
    WORD		VERDE , VERDE , VERDE , VERDE , VERDE 
	WORD		0 , VERDE , VERDE , VERDE , 0	

DEF_ASTEROIDE_MINERAVEL_3x3:            ; tabela que define o asteroide minerável na primeira iteração do seu desparecimento
    WORD		ALTURA_LARGURA_3x3      ; largura
    WORD        ALTURA_LARGURA_3x3      ; altura
    WORD		VERDE , VERDE , VERDE 
    WORD        VERDE , AMARELO , VERDE 
    WORD		VERDE , VERDE , VERDE 



DEF_EXPLOSAO_ASTEROIDE:			    ; tabela que define o asteroide quando explode 
	WORD		LARGURA_ASTEROIDE
    WORD        ALTURA
	WORD		0 , AZUL_CIANO , 0 , AZUL_CIANO , 0		
    WORD		AZUL_CIANO , 0, AZUL_CIANO , 0, AZUL_CIANO 
    WORD        0 , AZUL_CIANO , 0 , AZUL_CIANO , 0
    WORD		AZUL_CIANO , 0, AZUL_CIANO , 0, AZUL_CIANO 
	WORD		0 , AZUL_CIANO , 0 , AZUL_CIANO , 0	

DEF_NAVE:					         ; tabela que define a nave
  	WORD    LARGURA_NAVE
  	WORD    ALTURA
  	WORD    0, 0, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, VERMELHO, 0, 0
  	WORD    0, VERMELHO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, VERMELHO, 0
  	WORD    VERMELHO, PRETO, PRETO, PRETO, CINZENTO, LARANJA, AZUL_CIANO, VERMELHO, AZUL_CIANO, VERDE, CINZENTO, PRETO, PRETO, PRETO, VERMELHO
  	WORD    VERMELHO, PRETO, BRANCO, PRETO, VERDE, CINZENTO, VERMELHO, CINZENTO, LARANJA, CINZENTO, AZUL_CIANO, PRETO, BRANCO, PRETO, VERMELHO
  	WORD    VERMELHO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, VERMELHO


DEF_SONDA:					          ; tabela que define a sonda (apenas um pixel)
  	WORD    ROSA


tabela_cores:				          ; Tabela que define as cores possíveis para o painel de controlo					
	WORD 	CINZENTO		
	WORD 	VERDE
	WORD 	AMARELO
	WORD 	AZUL_CIANO
	WORD	VERMELHO


; * tabelas das posições dos asteroides
posicao_asteroide_0:

    WORD 0          ; variável que guarda a linha do asteroide no momento
    WORD 0          ; variável que guarda a coluna do asteroide no momento


posicao_asteroide_2:

    WORD 0          ; variável que guarda a linha do asteroide no momento
    WORD 0          ; variável que guarda a coluna do asteroide no momento

posicao_asteroide_4:

    WORD 0          ; variável que guarda a linha do asteroide no momento
    WORD 0          ; variável que guarda a coluna do asteroide no momento

posicao_asteroide_6:

    WORD 0          ; variável que guarda a linha do asteroide no momento
    WORD 0          ; variável que guarda a coluna do asteroide no momento


; * tabelas de controlo de cada asteroide 
; têm nomes com números pares para cada um dos seus números poder corresponder a um 
; incremento de 0 ou mais WORDS na tabela de controlo geral dos asteroides.
; a descrição da primeira tabela aplica-se às restantes
controlo_asteroide_0:
    WORD 0                  ; estado do asteroide: asteroide explodido (2), existe asteroide (1) 
                            ; ou não (0), ou se é para apagar o asteroide (-1) 
    WORD posicao_asteroide_0    ; posição do 1º asteroide (asteroide_0)
    WORD 0                  ; tipo de tabela do asteroide (irá depois ser alterada para minerável ou não) 
    WORD 0                  ; indica qual a tabela de posição incial/incremento foi atribuída ao asteroide 
    WORD 0                  ; indica o ecra de pixeis onde o asteroide se encontra
    WORD 0                  ; indica em que estado de desaparecimento está no caso de ser minerável
                            ; gama de valores: 0->tamanho=5x5, 1->tamanho=3x3, 2->tamanho=1x1, 3-> apagado 


controlo_asteroide_2:
    WORD 0                  
    WORD posicao_asteroide_2
    WORD 0
    WORD 0                  
    WORD 1
    WORD 0


controlo_asteroide_4:
    WORD 0                  
    WORD posicao_asteroide_4
    WORD 0
    WORD 0      
    WORD 2                   
    WORD 0

controlo_asteroide_6:
    WORD 0                  
    WORD posicao_asteroide_6
    WORD 0
    WORD 0
    WORD 3
    WORD 0

; * tabela de controlo de todos os asteroides
controlo_asteroides:        
    WORD controlo_asteroide_0
    WORD controlo_asteroide_2
    WORD controlo_asteroide_4
    WORD controlo_asteroide_6


; * tabela de controlo dos movimentos das sondas
sonda_esquerda: 
    WORD 0                  ; ALCANCE
    WORD LINHA_SONDA        ; LINHA DA SONDA NO MOMENTO (INICIALIZA NA LINHA_SONDA)
    WORD COLUNA_SONDA_ESQ   ; COLUNA DA SONDA NO MOMENTO (INICIALIZA NA COLUNA_SONDA_ESQ)
    WORD -1                 ; DECREMENTO/INCREMENTO DA COLUNA
    WORD 0                  ; ESTADO DA SONDA (0 - NÃO EXISTE, 1 - EXISTE; -1 - APAGAR)
    WORD COLUNA_SONDA_ESQ   ; GUARDA A COLUNA INICIAL (IRÁ SER NECESSÁRIO PARA REINICIAR A COLUNA DA SONDA)

sonda_frente:
    WORD 0                  ; ALCANCE
    WORD LINHA_SONDA        ; LINHA DA SONDA NO MOMENTO 
    WORD COLUNA_SONDA_MEIO  ; COLUNA DA SONDA NO MOMENTO 
    WORD 0                  ; DECREMENTO/INCREMENTO DA COLUNA
    WORD 0                  ; ESTADO DA SONDA (0 - NÃO EXISTE, 1 - EXISTE; -1 - APAGAR)
    WORD COLUNA_SONDA_MEIO  ; GUARDA A COLUNA INICIAL

sonda_direita:
    WORD 0                  ; ALCANCE
    WORD LINHA_SONDA        ; LINHA DA SONDA NO MOMENTO
    WORD COLUNA_SONDA_DIR   ; COLUNA DA SONDA NO MOMENTO
    WORD 1                  ; DECREMENTO/INCREMENTO DA COLUNA
    WORD 0                  ; ESTADO DA SONDA (0 - NÃO EXISTE, 1 - EXISTE; -1 - APAGAR)
    WORD COLUNA_SONDA_DIR   ; GUARDA A COLUNA INICIAL

; * tabela de controlo de todas as sondas
controlo_sondas:
    WORD sonda_esquerda
    WORD sonda_frente
    WORD sonda_direita


; * Tabelas das 5 possíveis combinações:
; 1ª word: coluna inicial
; 2ª word: incremento /decremento da coluna para o movimento
; 3ª word: se está a ser utilizada por algum asteroide ou não (esta WORD nao é utilizada no projeto original, para a utilizar deve retirar os comentarios da linhas 1733 a 1747)

inicio_esquerda_move_direita:
    WORD    MIN_COLUNA          
    WORD    INCREMENTO 
    WORD    0

inicio_meio_move_esquerda:
    WORD    COLUNA_ASTEROIDE_MEIO
    WORD    DECREMENTO
    WORD    0

inicio_meio_move_baixo:
    WORD    COLUNA_ASTEROIDE_MEIO
    WORD    BAIXO
    WORD    0

inicio_meio_move_direita:
    WORD    COLUNA_ASTEROIDE_MEIO
    WORD    INCREMENTO
    WORD    0

inicio_direita_move_esquerda:
    WORD    MAX_COLUNA_ASTEROIDE
    WORD    DECREMENTO
    WORD    0

; Tabela que será acedida para determinar a posição do asteróide a desenhar
tabela_geral_posicao:
    WORD inicio_esquerda_move_direita    
    WORD inicio_meio_move_esquerda
    WORD inicio_meio_move_baixo
    WORD inicio_meio_move_direita
    WORD inicio_direita_move_esquerda



; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                     ; o código tem de começar em 0000H
inicio:


    MOV SP, SP_inicial		; inicializa SP para a palavra a seguir à última da pilha
    MOV BTE, tabela_rot_int ; inicializa BTE (registo de Base da Tabela de Exceções)                        
    
    MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    MOV  [APAGA_CENARIO_FRONTAL], R1 ; apaga o cenário frontal (o valor de R1 não é relevante)
    MOV	 R1, IMAGEM_INICIO			; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
    

    MOV R1, TERMINADO
    MOV [estado_jogo], R1 ; iniciamos o programa no estado terminado

    MOV R1, 0
    MOV [mute], R1            ; Inicializa o jogo com o som ligado
    MOV [VOLUME_SONS],R1      ; Inicializa o volume do som
    

    EI0                   ; ativa as interrupção dos relogios
    EI1
    EI2
    EI3
    EI

    CALL proc_teclado    ; Cria o processo teclado
   

espera_inicio_jogo:
    MOV R1, [LOCK_tecla_carregada] ; Verifica se alguma tecla foi carregada, bloqueia até a processa voltar a carregar
    MOV R2, TECLA_JOGO_COMECA
    CMP R1, R2                ; Verifica se a tecla carregado foi a de inicio de jogo (C)
    JNZ espera_inicio_jogo    ; Se não foi, volta a verificar
    CALL rot_inicia_jogo      ; Se sim, inicia o jogo


inicia:                        ; Cria os diversos processos necessários para o jogo

    CALL proc_handle_som_score ; Cria o processo que trata do som e do score do jogo
    CALL proc_display          ; Cria o processo que irá atualizar o display
    CALL proc_fim_jogo         ; Cria o processo que ira recomecar o jogo apos o mesmo terminar
    CALL proc_pause            ; Cria o processo que coloca ou tira o jogo da pausa
    CALL proc_sonda            ; Cria o processo que dispara e movimenta as sondas 
    CALL proc_asteroides       ; Cria o processo que cria e movimenta os asteroides
    CALL proc_painel_nave      ; Cria o processo que atualiza o painel da nave
    CALL proc_colisao_sonda_asteroide


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

PROCESS SP_teclado	; indicação de que a rotina que se segue é um processo,
						    ; com indicação do valor para inicializar o SP
proc_teclado:
	MOV  R2, TEC_LIN		; endereço do periférico das linhas
	MOV  R3, TEC_COL		; endereço do periférico das colunas
	MOV  R5, MASCARA		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

    loop_linha:
       	MOV R1, LINHA_TECLADO ; por linha a 0001 0000 - para testar qual das linhas foi clicada

    espera_tecla:				; neste ciclo espera-se até uma tecla ser premida
        WAIT
    					    ; este ciclo é potencialmente bloqueante, pelo que tem de
    						; ter um ponto de fuga (aqui pode comutar para outro processo)
        SHR R1, 1           ; dividir por 2 para testar as varias linhas do teclado
        JZ  loop_linha      ; se for zero recomeçar o ciclo, caso contrario testar colunas 

    	MOVB [R2], R1			; escrever no periférico de saída (linhas)
    	MOVB R0, [R3]			; ler do periférico de entrada (colunas)
    	AND  R0, R5			    ; elimina bits para além dos bits 0-3
    	CMP  R0, 0			    ; há tecla premida?
    	JZ   espera_tecla		; se nenhuma tecla premida, repete

        CALL rot_converte_numero   ; retorna R9 com a tecla premida
    
    	MOV R9, [tecla]
        MOV	[LOCK_tecla_carregada], R9	; informa quem estiver bloqueado neste LOCK que uma tecla foi carregada
    							; ( o valor escrito e a tecla carregada)

        CMP R9, TECLA_DISPARO_DIREITA
        JGT ha_tecla
        
        MOV [int_movimenta_gera_sonda], R9  ; desbloqueia o processo que gera sondas, o valor da variavel é a tecla carregada

    ha_tecla:					; neste ciclo espera-se até NENHUMA tecla estar premida

    	YIELD				    ; este ciclo é potencialmente bloqueante, pelo que tem de
    						    ; ter um ponto de fuga (aqui pode comutar para outro processo)

        MOVB [R2], R1			; escrever no periférico de saída (linhas)
    							; mantenho mesmo R1 porque esse R1 tem a linha que foi premida em cima
    							; nao preciso de ir a procura outra vez qual linha foi premida
        MOVB R0, [R3]			; ler do periférico de entrada (colunas)
    	AND  R0, R5				; elimina bits para além dos bits 0-3
        CMP  R0, 0				; há tecla premida?
        JNZ  ha_tecla			; se ainda houver uma tecla premida, espera até não haver


        JMP espera_tecla        ; esta "rotina" nunca retorna porque nunca termina
    						    ; Se se quisesse terminar o processo, era deixar o processo chegar a um RET


     


;**********************************************************************
; PROCESSO - Handle Som
;
; Coloca ou tira o volume dos sons do jogo
; A word mute indica se o som esta ligado ou nao
; Se estiver a 0, o som esta ligado, se estiver a 1, o som esta mutado
;
; **********************************************************************
PROCESS SP_handle_som_score

proc_handle_som_score:
    MOV R0, [LOCK_tecla_carregada]  ; bloqueia o processo ate uma tecla ser carregada
    MOV R1, TECLA_MUTED         
    
    CMP R0, R1                  ; verifica se a tecla carregada foi a de mutar o som (F)
    JZ som                      ; se sim, vai para a rotina que trata do som
    
    MOV R2, TECLA_SCORES        
    CMP R0, R2                  ; verifica se a tecla carregada foi a de ver os scores (S)
    JZ ativa_score              ; se sim, vai para a rotina que trata do score
    JMP proc_handle_som_score
    
    som:
        MOV R1, [mute]          ; verifica se o som esta mutado ou nao
        CMP R1, 0               ; a WORD mute é 0 se nao estiver mutado e 1 se estiver mutado
        JZ muta_som
        
        MOV R9, 0             
        MOV [mute], R9          ; se estiver mutado, desmuta, colocando a WORD mute a 0
        MOV [VOLUME_SONS], R9   ; retoma o volume dos sons
        JMP proc_handle_som_score  

    muta_som:

        MOV R9, 1
        MOV [mute], R9          ; se nao estiver mutado, muta, colocando a WORD mute a 1
        MOV [MUTA_SONS], R9     ; muta todos os sons que estiverem a tocar
        JMP proc_handle_som_score  

    ativa_score:
        MOV R1, [score+2]        ; verifica se o estado do score (0 - nao mostra, 1 - mostra)
        CMP R1, 0               ; se estiver a 0, ativa o score
        JNZ desativa_score      ; se estiver a 1, desativa o score

        MOV R9, ATIVA_SCORE
        MOV [score+2], R9       ; ativa o score
        JMP proc_handle_som_score
    
    desativa_score:
        MOV R9, DESATIVA_SCORE
        MOV [score+2], R9       ; desativa o score
        JMP proc_handle_som_score


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
    PUSH R9
    PUSH R10

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

        MOV [tecla], R9


        POP R10
        POP R9
        POP R2
        POP R1
        POP R0
        RET


; **********************************************************************
; Processo
;
;
; Pausar jogo - Processo que coloca ou retira o jogo da pausa
;               caso o jogador carrega na tecla de pause (D)
;
; PARAMETROS: R0 - tecla carregada (LOCK)
;   	      
; **********************************************************************
PROCESS SP_pause

proc_pause:
    
    MOV R0, [LOCK_tecla_carregada] ; bloqueia o processo até uma tecla ser carregada
    MOV R4, [estado_jogo]     ; guarda o estado do jogo

    MOV R1, TECLA_JOGO_PAUSA
    CMP R0, R1                ; verifica se a tecla carregada e a tecla de pausa
    JZ pausa_jogo

    JMP proc_pause
    pausa_jogo:
        
        CMP R4, PAUSA                           ; se o jogo estiver pausado
        JZ  unpause                             ; volta ao jogo

        CMP R4, JOGO                            ; se o jogo não estiver a decorrer nem em pausa
        JNZ proc_pause                          ; nao faz nada

        MOV R4, SOM_JOGO
        MOV [PAUSA_SOM_LOOP], R4                ; pausa o som de jogo em loop enquanto está no menu de pausa

        MOV R4, PAUSA                           ; se o jogo estiver a decorrer 
        MOV [estado_jogo], R4                   ; coloca o jogo em pausa

        MOV R4, SOM_PAUSE
        MOV [TOCA_SOM], R4                     ; toca o som de pausa

        MOV R4, IMAGEM_PAUSE                       
        MOV [SELECIONA_CENARIO_FRONTAL], R4     ; coloca o ecrã de pausa

        JMP proc_pause

    unpause:
       
       MOV R4, JOGO                            ; retoma o jogo   
       MOV [estado_jogo], R4
               
    
       MOV [APAGA_CENARIO_FRONTAL], R4         ; volta ao ecrã de jogo 
       MOV [LOCK_jogo_pausado], R4                  ; desbloqueia os processos que estao bloqueados devido ao jogo estar pausado

       MOV R4, SOM_UNPAUSE   
       MOV [TOCA_SOM], R4                     ; toca o som de unpause


        MOV R4, SOM_JOGO
        MOV [CONTINUA_SOM_LOOP], R4           ; retoma a reproduçao do som de jogo em loop
       
        JMP proc_pause

 



; **********************************************************************
; Processo
;
;
; Fim de jogo - Processo que deteta se o jogo acabou: por colisao, falta de energia
;               ou se o utilizador carregou na tecla de sair (E)
;		
; **********************************************************************


PROCESS SP_game_over

proc_fim_jogo:
    YIELD                     ; o processo pode se tornar bloqueante enquanto o jogo nao acabar
                              ; ou seja se no verifica_tecla a tecla carregada nao for a tecla de sair (E)
                              ; o processo toma um ciclo infinito

    MOV R4, [estado_jogo]     ; verifica o estado do jogo
    CMP R4, JOGO
    JZ verifica_tecla         ; se o jogo estiver a decorrer ou em pausa

    CMP R4, PAUSA             ; verifica se o utilizador carregou na tecla de sair (E)
    JZ verifica_tecla

    CMP R4, SEM_ENERGIA       ; verifica se o jogo acabou por falta de energia
    JZ perdeu_sem_energia

    CMP R4, COLISAO           ; verifica se o jogo acabou por colisao
    JZ perdeu_colisao

    CMP R4, TERMINADO         ; verifica se o jogo já acabou
    JZ verifica_display_score ; espera até carregar na tecla de reinciiar o jogo (C)
    


perdeu_sem_energia:

    MOV R4, IMAGEM_SEMENERGIA           ; Caso tenha perdido por falta de energia

    MOV [SELECIONA_CENARIO_FRONTAL], R4 ; Muda o fundo do ecrã e toca o som especifico

    MOV R4, SOM_JOGO
    MOV [TERMINA_SOM_LOOP], R4           ; para o som de jogo em loop


    MOV R4, SOM_SEMENERGIA
    MOV [TOCA_SOM], R4                     ; toca o som de fim de jogo por falta de energia


    JMP verifica_display_score          ; espera até carregar na tecla de reiniciar o jogo (C)

perdeu_colisao:

    MOV R4, SOM_JOGO
    MOV [TERMINA_SOM_LOOP], R4           ; para o som de jogo em loop

    MOV R4, SOM_COLISAOFIM
    MOV [TOCA_SOM], R4                     ; toca o som de fim de jogo por colisao


    MOV R4, IMAGEM_COLISAO              ; Caso tenha perdido por uma colisao com a nave
    MOV [SELECIONA_CENARIO_FRONTAL], R4   ; Muda o fundo do ecrã e toca o som especifico
    


    JMP verifica_display_score          ; espera até carregar na tecla de reiniciar o jogo (C)
    
verifica_tecla:

    MOV R0, TECLA_JOGO_TERMINA
    MOV R4, [tecla]             ; Verifica se carregou na tecla de sair (E) 
    CMP R4, R0                  ; enquanto o jogo estava a decorrer ou em pausa
    JZ termina_jogo             ; Caso tenha saido do jogo


    JMP proc_fim_jogo           ; Caso não tenha clicado na tecla de sair não faz nada

termina_jogo:                   ; Caso tenha saido do jogo ao clicar na tecla de sair (E)
    
    MOV R4, TERMINADO
    MOV [estado_jogo], R4       ; Muda o estado do jogo para terminado

    MOV R4, IMAGEM_TERMINADO    ; Muda o fundo do ecrã e toca o som especifico    
    MOV [SELECIONA_CENARIO_FRONTAL], R4

    MOV R4, SOM_JOGO
    MOV [TERMINA_SOM_LOOP], R4  ; para o som de jogo em loop
    
    MOV R4, SOM_TERMINADO
    MOV [TOCA_SOM], R4            ; toca o som de fim de jogo por sair do jogo

    JMP verifica_display_score  ; espera até carregar na tecla de reiniciar o jogo (C)

verifica_display_score:

    MOV R4, [score +2]            ; verifica se deve mostrar o score no ecrã
    CMP R4, 0
    JZ verifica_recomeca_jogo     ; se o score for 0, não mostra o score no ecrã

    MOV R1, [score]               ; guarda o valor do score
    CALL rot_converte_Hex_Decimal ; converte o score para decimal
    MOV [DISPLAYS], R5            ; mostra o score no ecrã em decimal


verifica_recomeca_jogo:           ; fica nesta label até carregar na tecla de reiniciar o jogo (C)

    MOV R0, TECLA_JOGO_COMECA
    MOV R4, [LOCK_tecla_carregada]   ; bloqueia o processo até carregar voltar a ser carregada uma tecla

    CMP R4, R0                    ; Verifica se carregou na tecla de comecar (C)
    JZ recomeca_jogo              ; Se carregou, recomeca o jogo

    JMP verifica_recomeca_jogo  ; Se não carregou, continua a verificar até se carregar

recomeca_jogo:
    
    CALL rot_apaga_asteroides_gameover  ; apaga os asteroides que estavam no ecrã e reseta as tabelas respetivas
    CALL rot_apaga_sondas_gameover      ; apaga as sondas que estavam no ecrã e reseta as tabelas respetivas
    
    CALL rot_inicia_jogo                ; Recomeca o jogo

    JMP proc_fim_jogo


; ************************************************************************************
; Rotina Inicia Jogo
; 
; Inicia o jogo, alterando o ecrã e o estado do jogo, desenha a nave, reinicia o valor do display
; toca o som de inicio de jogo e desblqueia os processos essenciais ao jogo
;
;
; Nao recebe nem devolve nenhum registo
; ************************************************************************************
rot_inicia_jogo:

    PUSH R2
    PUSH R4

    MOV R4, JOGO
    MOV [estado_jogo], R4              ; muda o estado do jogo para JOGO
    

    MOV R4, IMAGEM_JOGO                ; muda o fundo do ecrã especifico
    
    MOV [APAGA_CENARIO_FRONTAL], R4
    MOV [SELECIONA_CENARIO_FUNDO], R4

    MOV [TERMINA_TODOS_SONS], R4       ; para todos os sons que estejam a tocar
                                       ; alguns sons de fim de jogo sao mais longos pelo que 
                                       ; podem ainda estar a tocar apos se reiniciar o jogo mais rapidamente

    MOV R4, SOM_INICIO
    MOV [TOCA_SOM], R4                 ; dtoca o som de inicio de jogo em loop



    MOV R4, VALOR_INICIAL_DISPLAY_HEX
    MOV [display_HEX], R4              ; guarda o valor inicial do display em hexadecimal

    MOV R4, VALOR_INICIAL_DISPLAY            
    MOV [DISPLAYS], R4                 ; inicializa o display com o valor inicial em decimal



    MOV R2, DEF_NAVE                    ; Inicializa o registo 2 que vai indicar que boneco desenhar
    CALL rot_desenha_asteroide_e_nave   ; desenha a nave


    MOV R4, SOM_JOGO

    MOV [TOCA_SOM_LOOP], R4             ; toca o som de jogo em loop até ser parado

    MOV R4, 0
    MOV [score], R4                     ; inicializa o score a 0

fim_inicia_jogo:

    MOV [LOCK_jogo_pausado], R4         ; desbloqueia os processos essenciais ao jogo
    MOV [LOCK_game_over], R4

    POP R4
    POP R2
    RET


; ************************************************************************************
; Rotina
; desenha asteroide ou nave, dependendo do valor de R2
;
; PARÂMETROS:  R2 - tipo da tabela (nave, asteroide não minerável, asteroide 
;              minerável ou explosão de asteroide), a sonda é tratada noutra rotina
;              R7 - linha do primeiro píxel do asteroide
;              R4 - coluna do primeiro píxel do asteroide
;              R9 - tabela com os endereços das tabelas de controlo dos asteroides
; ************************************************************************************

rot_desenha_asteroide_e_nave: ; Deposita os valores dos registos abaixo no stack


    PUSH R1 
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R10
    PUSH R11
    

    MOV R8, DEF_ASTEROIDE_MINERAVEL_3x3 ; guarda o endereço da tabela que define o asteroide mineravel 3x3
    CMP R2, R8                          ; se for minerável 3x3 não tem estado então salta logo para o desenha
    JZ desenha_asteroide_e_nave

    MOV R8, DEF_NAVE                    ; guarda o valor da memória na primeira posição da tabela que define a nave 
    CMP R2, R8                          ; verifica se foi pedido para desenhar uma nave
    JNZ obtem_estado_asteroide          ; se não foi pedida a nave então foi pedido um asteroide
    
    posicao_inicial_nave:
        MOV R7, ECRA_PIXEIS_SONDA_NAVE
        MOV [SELECIONA_ECRA_PIXEIS], R7 ; seleciona o ecrã dos pixeis onde a nave vai ser desenhada

        MOV  R7, LINHA_NAVE			    ; linha da nave
        MOV  R4, COLUNA_NAVE	        ; coluna da nave 
        JMP desenha_asteroide_e_nave
    
    obtem_estado_asteroide:         ; obtém o estado do asteroide através da sua tabela de controlo
        MOV R11, [R9]               ; guarda o valor da tabela que contém a variável de estado
        MOV R10, [R11]              ; obtém o estado (-1) se for para apagar ou 1 ou 0 se for para desenhar
        MOV R6, [R11 + 8]            ; obtem o ecra de pixeis onde o asteroide vai ser desenhado
        MOV [SELECIONA_ECRA_PIXEIS], R6 ; seleciona o ecrã dos pixeis onde o asteroide vai ser desenhado


    desenha_asteroide_e_nave:   ; desenha o asteroide/nave/sonda(bonecos) a partir da tabela

        MOV	R6, [R2]			; obtém a largura do boneco
        ADD R2, 2               ; endereço da altura do boneco
        MOV R1, [R2]            ; obtém a altura
        ADD	R2, 2			    ; endereço da cor do 1º pixel (2 porque a largura é uma word)

        MOV R8, R4              ; guarda o primeiro valor da coluna para depois


    desenha_todos_pixels:
        CMP R1, 0                               ; verifica se a altura é 0, se sim termina
        JZ muda_estado_asteroide

        MOV R4, R8                              ; reinicia a coluna para o seu valor inicial
        
    	MOV R3, 0               ; inicializa o R3 (futura cor dos pixels) a 0
		
		CALL rot_desenha_pixels_linha        ; se a altura não for 0 vai desenhar os pixels da primeira linha livre
        
        ADD R7, 1               ; próxima linha
        SUB R1, 1               ; menos uma linha para tratar

        JMP desenha_todos_pixels        ; continua até percorrer toda a tabela 

    muda_estado_asteroide:          ; define se a próxima chamada da rotina é para apagar(-1) ou desenhar(1)                      
        MOV R5, LARGURA_NAVE
        CMP R6, R5                  ; verifica se estamos a desenhar uma nave, se sim, ignora-se a mudança de estado
        JZ fim_desenha_asteroide_e_nave
        
        MOV R5, ALTURA_LARGURA_3x3
        CMP R6, R5                  ; verifica se estamos a desenhar um minerável 3x3, se sim, ignora-se a mudança de estado
        JZ fim_desenha_asteroide_e_nave

        CMP R10, -1                  ; se for um irá mudar para -1 e vice-versa, se for 0 muda para -1 também
        JZ muda_para_desenhar         
        
        muda_para_apagar:
            MOV R5, -1              
            MOV [R11], R5           ; no caso de R5 estar a 1 ou a 0 passa a -1
            JMP fim_desenha_asteroide_e_nave

        muda_para_desenhar:
            MOV R5, 1
            MOV [R11], R5                ; no caso de R10 estar a -1 passa a 1
            

    fim_desenha_asteroide_e_nave: ; volta a atribuir os valores acumulados no stack aos devidos registos
        POP R11
        POP R10
        POP R8
        POP R7
        POP R6
        POP R5
        POP R4
        POP R3
        POP R2
        POP R1
        RET


; ************************************************************************************
; Rotina
; preenche os pixeis de uma linha, ou com a cor presente em cada pixel da tabela
; do objeto, se R10 for diferente de -1 ou com cor 0, ou seja, apaga os pixels
;
; PARÂMETROS:  R2 - tipo da tabela (nave, sonda, asteroide não minerável, asteroide 
;                   minerável ou explosão de asteroide)
;              R3 - no caso de R10 ser -1, R3 indica a cor do pixel (0 para apagar)
;              R6 - largura do objeto
;              R7 - linha do objeto
;              R4 - coluna do objeto
;              R10 - estado do objeto
; ************************************************************************************

rot_desenha_pixels_linha:       		; desenha os pixels do asteroide/nave a partir da tabela
    
    PUSH R0
    PUSH R1
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R8
    PUSH R10


    MOV R1, DEF_SONDA       ; guarda o valor incial da tabela da sonda para se poder comparar com o do input(R2)
    MOV R5, tabela_cores    ; guarda o enderço da tabela de cores
    MOV R8, R5              ; guarda o enderço da tabela de cores para ser modificado

    CMP R10, 4              ; verifica se o input foi a tabela de cores 
    JNZ preenche_pixel      ; se não, salta
    
    MOV R0, 8               ; guarda o número 8 por ser demasiado grande para adicionar diretamente

    ADD R8, R0              ; Guarda em R8 o endereço da última cor da tabela 

    preenche_pixel:

        CMP R10, -1             ; verifica se é suposto apagar o desenho
        JZ pinta_pixels         ; se for para apagar não lê a cor do pixel, pois esta será 0
        
        CMP R10, 4              ; verifica de novo se o input foi a tabela de cores
        JNZ continua_preenche
        ; o seguinte bloco trata da aleatoridade da cor de cada bit dentro das cores da tabela de cores
        CALL rot_gera_aleatorio         ; entrega dois números aleatórios um em R0 (0 a 3) e outro em R1 (0 a 4)
        SHL R1, 1                       ; multiplica R1 por dois para ir de word em word (2 em bytes)
        ADD R2, R1                      ; adiciona o número aleatório entre 0 e 8 a R2
        

        CMP R2, R8              ; verifica se já chegou á última cor da tabela ou tem um valor maior
        JLE continua_preenche
        MOV R2, R5              ; se sim, reeinicia para a primeira cor da tabela 

    continua_preenche:
        MOV	R3, [R2]			; obtém a cor do próximo pixel do asteroide/nave
        
    pinta_pixels:
        MOV  [DEFINE_LINHA], R7	    ; seleciona a linha
        MOV  [DEFINE_COLUNA], R4	; seleciona a coluna
        MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas
        
        CMP R2, R1      ; Se for para desenhar uma sonda, apenas preenche o único pixel que tem e sai do loop
        JZ fim_desenha_pixels

        ADD	R2, 2			    ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
        ADD R4, 1               ; próxima coluna
        SUB R6, 1			    ; menos uma coluna para tratar (diminui a Largura restante)
        JNZ preenche_pixel      ; continua até percorrer toda a largura do objeto

    fim_desenha_pixels:
        
        POP R10
        POP R8
        POP R6
        POP R5
        POP R4
        POP R3
        POP R1
        POP R0
        RET

; **********************************************************************
; Rotina
; Serve para desenhar ou apagar a sonda dependendo do valor de R10
;
; PARÂMETROS: R1 - tabela da sonda a usar no momento
;             R2 - endereço inicial da tabela DEF_SONDA
;             R7 - sua linha no momento
;             R4 - sua coluna no momento
;             
; RETORNA: R10 - Registo para controlar o próximo desenho, se R10 veio a -1 (para apagar)
;               irá devolver R10 com 3, o que indica ao processador que a próxima chamada
;               desta rotina será para desenhar
; **********************************************************************
rot_desenha_sonda:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R7
    PUSH R8
    PUSH R10
    ; as seis intruções seguintes servem para verificar se existe alguma sonda ou se
    ; é para apagar,de acordo com o explicado na descrição de R10

    MOV R2, DEF_SONDA       ; indica que se vai desenhar uma sonda

    MOV R10, ECRA_PIXEIS_SONDA_NAVE          ; seleciona o ecra de pixeis onde a sonda vai ser desenhada
    MOV [SELECIONA_ECRA_PIXEIS], R10

    MOV R10, [R1 + 8]   ; guarda o estado da sonda (1 - desenhada/existe, 0 - nao existe, -1 - apagada)

    posicao_sonda:

        MOV  R7, [R1+2]			        ; linha da sonda
        MOV  R4, [R1+4]			        ; coluna da sonda
        
    desenha_pixels_sonda:
    	MOV R3, 0						; inicializa o R3 (futura cor dos pixels) a 0
        
        CALL rot_desenha_pixels_linha	; pinta a sonda de rosa, como definido na sua tabela

    muda_estado:
        CMP R10, -1						; verifica se esta rotina foi usada para apagar, se sim, põe o valor de R1 a 3 para poder desenhar de novo
        JNZ muda_estado_apaga 
        MOV R3, 1
        MOV [R1+8], R3      			; Põe R10 a 3 de modo a poder desenhar a próxima sonda
        JMP fim_desenho_sonda
    
    muda_estado_apaga:
        MOV R3, -1
        MOV [R1+8], R3      			; Põe R10 a 3 de modo a poder desenhar a próxima sonda

    fim_desenho_sonda:  
    POP R10
    POP R8
    POP R7
    POP R5                   
    POP R4
    POP R3
    POP R2
    POP R1
    RET

; **********************************************************************
; Processo
;
; display - Processo que aumenta ou diminui a energia da nave e a transmite para o display
;           em numeracao decimal
;           A energia comeca a 100% e diminui 3% a cada 3 segundos, 5% por cada sonda disparada
;           e aumenta 25% por cada asteroide mineravel destruido
;           Se chegar a 0% o jogo termina
;
;           As operacoes sao todas feito em hexadecimal, atraves da WORD display_HEX
;           O valor do display_HEX e convertido para decimal e transmitido para o display em atualiza_display
;           com auxilio da rotina - rot_converte_Hex_Decimal
;		
;           R1 - Valor atual do display em hexadecimal     
; **********************************************************************

PROCESS SP_display

proc_display:
    MOV R1, VALOR_INICIAL_DISPLAY_HEX          ; Valor inicial do display em hexadecimal (64H)
    MOV R3, VALOR_INICIAL_DISPLAY
    atualiza_energia:
        MOV R0, [int_energia_display]              ; Verifica o valor do LOCK energia_display para saber como atualizar a energia
                                               ; Bloqueia o processo até receber uma interrupcao do timer ou de um disparo ou uma colisao com um asteroide mineravel
        
        MOV R2, [estado_jogo]                  ; Verifica o estado do jogo
        CMP R2, PAUSA                          ; Se estiver em pausa não atualiza a energia
        JZ pausa_energia

        MOV R1, [display_HEX]
        MOV R3, VALOR_INICIAL_DISPLAY_HEX
        CMP R4, R3                             ; Verifica se o valor do display é O inicial
        JNZ acoes_display                      ; Se não for, vai para a rotina de atualizacao da energia

    reinicia_display:
        MOV R1, VALOR_INICIAL_DISPLAY_HEX      ; Se for, atualiza o valor do display em hexadecimal para o valor inicial

    acoes_display:
        CMP R2, SEM_ENERGIA                    ; Se estiver sem energia não atualiza a energia
        JZ sem_energia
        CMP R2, TERMINADO                      ; Se o jogo tiver terminado não atualiza a energia
        JZ fim_jogo
        CMP R2, COLISAO
        JZ fim_jogo

        CMP R0, DISPLAY_AUMENTA_ENERGIA        ; 1 - asteroide mineravel destruido, aumenta energia (25%)
        JZ aumenta_energia
        CMP R0, DISPLAY_ENERGIA_SONDA          ; 2 - sonda disparada, diminui energia (5%)
        JZ diminui_energia_sonda


    diminui_energia_int:                       ; 3 - rotina de interrupcao, diminui energia (3%)
        SUB R1, DIMINUI_ENERGIA_INT
        CMP R1, MIN_VALOR_DISPLAY              ; Verifica se a energia chegou a 0 apos a diminuicao
        JLE sem_energia
        JMP atualiza_display                   ; Se nao chegou, atualiza o valor no display


    diminui_energia_sonda:                     ; *2 - sonda disparada, diminui energia (5%)
        SUB R1, DIMINUI_ENERGIA_SONDA
        CMP R1, MIN_VALOR_DISPLAY              ; Verifica se a energia chegou a 0 apos a diminuicao
        JLE sem_energia
        JMP atualiza_display                   ; Se nao chegou, atualiza o valor no display


    aumenta_energia:                           ; *1 - asteroide mineravel destruido, aumenta energia (25%)
        MOV R2, AUMENTA_ENERGIA               
        ADD R1, R2                             ; Nao existe energia maxima, logo nao precisa de verificar se chegou a um maximo de energia com a adicao
        JMP atualiza_display                 

    sem_energia:                               ; Caso a energia tenha chegado a 0

        MOV R0, SEM_ENERGIA                    ; Altera o estado do jogo para SEM_ENERGIA, terminando o jogo
        MOV [estado_jogo], R0
        MOV R0, 0
        MOV [DISPLAYS], R0                     ; Display fica a 0 (sem energia)
        MOV R0, [LOCK_game_over]                    ; Bloqueamos o processo enquanto o jogo estiver terminado
        JMP proc_display

    atualiza_display:
        MOV [display_HEX], R1
        CALL rot_converte_Hex_Decimal          ; Converte o valor no R1 (hexadecimal) para decimal (R5)
        MOV [DISPLAYS], R5                     ; Atualiza o valor no display com o valor decimal (R5)
        JMP atualiza_energia                   ; Volta ao inicio do processo

    pausa_energia:
        MOV R9, [LOCK_jogo_pausado]                 ; Bloqueia o processo enquanto o jogo estiver em pausa
        JMP atualiza_energia

    fim_jogo:
        MOV R9, [LOCK_game_over]                    ; Bloqueia o processo enquanto o jogo estiver terminado
        JMP proc_display

; **********************************************************************
; ROTINA
;
; converte_Hex_Decimal - Converte um numero hexadecimal para decimal,
;						de forma a que cada nibble do display mostre um digito
;
; Parametros: R1 - numero em hexadecimal
;
; Variaveis:
;      		  R2 - temporario
;			  R3 - fator 
;			  R4 - digito
;		      R5 - resultado 
;
; Retorna R5 - valor decimal (cada nibble com um digito)
; **********************************************************************

rot_converte_Hex_Decimal:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
    PUSH R6

	MOV R4, 0
	MOV R5, 0H
	MOV R3, FATOR		; o fator começa em 1000
    ciclo_converte_hex:
        MOD R1, R3 			; numero = numero MOD Fator
        MOV R6, 10				
        DIV R3, R6			; fator = fator DIV 10

        MOV R2, R1			  
        DIV R2, R3			; digito = numero DIV fator
        MOV R4, R2

        SHL R5, 4			; resultado = resultado SHL 4 (proximo nibble)
                            ; desloca para cada nibble ter um digito
        OR R5,R4			; resultado = resultado OR digito
                            ; adiciona novo digito ao nible com menos peso

        MOV R2,R3			
        SUB R2, 1			; Ver se fator é igual a 1
        JNZ ciclo_converte_hex

        POP R6
        POP R4 
        POP R3
        POP R2 
        POP R1
        RET 

; **********************************************************************
; Rotina 
; - indica qual a próxima posição de um determinado objeto
;  
; - PARÂMETROS:    
;   No caso de ser sonda:
;   - R1 (endereço da sonda a aceder)
;   - R2 (endereço da tabela DEF_SONDA)
;   - R3 (alcance da sonda)
;
;   No caso de ser asteroide:
;   - R2 (endereço de alguma da tabela DEF_ASTEROIDE_MINERAVEL ou DEF_ASTEROIDE_N_MINERAVEL)   
;   - R9 (endereço da tabela de controlo dos asteroides)
; 
; - Esta rotina atualiza as variáveis do alcance, da linha e da coluna na sonda
;   ou da linha e da coluna dos asteroides
; **********************************************************************

rot_atualiza_posicao:
    PUSH R0
    PUSH R1
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9

    ; queremos atualizar o alcance, a coluna através do incremento no 4ª word da sonda (+6)
    MOV R0, DEF_SONDA           
    CMP R2, R0                          ; verifica se o objeto é uma sonda
    JNZ proxima_posicao_asteroide       ; salta se não for sonda (será asteroide)

    proxima_posicao_sonda:
        MOV R6, DECREMENTO
        ADD R3, R6                  ; decrementa o alcance
        MOV [R1], R3                ; atualiza o alcance
        MOV R5, [R1+2]              ; guarda o valor da linha da sonda
        ADD R5, DECREMENTO          ; diminui a linha
        MOV [R1+2], R5              ; muda a linha
        MOV R8, [R1+6]              ; guarda o incremento/decremento para adicionar à coluna
        MOV R9, [R1+4]              ; guarda a coluna da sonda
        ADD R9, R8                  ; muda a coluna
        MOV [R1+4], R9              ; guarda o novo valor da coluna
        
        
        JMP fim_atualiza_posicao

    
    proxima_posicao_asteroide:
        MOV R6, [R9]                    ; acede à tabela de controlo do asteroide ativo no momento
        MOV R5, [R6+2]                  ; acede à tabela de posição do asteroide
        MOV R3, [R5]                    ; guarda o endereço da linha do asteroide 
        MOV R7, [R5+2]                  ; guarda o endereço da coluna do asteroide 
        MOV R1, [R6+6]                  ; obtém a tabela que contém a posição inicial e o incremento/decremento
        MOV R8, [R1+2]                  ; obtém o incremento/decremento
        ADD R3, INCREMENTO              ; incrementa a linha (qualquer que seja a coluna o asteroide desce sempre +1 linha)
        ADD R7, R8                      ; incrementa/decrementa a coluna
        MOV [R5], R3                    ; guarda a nova linha
        MOV [R5+2],R7                   ; guarda a nova coluna


    
fim_atualiza_posicao:
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R1
    POP R0
    RET

; **********************************************************************
; Processo
;
; proc_painel_nave - Processo que lê o relógio da nave e muda o lock int_painel_nave
;               para que seja possível mudar as cores do painel da nave
;		
;       R0, R1 - largura do painel e altura do painel, respetivamente
;		R2 - endereço da tabela das cores definida no início 
;       R4, R7 - linha e coluna do painel, respetivamente
; **********************************************************************


PROCESS SP_painel_nave		; indicação de que a rotina que se segue é um processo,
							; com indicação do valor para inicializar o SP
proc_painel_nave:

	MOV R2, tabela_cores		; guarda o endereço da tabela das cores para se poder aceder às cores

	
    MOV R6, LARGURA_PAINEL_NAVE		; guarda a largura do painel em R0
	MOV R1, ALTURA_PAINEL_NAVE		; guarda a altura do painel
	
    posicao_painel_nave:
        
        MOV R7, LINHA_PAINEL		; linha do painel
        MOV R4, COLUNA_PAINEL       ; coluna do painel
        MOV R10, 4                  ; irá servir para dizer à rot_desenha_pixels_linha que o input é a tabela de cores

    loop_painel:
        YIELD
        
        MOV R3, ECRA_PIXEIS_SONDA_NAVE  ; seleciona o ecra de pixeis onde vai ser desenhado o painel da nave
        MOV [SELECIONA_ECRA_PIXEIS], R3 

        CALL rot_desenha_pixels_linha   ; muda a primeira linha do painel
        ADD R7, 1                       ; próxima linha
        CALL rot_desenha_pixels_linha   ; muda a segunda linha do painel
        SUB R7, 1                       ; reinicia para a primeira /linha 

        MOV R8, [int_painel_nave]       ; bloqueia o lock do painel para só andar à medida do relógio
    verifica_pausa:                     ; verifica se o jogo está pausado
        MOV R5, [estado_jogo]           ; se estiver, bloqueia o processo
        CMP R5, PAUSA            
        JNE verifica_fim_jogo
        
        MOV R5, [LOCK_jogo_pausado]     ; se estiver, bloqueia o processo

        JMP loop_painel

    verifica_fim_jogo:
        CMP R5, JOGO                    ; verifica se o jogo terminou
        JZ loop_painel

        MOV R5, [LOCK_game_over]        ; se terminou, bloqueia o processo   
    
        JMP loop_painel



; **********************************************************************
; Processo
;
; proc_asteroides - Processo que cria asteroides sempre que não hajam 
; já 4 na tela e que os movimenta de acordo com o relógio dos asteroides
;		
; **********************************************************************

PROCESS SP_asteroide        ; indicação de que a rotina que se segue é um processo,
							; com indicação do valor para inicializar o SP
    
proc_asteroides:

    MOV R8, [int_asteroide]         ; bloqueia o lock do asteroide para só andar à medida do relógio
                                    ; mas faz o processo uma vez    
    MOV R5, [estado_jogo]           ; verifica se o jogo está pausado ou se já terminou
    CMP R5, PAUSA                   ; e bloqueia o processo caso tal aconteça
    JZ pause_asteroides
    CMP R5, JOGO
    JNZ gameover_asteroides
       
    MOV R3, tabela_geral_posicao       ; guarda o endereço da tabela das combinações de posições possíveis
    MOV R9, controlo_asteroides        ; guarda o endereço da tabela de controlo do primeiro asteroide(asteroide0)
    MOV R11, R9
    ADD R11, 6                         ; guarda o endereço máximo da tabela controlo contida em R9 (limite)

; NOTA: quando algum asteroide deixar de existir, altera-se o seu estado na tabela de 
; controlo do respetivo asteroide e põe-se a primeira WORD da tabela a 0 de novo

spawn_asteroides:               ; desenha os asteroides na sua posição inicial

    MOV R5, [R9]                ; guarda o endereço da tabela de um asteroide
    MOV R10, [R5]               ; guarda o estado do asteróide
    CMP R10, 0                  ; verifica se esse asteroide já existe (se o estado tiver a 0 não existe)
    JNZ  incrementa_compara     ; no caso de já existe passa à tabela do próximo asteroide
    CALL rot_inicia_asteroide   ; desenha cada asteroide na sua posição inicial de acordo com a tabela de posições

    incrementa_compara:
        ADD R9, PROXIMO_ASTEROIDE   ; incrementa R9 por 2 (próxima word)
        CMP R9, R11                 ; se R9 for inferior ao limite da tabela controlo continua o ciclo
        JLE spawn_asteroides
    
    MOV R9, controlo_asteroides

    CALL rot_movimenta_asteroides

    JMP proc_asteroides             ; no caso de já ter visto todos os asteroides

pause_asteroides:                   ; caso o jogo esteja pausado, bloqueia o processo
    MOV R5, [LOCK_jogo_pausado]
    JMP proc_asteroides

gameover_asteroides:                ; caso o jogo tenha terminado, bloqueia o processo
    
    MOV R5, [LOCK_game_over]
    JMP proc_asteroides  


; **********************************************************************
; Rotina Movimenta Asteroides
;
; 
;
; 
; PARAMETROS: R9 - endereço da tabela de controlo dos asteroides
;             R5 - endereço da tabela de um asteroide
;             R11 - endereço máximo da tabela controlo contida em R9
;             
; **********************************************************************

rot_movimenta_asteroides:

    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8

    

loop_movimento:
    MOV R5, [R9]                ; guarda o endereço da tabela de um asteroide

    
    ; comeca por apagar eventuais explosões que tenham acontecido devido a colisões
    MOV R7, 10
    MOV R6, [R5+R7]                 ; vai buscar o estado de desaparecimento, 
                                    ; que é diferente de 0 se for um minerável 3x3 ou mais pequeno
    CMP R6, 0
    JGT apaga_explodidos            ; se o estado de desaparecimento for maior que 0 então é porque
                                    ; ainda falta eliminar a explosão de um minerável

    MOV R6, [R5]                    ; obtém o estado do asteroide
    CMP R6, 2                       ; compara o estado do asteroide com 2 (explodido)
    JNZ continua_movimento
    
    apaga_explodidos:
        CALL rot_apaga_explodidos
        JMP incrementa

continua_movimento:
    CALL rot_testa_colisao_nave     ; verifica se o asteroide colidiu com a nave
    CMP R6, COLISAO                 ; se houver colisão irá para o game over depois de sair da rotina
    JZ fim_movimenta_asteroides
    
    CALL rot_inicia_asteroide       ; apaga o asteroide da posição atual para poder desenhar na próxima
    
    CALL rot_testa_limites          ; verifica se o asteroide chegou ao limite do ecrã
    CMP R8, 1                       
    JZ incrementa              ; se chegou ao limite vai reiniciar a posição e direção iniciais do asteroide
    
    CALL rot_atualiza_posicao       ; incrementa a posição diagonalmente (+1 coluna +1 linha) 
    
    CALL rot_inicia_asteroide       ; desenha o asteroide na nova posição
    
    incrementa:
        ADD R9, PROXIMO_ASTEROIDE   ; incrementa R9 de modo ao seu endereço apontar para o próximo asteroide
        CMP R9, R11
        JLE loop_movimento          ; se ainda não tiver percorrido todos os asteroides vao para o próximo

fim_movimenta_asteroides:
    POP R8
    POP R7
    POP R6
    POP R5

    RET 

; **********************************************************************
; Rotina Apaga Asteróides Game Over
;
; Apaga os asteróides existentes no painel de jogo quando o jogo termina e está prestes a recomecar
;
; Coloca as variaveis de modo a estarem prontas para o proximo jogo, iniciando as para a posição inicial
; 
; PARAMETROS: R9 - endereço da tabela de controlo dos asteroides
;             R3 - endereço da tabela geral de posições
;             R11 - endereço máximo da tabela de controlo
; **********************************************************************

rot_apaga_asteroides_gameover:
    PUSH R0
    PUSH R1
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R9
    PUSH R10
    PUSH R11



    MOV R9, controlo_asteroides
    MOV R11, R9
    ADD R11, 6                      ; guarda o endereço máximo da tabela controlo contida em R9 (limite)

apaga_asteroide:


    CALL rot_inicia_asteroide       ; apaga o asteroide

    MOV R5, [R9]                    ; guarda o endereço da tabela de controlo de um asteroide

    reinicia_estados:
        MOV R10, 0                  ; coloca o estado do asteroide a 0
        MOV [R5], R10               ; guarda o estado do asteroide na tabela de controlo
        MOV R4, [R5+6]              ; guarda a tabela da posição inicial e incremento do asteroide    
        MOV [R4+4], R10             ; reinicia o estado dessa tabela a 0 
    
    reinicia_linha:
        MOV R0, [R5+2]                  ; guarda o endereço da tabela de posições do asteroide
        MOV [R0], R10                   ; coloca o asteroide na linha 0

    incrementa_R9:
        ADD R9, PROXIMO_ASTEROIDE
        CMP R9, R11                     ; verifica se R9 é inferior ao limite da tabela controlo
        JLE apaga_asteroide
                                   ; faz mais uma vez para a ultima posicao do asteroide
    ;MOV R1, [R3]                   ; guarda o endereço da tabela de posições
    ;MOV [R1+4],R10                 ; coloca O estado a 0

fim_apaga_asteroide_gameover:

    POP R11
    POP R10
    POP R9
    POP R5
    POP R4
    POP R3
    POP R1
    POP R0
    RET

; **********************************************************************
; Rotina 
; - trata das escolhas pseudo aleatórias para cada asteroide
;  
; - PARÂMETROS:    
;  R3 - endereço da tabela das combinações de posições possíveis
;  R9 - endereço da tabela de controlo de todos os asteroides
;
; - RETORNA:
;  
;  R1 - incremento da coluna para o movimento do asteroide
;  R2 - tabela do meteorito a desenhar
;  R4 - coluna do asteroide 
;  R7 - linha do asteroide
;  R9 - guarda o valor da tabela de controlo do próximo asteroide
; **********************************************************************


rot_inicia_asteroide:
    PUSH R0 
    PUSH R1
    PUSH R3
    PUSH R5
    PUSH R6
    PUSH R8
    PUSH R11

    MOV R3, tabela_geral_posicao        ; guarda o endereço da tabela das combinações de posições possíveis


    
    CALL rot_gera_aleatorio             ; recebe dois números pseudoaleatórios: R0(0 a 3) e R1(0 a 4)

    MOV R10, [R9]                       ; acede à tabela de controlo do asteroide a usar no momento
    MOV R11, [R10]                      ; guarda a informação sobre se é para apagar(-1) ou se existe(1) ou não (0)
    CMP R11, 0                          ; significa que este asteroide ainda não existe  
    JNZ obtem_dados_tabela_controlo                        

; No caso de ainda não haver asteroide (R11 = 0) cria um novo asteroide
    cria_asteroide:

        obtem_tabela_desenho:
            CMP R0, 0                           ; se R0 não for 0 é para fazer um não minerável senão o oposto
            JNZ  asteroide_nao_mineravel

            MOV R2, DEF_ASTEROIDE_MINERAVEL     ; no caso de ser minerável, guarda o endereço da sua tabela e salta
            JMP guarda_tabela_desenho

        asteroide_nao_mineravel:
            MOV R2, DEF_ASTEROIDE_N_MINERAVEL   ; no caso de ser não minerável, guarda o endereço da sua tabela
        
        guarda_tabela_desenho:
            MOV [R10+4], R2         ; guarda a tabela do objeto na sua word dentro da tabela de controlo do asteroide(3ª word)

        obtem_tabela_coluna_incremento:  ; tabela particular do movimento (dentro das 5 hipóteses de coluna/incremento possíveis)
            SHL R1, 1                    ; multiplica por dois (anda um bit para a direita pois queremos incrementar de 2 em 2 bytes)
            ADD R3, R1                   ; vai adicionar um certo valor par de 0 a 8 a R3 de modo a obter o endereço de uma tabela de direção
            MOV R5, [R3]                 ; guarda o endereço da tabela escolhida
            
        ;**************************************************
            ; Opção que remove a possibilidade de dois asteroides terem a mesma direção e coluna inicial
            ;MOV R11, [R5+4]         ; acede à word que guarda se a tabela está a ser usada ou não
            ;CMP R11, 0
            ;JZ muda_estado_tabela   ;no caso de não estar a ser usada salta
            ;
            ;CALL rot_gera_aleatorio             ; se já estiver a ser usada vai buscar outro número aleatório 
            ;
            ;MOV R3, tabela_geral_posicao        ; reinicia R3 com o endereço da tabela das combinações de posições possíveis
            ;JMP obtem_tabela_coluna_incremento  ; tenta de novo com outro número 
       
            ;muda_estado_tabela:
            ;    MOV R11, 1           ; MOV auxiliar
            ;    MOV [R5+4], R11      ; altera o estado da tabela de 0 para 1 (utilizada por um asteroide)
        ;**************************************************
        
        MOV [R10+6], R5      ; guarda esta tabela na tabela de controlo do asteroide

        define_coluna_inicial:
            
            MOV R6, [R10+2]      ; guarda o endereço da tabela de posição do asteroide
            MOV R3, [R5]         ; MOV auxiliar
            MOV [R6+2], R3       ; define a coluna inicial do asteroide retirando esse valor da tabela que contém a coluna e o incremento 
                    
            MOV R0, 1       ; MOV auxiliar
            MOV [R10], R0   ; atualiza a variável de estado do asteroide para 1 (existe)
    
    ; aqui a tabela de controlo do asteroide já contém todos os parâmetros necessários à sua manipulação
    ; começa a extrair os dados da tabela de controlo

    ; nota: 
    ; o R10 (endereço inicial da tabela controlo que aponta para a primeira word)
    ; é obtido logo ao início desta rotina, logo dá para o reutilizar.
    obtem_dados_tabela_controlo:  
        MOV R8, [R10+2]         ; guarda o endereço da tabela posição guardada na segunda word da tabela de controlo
        MOV R7, [R8]            ; obtém a linha do asteroide
        MOV R4, [R8+2]          ; obtém a coluna do asteroide
        MOV R2, [R10+4]         ; lê qual a tabela do asteroide a desenhar

    CALL rot_desenha_asteroide_e_nave   ; desenha o asteroide
    
fim_inicia_asteroide:
    POP R11
    POP R8
    POP R6
    POP R5
    POP R3
    POP R1
    POP R0
    RET

; **********************************************************************
; Processo
;
; proc_sonda - Processo que movimenta as sondas existentes no jogo
;              Ou dispara uma nova sonda de acordo com a tecla carregada
;              0 - dispara esquerda; 1 - dispara frente; 2 - dispara direita,
;              se ainda nao existir nenhuma sonda nessa direcao
;              A indicacao do que e para fazer e dada pelo lock int_movimenta_gera_sonda
;              (0,1,2) indica que e para disparar e para onde, 3 indica que e para movimentar
;		
; **********************************************************************

PROCESS SP_sonda

proc_sonda:

    MOV R0, [int_movimenta_gera_sonda]     ; bloqueia o processo e da a indicacao do que e para fazer: disparar (0,1,2) ou movimentar


    MOV R4, [estado_jogo]    ; verifica o estado do jogo
    CMP R4, PAUSA            ; se estiver pausado, bloqueia o processo
    JZ pause_sonda
    CMP R4, JOGO             ; se nao estiver em jogo, bloqueia o processo
    JNZ game_over_sonda      ; bloqueia o processo


    MOV R2, DEF_SONDA                   ; guarda o endereço da tabela de desenho da sonda 


    MOV R9, controlo_sondas             ; guarda o endereço da tabela de controlo das sondas
                                        
                                        ; verifica se é para movimentar ou gerar sonda
    MOV R5, TECLA_DISPARO_FRENTE        ; se o processo foi desbloqueado por uma tecla de disparo
    CMP R0, R5                          ; verifica qual foi a tecla
    JZ disparo_frente                   
                                        ; e verifica se está em condicoes de disparar
                                        ; ou seja criar uma nova sonda na respetiva direção
    MOV R5, TECLA_DISPARO_ESQUERDA
    CMP R0, R5
    JZ disparo_esquerda
    
    MOV R5, TECLA_DISPARO_DIREITA
    CMP R0, R5
    JZ disparo_direita

    JMP movimenta_sondas                ; se não for para disparar, é para movimentar as sondas

disparo_frente:                         
                                        ; se nao existir sonda, cria uma nova sonda
    MOV R1, [R9 + 2]                    ; vai buscar o endereço da tabela de controlo da sonda frente
    MOV R4, [R1]                        ; Alcance da sonda frente, se o alcance for 0 e porque nao existe sonda
    CMP R4, 0
    JNZ proc_sonda                      ; se já existir uma sonda (alcance diferente de 0), não faz nada

gera_sonda_frente:                      ; se nao existe, gera uma nova sonda nessa direcao
    CALL rot_gera_sonda



    JMP proc_sonda

disparo_esquerda:                       
                                        
    MOV R1, [R9]                        ; vai buscar o endereço da tabela de controlo da sonda da esquerda
    MOV R4, [R1]                        ; Alcance da sonda da esquerda, se o alcance for 0 e porque nao existe sonda
    CMP R4, 0
    JNZ proc_sonda                      ; se já existir uma sonda (alcance diferente de 0), não faz nada

gera_sonda_esquerda:                    ; se nao existe, gera uma nova sonda
    CALL rot_gera_sonda

    JMP proc_sonda


disparo_direita:                            
                
    MOV R1, [R9 + 4]                    ; vai buscar o endereço da tabela de controlo da sonda  da direita
    MOV R4, [R1]                        ; Alcance da sonda da direita, se o alcance for 0 e porque nao existe sonda
    CMP R4, 0
    JNZ proc_sonda                      ; se já existir uma sonda (alcance diferente de 0), não faz nada

gera_sonda_direita:                     ; se nao existe, gera uma nova sonda
    CALL rot_gera_sonda

    JMP proc_sonda


movimenta_sondas:                       ; movimenta as sondas existentes, faz um loop para cada sonda
                                        ; se ja chegaram ao alcance maximo, destroi a sonda
    CALL rot_movimenta_sondas
    JMP proc_sonda

pause_sonda:
    MOV R0, [LOCK_jogo_pausado]          ; bloqueia o processo enquanto o jogo esta pausado
    JMP proc_sonda

game_over_sonda:
    MOV R0, [LOCK_game_over]             ; bloqueia o processo quando o jogo termina
    JMP proc_sonda



; **********************************************************************
; processo
;
; colisao_sonda_asteroide - Processo que verifica se alguma sonda colidiu com algum asteroide,
; se sim, o asteroide explode ser for não minerável ou diminui até desaparecer se for minerável
;
; 
; **********************************************************************

PROCESS SP_colisoes

proc_colisao_sonda_asteroide:
    
    MOV R1, [LOCK_colisoes]     ; bloqueia o processo (mas faz uma vez) e lê a tabela da sonda

    MOV R0, controlo_sondas     ; guarda a tabela de controlo das sondas             
    
    MOV R9, controlo_asteroides         ; guarda a tabela de controlo dos asteroides
    
    verifica_colisao_direcoes:
        MOV R1, [R0]                ; vai buscar o endereço da tabela de controlo de uma sonda
        MOV R4, 10                  ; auxiliar
        MOV R5, [R1+R4]             ; vai buscar a coluna inicial da sonda

        MOV R3, COLUNA_SONDA_ESQ    ; guarda o valor da coluna da esquerda
        CMP R5, R3                  ; compara R5 com a coluna inicial da sonda
        JZ verifica_colisao     

        MOV R3, COLUNA_SONDA_MEIO   ; guarda o valor da coluna do meio
        CMP R5, R3                  ; compara R5 com a coluna inicial da sonda
        JZ verifica_colisao         

        MOV R3, COLUNA_SONDA_DIR    ; guarda o valor da coluna da direita
                                    ; senao for nenhuma das sondas anteriores tem necessariamente 
                                    ; de ser a sonda da direita

    verifica_colisao:
        CALL rot_processa_colisao   ; chama a rotina que verifica e trata se houverem a/as colisões

    proxima_sonda_colisao:

        ADD R0, 2
        MOV R11,controlo_sondas     ; sao 3 sondas logo o enderço da ultima sonda e o endereço da tabela de controlo + 4
        ADD R11, 4                  ; guarda o ultimo endereco

        CMP R0, R11                     ; compara se ja chegou ao fim da tabela de controlo das sondas
        
        JLE verifica_colisao_direcoes   ; se nao chegou, verifica as colisoes da proxima sonda

    JMP proc_colisao_sonda_asteroide


; **********************************************************************
; Rotina 
; - verifica se existem colisões no eixo central e faz a explosão se for caso disso
;  
; - PARÂMETROS:    
;              R1 - tabela da sonda
;              R3 - coluna inicial da sonda
;              
; 
; - RETORNA: R0 (número entre 0 e 3) e R1 (número entre 0 e 4)
; **********************************************************************
rot_processa_colisao:
    PUSH R0
    PUSH R2 
    PUSH R3 
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R8
    PUSH R9
    PUSH R11

    verifica_linha:
        MOV R5, [R9]                ; guarda a tabela do asteroide
        MOV R6, [R5+6]              ; guarda a tabela que contem a coluna inicial e o incremento 
        MOV R11, [R5+2]             ; guarda a tabela que contém a posição do asteroide
        MOV R2, [R11]               ; guarda a linha do asteroide
        MOV R8, 10                  ; auxiliar
        CMP R2, R8                  ; se a primeira linha do asteroide for menor ou igual a 10 quer dizer que 
                                    ; a sua linha final é menor ou igual a 14, e a sonda só alcança até à linha 15 
        JLE prox_asteroide
    
    obtem_posicao_sonda:
        MOV R0, [R1+2]          ; guarda a linha da sonda 
        MOV R4, [R1+4]          ; guarda a coluna da sonda

    MOV R6, [R11+2]             ; guarda a coluna do asteroide
    
    verifica_igualdade_coluna_meio:
        
        ADD R6, 2                   ; coluna do meio (onde a sonda vai bater)
        CMP R6, R3                  ; compara a coluna do asteroide com a coluna inicial da sonda,
        JNZ verifica_igualdade_direcao          ; só dá para este caso pois ambas as colunas não mudam
        
        CMP R0, R2                  ; verifica se a sonda está acima da primeira linha do asteroide
        JLT prox_asteroide          ; se a linha da sonda for menor que a linha do asteroide salta
        ADD R2, 4                   ; R2 passa a conter a última linha do asteroide
        CMP R0, R2                  ; verifica se a sonda está abaixo da última linha do asteroide
        JGT prox_asteroide          ; se a linha da sonda for maior que a do asteroide então ainda não lá chegou



    colisao:
        CALL rot_trata_colisao      
        JMP fim_processa_colisao

    verifica_igualdade_direcao:
        
        CMP R0, R2                  ; verifica se a sonda está acima da primeira linha do asteroide
        JLT prox_asteroide          ; se a linha da sonda for menor que a linha do asteroide salta
        ADD R2, 4                   ; R2 passa a conter a última linha do asteroide
        CMP R0, R2                  ; verifica se a sonda está abaixo da última linha do asteroide
        JGT prox_asteroide          ; se a linha da sonda for maior que a do asteroide então ainda não lá chegou
        
        CMP R4, R6                  ; verifica se a sonda está à esquerda
        JLT prox_asteroide          ; se estiver à esquerda (menor coluna) salta
        ADD R6, 4                   ; R6 passa a conter a últlima coluna
        CMP R4, R6                  ; verifica se a sonda está à direita
        JGT prox_asteroide          ; se estiver à esquerda (maior coluna) salta

        JMP colisao                 ; se não saltou nenhuma vez é porque aconteceu colisão

    prox_asteroide:     
    MOV R11, controlo_asteroides    ; auxiliar    
    ADD R11, 6              ; guarda o valor máximo da tabela controlo em que ainda existe uma tabela de controlo de um asteroide
    ADD R9, PROXIMO_ASTEROIDE       ; passa a apontar para a tabela de controlo do próximo asteroide
    CMP R9,R11          
    JLE verifica_linha      ; recomeça o loop para verificar se a sonda bateu com o próximo asteroide     

fim_processa_colisao:
    POP R11
    POP R9
    POP R8
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R0
    RET


; **********************************************************************
; Rotina 
; - verifica se existem colisões no eixo central e faz a explosão se for caso disso
;  
; - PARÂMETROS:    
;              R1 - sonda
;              R5 - tabela do asteroide 
;              R11 - tabela posição do asteroide
;              
;
; **********************************************************************

; To do: fazer a explosão e reinicializar tanto o asteroide como a sonda

rot_trata_colisao:
    PUSH R0
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R10
  
    apaga_sonda:
        CALL rot_desenha_sonda

    obtem_tipo_asteroide:
        MOV R0, [score]                     ; guarda o valor do score atual
        ADD R0, 1                           ; aumenta o score em 1 devio à destruição do asteroide
        MOV [score], R0                     ; atualiza o score (EXECUTA AS OPERACOES EM HEXADECIMAL)

        MOV R0, [R5+4]                      ; obtém a tabela que indica o tipo de asteroide
        MOV R2, DEF_ASTEROIDE_MINERAVEL     ; guarda a constante com o endereço da tabela do tipo minerável
        CMP R0, R2                          ; verifica se é minerável ou não
        JZ minera_asteroide

        
    explosao:                               ; colisao da sonda com asteroide nao mineravel                            
        MOV R4, SOM_ASTEROIDEDESTRUIDO
        MOV [TOCA_SOM], R4                  ; toca o som da explosão do asteroide não minerável 
                                            
        MOV R2, DEF_EXPLOSAO_ASTEROIDE
        MOV R8, 1
        MOV [R5], R8
        MOV R7, [R11]                       ; obtém a linha do asteroide
        MOV R4, [R11+2]                     ; obtém a coluna do asteroide
        CALL rot_desenha_asteroide_e_nave   ; desenha a explosão no local do asteroide
       
        JMP muda_estado_para_explodido

    minera_asteroide:                       ; recebe R2 com DEF_ASTEROIDE_MINERAVEL
        MOV R4, SOM_ASTEROIDEMINERAVEL
        MOV [TOCA_SOM], R4                  ; toca o som da colisao da sonda com o asteroide minerável
        
        MOV R4, DISPLAY_AUMENTA_ENERGIA
        MOV [int_energia_display], R4       ; indica que a energia aumentou (25%)
                                            ; desbloqueia o processo display para atualizar o display
                                            ; face ao aumento da energia 
    muda_estado_para_explodido:
        MOV R8,2
        MOV [R5], R8                     ; guarda na sua tabela de controlo que foi explodido

    reinicializa_valores_sonda: ; basta o alcance pois o movimento da sonda trata do resto    
        MOV R4, 0
        MOV [R1], R4    ; reinicializa o alcance da sonda

        MOV R4, LINHA_SONDA
        MOV [R1+2], R4                  ; volta a linha inicial
        MOV R4, 10
        MOV R7, R1                      ; guarda o endereço da primeira WORD da sonda 
        ADD R7, R4                      ; guarda o endereço da última word da sonda (coluna inicial)
        MOV R4, [R7]                    ; guarda o valor da coluna inicial 
        MOV [R1+4], R4                  ; volta a coluna incial

fim_trata_colisao:
    POP R10
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R0
    RET


; **********************************************************************
; Rotina 
; - 
;  
; - PARÂMETROS:    
;              R5 - tabela de um asteroide que explodiu 
;              
;
; 
; - RETORNA: 
; **********************************************************************

rot_apaga_explodidos:
    PUSH R0 
    PUSH R1 
    PUSH R3 
    PUSH R4 
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R10
    PUSH R11

    MOV R11, [R5+2]     ; guarda a tabela de posição do asteroide
    MOV R0, [R5+4]      ; guarda a tabela que define o tipo de objeto
    MOV R1, DEF_ASTEROIDE_MINERAVEL
    MOV R8, -1
    MOV [R5], R8        ; força o estado de R5 a -1 para apagar
    MOV R7, [R11]       ; guarda a linha do asteroide
    MOV R4, [R11+2]     ; guarda a coluna do asteroide
    CMP R0, R1          ; no caso do asteroide ser minerável vai para o desaparecimento do minerável
    JZ retira_anel_exterior_mineravel

    
    

    apaga_explosao:     ; no caso de ser não minerável
        MOV R1, -1
        MOV [R5], R1    ; força o estado de R5 a -1 para apagar
        CALL rot_desenha_asteroide_e_nave   ; apaga a explosão   
        JMP reinicializa_valores_asteroide  ; reinicia os valores do asteroide  

    retira_anel_exterior_mineravel:

        MOV R0, 8                       ; auxiliar
        MOV R1, [R5+8]                  ; guarda o ecrã de pixeis do asteroide
        MOV [SELECIONA_ECRA_PIXEIS], R1 ; seleciona o ecrã de pixeis de modo a que tudo o que for
                                        ; desenhado/apagado nesta rotina seja nesse ecrã

        MOV R0, 10          ; incremento adicionado ao endereço inicial da tabela asteroide(R5) 
                            ; para passar a apontar para o estado de desaparecimento
        MOV R1, [R5+R0]             ; guarda o estado de desaparecimento do asteroide
        CMP R1, 0
        JZ apaga_5x5_desenha_3x3
        CMP R1, 1
        JZ apaga_3x3_desenha_1x1
        ; no caso de não ser nenhum dos anteriores
    
    apaga_1x1:

        MOV R3, 0                   ; cor dos pixels (0 para apagar)
        ADD R7, 2                   ; obtém linha quadrado 1v1
        ADD R4, 2                   ; obtém coluna 
        MOV  [DEFINE_LINHA], R7	    ; seleciona a linha
        MOV  [DEFINE_COLUNA], R4	; seleciona a coluna
        MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas
        MOV R6, 3                   ; novo valor a dar ao estado de desaparecimento
        MOV [R5+R0], R6             ; altera o asteroide restante para apagado
        JMP reinicializa_valores_asteroide  ; apaga_1x1 é o último estado antes de apagar tudo,
                                    ; logo só depois deste é que se pode reiniciar os valores do asteroide

    apaga_3x3_desenha_1x1:
        ADD R7, 1
        ADD R4, 1
        MOV R2, DEF_ASTEROIDE_MINERAVEL_3x3     ; atualiza R2 para a tabela do asteroide 3x3
        MOV R10, -1                             ; atualiza R10 para apagar
        CALL rot_desenha_asteroide_e_nave           ; apaga asteroide minerável 3x3
        
        ADD R7, 1                   ; obtém linha do pixel do centro a desenhar
        ADD R4, 1                   ; obtem coluna
        MOV R3, AMARELO
        MOV  [DEFINE_LINHA], R7	    ; seleciona a linha
        MOV  [DEFINE_COLUNA], R4	; seleciona a coluna
        MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas
        MOV R6, 2                   ; novo valor a dar ao estado de desaparecimento
        MOV [R5+R0], R6             ; atualiza o estado de desaparecimento do
        JMP fim_apaga_explodidos

    ; acabar amanha
    apaga_5x5_desenha_3x3:
        MOV R6, -1
        MOV [R5], R6
        CALL rot_desenha_asteroide_e_nave   ; apaga o asteroide minerável

        ADD R7, 1                       ; obtém a linha inicial do asteroide 3x3
        ADD R4, 1                       ; obtém a coluna inicial
        MOV R2, DEF_ASTEROIDE_MINERAVEL_3x3
        MOV R10, 1
        CALL rot_desenha_asteroide_e_nave
        MOV R6, 1                   ; novo valor a dar ao estado de desaparecimento
        MOV [R5+R0], R6             ; altera o asteroide restante para apagado 
        JMP fim_apaga_explodidos

    reinicializa_valores_asteroide:
        MOV R4, 0       ; MOV auxiliar
        MOV [R5], R4    ; muda o estado do asteroide para 0 para indicar que vai deixar de existir
        MOV [R11], R4   ; reinicia a linha do asteroide a 0 
        MOV R7, [R5+6]  ; guarda endereço da tabela da posição inicial e incremento do asteroide
        MOV [R7+4], R4  ; altera o estado dessa tabela para 0
        MOV R6, 10
        MOV [R5+R6], R4
    
fim_apaga_explodidos:
    POP R11
    POP R10
    POP R8
    POP R7
    POP R6
    POP R4
    POP R3
    POP R1
    POP R0
    RET

;MOV R3, AMARELO
;        MOV  [DEFINE_LINHA], R7	    ; seleciona a linha
;        MOV  [DEFINE_COLUNA], R4	; seleciona a coluna
;        MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas
;        MOV R3, 0
;        MOV  [DEFINE_LINHA], R7	    ; seleciona a linha
;        MOV  [DEFINE_COLUNA], R4	; seleciona a coluna
;        MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas
        

; **********************************************************************
; Rotina 
; - movimenta as sondas
;
;
; PARÂMETROS - R9 - endereço controla sondas
; **********************************************************************

rot_movimenta_sondas:
    PUSH R0
    PUSH R1
    PUSH R3
    PUSH R5
    PUSH R6

    MOV R0, 0                           ; contador
    
    movimento_sondas:

        MOV R1, [R9+R0]                 ; endereço da tabela de uma sonda
        MOV R3, [R1]                    ; alcance da sonda
        
        CMP R3, 0                       ; se o alcance for 0, passa à próxima sonda
        JZ proxima_sonda      


        movimento_cada_sonda:
        
            CALL rot_desenha_sonda          ; apaga a sonda
            
            CALL rot_atualiza_posicao       ; atualiza o alcance e a posição da sonda (linha e coluna) 
            
            MOV [LOCK_colisoes], R1         ; desbloqueia o processo que verifica as colisões com uma variável qualquer

            MOV R3, [R1]                    ; alcance da sonda (intrução repetida pois o processo desbloqueado
                                            ; em acima pode alterar o alcance da sonda para 0)
            CMP R3, 0                       ; no caso do alcance ser 0 irá reiniciar a posição da sonda
            JZ reinicia_linha_e_coluna      ; se não for 0 irá continuar o movimento (desenhando na próxima posição)

            desenha:                        ; se o alcance não for 0
            CALL rot_desenha_sonda          ; deseja a sonda na nova posição
            JMP proxima_sonda

        reinicia_linha_e_coluna:            ; reinicia a linha e a coluna da sonda caso tenha chegado ao alcance maximo
            MOV R5, LINHA_SONDA
            MOV [R1+2], R5                  ; volta a linha inicial
            MOV R5, 10
            MOV R6, R1                      ; guarda o endereço da primeira WORD da sonda 
            ADD R6, R5                      ; guarda o endereço da última word da sonda (coluna inicial)
            MOV R5, [R6]                    ; guarda o valor da coluna inicial 
            MOV [R1+4], R5                  ; volta a coluna incial
            MOV R5, 0
            MOV [R1+8], R5
        
        proxima_sonda:                      ; passa para a próxima sonda
            ADD R0, 2
            CMP R0, 6                       
            JLT movimento_sondas            ; se já passou por todas as sondas, termina


    fim_movimenta_sondas:
        POP R6
        POP R5
        POP R3
        POP R1
        POP R0
        RET


; **********************************************************************
; Rotina 
;
; Desenha a sonda na posição inicial de acordo com a tecla carregada (0,1,2)
; E desbloqueia o processo do display para diminuir a energia em 
; 5% por cada nova sonda disparada 
;  
; **********************************************************************

rot_gera_sonda:                 
    PUSH R0
    PUSH R1
    PUSH R3
    PUSH R10

    MOV R3, ALCANCE_SONDA               ; guarda o alcance máximo da sonda
    MOV [R1], R3                        ; inicia o alcance da sonda
    
    CALL rot_desenha_sonda              ; desenha a sonda na posição inicial da nave

    MOV R10, SOM_DISPARO
    MOV [TOCA_SOM], R10                 ; toca o som de disparo da sonda

    MOV R10, DISPLAY_ENERGIA_SONDA      ; guarda o valor de diminuição de energia por cada sonda criada


    MOV [int_energia_display], R10      ; desbloqueia o processo de atualização do display de energia, para diminuir a energia por cada sonda criada
    

    POP R10
    POP R3
    POP R1
    POP R0
    RET

; **********************************************************************
; Rotina Apaga Sondas Game Over
;
; Apaga as sondas existentes no painel de jogo quando o jogo termina e está prestes a recomecar
;
; Coloca as variaveis de modo a estarem prontas para o proximo jogo, iniciando as para a posição inicial
; 
; PARAMETROS: R1 - endereço da tabela de controlo das sondas
;             R11 - endereço máximo da tabela de controlo
; **********************************************************************


rot_apaga_sondas_gameover:
    PUSH R1
    PUSH R2
    PUSH R4
    PUSH R5
    PUSH R10
    PUSH R11



    MOV R1, controlo_sondas         ; guarda o endereço da tabela controlo das sondas
    MOV R11, R1
    ADD R11, 4                      ; guarda o endereço máximo da tabela controlo contida em R9 (limite)
                                    ; existem 3 sondas, logo o endereço máximo é R9+4, visto que cada sonda representa 1 WORD na tabela


reseta_sondas:


    MOV R5, [R1]                    ; guarda o endereço da tabela de uma sonda
    MOV R10, [R5+8]                 ; guarda o estado da sonda
    CMP R10, 0                      ; se o estado da sonda for 0, a sonda não existe e passa a proxima sonda
    JZ reseta_proxima_sonda

    MOV R10, 0                      ; coloca o estado da sonda a 0
    MOV [R5+8], R10                 ; atualiza o estado da sonda na tabela
    
    MOV R10 , 0                     ; coloca o alcance da sonda a 0
    MOV [R5], R10                   ; atualiza o alcance da sonda na tabela

    MOV R10, LINHA_SONDA
    MOV [R5+2], R10                 ; coloca as sondas para serem desenhadas na linha inicial
    MOV R10, [R5 + 10]              ; guarda o valor da coluna inicial onde a sonda deve ser desenhada
    MOV [R5+4], R10                 ; coloca as sondas para serem desenhadas na coluna inicial

reseta_proxima_sonda:
    ADD R1, 2                       ; passa para a próxima sonda
    
    CMP R1, R11                     ; verifica se R9 é inferior ao limite da tabela controlo
    JLE reseta_sondas

    MOV R4, ECRA_PIXEIS_SONDA_NAVE
    MOV [APAGA_UM_ECRA], R4            ; apaga o ecrã da sonda e da nave


fim_apaga_sonda_gameover:

    POP R11
    POP R10
    POP R5
    POP R4
    POP R2
    POP R1
    RET


; **********************************************************************
; Rotina 
; - verifica se a coluna do asteroide está no intervalo das colunas da nave
; - se a linha do asteroides corresponder à linha anterior da linha da nave existe colisão,
;   pois esta rotina é chamada no movimento antes de atualizar a posição
; RETORNA: se houver colisão, R6 como estado do jogo (R6 = colisão)
;  
; **********************************************************************
rot_testa_colisao_nave:
    PUSH R0
    PUSH R1
    PUSH R5
    PUSH R7

    MOV R0, [R9]        ; acede à tabela de controlo do asteroide a usar no momento
    MOV R6, [R0+6]      ; guarda o nome da tabela da posição/incremento do asteroide
    
    ; as próximas duas comparações servem para vermos se o asteroide é um dos que começa
    ; no meio e anda para uma das diagonais, se sim então nunca irá bater na nave
    MOV R5, inicio_meio_move_esquerda   ; guarda o endereço desta tabela para comparar
    CMP R5, R6
    JZ fim_testa_colisao_nave

    MOV R5, inicio_meio_move_direita    ; guarda o endereço desta tabela para comparar
    CMP R5, R6
    JZ fim_testa_colisao_nave

    ; Como sabemos que os asteroides que andam noutros sentidos vão todos parar à nave se
    ; não forem destruídos, basta comparar a sua linha com a linha anterior à linha da nave
    testa_colisao:
        MOV R1, [R0+2]                  ; guarda o endereço da tabela de posição do asteroide
        MOV R7, [R1]                    ; guarda a linha do asteroide no momento 
        ADD R7, 4                       ; passa à última linha do asteroide
        MOV R5, LINHA_NAVE              ; guarda a linha da nave em R5
        SUB R5, 1                       ; passa à linha anterior da nave
        CMP R7, R5                      ; compara a linha do asteroide com a linha anterior da nave
        JNZ fim_testa_colisao_nave      ; no caso de não haver colisão 
        MOV R6, COLISAO                 ; no caso de haver colisão muda o estado do jogo para colisão
        MOV [estado_jogo], R6           ; o estado do jogo passa a colisão
        MOV [LOCK_game_over], R6        ; desbloqueia o proc_fim_jogo

fim_testa_colisao_nave:
    POP R7
    POP R5
    POP R1
    POP R0
    RET


; **********************************************************************
; Rotina 
; - verifica se um asteroide chegou ao limite do ecrã ou não (se a linha for igual a 31)
; RETORNA: R8 com 1 se chegou ao limite ou 0 se não chegou
; **********************************************************************
rot_testa_limites:
    PUSH R0
    PUSH R1
    PUSH R5
    PUSH R4
    PUSH R7


    MOV R8, 0           ; inicia a variável que indica se chegou ao limite
    MOV R0, [R9]        ; acede à tabela de controlo do asteroide a usar no momento
    MOV R1, [R0+2]      ; guarda a tabela da posição do asteroide
    MOV R7, [R1]        ; guarda a linha do asteroide
    MOV R4, MAX_LINHA   ; guarda a linha máxima para comparar à do asteroide
    CMP R7, R4
    JLT fim_testa_limites

    chegou_limite:
        MOV R8, 1          ; se chegou ao limite R5 passa para 1
        MOV R4, 0          ; MOV auxiliar
        MOV [R0], R4       ; muda o estado do asteroide para 0 para indicar que vai deixar de existir
        MOV [R1], R4       ; reinicia a linha do asteroide a 0 
        MOV R5, [R0+6]     ; guarda endereço da tabela da posição inicial e incremento do asteroide
        MOV [R5+4], R4     ; altera o estado dessa tabela para 0

fim_testa_limites:

    POP R7
    POP R5
    POP R4
    POP R1
    POP R0
    RET

; **********************************************************************
; Rotina 
; - gera dois números aleatórios, um entre 0 e 3, outro entre 0 e 4
;  
; - PARÂMETROS:    
;              R2 - Máscara de 2 bits
;              R4 - endereço do periférico PIN
; 
; - RETORNA: R0 (número entre 0 e 3) e R1 (número entre 0 e 4)
; **********************************************************************

rot_gera_aleatorio:
    
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R6

    MOV R2, MASCARA_2_BITS   ; será utilizado para isolar os 2 bits de menor peso de um valor
    MOV R6, MASCARA_MAIS_SIGNIFICATIVOS ; será utilizado para isolar os 4 bits de maior peso
    MOV R3, 5
    MOV R4, PIN             ; guarda o endereço do periférico PIN
    MOVB R0, [R4]           ; guarda o valor do periférico
    AND R0, R6              ; guarda apenas os bits 4 a 7 do periférico 
    SHR R0, 4               ; coloca os bits lidos antes (4 a 7) nos bits 0 a 3, de modo a ficar com um valor entre 0 e 15
    MOV R1, R0              ; guarda esse valor em R1

    AND R0, R2              ; isola os 2 bits de menor peso, o que dá 4 hipóteses (00,01,10,11) de 0 a 3
    MOD R1, R3              ; R1 = resto da divisão de R1 por 5 de modo a ficarmos com 5 hipóteses (0 a 4)

fim_gera_aleatório:
    POP R6
    POP R4
    POP R3
    POP R2
    RET


; **********************************************************************
; Rotinas de interrupção
; - rotinas que atendem as interrupções, uma para cada relógio exterior
; apenas escrevem algo no lock do processo respetivo de modo a desbloqueá-lo  
;
; **********************************************************************



rot_int_0:                  ; Rotina que trata a interrupção 0 (Relogio de 400ms)
	PUSH R2
	MOV R2, int_asteroide
	MOV [R2], R1            ; Desbloqueia o processo dos asteroides para os movimentar
	POP R2
	RFE


rot_int_1:                  ; Rotina que trata a interrupção 1 (Relogio de 200ms)
	PUSH R0
    MOV R0, MOVIMENTACAO_SONDAS 
	MOV [int_movimenta_gera_sonda], R0 ; Desbloqueia o processo das sondas para as movimentar
	POP R0
	RFE


 rot_int_2:                 ; Rotina que trata a interrupção 2 (Relogio de 3s)
 	PUSH R0                 
 	MOV R0, DISPLAY_ENERGIA_INT
 	MOV [int_energia_display], R0   ; Desbloqueia o processo display para diminuir a energia da nave em 3%
 	POP R0
 	RFE
 

rot_int_3:                  ; Rotina que trata a interrupção 3 (Relogio de 300ms)
	PUSH R0                  
	MOV R0, int_painel_nave 
	MOV [R0], R1            ; Desbloqueia o processo do painel da nave para alterar as cores do painel
	POP R0
	RFE
