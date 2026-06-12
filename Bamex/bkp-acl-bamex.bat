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
