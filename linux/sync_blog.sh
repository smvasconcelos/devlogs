#!/bin/bash

# --- Configurações de Variáveis ---
# Altere estes caminhos para os caminhos do seu sistema Linux/WSL
SOURCE_PATH="/mnt/Games/Programming/obsidian/Blog/Posts"
DESTINATION_PATH="/mnt/Games/Programming/Blog/devlogs/content/posts"
BLOG_PATH="/mnt/Games/Programming/Blog/devlogs/"
MY_REPO="https://github.com/smvasconcelos/devlogs"

# Interrompe o script em caso de erro
set -e

# Define o diretório do script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd "$SCRIPT_DIR"

# --- Verificação de Comandos ---
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Erro: $1 não está instalado ou não está no PATH."
        exit 1
    fi
}

# Verifica Python (python ou python3)
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    echo "Erro: Python não encontrado."
    exit 1
fi

check_command "git"
check_command "hugo"
check_command "npx"

# --- Passo 1: Sincronização ---
echo "Sincronizando posts do Obsidian..."

if [ ! -d "$SOURCE_PATH" ]; then
    echo "Erro: Caminho de origem não existe: $SOURCE_PATH"
    exit 1
fi

if [ ! -d "$DESTINATION_PATH" ]; then
    echo "Erro: Caminho de destino não existe: $DESTINATION_PATH"
    exit 1
fi

# --- Passo 2: Processamento por Idioma ---
LANGUAGES=("en" "pt")

for LANG in "${LANGUAGES[@]}"; do
    LANG_SOURCE="$SOURCE_PATH/$LANG"

    if [ ! -d "$LANG_SOURCE" ]; then
        echo "Aviso: Pasta de idioma não encontrada: $LANG_SOURCE"
        continue
    fi

    echo "Processando idioma: $LANG"

    # Busca arquivos .md recursivamente
    find "$LANG_SOURCE" -type f -name "*.md" | while read -r FILE; do
        FILE_NAME=$(basename "$FILE" .md)
        
        # Nome seguro (minúsculo e sem espaços)
        SAFE_FILE_NAME=$(echo "$FILE_NAME" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '-')

        # Gera hash SHA256 (equivalente aos 16 caracteres hex do PS)
        SHORT_HASH=$(echo -n "$SAFE_FILE_NAME" | sha256sum | cut -c1-16)

        DEST_FILE="$DESTINATION_PATH/$SHORT_HASH.$LANG.md"

        cp "$FILE" "$DEST_FILE"
        echo "Copiado: $SAFE_FILE_NAME como $SHORT_HASH.$LANG.md"
    done
done

echo "Sincronização concluída — arquivos renomeados por idioma."

# --- Passo 3: Script Python para Imagens ---
echo "Processando links de imagem..."
if [ ! -f "images.py" ]; then
    echo "Erro: Script Python images.py não encontrado."
    exit 1
fi

$PYTHON_CMD images.py

# --- Passo 4: Build do Hugo ---
cd "$BLOG_PATH"
echo "Construindo o site Hugo..."

hugo

echo "Indexando arquivos de busca..."
npx pagefind --site public

# --- Passo 5 & 6: Git Flow ---
echo "Preparando mudanças para o Git..."

if [ -z "$(git status --porcelain)" ]; then
    echo "Nenhuma mudança para stage."
else
    git add .
    
    # Commit
    COMMIT_MESSAGE="post: New Blog Post on $(date '+%Y-%m-%d %H:%M:%S')"
    
    if git diff --cached --quiet; then
        echo "Nenhuma mudança para commit."
    else
        echo "Commitando mudanças..."
        git commit -m "$COMMIT_MESSAGE"
    fi
fi

# --- Passo 7: Push ---
echo "Fazendo deploy para GitHub Main..."

git push origin main

echo "Tudo pronto! Site sincronizado, processado, commitado e publicado."