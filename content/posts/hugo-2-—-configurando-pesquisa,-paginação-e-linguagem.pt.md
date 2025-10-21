---
title: "Hugo #2 — Adicionando melhorias no nosso blog"
date: 2025-10-20
draft: false
tags:
  - hugo
  - translation
  - pagination
  - language
---

Neste artigo, vamos conhecer um pouco mais sobre a ferramenta **Hugo**, entender como funcionam algumas de suas **APIs** — pesquisa, paginação e linguagem — e descobrir como utilizá-las para aprimorar o nosso blog.

---

## Seletor de linguagem e tradução

Ao criar um novo projeto com o Hugo, temos configurada apenas uma linguagem por padrão. No entanto, a ferramenta permite facilmente adicionar suporte a múltiplos idiomas, por meio de uma configuração simples:

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

Com as linguagens configuradas e utilizando o sistema de organização de pastas do Hugo, podemos editar o arquivo de configuração principal para ativar o seletor de idiomas:

```toml
# Exibe o menu de seleção de linguagem
showLanguageSelector = true
```

Com essa opção ativada e as traduções configuradas corretamente, o menu de seleção de idioma será exibido de acordo com as definições do seu tema.

No tema **re-terminal**, por exemplo, o resultado esperado será algo semelhante a:

![Image Description](/devlogs/images/Pasted-image-20251020233751.png)

---

## Paginação padrão e como personalizar

O Hugo também oferece suporte nativo à **paginação**, permitindo controlar completamente sua aparência e comportamento.  
Um dos parâmetros mais importantes é a quantidade de itens exibidos por página:

```toml
pagination.pagerSize = 10
```

Após definir essa configuração, quando o número de itens ultrapassar o limite estabelecido, o Hugo exibirá o menu de paginação conforme o padrão do seu tema.

Com o tema **re-terminal**, e após algumas personalizações de estilo, o resultado pode se parecer com o seguinte:

![Image Description](/devlogs/images/Pasted-image-20251020234144.png)

No exemplo acima, foi feita uma personalização dos itens de paginação do tema padrão.  
Para obter o mesmo resultado, você pode criar o arquivo `layouts/partials/pagination.html` com o seguinte conteúdo:

```html
{{ $p := .Paginator }}
{{ if gt $p.TotalPages 1 }}
<div class="pagination">
  <div class="pagination__buttons">

    {{ if $p.HasPrev }}
    <a href="{{ $p.Prev.URL }}" class="button previous"
      aria-label="Página anterior" title="Página anterior">
      &lt;
    </a>
    {{ end }}
	
    <nav class="pagination__numbers" role="navigation" aria-label="Paginação">
      {{ range $i, $pager := $p.Pagers }}
      {{ $num := add $i 1 }}
      {{ if eq $num $p.PageNumber }}
      <span class="page current" aria-current="page">{{ $num }}</span>
      {{ else }}
      <a href="{{ $pager.URL }}" class="page"
        title="Ir para página {{ $num }}">{{ $num }}</a>
      {{ end }}
      {{ end }}
    </nav>

    {{ if $p.HasNext }}
    <a href="{{ $p.Next.URL }}" class="button next" aria-label="Próxima página"
      title="Próxima página">
      &gt;
    </a>
    {{ end }}

  </div>
</div>
{{ end }}
```

No código acima, fazemos algumas validações para definir o que será exibido:

- Verificamos se existe pelo menos uma página.  
- Exibimos o link da **página anterior**, caso disponível.  
- Geramos um **link numérico** para cada página.  
- Exibimos o link da **próxima página**, caso também exista.

---

## Configurando a pesquisa

Como o Hugo é uma ferramenta para gerar **sites estáticos**, ele não possui banco de dados nem uma API própria para realizar buscas.  
Para adicionar uma funcionalidade de pesquisa, precisamos **indexar os arquivos gerados durante o build** — e é aqui que entra o **Pagefind**.

O [Pagefind](https://pagefind.app/docs/) é uma ferramenta simples e poderosa que adiciona uma **busca local e ultrarrápida** ao seu site estático, com instalação e configuração rápidas.

Para inicializar a API do Pagefind, adicione o seguinte código ao seu projeto:

```html
<link href="/pagefind/pagefind-ui.css" rel="stylesheet">
<script src="/pagefind/pagefind-ui.js"></script>
<div id="search"></div>
<script>
    window.addEventListener('DOMContentLoaded', (event) => {
        new PagefindUI({ element: "#search", showSubResults: true });
    });
</script>
```

Neste exemplo, vamos adicionar o campo de busca ao **header** do blog.  
Crie um arquivo chamado `partials/header.html` e reimplemente a estrutura do tema **re-terminal** da seguinte forma:

```html
<header class="header">
  <div class="header__inner">
    <div class="header__logo">
      {{ partial "logo.html" . }}
    </div>
    {{ if len $.Site.Menus }}
    {{ partial "mobile-menu.html" . }}
    {{ end }}
    <div id="search"></div>
    {{ if and $.Site.Params.showLanguageSelector (len $.Site.Home.AllTranslations) }}
    {{ partial "language-menu.html" . }}
    {{ end }}
  </div>
</header>
```

A **div** com o atributo **id="search"** é o local onde a interface de busca será renderizada.  
Após adicionar o código, o resultado deve se parecer com o exemplo abaixo:

![Image Description](/devlogs/images/Pasted-image-20251021000348.png)

Entretanto, para que os posts apareçam corretamente nos resultados de pesquisa, é necessário **indexar o site**.  
Podemos fazer isso com o comando do Pagefind (mais detalhes na [documentação oficial](https://pagefind.app/docs/running-pagefind/)):

```bash
# Gera uma nova build do Hugo
hugo

# Indexa os posts gerados
npx pagefind --site public --glob "**/posts/*.html"
```

No comando acima, executamos o **Pagefind** sobre o site presente na pasta `public/`, usando a flag `--glob` para filtrar apenas os arquivos localizados dentro da pasta `posts`.

Após rodar o comando, o Pagefind exibirá um resumo contendo o que foi gerado — como o número de arquivos indexados, as linguagens detectadas, e outros detalhes.

![Image Description](/devlogs/images/Pasted-image-20251021000828.png)

## Conclusão

Com as configurações apresentadas neste artigo, conseguimos tornar o Hugo ainda mais completo e funcional, adicionando recursos essenciais como **suporte a múltiplos idiomas**, **paginação personalizada** e uma **pesquisa local eficiente** com o Pagefind.

Essas funcionalidades elevam o nível do seu blog estático, oferecendo uma experiência mais fluida e intuitiva para o leitor, sem comprometer o desempenho — um dos grandes diferenciais do Hugo.

A partir daqui, você pode continuar explorando o potencial da ferramenta, ajustando o design, otimizando o conteúdo e até automatizando o processo de build e indexação da pesquisa em seu pipeline de deploy.

O Hugo é extremamente flexível e, com pequenas personalizações como as vistas hoje, é possível criar blogs profissionais, rápidos e multilíngues com muito pouco esforço.