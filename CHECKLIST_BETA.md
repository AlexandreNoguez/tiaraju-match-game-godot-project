# Checklist da Versao Beta

Marque com `[x]` quando a tarefa estiver concluida.

## 1. Identidade e escopo

- [ ] Definir nome provisiorio do jogo
- [ ] Definir nomes dos personagens principais
- [ ] Definir ambientacao da vila ficcional
- [ ] Definir direcao visual inicial
- [ ] Confirmar que o protagonista sera ficcional e apenas inspirado em referencias historicas
- [x] Confirmar lista de mecanicas do beta
- [x] Confirmar lista de obstaculos do beta

## 2. Ferramentas

- [ ] Instalar Godot 4
- [ ] Instalar Android Studio
- [ ] Instalar Android SDK
- [ ] Instalar OpenJDK 17
- [ ] Instalar Git
- [ ] Configurar VSCode para editar scripts do projeto
- [ ] Ativar modo desenvolvedor no Android
- [ ] Ativar depuracao USB no Android

## 2.1 Seguranca e privacidade

- [x] Confirmar que o beta sera 100% offline
- [x] Confirmar que o beta nao tera login
- [x] Confirmar que o beta nao tera coleta de dados pessoais
- [ ] Revisar dependencias de terceiros antes de adicionar qualquer SDK
- [x] Criar politica de nao versionar segredos no repositorio
- [ ] Definir plano futuro para autenticacao segura, apenas quando houver backend

## 2.2 Arquitetura

- [x] Confirmar arquitetura em camadas domain/application/presentation/infrastructure
- [x] Definir regras que precisam ficar fora da UI
- [x] Definir formato base de fase em JSON
- [x] Definir estrategia de save local
- [x] Confirmar suporte planejado a grids nao quadrados

## 3. Projeto base

- [x] Criar projeto Godot
- [x] Criar estrutura inicial de pastas
- [x] Criar cena principal
- [x] Configurar resolucao base
- [ ] Configurar input principal
- [x] Configurar export templates

## 4. Nucleo do tabuleiro

- [x] Criar grid com mascara de fase
- [x] Criar tipos de pecas coloridas
- [x] Implementar selecao de peca
- [x] Implementar troca entre pecas adjacentes
- [x] Implementar validacao de troca
- [x] Implementar match horizontal
- [x] Implementar match vertical
- [x] Implementar remocao de pecas
- [x] Implementar gravidade
- [x] Implementar reposicao aleatoria
- [x] Implementar cascatas
- [x] Impedir inicio de fase sem jogadas possiveis

## 5. Regras da partida

- [x] Implementar contador de jogadas
- [x] Implementar objetivos de fase
- [x] Implementar condicao de vitoria
- [x] Implementar condicao de derrota
- [x] Bloquear input enquanto o tabuleiro resolve
- [x] Mostrar HUD basica

## 6. Especiais

- [x] Implementar missil horizontal
- [x] Implementar missil vertical
- [x] Implementar coringa
- [x] Implementar combo missil + missil
- [x] Implementar combo coringa + peca comum
- [x] Implementar combo coringa + missil
- [ ] Adicionar efeitos visuais simples para especiais

## 7. Obstaculos

- [x] Implementar caixa
- [x] Implementar gelo
- [x] Implementar grama
- [x] Implementar grama densa
- [ ] Implementar sapo
- [ ] Validar interacao dos obstaculos com especiais

## 8. Dados de fase

- [x] Definir formato de arquivo de fase
- [x] Criar loader de fase
- [x] Criar fase sandbox
- [x] Criar 5 fases tecnicas de teste
- [x] Adicionar 3 grids nao quadrados de teste
- [x] Criar 20 fases jogaveis do beta
- [ ] Ajustar curva inicial de dificuldade

## 9. Interface e UX

- [x] Criar tela inicial
- [ ] Criar tela de mapa ou selecao simples
- [x] Exibir placeholders de avatar, eventos, perfil e configuracoes na tela principal
- [x] Exibir placeholder de moedas no home
- [x] Exibir placeholder de shop no home
- [x] Conectar botao Jogar a fase atual desbloqueada
- [x] Criar tela de vitoria
- [x] Criar tela de derrota
- [x] Retornar ao home ao terminar cada fase
- [x] Criar tela de pausa
- [x] Adicionar feedback visual de combo
- [x] Adicionar efeitos sonoros basicos
- [x] Melhorar HUD visual da fase
- [x] Aplicar primeira passada premium no board e na UI

## 10. Save e progresso

- [x] Implementar save local
- [x] Salvar fase desbloqueada
- [x] Manter fluxo principal linear sem replay de fases antigas
- [x] Salvar configuracoes basicas
- [x] Validar leitura do save apos fechar e abrir o jogo

## 11. Android

- [ ] Configurar export Android
- [ ] Gerar APK debug
- [ ] Instalar APK no celular
- [ ] Validar toque em aparelho real
- [ ] Validar resolucao em tela pequena
- [ ] Validar performance em varias fases
- [ ] Corrigir bugs criticos de Android

## 12. Testes

- [x] Criar roteiro de teste manual
- [ ] Testar trocas invalidas
- [x] Testar cascatas longas
- [ ] Testar fases com poucos movimentos
- [ ] Testar especiais isolados
- [ ] Testar combos de especiais
- [ ] Testar cada obstaculo isoladamente
- [ ] Testar mistura de obstaculos
- [ ] Testar vitoria por objetivo
- [ ] Testar derrota por falta de movimentos
- [x] Testar save local
- [x] Testar no desktop
- [ ] Testar no emulador Android
- [ ] Testar em celular Android real

## 13. Pronto para beta

- [x] Loop principal estavel
- [ ] 20 fases concluidas
- [ ] Especiais do beta corretos
- [ ] Obstaculos do beta corretos
- [x] Save local funcionando
- [ ] Build Android funcional
- [ ] Sem bugs bloqueadores conhecidos

## 14. Pos-beta e backlog

- [x] Definir como o jogador ganha moedas
- [x] Implementar saldo real de moedas no save local
- [ ] Implementar shop offline
- [ ] Definir primeiros itens compraveis
- [ ] Balancear a economia das compras
