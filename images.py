import os
import re
import shutil
import hashlib

# Paths
posts_dir = r"D:\Programming\blog\content\posts"
attachments_dir = r"D:\obsidian\Attachments"
static_images_dir = r"D:\Programming\blog\static\images"

# Dicionário para evitar copiar o mesmo arquivo várias vezes
renamed_files = {}

# --- Função para gerar hash curto e estável ---
def short_hash(name: str, length: int = 16) -> str:
    """Gera hash SHA256 curto e consistente baseado no nome do arquivo base."""
    h = hashlib.sha256(name.encode("utf-8")).hexdigest()
    return h[:length]  # limita a 16 caracteres

# --- Processamento dos arquivos .md ---
for filename in os.listdir(posts_dir):
    if not filename.endswith(".md"):
        continue

    filepath = os.path.join(posts_dir, filename)
    with open(filepath, "r", encoding="utf-8") as file:
        content = file.read()

    # Encontra imagens/gifs/vídeos no formato [[...]]
    media_files = re.findall(
        r'\[\[([^]]*\.(?:png|jpg|jpeg|gif|webp|mp4|webm|mov|avi))\]\]',
        content,
        re.IGNORECASE,
    )

    for original_name in media_files:
        base, ext = os.path.splitext(original_name)
        safe_base = base.replace(" ", "-").lower()

        # Gera hash curto e consistente
        hash_id = short_hash(safe_base)
        new_name = f"{hash_id}{ext.lower()}"

        # Novo link Markdown (ajuste o path se necessário)
        markdown_link = f"![Image Description](/devlogs/images/{new_name})"

        # Substitui ![[arquivo.ext]] ou [[arquivo.ext]]
        content = re.sub(
            rf'!?\[\[{re.escape(original_name)}\]\]', markdown_link, content
        )

        # Caminhos de origem e destino
        src = os.path.join(attachments_dir, original_name)
        dest = os.path.join(static_images_dir, new_name)

        # Copia se ainda não tiver sido copiado
        if os.path.exists(src) and new_name not in renamed_files:
            try:
                shutil.copy(src, dest)
                renamed_files[new_name] = True
                print(f"Copied: {original_name} → {new_name}")
            except Exception as e:
                print(f"Erro ao copiar {original_name}: {e}")

    # Reescreve o arquivo .md com os novos links
    with open(filepath, "w", encoding="utf-8") as file:
        file.write(content)

print("\n✅ Todos os markdowns processados e mídias renomeadas com hash curto.")
