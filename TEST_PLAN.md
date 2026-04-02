# Plano de Testes Locais

## 1. Objetivo

Definir como testar o jogo durante o desenvolvimento para detectar bugs cedo, validar mecanicas e garantir que a build Android continue funcionando.

## 2. Ferramentas Recomendadas

- `VSCode`: escrever codigo
- `Godot 4`: rodar e depurar o jogo no desktop
- `Android Studio`: SDK, ADB e emulador
- `celular Android real`: teste final de toque, desempenho e resolucao

## 3. Melhor Fluxo de Trabalho

### 3.1 Desenvolvimento diario

1. editar codigo no VSCode
2. rodar o projeto no desktop pela Godot
3. corrigir rapidamente bugs de logica
4. quando a mecanica estiver boa, testar no Android

### 3.2 Validacao Android

1. exportar build debug
2. instalar no celular real
3. testar toque, animacao e desempenho
4. repetir no emulador para validar tela e versoes diferentes

## 4. O Que Testar em Cada Etapa

### 4.1 Sempre que mexer no tabuleiro

- troca entre pecas adjacentes
- troca invalida retornando
- match horizontal
- match vertical
- gravidade
- refill
- cascata
- ausencia de travamento

### 4.2 Sempre que mexer em especiais

- criacao correta do especial
- ativacao correta
- interacao com pecas comuns
- interacao com outros especiais
- contagem correta nos objetivos

### 4.3 Sempre que mexer em obstaculos

- spawn correto
- bloqueio correto
- dano correto
- remocao correta
- interacao com especiais

### 4.4 Sempre que mexer na UI

- HUD atualiza movimentos
- HUD atualiza objetivos
- tela de vitoria aparece no momento certo
- tela de derrota aparece no momento certo
- escalas funcionam em resolucoes diferentes

## 5. Ambientes de Teste

### 5.1 Desktop

Use para:

- testar logica rapidamente
- reproduzir bugs
- ajustar fluxo do tabuleiro
- desenvolver com velocidade

### 5.2 Emulador Android

Use para:

- validar resolucoes diferentes
- validar proporcao de tela
- validar comportamento basico de toque
- testar versoes diferentes de Android, se necessario

### 5.3 Celular real

Use para:

- validar toque real
- medir fluidez
- verificar consumo de bateria e aquecimento
- validar tempo de carregamento
- verificar se a experiencia final esta boa

## 6. Roteiro Minimo por Build

Cada build nova deve passar nestes testes:

1. abrir o jogo
2. entrar em uma fase
3. fazer uma troca invalida
4. fazer uma troca valida
5. gerar um match-4
6. gerar um match-5
7. ativar especial manualmente
8. concluir uma fase
9. perder uma fase
10. fechar e abrir o jogo para validar save
11. repetir tudo no Android

## 6.1 Roteiro de curva para o pacote 010-029

Ao revisar a campanha inicial, testar nesta ordem:

1. `010-011`: onboarding de coleta de cor
2. `012-015`: introducao de caixa, gelo, grama e grama densa
3. `016-020`: consolidacao com tabuleiros maiores ou nao quadrados
4. `021-024`: layouts apertados e mistura de obstaculos
5. `025-029`: fechamento do pacote inicial com pico de dificuldade

Para cada fase, anotar:

- venceu ou perdeu
- numero de tentativas
- quantidade de movimentos restantes na vitoria
- se a fase foi facil, justa ou frustrante
- se o objetivo ficou claro

Se uma fase falhar repetidamente por falta de movimentos, primeiro ajustar `moves`.
Se a fase parecer caotica mesmo com muitas jogadas, revisar obstaculos e layout.

## 6.2 Roteiro manual do fluxo principal

Usar tambem o roteiro detalhado em `docs/MANUAL_TEST_BETA_FLOW.md`.

Esse fluxo deve validar:

- `home -> fase -> home`
- progressao linear entre fases
- persistencia do save local entre sessoes
- coerencia das informacoes exibidas no `home`

## 6.3 Atalho de playtest em debug

Em build de debug ou rodando pela Godot, o menu `Configuracoes` do `home` passa a exibir uma ferramenta de playtest.

Usar quando:

- precisar abrir rapidamente qualquer fase entre `001-029`
- revisar a curva `010-029` sem vencer manualmente todas as anteriores
- repetir uma fase varias vezes sem sujar o save principal

Resultado esperado:

- a fase selecionada abre normalmente
- o tabuleiro indica que esta em modo playtest
- vencer ou perder nao altera progresso salvo
- ao voltar para o `home`, a fase atual do save continua intacta

## 6.4 Regressao de moedas, chains e save

Depois das ultimas mudancas no tabuleiro, este pacote de regressao deve ser rodado no desktop e no Android:

1. entrar em uma fase
2. gerar uma combinacao simples
3. confirmar que so a combinacao atual some primeiro
4. confirmar a queda das pecas restantes
5. confirmar que a chain seguinte so desaparece depois de se formar
6. verificar o feedback visual de `Chain x2`, `Chain x3` e `+moedas`
7. concluir ou perder a fase
8. voltar ao `home`
9. confirmar que o total de moedas mudou como esperado
10. fechar e abrir o jogo para validar persistencia do saldo

Resultado esperado:

- pecas nao afetadas nao animam de novo
- nenhuma peca invade a area fora do grid
- moedas por chain aparecem de forma compreensivel
- saldo continua salvo entre sessoes

## 7. Quando Usar VSCode, Android Studio e Docker

### 7.1 VSCode

Excelente para escrever codigo, navegar pelos arquivos e manter organizacao.

### 7.2 Android Studio

Essencial para:

- instalar SDK
- usar ADB
- usar emulador
- inspecionar ambiente Android

### 7.3 Docker

Opcional e mais util depois, para:

- automacao de build
- padronizacao de ambiente
- pipelines futuras

Nao e a melhor ferramenta principal para testar um jogo mobile visual e interativo.

## 8. Criterio de Saude do Projeto

O projeto esta saudavel quando:

- novas mecanicas entram sem quebrar mecanicas antigas
- bugs sao reproduziveis
- build desktop funciona sempre
- build Android funciona com frequencia
- cada fase pode ser testada isoladamente

## 9. Recomendacao Final

Para este projeto, a melhor combinacao e:

1. `VSCode` para programar
2. `Godot` para iteracao rapida
3. `Android Studio` para SDK e emulador
4. `celular real` para aprovacao final

Se voce tiver que escolher apenas uma ferramenta adicional alem do VSCode, escolha `Android Studio`.

## 10. Guia Rapido para Aparelho Real

Usar tambem:

- [ANDROID_REAL_DEVICE_TEST.md](/mnt/c/workspaces/tiaraju-match-game-godot-project/docs/ANDROID_REAL_DEVICE_TEST.md)
