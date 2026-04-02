# Curva Inicial das Fases 010-029

## Objetivo

Documentar a intencao da curva inicial de dificuldade do primeiro pacote jogavel do beta, para facilitar balanceamento e playtest.

## Estrutura da Curva

### Fases 010-011

Onboarding leve de coleta de cor:

- foco em entender fluxo `home -> fase -> home`
- sem obstaculos
- baixa pressao de movimentos

### Fases 012-015

Apresentacao progressiva dos obstaculos:

- `012`: caixa
- `013`: gelo
- `014`: grama
- `015`: grama densa

Meta desta faixa:

- o jogador deve reconhecer rapidamente o comportamento de cada obstaculo
- a fase deve ensinar sem travar o ritmo

### Fases 016-020

Primeiro bloco intermediario:

- tabuleiros maiores ou nao quadrados
- mistura simples de objetivos
- inicio de leitura tática de tabuleiro

Meta desta faixa:

- consolidar as regras basicas
- aumentar variedade sem exigir dominio completo de especiais

### Fases 021-024

Bloco intermediario avancado:

- layouts mais apertados
- mistura de obstaculos
- mais casas mortas ou caminhos estreitos

Meta desta faixa:

- exigir mais planejamento
- manter sensacao de progresso sem parecer injusto

### Fases 025-029

Fechamento do pacote inicial:

- `025` funciona como fase-respiro de coleta
- `026-029` voltam a subir a pressao
- `029` fecha o pacote com mistura completa de obstaculos atuais

Meta desta faixa:

- dar sensacao de mini-campanha concluida
- preparar terreno para balanceamento fino antes do Android

## Ajustes Heuristicos Ja Aplicados

Para reduzir picos bruscos antes do primeiro playtest completo:

- fases com muitos obstaculos mistos receberam mais jogadas
- `025` foi mantida como fase-respiro antes do fechamento do pacote
- `029` ficou como pico local do conjunto

## Roteiro de Validacao da Curva

Durante o playtest das fases `010-029`, registrar:

- fase concluida ou nao
- quantidade de tentativas
- movimentos restantes na vitoria
- se a fase pareceu facil, justa ou frustrante
- se o objetivo foi entendido sem explicacao externa
- se o layout ajudou ou atrapalhou leitura do tabuleiro

## Sinais de Ajuste Necessario

Reduzir dificuldade se:

- a fase falhar repetidamente em mais de 3 tentativas
- o objetivo parecer confuso
- o jogador depender de sorte demais para vencer

Aumentar dificuldade se:

- a fase for vencida sempre com muitas jogadas sobrando
- o layout nao gerar decisao interessante
- o obstaculo principal quase nao influenciar a partida

## Alvo Pratico para o Primeiro Pass

- fases `010-015`: vencer na primeira tentativa com folga
- fases `016-024`: vencer em 1 a 2 tentativas
- fases `025-029`: vencer em 1 a 3 tentativas, sem parecer injusto
