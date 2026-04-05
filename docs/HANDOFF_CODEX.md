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
- fim de fase aguardando confirmação manual para voltar ao home
- tela de pausa funcionando
- feedback visual de combo funcionando
- efeitos sonoros básicos funcionando com assets gratuitos locais
- musica do `home` tocando a faixa local dedicada
- fases sorteando aleatoriamente entre duas musicas locais a cada entrada
- configuracoes do home controlando `Musica` e `SFX` com persistencia local
- interface do `home`, pausa e fim de fase recebeu uma primeira passada visual usando `Kenney UI Pack`
- animação de troca lateral entre peças funcionando
- animação de queda das peças funcionando com cascatas reproduzidas por etapas
- efeito de pop antes da remoção das combinações funcionando
- moedas sendo ganhas por chain e salvas localmente
- atalho de playtest em debug no menu de configurações para abrir fases sem alterar o save
- guia de teste em aparelho Android real documentado
- documentacao reforca que Godot, Java SDK e Android SDK precisam ficar no mesmo lado do ambiente ao exportar
- documentacao registra o caso real em que `adb` funciona no WSL, mas a exportacao da Godot do Windows continua exigindo SDK/JDK no Windows
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
- ao terminar cada fase, o jogador le o resumo final e escolhe quando voltar para o home
- shop fica como placeholder no beta
- moedas ja podem ser acumuladas localmente a partir de chains, mas a economia ainda e provisoria
- login, perfil funcional, foto e social ficam para pós-beta
- se houver conta no futuro, precisamos prever exclusão de conta e dados conforme exigências do Google Play

Próximos passos planejados:
1. rodar a regressao manual de moedas, chains, save e animacoes no desktop
2. validar no Android resolução, toque, performance e persistencia do save, preferindo exportacao pela Godot do Windows com SDK/JDK no Windows
3. usar o atalho de playtest nas configurações em debug para acelerar a revisão da campanha sem poluir o save
4. voltar ao balanceamento fino da curva das fases 010-029
5. decidir o proximo passo de UX entre HUD de moedas mais evidente, iconografia do board ou primeiros elementos reais do shop offline

Antes de editar, leia:
- GAME_PLAN.md
- CHECKLIST_BETA.md
- docs/SECURITY.md
- scripts/bootstrap/bootstrap.gd
- scripts/presentation/board/board_screen.gd
- scenes/presentation/board/board_screen.tscn
- data/levels
