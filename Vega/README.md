# Backup de Permissões - VEGA

Este diretório contém o script automatizado para backup e retenção das permissões de acesso (ACLs) da estrutura de pastas da VEGA.

## 📝 Detalhes do Ambiente
*   **Diretório de Origem (`PASTA`):** `D:\Vega`
*   **Diretório de Destino (`BKPDIR`):** `D:\Vega\Operacao\Backups - Diversos\ICALCS-VEGA`
*   **Retenção (`DIAS`):** 30 dias
*   **Nomenclatura do Arquivo:** `ACL-VEGA_AAAAMMDD.txt`

---

## 💾 Arquivo do Script
*   Você pode baixar o arquivo do script diretamente aqui: [bkp-acl-vega.bat](./bkp-acl-vega.bat)

---

## 💻 Código do Script (`bkp-acl-vega.bat`)
```bat
@echo off

:: --- CONFIGURAÇÃO DE DIRETÓRIOS ---
set PASTA=D:\Vega
set BKPDIR=D:\Vega\Operacao\Backups - Diversos\ICALCS-VEGA
set DIAS=30

:: Criar a pasta de backup caso ela não exista
if not exist "%BKPDIR%" mkdir "%BKPDIR%"

:: Obter a data atual no formato AAAAMMDD de forma padronizada
for /f "tokens=2 delims==" %%i in ('wmic os get LocalDateTime /value ^| find "="') do set ldt=%%i
set DATA=%ldt:~0,8%

:: Executar o backup das permissões (ACLs)
icacls "%PASTA%" /save "%BKPDIR%\ACL-VEGA_%DATA%.txt" /T /C /Q

:: Apagar backups automáticos com mais de 30 dias
forfiles /p "%BKPDIR%" /m "ACL-VEGA_*.txt" /d -%DIAS% /c "cmd /c del /q @path"

:: Confirmação na tela
echo OK - Backup criado: "%BKPDIR%\ACL-VEGA_%DATA%.txt"
```

---

## ↩️ Como Restaurar as Permissões
Caso seja necessário restaurar as permissões a partir de um backup:

1.  Abra o **Prompt de Comando (CMD)** como **Administrador**.
2.  Execute o comando abaixo, apontando para a pasta raiz `D:\` (pois as permissões no backup foram salvas com o caminho relativo contendo a pasta `Vega`):

```cmd
icacls "D:\" /restore "D:\Vega\Operacao\Backups - Diversos\ICALCS-VEGA\ACL-VEGA_AAAAMMDD.txt" /T /C
```

> [!IMPORTANT]  
> Lembre-se de substituir `AAAAMMDD` no nome do arquivo pela data correspondente ao backup que você deseja aplicar.
