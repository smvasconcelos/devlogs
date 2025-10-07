---
title: Criando um blog com hugo
date: 2025-10-06
draft: false
tags:
  - blog
  - hugo
  - re-terminal
---
# Motivação

Durante a maior parte da minha carreira, sempre foquei em evoluir tecnicamente por meio de estudos e em aplicar da melhor forma possível o que aprendi.  
Mas percebi que faltava um espaço para documentar esse processo de aprendizado — **um devlog** — que servisse tanto como repositório de consulta quanto como uma forma de compartilhar conhecimento com outros profissionais.

Durante as pesquisas, descobri o **Hugo**, uma ferramenta simples, porém extremamente poderosa, para criação de sites estáticos. A velocidade e a facilidade de desenvolvimento me chamaram a atenção, e decidi usá-la para construir este hub de conhecimento. E aqui estamos.

# Como foi desenvolvido

Mas afinal, o que é o **Hugo**?  
Segundo a [documentação oficial](https://themes.gohugo.io/):

> “Hugo é um dos geradores de sites estáticos de código aberto mais populares. Com sua incrível velocidade e flexibilidade, Hugo torna a criação de sites divertida novamente.”

Com alguns [pré-requisitos](https://gohugo.io/getting-started/quick-start/#prerequisites) instalados, é possível colocá-lo para rodar em poucos minutos.

Após a instalação, confirme que está tudo certo:

```bash
> hugo version
# hugo v0.151.0-c70ab27ceb841fc9404eab5d2c985ff7595034b7+extended windows/amd64 BuildDate=2025-10-02T13:30:36Z VendorInfo=gohugoio
```

Com tudo funcionando, podemos criar um site a partir de um dos **templates básicos** que o Hugo disponibiliza:

```bash
hugo new site quickstart
cd quickstart
git init
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
echo "theme = 'ananke'" >> hugo.toml
hugo server
```

O comando acima inicia o servidor local e o site estará disponível em `http://localhost:1313/`.

![Image Description](/devlogs/images/Pasted-image-20251006203921.png)

## Escolhendo o tema e configurando o projeto

Na configuração inicial, utilizei o tema **Ananke** apenas para demonstração.  
Depois, fui até o [repositório de temas da comunidade](https://themes.gohugo.io/tags/blog/) e escolhi o tema [**re-terminal**](https://github.com/panr/hugo-theme-terminal) — o visual retrô e o estilo de terminal antigo combinaram muito bem com a proposta deste blog.

### Instalando o tema

O tema oferece três formas de instalação, descritas na [documentação oficial](https://github.com/panr/hugo-theme-terminal?tab=readme-ov-file#how-to-start).  
Após testar todas, a **opção 3** se mostrou a mais prática:

```bash
git submodule add -f https://github.com/panr/hugo-theme-terminal.git themes/terminal
```

Com o tema instalado, basta ajustar o arquivo principal de configuração (`hugo.toml`):

```toml
baseurl = "/"
languageCode = "en-us"
theme = "terminal"
pagination.pagerSize = 5

[markup.highlight]
  noClasses = false

[params]
  contentTypeName = "posts"
  showMenuItems = 2
  showLanguageSelector = false
  fullWidthTheme = false
  centerTheme = false
  autoCover = true
  showLastUpdated = false
```

E por fim, rodar o projeto novamente:

```bash
hugo server -t terminal
```
# Criando a primeira postagem

O **Hugo** segue uma estrutura de diretórios bem organizada, como descrito na [documentação oficial](https://gohugo.io/getting-started/directory-structure/):

```txt
my-site/
	├── archetypes/
	├── assets/
	├── content/
	│   └── posts/
	│       └── default.{lang}.md
	│       └── default.{lang}.md
	├── data/
	├── i18n/
	├── layouts/
	├── static/
	├── themes/
	└── hugo.toml
```

Os posts ficam na pasta **`content/posts`**.  
Se quiser oferecer múltiplos idiomas (como neste blog), basta criar arquivos com sufixos de idioma — por exemplo, `post.en.md` e `post.pt.md`.  
As línguas devem estar configuradas previamente no `hugo.toml`:

```toml
[languages]
  [languages.en]
    languageName = "English"
    [languages.en.params]
      title = "DevLogs"
      subtitle = "A simple DevLog"

  [languages.pt]
    languageName = "Português"
    [languages.pt.params]
      title = "DevLogs"
      subtitle = "Um simples DevLog"
```

Assim, o Hugo reconhecerá automaticamente as traduções e gerará as versões correspondentes do site.
# Conclusão

Com a base pronta, comecei a implementar melhorias que senti falta — como **pesquisa**, **paginação numérica** e **alternância de idioma**.  
Nos próximos posts, vou detalhar como foi o processo de adicionar essas **features** e como você também pode aplicá-las no seu blog desenvolvido com **Hugo**.