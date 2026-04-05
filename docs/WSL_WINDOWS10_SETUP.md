# Setup do Projeto no WSL Ubuntu no Windows 10

## Objetivo

Configurar um ambiente de desenvolvimento para este projeto usando Ubuntu no WSL, com Godot, Java, Android SDK e ADB.

## Recomendacao pratica

Da para trabalhar com quase tudo dentro do WSL, mas no Windows 10 ha duas observacoes importantes:

1. `Godot` no WSL depende de suporte a apps GUI no WSL 2.
2. `Android Emulator` dentro do WSL nao e o caminho que eu recomendo para este projeto.

### Recomendacao mais segura para o seu caso

- codigo pode ficar no WSL
- testes de CLI e `adb` podem acontecer no WSL
- mas, se voce for usar a `Godot do Windows` para exportar Android, mantenha `Java SDK` e `Android SDK` no Windows
- testes Android preferencialmente em aparelho real

### Inference importante

Nao encontrei uma documentacao oficial do Android recomendando explicitamente um fluxo de `Android Studio + Emulator` rodando dentro do WSL no Windows 10. As documentacoes oficiais cobrem:

- instalacao Linux do Android Studio
- uso do Android Emulator
- uso do WSL e GUI apps

Por isso, a recomendacao mais segura e pratica para este projeto e:

- usar `WSL` para codigo, terminal e automacao
- usar `Godot do Windows` para exportar Android
- manter `Java SDK` e `Android SDK` no mesmo lado da Godot usada para exportar
- tratar `Android Studio dentro do WSL` como opcional
- evitar depender do emulador dentro do WSL nesta fase

## Regra de ouro para evitar confusao

O editor que exporta o APK precisa enxergar diretamente:

- `Java SDK`
- `Android SDK`
- `build-tools`
- `platform-tools`

Entao:

- `Godot Windows` -> `SDK/JDK Windows`
- `Godot WSL/Linux` -> `SDK/JDK WSL/Linux`

Misturar `Godot Windows` com SDK do WSL costuma gerar exatamente estes erros:

- `Java SDK invalido`
- `platform-tools absent`
- `build-tools absent`
- `apksigner` nao encontrado

## 1. Pre-requisitos no Windows

Segundo a documentacao da Microsoft, apps GUI no WSL exigem:

- `Windows 10 build 19044+` ou `Windows 11`
- `WSL 2`
- driver de GPU atualizado

### 1.1 Comandos no PowerShell como administrador

```powershell
wsl --version
wsl --status
wsl -l -v
```

Se ainda nao tiver WSL:

```powershell
wsl --install -d Ubuntu
```

Se ja tiver WSL instalado:

```powershell
wsl --update
wsl --shutdown
```

Se sua distro estiver em WSL 1, migre para WSL 2:

```powershell
wsl --set-version Ubuntu 2
```

## 2. Confirmar GUI no WSL

Teste um app grafico simples no Ubuntu:

```bash
sudo apt update
sudo apt install -y x11-apps
xcalc
```

Se o `xcalc` abrir, o suporte GUI esta funcionando.

## 3. Pacotes base no Ubuntu

No terminal do Ubuntu WSL:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y \
  build-essential \
  git curl wget unzip zip \
  ca-certificates file jq \
  openjdk-17-jdk \
  adb android-sdk-platform-tools-common \
  libx11-6 libxcursor1 libxinerama1 libxi6 libxrandr2 libxrender1 \
  libgl1 libasound2t64 libpulse0 \
  xdg-utils x11-apps
```

### 3.0 Observacao para Ubuntu 24.04

No `Ubuntu 24.04 (noble)`, o pacote `libasound2` aparece como virtual. Se isso acontecer, use `libasound2t64`.

### 3.1 Verificacoes

```bash
java -version
adb version
git --version
```

## 4. Instalar Godot no WSL

O site oficial da Godot informa que, em Linux, o editor e "extract and run". Para este projeto, vamos usar a versao estavel atual do download oficial.

### 4.1 Baixar e configurar

```bash
mkdir -p ~/tools/godot ~/bin ~/Downloads/godot
cd ~/Downloads/godot

wget -O Godot_v4.6.1-stable_linux.x86_64.zip \
  "https://downloads.godotengine.org/?flavor=stable&platform=linux.64&slug=linux.x86_64.zip&version=4.6.1"

unzip -o Godot_v4.6.1-stable_linux.x86_64.zip -d ~/tools/godot/4.6.1
chmod +x ~/tools/godot/4.6.1/Godot_v4.6.1-stable_linux.x86_64
ln -sf ~/tools/godot/4.6.1/Godot_v4.6.1-stable_linux.x86_64 ~/bin/godot
```

Adicionar `~/bin` ao `PATH`:

```bash
grep -qxF 'export PATH="$HOME/bin:$PATH"' ~/.bashrc || echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 4.2 Teste

```bash
godot --version
godot
```

## 5. Abrir o projeto

Depois de instalar a Godot:

```bash
cd /home/alexandre/workspace/royal-match
godot project.godot
```

## 6. Android SDK no WSL

Para exportar Android com Godot Linux no WSL, a doc oficial recomenda `OpenJDK 17` e Android SDK. O SDK pode ser instalado via Android Studio ou via command-line tools.

### 6.1 Caminhos recomendados

```bash
mkdir -p ~/Android/Sdk/cmdline-tools
```

Adicionar variaveis no `~/.bashrc`:

```bash
grep -qxF 'export ANDROID_HOME="$HOME/Android/Sdk"' ~/.bashrc || echo 'export ANDROID_HOME="$HOME/Android/Sdk"' >> ~/.bashrc
grep -qxF 'export ANDROID_SDK_ROOT="$HOME/Android/Sdk"' ~/.bashrc || echo 'export ANDROID_SDK_ROOT="$HOME/Android/Sdk"' >> ~/.bashrc
grep -qxF 'export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"' ~/.bashrc || echo 'export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"' >> ~/.bashrc
grep -qxF 'export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"' ~/.bashrc || echo 'export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 6.2 Opcao A: Android command-line tools no WSL

Baixe o pacote oficial de command-line tools pela pagina do Android Studio e extraia de acordo com a doc do `sdkmanager`.

Estrutura esperada:

```text
~/Android/Sdk/
  cmdline-tools/
    latest/
      bin/
      lib/
      NOTICE.txt
      source.properties
```

Depois de colocar os arquivos nessa estrutura, rode:

```bash
sdkmanager --sdk_root="$ANDROID_HOME" --list
sdkmanager --sdk_root="$ANDROID_HOME" "platform-tools" "platforms;android-35" "build-tools;35.0.0"
sdkmanager --sdk_root="$ANDROID_HOME" --licenses
```

### 6.3 Opcao B: Android Studio dentro do WSL

Segundo a doc oficial Linux do Android Studio:

- baixe o `.tar.gz`
- extraia em `/opt` ou outro diretorio de apps
- rode `android-studio/bin/studio`

No Ubuntu, a doc tambem manda instalar bibliotecas 32-bit:

```bash
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
```

Depois, com o arquivo `.tar.gz` ja baixado:

```bash
cd /opt
sudo tar -xzf ~/Downloads/android-studio-*.tar.gz
/opt/android-studio/bin/studio
```

### 6.4 Recomendacao

Para este projeto, eu recomendo comecar pela `Opcao A` e so instalar `Android Studio` no WSL se voce realmente sentir falta da interface do SDK Manager.

## 7. Conectar um Android real ao WSL

A documentacao oficial do Android recomenda sempre testar em aparelho real antes de publicar.

### 7.1 Via Wi-Fi

Se seu aparelho tiver Android 11+ e wireless debugging:

```bash
adb pair <ip>:<porta>
adb connect <ip>:<porta>
adb devices
```

### 7.2 Via USB no WSL

A documentacao da Microsoft indica usar `usbipd-win`.

No Windows PowerShell como administrador:

```powershell
winget install --interactive --exact dorssel.usbipd-win
usbipd list
usbipd bind --busid <BUSID>
usbipd attach --wsl --busid <BUSID>
```

No Ubuntu WSL:

```bash
lsusb
adb devices
```

Observacao pratica:

- `usbipd` roda no Windows PowerShell, nao no Ubuntu
- `adb` pode rodar no WSL depois que o dispositivo ja estiver anexado

## 7.4 Recomendacao final para este projeto

Hoje, o caminho com menos atrito e:

1. editar no WSL ou Windows
2. usar `adb` no WSL se quiser
3. usar a `Godot do Windows` para exportar
4. configurar `Java SDK` e `Android SDK` no Windows quando exportar pela interface do Windows

### 7.3 Ubuntu e ADB no aparelho

Se o ADB reclamar de permissao no Linux, a doc oficial do Android para Ubuntu indica:

```bash
sudo usermod -aG plugdev $LOGNAME
sudo apt-get install android-sdk-platform-tools-common
```

Depois disso, encerre e reabra a sessao.

## 8. Export templates da Godot

Voce vai precisar dos export templates para exportar o jogo para Android.

### 8.1 Jeito mais simples

Abrir a Godot e instalar pelo proprio editor:

- `Editor > Manage Export Templates`

### 8.2 Download manual opcional

Se quiser baixar manualmente o pacote oficial:

```bash
mkdir -p ~/Downloads/godot
cd ~/Downloads/godot

wget -O Godot_v4.6.1-stable_export_templates.tpz \
  "https://downloads.godotengine.org/?flavor=stable&platform=templates&slug=export_templates.tpz&version=4.6.1"
```

Depois, importe pelo editor da Godot.

## 9. Validacao final

Rode estes comandos no Ubuntu:

```bash
java -version
adb version
godot --version
echo $ANDROID_HOME
echo $JAVA_HOME
```

E confira:

1. a Godot abre sem erro
2. o projeto abre sem erro
3. `adb devices` enxerga o aparelho
4. a exportacao Android debug funciona

## 10. Ordem recomendada

Para evitar dor de cabeca, siga esta ordem:

1. atualizar WSL
2. validar GUI no WSL
3. instalar Java e pacotes base
4. instalar Godot
5. abrir este projeto
6. instalar Android SDK
7. conectar aparelho real com ADB
8. configurar export Android na Godot

## Fontes oficiais

- Microsoft WSL install: https://learn.microsoft.com/en-us/windows/wsl/install
- Microsoft WSL GUI apps: https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps
- Microsoft USB no WSL: https://learn.microsoft.com/en-us/windows/wsl/connect-usb
- Android Studio install: https://developer.android.com/studio/install
- Android sdkmanager: https://developer.android.com/tools/sdkmanager
- Android device testing: https://developer.android.com/studio/run/device
- Godot Linux download: https://godotengine.org/download/linux/
- Godot Android export: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
- Godot one-click deploy: https://docs.godotengine.org/en/stable/tutorials/export/one-click_deploy.html
