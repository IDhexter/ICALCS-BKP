# ICALCS Backups - Controle de Permissões de Arquivos

Repositório contendo scripts automatizados para backup e retenção de permissões de acesso (Access Control Lists - ACLs) do Windows (`icacls`) para diferentes ambientes e clientes.

## 📌 Clientes Cadastrados

Clique no link abaixo para pular diretamente para a configuração do cliente desejado:

*   [VEGA](#-1-vega)
*   [Hospital Evangélico de Sorocaba (HES)](#-2-hospital-evangélico-de-sorocaba-hes)

---

## 🏢 1. VEGA

Script de backup das permissões para a estrutura de pastas da VEGA.

### 📝 Detalhes do Ambiente
*   **Diretório de Origem (`PASTA`):** `D:\Vega`
*   **Diretório de Destino (`BKPDIR`):** `D:\Vega\Operacao\Backups - Diversos\ICALCS-VEGA`
*   **Retenção (`DIAS`):** 30 dias
*   **Nomenclatura do Arquivo:** `ACL-VEGA_AAAAMMDD.txt`

### 💾 Arquivo do Script
*   Script pronto para download/uso: [bkp-acl-vega.bat](./Vega/bkp-acl-vega.bat)

### 💻 Código do Script
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

### ↩️ Como Restaurar as Permissões
Para restaurar as permissões a partir de um backup existente, abra o Prompt de Comando (CMD) como **Administrador** e execute:
```cmd
icacls "D:\" /restore "D:\Vega\Operacao\Backups - Diversos\ICALCS-VEGA\ACL-VEGA_AAAAMMDD.txt" /T /C
```
> [!IMPORTANT]  
> Substitua `AAAAMMDD` no comando acima pela data do arquivo de backup que deseja restaurar. O diretório alvo deve ser a raiz do volume (`D:\`), pois as permissões foram salvas com o caminho relativo contendo a pasta `Vega`.

---

## 🏥 2. Hospital Evangélico de Sorocaba (HES)

Script de backup das permissões para o servidor de arquivos (`Dados`) do Hospital Evangélico de Sorocaba.

### 📝 Detalhes do Ambiente
*   **Diretório de Origem (`PASTA`):** `E:\Dados`
*   **Diretório de Destino (`BKPDIR`):** `C:\BKP`
*   **Retenção (`DIAS`):** 30 dias
*   **Nomenclatura do Arquivo:** `ACL-DADOS_AAAAMMDD.txt`

### 💾 Arquivo do Script
*   Script pronto para download/uso: [bkp-acl-hes.bat](./Hospital-Evangelico-Sorocaba/bkp-acl-hes.bat)

### 💻 Código do Script
```bat
@echo off

:: --- CONFIGURAÇÃO DE DIRETÓRIOS ---
set PASTA=E:\Dados
set BKPDIR=C:\BKP
set DIAS=30

:: Criar a pasta de backup caso ela não exista
if not exist "%BKPDIR%" mkdir "%BKPDIR%"

:: Obter a data atual no formato AAAAMMDD de forma padronizada
for /f "tokens=2 delims==" %%i in ('wmic os get LocalDateTime /value ^| find "="') do set ldt=%%i
set DATA=%ldt:~0,8%

:: Executar o backup das permissões (ACLs)
icacls "%PASTA%" /save "%BKPDIR%\ACL-DADOS_%DATA%.txt" /T /C /Q

:: Apagar backups automáticos com mais de 30 dias
forfiles /p "%BKPDIR%" /m "ACL-DADOS_*.txt" /d -%DIAS% /c "cmd /c del /q @path"

:: Confirmação na tela
echo OK - Backup criado: "%BKPDIR%\ACL-DADOS_%DATA%.txt"
```

### ↩️ Como Restaurar as Permissões
Para restaurar as permissões a partir de um backup existente, abra o Prompt de Comando (CMD) como **Administrador** e execute:
```cmd
icacls "E:\" /restore "C:\BKP\ACL-DADOS_AAAAMMDD.txt" /T /C
```
> [!IMPORTANT]  
> Substitua `AAAAMMDD` no comando acima pela data do arquivo de backup que deseja restaurar. O diretório alvo deve ser a raiz do volume (`E:\`), pois as permissões foram salvas com o caminho relativo contendo a pasta `Dados`.
