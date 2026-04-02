Estamos trabalhando neste projeto Godot match-3:
C:\workspaces\tiaraju-match-game-godot-project
ou
/mnt/c/workspaces/tiaraju-match-game-godot-project

Regras atuais do projeto:
- usar somente esse diretório do Windows como fonte de verdade
- sempre me passar git add e commit message após alterações
- manter foco em arquitetura escalável, segurança e boas práticas
- beta offline-first, sem login por enquanto

Estado atual do desenvolvimento:
- tabuleiro base funcionando
- swap, match, gravidade, refill e cascatas funcionando
- jogadas, objetivos e HUD funcionando
- especiais básicos funcionando:
  - míssil horizontal/vertical
  - coringa
  - combo míssil + míssil
  - combo coringa + peça comum
  - combo coringa + míssil
- obstáculos funcionando:
  - caixa
  - gelo
  - grama
  - grama densa
- save local básico funcionando
- fluxo de vitória/derrota funcionando
- progressão básica entre fases funcionando
- tela principal funcionando com botão Jogar
- home com placeholders de avatar, eventos, perfil, configurações, moedas e shop
- fim de fase retornando ao home
- tela de pausa funcionando
- feedback visual de combo funcionando
- efeitos sonoros básicos funcionando com assets gratuitos locais
- músicas temporárias gratuitas tocando no home e nas fases
- animação inicial de queda das peças funcionando no tabuleiro
- atalho de playtest em debug no menu de configurações para abrir fases sem alterar o save
- 9 fases técnicas de teste já criadas
- pacote inicial com 20 fases jogáveis criado
- 29 fases totais disponíveis em dados
- curva inicial revisada heurísticamente e documentada para playtest
- roteiro manual do fluxo home -> fase -> home -> save documentado
- testes manuais no Godot do Windows passaram

Decisões de produto:
- o jogo deve seguir progressão linear, sem voltar para fases anteriores no fluxo principal
- a cada 100 fases entra uma nova família de obstáculo
- queremos suportar grids não quadrados
- queremos uma tela principal com botão Jogar, avatar placeholder, eventos placeholder, perfil placeholder, moedas placeholder, shop placeholder e configurações
- ao terminar cada fase, o jogador volta para o home
- moedas e shop ficam como placeholders no beta e entram de verdade no pós-beta
- login, perfil funcional, foto e social ficam para pós-beta
- se houver conta no futuro, precisamos prever exclusão de conta e dados conforme exigências do Google Play

Próximos passos planejados:
1. executar playtest das fases 010-029 e registrar onde a curva ainda quebra
2. usar o atalho de playtest nas configurações em debug para acelerar a revisão da campanha sem poluir o save
3. rodar o roteiro manual home -> fase -> home -> save no Godot do Windows
4. validar no Android resolução, toque e performance
5. adicionar controles básicos de áudio nas configurações e persistir preferências locais

Antes de editar, leia:
- GAME_PLAN.md
- CHECKLIST_BETA.md
- docs/SECURITY.md
- scripts/bootstrap/bootstrap.gd
- scripts/presentation/board/board_screen.gd
- scenes/presentation/board/board_screen.tscn
- data/levels
