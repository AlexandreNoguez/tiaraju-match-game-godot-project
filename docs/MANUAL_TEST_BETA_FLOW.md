# Roteiro Manual do Fluxo Beta

## Objetivo

Validar o fluxo principal atual do jogo:

- `home -> fase -> home`
- progressao linear
- persistencia do save local

## Preparacao

1. Abrir o projeto na Godot.
2. Rodar a cena principal do jogo.
3. Observar no `home`:
   - `Fase atual`
   - `Maior desbloqueada`
   - `Ultima concluida`
   - `Fases concluidas no aparelho`

## Caso 1: Primeiro Boot sem Save

Passos:

1. Abrir o jogo sem progresso anterior.
2. Verificar a tela principal.
3. Pressionar `Jogar`.

Resultado esperado:

- o jogo abre no `home`
- a fase atual inicial e a `1`
- `Maior desbloqueada` mostra `1`
- `Ultima concluida` mostra `nenhuma`
- o botao `Jogar` entra na fase atual

## Caso 2: Vitoria e Retorno ao Home

Passos:

1. Concluir a fase atual.
2. Esperar o retorno automatico ao `home`.

Resultado esperado:

- a tela de vitoria aparece
- o jogo retorna ao `home`
- `Ultima concluida` mostra a fase vencida
- `Maior desbloqueada` avanca para a proxima fase, se existir
- `Fase atual` aponta para a proxima fase desbloqueada
- `Fases concluidas no aparelho` incrementa

## Caso 3: Derrota e Retorno ao Home

Passos:

1. Entrar na fase atual.
2. Perder a fase.
3. Esperar o retorno ao `home`.

Resultado esperado:

- a tela de derrota aparece
- o jogo retorna ao `home`
- `Fase atual` continua na mesma fase
- `Maior desbloqueada` nao retrocede
- `Ultima concluida` nao muda por causa da derrota

## Caso 4: Save Local Entre Sessoes

Passos:

1. Vencer pelo menos uma fase.
2. Fechar completamente o jogo.
3. Abrir novamente.

Resultado esperado:

- o jogo volta para o `home`
- `Fase atual` continua na maior fase desbloqueada
- `Maior desbloqueada` continua correta
- `Ultima concluida` continua correta
- `Fases concluidas no aparelho` continua correta

## Caso 5: Fluxo Curto da Campanha Inicial

Executar pelo menos este recorte:

1. vencer `010`
2. vencer `011`
3. tentar `012`
4. perder uma vez em `012`
5. vencer `012`

Resultado esperado:

- progresso linear funciona sem voltar para fase antiga
- derrota nao apaga progresso salvo
- vitoria destrava a fase seguinte

## Caso 6: Verificacao Visual do Home

No `home`, conferir:

- placeholders de avatar, eventos, perfil, moedas e `shop`
- textos legiveis
- informacoes de progresso atualizadas
- botao `Jogar` sempre coerente com a fase atual

## Caso 7: Atalho de Playtest em Debug

Passos:

1. Abrir `Configuracoes` no `home`.
2. Confirmar que a ferramenta de playtest aparece apenas em debug.
3. Selecionar uma fase como `010`, `020` ou `029`.
4. Abrir a fase pelo atalho.
5. Vencer ou perder e voltar ao `home`.

Resultado esperado:

- a fase escolhida abre corretamente
- a mensagem da fase informa que o save nao sera alterado
- ao voltar para o `home`, `Fase atual`, `Maior desbloqueada` e `Ultima concluida` continuam iguais ao save anterior

## Observacoes a Registrar

Durante o teste, anotar:

- fase em que houve bug
- passos exatos para reproduzir
- comportamento esperado
- comportamento observado
- se o problema afeta progressao ou save

## Prioridade de Correcao

Alta prioridade:

- fase errada sendo aberta
- save nao persistindo
- progresso regredindo
- retorno ao `home` falhando

Media prioridade:

- texto incorreto no `home`
- labels de progresso desatualizadas
- transicao visual estranha, mas sem quebrar o fluxo
