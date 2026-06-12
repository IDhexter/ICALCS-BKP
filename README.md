# Gerenciamento e Backup de ACLs (icacls) no Windows

Este repositório centraliza scripts automatizados para realizar o backup e a retenção de permissões de arquivos (Access Control Lists - ACLs) em ambientes Windows Server e computadores locais.

---

## ❓ O que é o ICACLS e como ele funciona?

O **`icacls`** é um utilitário nativo de linha de comando do Windows (presente desde o Windows Server 2003 SP2 e Windows Vista) utilizado para exibir, modificar, fazer backup e restaurar descritores de segurança (permissões NTFS) de arquivos e pastas.

### Como funciona o Backup?
Quando executamos o backup com a flag `/save`, o `icacls` lê a Tabela de Controle de Acesso (ACL) de cada arquivo/pasta e a exporta para um arquivo de texto criptografado/estruturado proprietário. O script automatiza isso usando o seguinte padrão:
```cmd
icacls "%PASTA%" /save "%BKPDIR%\ACL-ARQUIVO_%DATA%.txt" /T /C /Q
```
*   `/T`: Varre recursivamente a pasta (`%PASTA%`) e todos os seus arquivos/subpastas.
*   `/C`: Continua a execução mesmo se encontrar erros (como arquivos temporariamente bloqueados).
*   `/Q`: Executa de modo silencioso para não poluir o terminal de logs de sucesso de cada arquivo.

### ⚠️ A Nuance Crítica da Restauração
Um erro muito comum ao usar o `icacls` é tentar restaurar as permissões apontando diretamente para a pasta original. 

O `icacls /save` armazena os caminhos dos arquivos de forma **relativa** à pasta especificada. 
*   *Exemplo:* Ao fazer o backup de `E:\Dados`, o arquivo gerado salvará os registros com caminhos como `Dados\Administrativo UTI`, `Dados\AGENDAMENTO`, etc.
*   *Como restaurar:* Por conta dessa gravação relativa, ao restaurar (`/restore`), você **deve especificar a pasta pai** como alvo do comando (no caso, a raiz do volume `E:\`):
```cmd
icacls "E:\" /restore "C:\BKP\ACL-DADOS_AAAAMMDD.txt" /T /C
```

---

## 📅 Lógica de Automação do Script

Todos os scripts contidos neste repositório utilizam dois mecanismos de automação adicionais:

1.  **Formatação da Data (`wmic`)**: 
    Para evitar que o script quebre dependendo do idioma do Windows (onde o formato da data pode variar entre `DD/MM/AAAA` ou `MM/DD/AAAA`), o script usa a ferramenta de instrumentação do Windows para coletar a data no formato ISO (`AAAAMMDD`) que é universal.
2.  **Retenção Automática (`forfiles`)**:
    Evita o consumo excessivo de disco apagando backups de permissões que foram gerados há mais de X dias (configurável pela variável `%DIAS%`).

---

## 🏢 Clientes / Ambientes Configurados

Cada cliente possui um diretório dedicado com seu próprio script `.bat` e instruções específicas de execução e restauração de permissões. 

Selecione um cliente abaixo para abrir a documentação detalhada:

*   [🏢 VEGA (Backup em D:\Vega)](./Vega/README.md)
*   [🏥 Hospital Evangélico de Sorocaba (Backup em E:\Dados)](./Hospital-Evangelico-Sorocaba/README.md)
*   [👩‍🔬 Hanna (Backup em D:\Dados)](./Hanna/README.md)

---

## ➕ Como Adicionar um Novo Cliente

1.  Crie uma nova pasta no repositório com o nome do cliente.
2.  Copie um arquivo `.bat` existente para dentro dela, ajustando as variáveis `PASTA`, `BKPDIR` e `DIAS`.
3.  Crie um `README.md` na pasta do novo cliente documentando os diretórios configurados.
4.  Adicione o link correspondente na lista acima neste arquivo `README.md` principal.
