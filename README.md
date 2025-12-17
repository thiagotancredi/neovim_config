# Neovim Setup – Configuração Completa

Este repositório contém uma configuração de **Neovim focada em desenvolvimento Python**, com LSP, autocomplete, **GitHub Copilot (sugestões + painel)**, **Copilot Chat (conversação com IA)**, formatação automática e uma UI moderna.

> **Leader key:** `Espaço`

---

## 1. Pré-requisitos

Antes de tudo, é necessário instalar algumas ferramentas **fora do Neovim**.

### 1.1 Neovim

* **Neovim >= 0.9** (recomendado 0.10+)

```bash
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim -y
```

Verificar:

```bash
nvim --version
```

---

### 1.2 Git

```bash
sudo apt install git -y
```

---

### 1.3 Node.js (OBRIGATÓRIO)

Necessário para **GitHub Copilot** e **Copilot Chat**.

```bash
sudo apt install nodejs npm -y
```

Verificar:

```bash
node -v
```

> Recomendado: Node 18+

---

### 1.4 Build tools (para Copilot Chat – recomendado)

Usado para compilar o `tiktoken` (melhora performance do chat).

```bash
sudo apt install build-essential -y
```

---

### 1.5 Python, Poetry e Pipx

Esta configuração separa claramente **ferramentas globais** (pipx) de **dependências de projeto** (Poetry).

---

#### 🔹 pipx (ferramentas globais)

Use **pipx** para instalar ferramentas de linha de comando que você usa em vários projetos.

Instalação do pipx:

```bash
sudo apt install pipx -y
pipx ensurepath
```

Ferramentas recomendadas via pipx:

```bash
pipx install poetry
pipx install black
pipx install isort
```

Motivo:

* ficam isoladas do Python do sistema
* disponíveis globalmente
* não poluem ambientes de projeto

---

#### 🔹 Poetry (dependências do projeto)

Use **Poetry** para gerenciar dependências **dentro de cada projeto Python**.

Exemplo de uso:

```bash
poetry init
poetry add fastapi sqlalchemy
poetry add --group dev pytest ruff
```

Quando usar Poetry:

* bibliotecas da aplicação
* dependências de teste
* ferramentas que precisam respeitar versões do projeto

> No Neovim, o LSP detecta automaticamente o ambiente Poetry ativo.

---

## 2. Primeiro uso (passo a passo)

Siga esta ordem para evitar problemas de autenticação e plugins não carregados:

1. Abra o Neovim
2. Execute `:Lazy sync`
3. Reinicie o Neovim
4. Autentique o Copilot:

   ```vim
   :Copilot auth
   ```
5. Verifique o status:

   ```vim
   :Copilot status
   ```
6. Abra um arquivo Python e teste as sugestões

---

## 3. Gerenciador de Plugins

### lazy.nvim

O **lazy.nvim** gerencia todos os plugins.

Primeira vez no Neovim:

```vim
:Lazy sync
```

---

## 4. Plugins Instalados (Resumo)

### UI / Visual

* nord.nvim – Tema
* lualine.nvim – Statusline
* bufferline.nvim – Buffers em abas
* nvim-tree.lua – Explorador de arquivos
* nvim-web-devicons – Ícones

### Navegação e Produtividade

* telescope.nvim – Busca de arquivos/texto
* nvim-autopairs – Pares automáticos
* gitsigns.nvim – Integração Git

### Código

* nvim-treesitter – Highlight/indent
* nvim-cmp – Autocomplete
* LuaSnip – Snippets
* none-ls.nvim – Black + Isort

### LSP

* mason.nvim
* mason-lspconfig.nvim
* nvim-lspconfig
* pyright (Python)

### IA

* copilot.lua – Sugestões de código
* CopilotChat.nvim – Chat com IA dentro do Neovim

---

## 5. Copilot vs Copilot Chat

* **Copilot**: sugere código automaticamente enquanto você digita
* **Copilot Chat**: conversa com a IA para explicar, corrigir e gerar código

Use **Copilot** para escrever código.
Use **Copilot Chat** para pensar, revisar e aprender.

---

## 6. GitHub Copilot (Sugestões)

### 4.1 Autenticação

```vim
:Copilot auth
```

Ver status:

```vim
:Copilot status
```

---

### 4.2 Atalhos – Sugestões

| Atalho     | Ação               |
| ---------- | ------------------ |
| `Ctrl + l` | Aceitar sugestão   |
| `Alt + ]`  | Próxima sugestão   |
| `Alt + [`  | Sugestão anterior  |
| `Ctrl + ]` | Dispensar sugestão |

---

### 4.3 Painel do Copilot

| Atalho        | Ação                       |
| ------------- | -------------------------- |
| `Alt + Enter` | Abrir painel de sugestões  |
| `Enter`       | Aceitar sugestão no painel |
| `[[` / `]]`   | Navegar entre sugestões    |
| `gr`          | Atualizar painel           |

---

## 7. Copilot Chat (Conversar com IA)

Permite **explicar, corrigir e gerar testes** a partir do código selecionado.

### Atalhos

| Atalho                | Ação                        |
| --------------------- | --------------------------- |
| `<Leader>cc`          | Abrir/Fechar Copilot Chat   |
| `<Leader>ce` (visual) | Explicar código selecionado |
| `<Leader>cf` (visual) | Corrigir código selecionado |
| `<Leader>ct` (visual) | Gerar testes para o código  |

> `Leader` = **Espaço**

---

## 8. Atalhos Gerais

### Arquivos

| Atalho      | Descrição             |
| ----------- | --------------------- |
| `<Leader>w` | Salvar arquivo        |
| `<Leader>q` | Fechar buffer         |
| `<Leader>e` | Abrir/Fechar NvimTree |

---

### Diagnóstico e LSP

| Atalho       | Descrição            |
| ------------ | -------------------- |
| `gd`         | Ir para definição    |
| `K`          | Hover (documentação) |
| `gr`         | Referências          |
| `[d` / `]d`  | Navegar erros        |
| `<Leader>.`  | Code Action          |
| `<Leader>rn` | Renomear símbolo     |
| `<Leader>f`  | Formatar código      |

---

### Buffers

| Atalho        | Descrição       |
| ------------- | --------------- |
| `<Tab>`       | Próximo buffer  |
| `Shift + Tab` | Buffer anterior |

---

### Telescope

| Atalho       | Descrição               |
| ------------ | ----------------------- |
| `<Leader>ff` | Buscar arquivos         |
| `<Leader>fg` | Buscar texto no projeto |
| `<Leader>fb` | Listar buffers          |

---

### Terminal Inteligente

| Atalho     | Descrição               |
| ---------- | ----------------------- |
| `Ctrl + j` | Abrir terminal inferior |
| `Ctrl + q` | Fechar terminal         |

Funciona em modo normal e terminal.

---

## 9. Problemas comuns

### Copilot não sugere nada

* Verifique `:Copilot status`
* Aguarde 1–2 segundos após digitar
* Confirme que o arquivo não é markdown ou texto puro

### Copilot Chat não abre

* Verifique se o Node.js está instalado
* Rode `:Lazy sync`
* Reinicie o Neovim

---

## 10. O que este setup não inclui

* Debugger (DAP)
* Testes automatizados
* Git UI completa (ex: LazyGit)

---

## 11. Observações

* Setup focado em **Python + IA**
* Copilot Chat é ideal para revisão e aprendizado
* Formatter e LSP garantem padrão de código

---

✅ Configuração moderna, produtiva e documentada para uso diário.
