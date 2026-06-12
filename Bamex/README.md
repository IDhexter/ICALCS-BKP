# Backup de Permissões - Bamex

Este diretório contém o script automatizado para backup e retenção das permissões de acesso (ACLs) do servidor de arquivos (`Dados`) da Bamex.

## 📝 Detalhes do Ambiente
*   **Diretório de Origem (`PASTA`):** `E:\Dados`
*   **Diretório de Destino (`BKPDIR`):** `C:\BKP\ACL`
*   **Retenção (`DIAS`):** 30 dias
*   **Nomenclatura do Arquivo:** `ACL-DADOS_AAAAMMDD.txt`

---

## 💾 Arquivo do Script
*   Você pode baixar o arquivo do script diretamente aqui: [bkp-acl-bamex.bat](./bkp-acl-bamex.bat)

---

## 💻 Código do Script (`bkp-acl-bamex.bat`)
```bat
@echo off

:: --- CONFIGURAÇÃO DE DIRETÓRIOS ---
set PASTA=E:\Dados
set BKPDIR=C:\BKP\ACL
set DIAS=30

:: Criar a pasta de backup caso ela não exista
if not exist "%BKPDIR%" mkdir "%BKPDIR%"

:: Obter a data atual no formato AAAAMMDD de forma padronizada
for /f "tokens=2 delims==" %%i in ('wmic os get LocalDateTime /value ^| find "="') do set ldt=%%i
set DATA=%ldt:~0,8%

:: Executar o backup das permissões (ACLs)
icacls "%PASTA%" /save "%BKPDIR%\ACL-DADOS_%DATA%.txt" /T /C /Q

:: Apagar backups automáticos com mais de 30 dias (suprimindo erro se não houver arquivos antigos)
forfiles /p "%BKPDIR%" /m "ACL-DADOS_*.txt" /d -%DIAS% /c "cmd /c del /q @path" 2>nul

:: Confirmação na tela
echo OK - Backup criado: "%BKPDIR%\ACL-DADOS_%DATA%.txt"
```

---

## ↩️ Como Restaurar as Permissões
Caso seja necessário restaurar as permissões a partir de um backup:

1.  Abra o **Prompt de Comando (CMD)** como **Administrador**.
2.  Execute o comando abaixo, apontando para a pasta raiz `E:\` (pois as permissões no backup foram salvas com o caminho relativo contendo a pasta `Dados`):

```cmd
icacls "E:\" /restore "C:\BKP\ACL\ACL-DADOS_AAAAMMDD.txt" /T /C
```

> [!IMPORTANT]  
> Lembre-se de substituir `AAAAMMDD` no nome do arquivo pela data correspondente ao backup que você deseja aplicar.
