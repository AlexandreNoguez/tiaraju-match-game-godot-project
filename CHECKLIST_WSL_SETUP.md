# Checklist de Setup no WSL

Marque com `[x]` quando concluir cada etapa.

## 1. Windows 10 e WSL

- [ ] Confirmar que o Windows 10 esta no build 19044 ou superior
- [ ] Confirmar que o WSL esta instalado
- [ ] Confirmar que a distro Ubuntu esta em `WSL 2`
- [ ] Rodar `wsl --update`
- [ ] Rodar `wsl --shutdown`
- [ ] Atualizar driver de GPU do Windows

## 2. GUI no WSL

- [ ] Confirmar que apps GUI do Linux funcionam no WSL
- [ ] Se GUI nao funcionar, decidir entre atualizar o WSL/Windows ou usar X server externo

## 3. Pacotes base no Ubuntu

- [ ] Rodar `sudo apt update`
- [ ] Rodar `sudo apt upgrade -y`
- [ ] Instalar `git`, `curl`, `wget`, `unzip`, `zip`
- [ ] Instalar `build-essential`
- [ ] Instalar `openjdk-17-jdk`
- [ ] Instalar `adb`
- [ ] Instalar bibliotecas necessarias para apps GUI

## 4. Godot

- [ ] Baixar Godot 4 para Linux
- [ ] Extrair Godot em `~/tools/godot`
- [ ] Dar permissao de execucao no binario
- [ ] Criar atalho `godot` no `PATH`
- [ ] Abrir o editor Godot no WSL
- [ ] Abrir o projeto `royal-match`

## 5. Android SDK no WSL

- [ ] Criar pasta `~/Android/Sdk`
- [ ] Instalar Android command-line tools ou Android Studio no WSL
- [ ] Configurar `ANDROID_HOME`
- [ ] Configurar `ANDROID_SDK_ROOT`
- [ ] Configurar `JAVA_HOME`
- [ ] Adicionar `platform-tools` e `cmdline-tools/latest/bin` ao `PATH`
- [ ] Instalar `platform-tools`
- [ ] Instalar `platforms;android-35`
- [ ] Instalar `build-tools;35.0.0`
- [ ] Aceitar licencas com `sdkmanager --licenses`

## 6. Dispositivo Android

- [ ] Ativar modo desenvolvedor no celular
- [ ] Ativar depuracao USB ou wireless debugging
- [ ] Se usar USB no WSL, instalar `usbipd-win` no Windows
- [ ] Conectar o aparelho ao WSL
- [ ] Confirmar que `adb devices` lista o aparelho

## 7. Godot para Android

- [ ] Baixar ou instalar os export templates da Godot
- [ ] Configurar os caminhos Android nas configuracoes da Godot
- [ ] Criar preset Android de export
- [ ] Gerar build debug
- [ ] Instalar build no aparelho

## 8. Validacao final

- [ ] Confirmar `java -version`
- [ ] Confirmar `adb version`
- [ ] Confirmar `godot` abre sem erro
- [ ] Confirmar o projeto abre na Godot
- [ ] Confirmar a exportacao Android funciona
