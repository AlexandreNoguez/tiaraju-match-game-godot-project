# Arquitetura Inicial do Projeto

## Objetivo

Organizar o jogo com uma arquitetura modular, simples de manter e pronta para crescer sem virar um unico script gigante.

## Abordagem Recomendada

Para este projeto, a melhor base nao e um DDD "puro" e pesado, e sim uma arquitetura inspirada em dominio com separacao clara entre:

- `domain`: regras puras do tabuleiro e das mecanicas
- `application`: casos de uso que orquestram o fluxo do jogo
- `presentation`: cenas, HUD, animacoes e input
- `infrastructure`: leitura de arquivos, save local e integracoes externas

Essa abordagem funciona melhor para jogos pequenos e medios porque mantem a regra importante desacoplada da interface.

## Principios

1. Regras de match-3 nao dependem de UI.
2. HUD e animacoes nao decidem regra de jogo.
3. Arquivos de fase sao dados, nao scripts hardcoded.
4. Save local e futuras APIs ficam fora do dominio.
5. Cada sistema faz uma coisa principal.

## Camadas

### Domain

Responsavel por:

- estado do tabuleiro
- pecas
- celulas
- deteccao de match
- regras de especiais
- regras de obstaculos
- objetivos

Nao deve depender de:

- cenas
- botoes
- arquivos da UI
- SDKs externos

### Application

Responsavel por:

- iniciar fase
- aplicar troca
- resolver turno
- encerrar fase
- salvar progresso

Ela conversa com o dominio e com gateways simples de infraestrutura.

### Presentation

Responsavel por:

- cenas da Godot
- renderizacao do tabuleiro
- HUD
- telas de vitoria, derrota e pausa
- feedback visual
- input do jogador

### Infrastructure

Responsavel por:

- ler JSON de fases
- salvar progresso local
- no futuro, conversar com backend

## Estrutura de Pastas

```text
assets/
data/
  levels/
docs/
scenes/
  bootstrap/
scripts/
  application/
    use_cases/
  bootstrap/
  domain/
    board/
      models/
      services/
  infrastructure/
    levels/
    persistence/
  presentation/
    board/
```

## Convencoes

- scripts pequenos e orientados por responsabilidade
- nomes explicitos para use cases
- classes de dominio sem efeitos colaterais desnecessarios
- JSON para fases e configuracoes
- dependencias externas concentradas em `infrastructure`

## Evolucao Planejada

Quando o projeto crescer, podemos expandir sem quebrar a base:

1. adicionar `domain/goals`
2. adicionar `domain/obstacles`
3. adicionar `presentation/board`
4. adicionar `presentation/ui`
5. adicionar `infrastructure/network`

## Regra de Ouro

Se uma logica precisa ser testada e validada como regra do jogo, ela deve morar em `domain` ou `application`, nao escondida dentro de uma cena.
