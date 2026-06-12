# Backup de Permissões - Hanna

Este diretório contém o script automatizado para backup e retenção das permissões de acesso (ACLs) do servidor de arquivos (`Dados`) da Hanna.

## 📝 Detalhes do Ambiente
*   **Diretório de Origem (`PASTA`):** `D:\Dados`
*   **Diretório de Destino (`BKPDIR`):** `C:\BKP_HANNA\ACL - ICALCS`
*   **Retenção (`DIAS`):** 30 dias
*   **Nomenclatura do Arquivo:** `ACL-DADOS_AAAAMMDD.txt`

---

## 💾 Arquivo do Script
*   Você pode baixar o arquivo do script diretamente aqui: [bkp-acl-hanna.bat](./bkp-acl-hanna.bat)

---

## 💻 Código do Script (`bkp-acl-hanna.bat`)
```bat
@echo off

:: --- CONFIGURAÇÃO DE DIRETÓRIOS ---
set PASTA=D:\Dados
set BKPDIR=C:\BKP_HANNA\ACL - ICALCS
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
2.  Execute o comando abaixo, apontando para a pasta raiz `D:\` (pois as permissões no backup foram salvas com o caminho relativo contendo a pasta `Dados`):

```cmd
icacls "D:\" /restore "C:\BKP_HANNA\ACL - ICALCS\ACL-DADOS_AAAAMMDD.txt" /T /C
```

> [!IMPORTANT]  
> Lembre-se de substituir `AAAAMMDD` no nome do arquivo pela data correspondente ao backup que você deseja aplicar.
