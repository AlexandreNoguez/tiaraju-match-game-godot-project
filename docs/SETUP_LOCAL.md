# Setup Local Recomendado

## Ordem de instalacao

1. Instalar `Godot 4`
2. Instalar `OpenJDK 17`
3. Instalar `Android SDK` e `ADB`
4. Instalar `Android Studio` apenas se quiser a interface grafica do SDK Manager
5. Ativar modo desenvolvedor e depuracao USB no celular Android

## Fluxo diario recomendado

1. editar scripts no `VSCode`
2. abrir e rodar o projeto pela `Godot`
3. exportar build debug quando a mecanica estiver boa
4. instalar no celular real
5. repetir testes no emulador apenas se esse fluxo estiver confortavel no seu ambiente

## O que validar logo apos instalar

### Godot

- o projeto abre sem erro
- a cena bootstrap carrega
- os scripts sao reconhecidos

### Android SDK / ADB

- o SDK foi baixado
- o `adb` funciona
- o `sdkmanager` funciona

### Android Studio

- opcional no fluxo WSL
- util se voce quiser uma interface grafica para o SDK
- o emulador nao e obrigatorio para esta fase do projeto

### Celular real

- o aparelho aparece via USB
- a depuracao USB esta aceita
- a build debug instala corretamente

## Observacao importante

Como o projeto ainda esta no comeco, a prioridade nao e performance extrema, e sim:

1. conseguir rodar no desktop
2. conseguir exportar para Android
3. manter o codigo organizado e seguro desde cedo

## Observacao para WSL

No seu caso, a recomendacao principal e:

1. usar `Godot` no WSL
2. usar `Android SDK` e `ADB` no WSL
3. testar em `aparelho Android real`
4. tratar `Android Studio` e `Emulator` como opcionais
