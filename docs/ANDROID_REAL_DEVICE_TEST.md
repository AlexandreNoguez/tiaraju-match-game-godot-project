# Teste em Android Real

## Objetivo

Rodar a build debug do jogo em um aparelho Android real para validar:

- toque
- desempenho
- animacoes
- audio
- save local
- moedas por chain

## 1. Preparacao do celular

No aparelho Android:

1. abrir `Configuracoes`
2. entrar em `Sobre o telefone`
3. tocar 7 vezes em `Numero da versao` para ativar o modo desenvolvedor
4. voltar para `Configuracoes`
5. abrir `Opcoes do desenvolvedor`
6. ativar `Depuracao USB`

Se o aparelho tiver Android 11+ e voce preferir, tambem pode usar `Wireless debugging`, mas USB costuma ser o caminho mais simples para a primeira validacao.

## 2. Preparacao do PC / WSL

Voce precisa ter:

- `adb`
- `OpenJDK 17`
- `Android SDK`
- export templates da Godot

Se estiver usando este fluxo com WSL, seguir tambem:

- [CHECKLIST_WSL_SETUP.md](/mnt/c/workspaces/tiaraju-match-game-godot-project/CHECKLIST_WSL_SETUP.md)
- [WSL_WINDOWS10_SETUP.md](/mnt/c/workspaces/tiaraju-match-game-godot-project/docs/WSL_WINDOWS10_SETUP.md)

## 3. Conectar o aparelho

### 3.1 Via USB

1. conectar o celular no cabo USB
2. no aparelho, aceitar o prompt de depuracao
3. no terminal, rodar:

```bash
adb devices
```

Resultado esperado:

- o aparelho aparece como `device`

Se aparecer `unauthorized`, desbloqueie o celular e aceite a chave RSA.

### 3.2 Se estiver no WSL usando USB

No Windows, pode ser necessario anexar o USB ao WSL com `usbipd-win`.

Fluxo comum:

1. no PowerShell do Windows, listar USB:

```powershell
usbipd list
```

2. bind no dispositivo:

```powershell
usbipd bind --busid <BUSID>
```

3. attach ao WSL:

```powershell
usbipd attach --wsl --busid <BUSID>
```

4. voltar ao Ubuntu/WSL e rodar:

```bash
adb devices
```

## 4. Exportar a build debug na Godot

Na Godot:

1. confirmar que os export templates estao instalados
2. abrir `Editor Settings` e revisar caminhos de `Android SDK`, `JDK` e ferramentas Android
3. abrir `Project -> Export`
4. criar ou revisar o preset `Android`
5. exportar um `APK` debug

## 5. Instalar no aparelho

Se a Godot nao instalar automaticamente, usar `adb`:

```bash
adb install -r caminho/para/o_jogo_debug.apk
```

O `-r` reinstala por cima da versao anterior.

## 6. Roteiro minimo no aparelho real

Depois de instalar:

1. abrir o jogo
2. entrar em uma fase
3. fazer uma troca invalida
4. fazer uma troca valida
5. observar:
   - swap lateral
   - pop da combinacao
   - queda por etapas
   - chains aparecendo separadamente
   - ganho visual de moedas por chain
6. concluir uma fase
7. voltar ao `home`
8. confirmar se o total de moedas aumentou
9. fechar completamente o jogo
10. abrir novamente
11. confirmar se moedas e progresso continuam salvos

## 7. O que observar no Android real

- se o toque responde bem
- se as labels continuam legiveis
- se o tabuleiro cabe corretamente na tela
- se as pedrinhas nao escapam da area do grid
- se o jogo perde fluidez em cascatas longas
- se o audio esta num volume aceitavel
- se o aparelho aquece demais

## 8. Problemas comuns

### `adb devices` nao mostra o aparelho

- trocar o cabo USB
- trocar a porta USB
- confirmar que a depuracao USB esta ativa
- revogar e aceitar novamente a autorizacao no aparelho

### `unauthorized`

- desbloquear o celular
- aceitar a chave RSA
- rodar de novo `adb devices`

### Falha ao instalar APK

- apagar versao anterior do app
- garantir espaco livre no aparelho
- verificar se a build foi exportada em modo debug

## 9. Resultado esperado desta etapa

Ao final, voce deve conseguir:

1. exportar uma build debug
2. instalar no aparelho real
3. validar toque, animacao, audio, moedas e save
4. registrar bugs especificos do Android antes do beta
