# Requisitos de Seguranca e Privacidade

## Objetivo

Definir as regras minimas de seguranca do projeto desde o comeco, para evitar retrabalho e reduzir risco quando o jogo crescer e, no futuro, tiver login ou recursos online.

## Regra Mais Importante

Enquanto o jogo for offline, o caminho mais seguro e nao coletar dados pessoais.

Para o beta atual:

- sem login
- sem senha
- sem email
- sem analytics invasivo
- sem SDKs de terceiros desnecessarios
- sem compras internas

Menos coleta significa menos superficie de risco.

## Principios

1. Coletar o minimo possivel.
2. Nunca armazenar segredos no cliente.
3. Nunca confiar no cliente para autorizacao.
4. Usar conexao segura em qualquer trafego futuro.
5. Evitar dependencias que nao sejam realmente necessarias.
6. Revisar privacidade antes de publicar.

## Se Houver Login no Futuro

### Regras obrigatorias

- preferir provedor de autenticacao consolidado ou backend proprio com boas praticas
- nunca guardar senha em texto puro
- nunca embutir chave administrativa no app
- usar HTTPS em todo trafego
- validar autorizacao no servidor, nunca apenas no app
- aplicar rate limit e protecao contra abuso no backend
- registrar eventos de seguranca no servidor, sem vazar dados sensiveis

### Armazenamento local

Se o app precisar guardar token de sessao no futuro:

- usar armazenamento seguro do sistema
- no Android, preferir recursos baseados em Keystore ou armazenamento seguro equivalente
- nunca salvar token sensivel em arquivo texto, JSON aberto ou logs

### Dados do usuario

Se houver conta, manter politica clara para:

- coleta
- uso
- compartilhamento
- retencao
- exclusao

## Regras para o Repositorio

- nao commitar senhas, chaves privadas ou tokens
- usar `.gitignore` para arquivos locais e de build
- separar configuracoes sensiveis por ambiente
- documentar toda nova dependencia externa

## Regras para Codigo

- nao logar dados pessoais
- nao logar tokens
- validar entradas vindas do usuario ou da rede
- limitar confianca em dados locais
- tratar saves locais como manipulaveis pelo usuario

## Regras para Publicacao Futura

Antes de publicar na Play Store:

1. revisar o formulario de Data safety
2. revisar as politicas de User Data do Google Play
3. validar quais dados sao realmente coletados
4. remover SDKs que nao forem essenciais
5. preparar politica de privacidade publica

## Decisao Recomendada para Este Projeto

Para as primeiras versoes:

- manter o jogo 100% offline
- usar apenas save local
- adiar login para uma fase posterior

Isso reduz muito o risco tecnico e juridico na fase inicial.
