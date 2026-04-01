# Checklist de Setup no WSL

Marque com `[x]` quando concluir cada etapa.

## 1. Windows 10 e WSL

- [ ] Confirmar que o Windows 10 esta no build 19044 ou superior
- [x] Confirmar que o WSL esta instalado
- [x] Confirmar que a distro Ubuntu esta em `WSL 2`
- [ ] Rodar `wsl --update`
- [ ] Rodar `wsl --shutdown`
- [ ] Atualizar driver de GPU do Windows

## 2. GUI no WSL

- [x] Confirmar que apps GUI do Linux funcionam no WSL
- [ ] Se GUI nao funcionar, decidir entre atualizar o WSL/Windows ou usar X server externo

## 3. Pacotes base no Ubuntu

- [x] Rodar `sudo apt update`
- [x] Rodar `sudo apt upgrade -y`
- [x] Instalar `git`, `curl`, `wget`, `unzip`, `zip`
- [x] Instalar `build-essential`
- [x] Instalar `openjdk-17-jdk`
- [x] Instalar `adb`
- [x] Instalar bibliotecas necessarias para apps GUI

## 4. Godot

- [x] Baixar Godot 4 para Linux
- [x] Extrair Godot em `~/tools/godot`
- [x] Dar permissao de execucao no binario
- [x] Criar atalho `godot` no `PATH`
- [x] Abrir o editor Godot no WSL
- [x] Abrir o projeto `royal-match`

## 5. Android SDK no WSL

- [x] Criar pasta `~/Android/Sdk`
- [x] Instalar Android command-line tools ou Android Studio no WSL
- [x] Configurar `ANDROID_HOME`
- [x] Configurar `ANDROID_SDK_ROOT`
- [x] Configurar `JAVA_HOME`
- [x] Adicionar `platform-tools` e `cmdline-tools/latest/bin` ao `PATH`
- [x] Instalar `platform-tools`
- [x] Instalar `platforms;android-35`
- [x] Instalar `build-tools;35.0.0`
- [x] Aceitar licencas com `sdkmanager --licenses`

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

- [x] Confirmar `java -version`
- [x] Confirmar `adb version`
- [x] Confirmar `godot` abre sem erro
- [x] Confirmar o projeto abre na Godot
- [ ] Confirmar a exportacao Android funciona
