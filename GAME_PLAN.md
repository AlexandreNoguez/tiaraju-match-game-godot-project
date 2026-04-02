# Planejamento Beta: Jogo Match-3 Inspirado em Royal Match

## 1. Visao do Projeto

Criar um jogo mobile de match-3 para Android, offline e sem compras internas, inspirado na sensacao de progresso, clareza de objetivos e combinacoes especiais de jogos como Royal Match, mas com identidade propria em ambientacao, personagens, arte, interface, sons, fases e progressao.

O foco da versao beta sera provar quatro pontos:

1. O tabuleiro e divertido.
2. As regras sao estaveis e previsiveis.
3. A progressao de fases funciona.
4. O jogo roda localmente em Android com boa fluidez.

## 2. Direcao Criativa

### 2.1 Premissa narrativa

Em vez de um castelo europeu, o jogo acontecera em uma vila ficcional inspirada em biomas e referencias culturais brasileiras. O jogador ajuda a restaurar, expandir e celebrar os espacos da comunidade por meio das vitorias nas fases.

### 2.2 Personagens principais

- protagonista jovem: heroi ficcional inspirado em liderancas indigenas do sul do Brasil
- companheiro carismatico: um papagaio
- lideranca da vila: ancia ou anciao sabio
- artesaos, pescadores, guardioes da mata e familiares como elenco secundario

### 2.3 Observacao cultural importante

Vale muito a pena evitar caricaturas ou uma mistura generica de povos reais. A recomendacao para o beta e:

- usar uma comunidade ficcional inspirada no Brasil
- usar nomes brasileiros e de origem indigena com cuidado
- usar figuras historicas reais apenas como referencia de valores e contexto, nao como avatar literal
- evitar copiar adornos sagrados, grafismos especificos ou elementos cerimoniais sem pesquisa
- tratar os personagens com dignidade, protagonismo e humanidade

### 2.4 Sugestao inicial de identidade

- nome provisiorio do projeto: `Aldeia das Cores`
- protagonista ficcional: `Tiaru`, `Sepan`, `Kaua` ou `Aira`
- papagaio companheiro: `Aru`
- ancia da vila: `Jaci`

Esses nomes sao so placeholders e podem ser ajustados depois.

### 2.5 Diretriz sobre Sepé Tiaraju

Para reduzir risco criativo, juridico e cultural, a melhor decisao para este projeto e:

- nao usar `Sepé Tiaraju` como personagem literal do jogo
- nao transformar uma figura historica e espiritual em mascote ou avatar gamificado
- usar sua historia apenas como inspiracao de coragem, lideranca, resistencia e defesa da comunidade
- criar um protagonista original, com visual, nome, biografia e arco proprios

Essa abordagem e mais segura do que tentar representar diretamente uma figura historica reverenciada.

## 3. Limites de Inspiracao

Este projeto pode ser inspirado nas mecanicas gerais de match-3, mas nao deve copiar:

- nome do jogo original
- personagens do jogo original
- layout da interface do jogo original
- artes, trilha, efeitos, textos e fases do jogo original
- balanceamento interno ou dados extraidos do jogo original

O caminho correto e recriar o sistema do zero com regras proprias e apresentacao propria.

## 4. Escopo da Versao Beta

### 4.1 Objetivo do beta

Entregar uma build Android local com um loop completo e confiavel de match-3, contendo conteudo suficiente para validar jogabilidade, dificuldade e arquitetura.

### 4.2 O que entra no beta

1. Tabuleiro com mascaras de fase.
2. Troca entre pecas adjacentes.
3. Match-3 horizontal e vertical.
4. Queda de pecas e reposicao aleatoria.
5. Cascatas.
6. Sistema de jogadas restantes.
7. Objetivos visiveis da fase.
8. Tela de vitoria e derrota.
9. Especiais basicos.
10. Primeiros obstaculos.
11. Progressao inicial de fases.
12. Salvamento local de progresso.
13. Export Android em modo debug.

### 4.3 O que fica fora do beta

- loja
- compras internas
- multiplayer
- eventos sazonais
- monetizacao
- conta online
- dezenas de efeitos visuais complexos
- localizacao multi-idioma
- geracao procedural avancada de fases infinitas

## 5. Stack Recomendada

### 5.1 Ferramentas principais

- engine: `Godot 4`
- linguagem: `GDScript`
- editor de codigo: `VSCode` ou o editor da propria Godot
- export Android: `Android Studio` + Android SDK + OpenJDK 17
- controle de versao: `Git`

### 5.2 Recomendacao pratica

Para iniciante, a combinacao mais simples e:

1. editar scripts no VSCode se voce gostar mais dele
2. abrir e rodar o jogo pela Godot
3. testar Android por dispositivo fisico USB ou emulador via Android Studio

## 6. Regras Base do Jogo

### 6.1 Tabuleiro

- o tabuleiro usa uma mascara que define quais casas existem
- pecas ocupam apenas casas validas
- novas pecas nascem no topo ou em spawners definidos
- o jogo deve impedir fases que comecem sem jogadas possiveis

### 6.2 Troca

- o jogador troca apenas pecas adjacentes
- a troca so e confirmada se gerar match ou ativar regra valida de especial
- trocas invalidas retornam para a posicao anterior

### 6.3 Match comum

- 3 ou mais pecas da mesma cor em linha horizontal ou vertical sao removidas
- apos remocao, a gravidade derruba as pecas
- espacos vazios sao preenchidos por novas pecas
- o sistema continua ate estabilizar o tabuleiro

### 6.4 Especiais do beta

- 4 em linha horizontal: cria missil horizontal
- 4 em linha vertical: cria missil vertical
- 5 em linha: cria coringa ou super luz

### 6.5 Combos de especiais do beta

- missil + missil
- coringa + peca comum
- coringa + missil

O combo `coringa + missil` deve transformar todas as pecas da cor selecionada em misseis e ativa-las.

## 7. Obstaculos do Beta

Os obstaculos entram por camadas para reduzir risco tecnico.

### 7.1 Ordem recomendada

1. caixa
2. gelo
3. grama
4. grama densa
5. sapo

### 7.2 Regras iniciais

- `caixa`: bloqueia a casa ou exige combinacoes adjacentes para quebrar
- `gelo`: exige uma ou mais limpezas sobre a casa
- `grama`: se espalha ou exige limpeza no local, conforme a regra escolhida para o projeto
- `grama densa`: precisa de dois impactos
- `sapo`: precisa de regras proprias de carregamento ou alimentacao por combinacoes proximas

O beta nao precisa ter a mesma semantica do jogo inspirador. Ele precisa ter regras consistentes e divertidas.

## 8. Estrutura Tecnica Recomendada

Separar responsabilidades desde cedo vai poupar retrabalho.

- `BoardManager`: estado bruto do tabuleiro
- `SwapSystem`: validacao e execucao de trocas
- `MatchFinder`: encontra matches
- `GravitySystem`: queda e reposicao
- `SpecialPieceSystem`: criacao e ativacao de especiais
- `ObstacleSystem`: comportamento dos obstaculos
- `GoalSystem`: acompanha objetivos da fase
- `LevelSystem`: le arquivos de fase
- `ProgressionSystem`: desbloqueio e escalada de dificuldade
- `SaveSystem`: progresso local
- `UIFlow`: HUD, vitoria, derrota, pausa e retorno

## 9. Formato de Dados das Fases

Cada fase deve ser definida em dados e nao codificada manualmente no script.

Campos recomendados:

- `id`
- `grid_mask`
- `moves`
- `allowed_colors`
- `spawn_weights`
- `goals`
- `obstacles`
- `special_rules`
- `difficulty_tier`
- `seed`

## 10. Progressao de Conteudo

### 10.1 Estrategia inicial

Antes de tentar 100 fases, construir:

1. 1 fase sandbox
2. 5 fases tecnicas de teste
3. 20 fases do primeiro pacote jogavel

### 10.2 Escalada por blocos

Depois do nucleo estavel:

- fases 1 a 20: tutorial e consolidacao
- fases 21 a 50: combinacoes especiais e metas mais variadas
- fases 51 a 100: obstaculos mistos
- a cada 100 fases: novo tier de dificuldade

### 10.3 Sistema "infinito"

O modo infinito deve vir depois do beta e usar geracao hibrida:

- biblioteca de mascaras
- biblioteca de objetivos
- biblioteca de configuracoes de obstaculos
- orcamento de dificuldade por faixa
- seeds reproduziveis

### 10.4 Direcao de progressao do beta

Para o fluxo principal do beta, seguimos estas regras:

- progressao linear, sem voltar para fases antigas no caminho principal
- o botao `Jogar` deve sempre abrir a fase atual desbloqueada
- a tela principal deve existir desde ja, mesmo com avatar, eventos, perfil e configuracoes ainda como placeholder
- o jogo deve continuar suportando grades com mascara nao quadrada
- a cada 100 fases, entra uma nova familia de obstaculo

Essas regras ajudam a manter o escopo enxuto, validam a arquitetura de progressao e evitam retrabalho quando o pacote de fases crescer.

## 11. Plano de Desenvolvimento Numerado para o Beta

### 11.1 Fase 0: preparacao

1. Instalar Godot 4.
2. Instalar Android Studio.
3. Instalar Android SDK.
4. Instalar OpenJDK 17.
5. Configurar dispositivo Android em modo desenvolvedor.
6. Criar repositorio Git.

### 11.2 Fase 1: prototipo do tabuleiro

1. Criar projeto Godot.
2. Criar cena principal.
3. Criar grid visual.
4. Criar pecas coloridas.
5. Implementar selecao e troca.
6. Implementar detecao de match.
7. Implementar remocao, queda e refill.
8. Implementar cascata ate estabilizar.

### 11.3 Fase 2: regras jogaveis

1. Adicionar contador de jogadas.
2. Adicionar objetivos simples.
3. Adicionar vitoria e derrota.
4. Bloquear input enquanto o tabuleiro resolve.
5. Garantir que o tabuleiro sempre tenha jogadas possiveis.

### 11.4 Fase 3: especiais

1. Implementar missil horizontal.
2. Implementar missil vertical.
3. Implementar coringa.
4. Implementar animacoes de ativacao.
5. Implementar combos entre especiais do beta.

### 11.5 Fase 4: obstaculos

1. Implementar caixa.
2. Implementar gelo.
3. Implementar grama.
4. Implementar grama densa.
5. Implementar sapo.

### 11.6 Fase 5: dados e conteudo

1. Definir formato de arquivo de fase.
2. Criar loader de fase.
3. Criar 20 fases iniciais.
4. Balancear dificuldade.
5. Criar curva inicial de progressao.

### 11.7 Fase 6: UX e polimento

1. Criar HUD final do beta.
2. Adicionar sons basicos.
3. Adicionar feedback de combo.
4. Adicionar telas de inicio, pausa e fim de fase.
5. Salvar progresso local.

### 11.8 Fase 7: Android

1. Configurar export preset Android.
2. Gerar build debug.
3. Rodar em celular real.
4. Medir performance.
5. Corrigir bugs de input, escala e memoria.

## 12. Estrategia de Testes

### 12.1 Melhor fluxo para este projeto

O melhor fluxo para voce sera:

1. `VSCode` para escrever codigo
2. `Godot` para rodar rapidamente no desktop
3. `Android Studio` para emulador, SDK e ferramentas Android
4. `celular Android real` para teste final de toque, desempenho e resolucao

### 12.2 Pode usar so VSCode?

Pode usar VSCode para editar scripts e organizar o projeto, mas ele nao substitui:

- a execucao visual da Godot
- o export Android
- o emulador e as ferramentas do Android

Entao, para este projeto, VSCode sozinho nao e a melhor opcao.

### 12.3 Docker vale a pena?

Docker nao e a melhor ferramenta principal para esse tipo de desenvolvimento porque:

- o jogo e visual e interativo
- emulador Android em container e mais chato
- aceleracao grafica costuma complicar
- o ciclo de teste fica mais lento

Docker pode ser util depois para automacao de build, mas nao como ambiente principal de desenvolvimento e teste do beta.

### 12.4 Melhor opcao de testes

A melhor combinacao para seu caso e:

1. testar logica no desktop com execucao rapida
2. testar layout e toque no Android real
3. usar emulador Android para validacoes extras

## 13. Como Verificar se Esta Tudo Funcionando

### 13.1 Checklist de verificacao manual por build

Cada build deve responder sim para estas perguntas:

1. O jogo abre sem erro?
2. O tabuleiro carrega corretamente?
3. Toda troca invalida retorna?
4. Toda troca valida resolve o match?
5. As cascatas terminam sozinhas?
6. O tabuleiro nunca fica preso sem resolucao?
7. Os especiais surgem corretamente?
8. Os combos de especiais funcionam?
9. Os objetivos contam corretamente?
10. Vitoria e derrota aparecem na hora certa?
11. O save local funciona?
12. No Android, o toque responde bem?
13. O jogo roda sem travar em varias fases seguidas?

### 13.2 Tipos de teste a usar

- testes manuais de jogabilidade
- testes repetidos de fases especificas
- fases sandbox para reproduzir bugs
- logs para entender regras
- testes em celular fraco e celular medio, se possivel

### 13.3 Boas praticas de teste

- usar seeds fixas para reproduzir bugs
- criar fases pequenas so para validar uma regra
- testar uma mecanica nova isoladamente antes de mistura-la com outras
- registrar bugs por prioridade

## 14. Criterios de Pronto para Beta

O beta estara pronto quando:

1. o loop principal estiver estavel
2. houver pelo menos 20 fases jogaveis
3. os especiais do beta estiverem corretos
4. os obstaculos do beta estiverem corretos
5. o progresso local estiver salvando
6. a build Android abrir e rodar bem em aparelho real
7. os bugs bloqueadores estiverem resolvidos

## 15. Proximo Passo Recomendado

O melhor proximo passo tecnico e iniciar a `Fase 0` e a `Fase 1` ao mesmo tempo:

1. instalar a stack
2. criar o projeto Godot
3. fazer um tabuleiro simples rodando no desktop
4. exportar uma build Android de teste o quanto antes

Se o Android for deixado para o fim, a chance de retrabalho sobe muito.
