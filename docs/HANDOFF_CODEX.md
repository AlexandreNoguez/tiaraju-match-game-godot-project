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
- 9 fases técnicas de teste já criadas
- pacote inicial com 20 fases jogáveis criado
- 29 fases totais disponíveis em dados
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
1. ajustar e validar a curva inicial de dificuldade das 20 fases jogáveis
2. montar roteiro de teste manual cobrindo home -> fase -> home
3. adicionar pausa, feedback visual e áudio básico
4. validar no Android resolução, toque e performance
5. definir o desenho pós-beta da economia de moedas e do shop offline

Antes de editar, leia:
- GAME_PLAN.md
- CHECKLIST_BETA.md
- docs/SECURITY.md
- scripts/bootstrap/bootstrap.gd
- scripts/presentation/board/board_screen.gd
- scenes/presentation/board/board_screen.tscn
- data/levels
