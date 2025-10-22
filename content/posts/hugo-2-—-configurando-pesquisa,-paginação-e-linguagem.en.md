---
title: "Hugo #2 — Adding Improvements to Our Blog"
date: 2025-10-20
draft: false
tags:
  - hugo
  - translation
  - pagination
  - language
---

In this article, we’ll take a closer look at the **Hugo** tool, understand how some of its **APIs** work — search, pagination, and language — and learn how to use them to enhance our blog.

---

## Language Selector and Translation

When creating a new project with Hugo, only one language is configured by default. However, the tool easily allows you to add support for multiple languages through a simple configuration:

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

With the languages configured and using Hugo’s folder organization system, we can edit the main configuration file to enable the language selector:

```toml
# Displays the language selection menu
showLanguageSelector = true
```

Once this option is enabled and translations are properly configured, the language selection menu will appear according to your theme’s design.

For the **re-terminal** theme, for example, the expected result will look like this:

![Image Description](/devlogs/images/Pasted-image-20251020233751.png)

---

## Default Pagination and How to Customize It

Hugo also provides native support for **pagination**, allowing full control over its appearance and behavior.  
One of the most important parameters is the number of items displayed per page:

```toml
pagination.pagerSize = 10
```

After setting this configuration, when the number of items exceeds the defined limit, Hugo will automatically display the pagination menu according to your theme’s style.

With the **re-terminal** theme, and after some styling adjustments, the result might look like this:

![Image Description](/devlogs/images/Pasted-image-20251020234144.png)

In the example above, the pagination elements of the default theme were customized.  
To achieve the same result, you can create a file called `layouts/partials/pagination.html` with the following content:

```html
{{ $p := .Paginator }}
{{ if gt $p.TotalPages 1 }}
<div class="pagination">
  <div class="pagination__buttons">

    {{ if $p.HasPrev }}
    <a href="{{ $p.Prev.URL }}" class="button previous"
      aria-label="Previous page" title="Previous page">
      &lt;
    </a>
    {{ end }}
	
    <nav class="pagination__numbers" role="navigation" aria-label="Pagination">
      {{ range $i, $pager := $p.Pagers }}
      {{ $num := add $i 1 }}
      {{ if eq $num $p.PageNumber }}
      <span class="page current" aria-current="page">{{ $num }}</span>
      {{ else }}
      <a href="{{ $pager.URL }}" class="page"
        title="Go to page {{ $num }}">{{ $num }}</a>
      {{ end }}
      {{ end }}
    </nav>

    {{ if $p.HasNext }}
    <a href="{{ $p.Next.URL }}" class="button next" aria-label="Next page"
      title="Next page">
      &gt;
    </a>
    {{ end }}

  </div>
</div>
{{ end }}
```

In the code above, we perform a few checks to determine what should be displayed:

- We check if there is at least one page.  
- We display the **previous page** link if available.  
- We generate a **numeric link** for each page.  
- We display the **next page** link if it exists.

---

## Configuring Search

Since Hugo is a **static site generator**, it doesn’t include a database or built-in API for handling searches.  
To add search functionality, we need to **index the files generated during the build process** — and that’s where **Pagefind** comes in.

[Pagefind](https://pagefind.app/docs/) is a simple yet powerful tool that provides **lightning-fast local search** for static sites, with quick installation and setup.

To initialize the Pagefind API, add the following code to your project:

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

In this example, we’ll add the search field to the **header** of the blog.  
Create a file called `partials/header.html` and reimplement the **re-terminal** theme structure as follows:

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

The **div** with the attribute **id="search"** is where the search interface will be rendered.  
After adding the code, the result should look similar to this:

![Image Description](/devlogs/images/Pasted-image-20251021000348.png)

However, for the posts to appear correctly in the search results, you’ll need to **index your site**.  
You can do this using the Pagefind command (see more details in the [official documentation](https://pagefind.app/docs/running-pagefind/)):

```bash
# Generate a new Hugo build
hugo

# Index the generated posts
npx pagefind --site public --glob "**/posts/*.html"
```

In the command above, we run **Pagefind** on the site inside the `public/` folder, using the `--glob` flag to filter only files located within the `posts` directory.

After running the command, Pagefind will display a summary of the indexing process — including the number of files indexed, detected languages, and other details. It's a good idea to set the `data-pagefind-body` attribute in the `layouts\_default\single.html` file so that Pagefind can correctly locate the data it needs to index.

![Image Description](/devlogs/images/Pasted-image-20251021233149.png)

---

## Conclusion

With the configurations presented in this article, we’ve made Hugo even more powerful and flexible, adding essential features like **multi-language support**, **custom pagination**, and an **efficient local search** with Pagefind.

These enhancements take your static blog to the next level, offering a smoother and more intuitive experience for readers without compromising performance — one of Hugo’s greatest strengths.

From here, you can keep exploring the tool’s potential, adjusting your design, optimizing content, and even automating the build and search indexing process in your deployment pipeline.

Hugo is extremely flexible, and with small customizations like the ones shown today, it’s possible to create fast, professional, and multilingual blogs with very little effort.
