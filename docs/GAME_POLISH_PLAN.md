# Plano de Polimento

## Objetivo

Registrar o que ainda falta para o jogo sair do estado de `beta jogavel` e ganhar sensacao mais premium, mais proxima de um match-3 comercial moderno, sem perder a identidade propria do projeto.

## Leitura atual do projeto

Hoje o jogo ja tem:

- loop principal funcional
- cascatas, especiais e obstaculos basicos
- save local
- `home`
- audio basico
- primeiras passadas visuais com `Kenney UI Pack`
- gems novas da pasta `Sylly`

O que mais falta agora e camada de apresentacao, conteudo e meta game.

## Frentes principais de polimento

### 1. Juice do tabuleiro

- brilho melhor ao selecionar pecas
- efeitos de impacto ao remover combinacoes
- particulas leves em matches e especiais
- tremor sutil em explosoes e combos fortes
- entrada mais rica de especiais
- transicao de vitoria e derrota mais refinada

### 2. HUD e UX premium

- objetivos com icones em vez de texto puro
- contador de jogadas com hierarquia visual mais forte
- saldo de moedas visivel tambem na fase
- pre-fase simples com nome, objetivo e CTA claro
- vitoria e derrota com layout mais premium

### 3. Progressao e meta game

- mapa de fases em trilha visual
- marcos, baus e recompensas
- moedas com utilidade real
- `shop` offline com primeiros itens compraveis
- sistema de restauracao da vila ou colecao visual

### 4. Arte e identidade

- consolidar familia visual das gems, especiais e obstaculos
- fundos mais ricos por tema
- fontes mais legiveis e com melhor espacamento
- maior consistencia entre `home`, HUD, pausa e vitoria
- iconografia padronizada para objetivos, reward e status

### 5. Audio e sensacao geral

- SFX com mais peso para especiais
- trilhas mais coerentes com `home` e fase
- mix mais controlada entre musica e SFX
- variacao maior de feedback sonoro por situacao

### 6. Conteudo

- muito mais fases
- curva de dificuldade revisada com playtest
- mais familias de obstaculos
- tutorial guiado nas primeiras fases

## Ordem sugerida

1. polimento visual do board e da HUD
2. mapa de progressao
3. economia real com moedas e `shop`
4. maior pacote de conteudo
5. validacao forte em Android

## Estrategia de assets premium

### Objetivo pratico

No curto prazo, evitar trocar tudo de uma vez. O ideal e substituir por camadas:

1. primeiro fontes e HUD
2. depois gems, especiais e obstaculos
3. depois backgrounds e mapas
4. por fim personagens, `shop` e telas mais complexas

### O que procurar em packs

- PNGs separados por elemento
- consistencia de estilo entre gem, booster, obstaculo e HUD
- licenca clara para uso comercial em jogo
- arquivos fonte editaveis quando possivel
- resolucao boa para mobile
- icones de objetivos e boosters no mesmo estilo

### O que evitar

- packs sem licenca clara
- arte muito heterogenea
- fontes sem boa leitura em mobile
- kits gigantes sem necessidade imediata
- comprar muitos packs ao mesmo tempo antes de validar a direcao visual

## Plano de busca de assets

### Gems, especiais e match-3 premium

- avaliar packs completos de match-3 com gem, booster e obstaculo
- priorizar packs que tragam tambem UI ou backgrounds no mesmo estilo
- manter uma planilha simples com: link, preco, licenca, estilo e observacoes

### HUD e UI

- procurar kits mobile com botoes, paineis, icones e popups
- testar primeiro em mock de `home`, pausa e vitoria antes de trocar a HUD toda

### Fontes

- testar pelo menos 3 familias diferentes
- usar uma fonte para titulo e outra para texto/UI
- validar espaco entre letras e palavras em tela pequena

## Fontes candidatas para proxima rodada

- `Fredoka`
- `Baloo 2`
- `Bungee`

Uso sugerido:

- `Bungee` para titulos curtos, comemoracoes e chamadas
- `Fredoka` para botoes e UI principal
- `Baloo 2` para subtitulos e textos curtos mais amigaveis

## Sites para baixar ou comprar assets

### Gratuitos ou de baixo risco para prototipo

- Kenney: `https://kenney.nl/assets`
- OpenGameArt: `https://opengameart.org/`

### Bons para packs prontos de match-3 e mobile casual

- itch.io game assets: `https://itch.io/game-assets`
- CraftPix: `https://craftpix.net/`

### Links de referencia para match-3

- QuillGrafit Match 3 Flat Gems Asset Pack: `https://quillgrafit.itch.io/match-3-flat-gems-asset-pack`
- PixMeUp Flat Vector Match-3 Asset Pack: `https://pixmeup.itch.io/pixmeup-fvs-match-3-game-assets`
- HypeSupply gem-style assets: `https://hypesupply.itch.io/`
- CraftPix Match 3 Game Asset Set: `https://craftpix.net/product/match-3-game-asset-set/`
- CraftPix Match 3 Game Locations: `https://craftpix.net/product/match-3-game-locations/`
- CraftPix Match 3 Game Kit: `https://craftpix.net/sets/match-3-game-kit-asset/`

## Sites para fontes

- Google Fonts Fredoka: `https://fonts.google.com/specimen/Fredoka`
- Google Fonts Baloo 2: `https://fonts.google.com/specimen/Baloo+2`
- Google Fonts Bungee: `https://fonts.google.com/specimen/Bungee`

## Regras de compra e adocao

1. Registrar origem e licenca em `docs/ASSETS.md`.
2. Antes de comprar, decidir qual camada vamos trocar.
3. Preferir packs que resolvam um problema real do roadmap.
4. Testar visualmente em uma tela do jogo antes de espalhar pelo projeto inteiro.
5. Nao misturar varias direcoes artisticas conflitantes.
