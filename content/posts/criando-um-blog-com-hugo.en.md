---
title: Creating a blog with hugo
date: 2025-10-06
draft: false
tags:
  - blog
  - hugo
  - re-terminal
---
## Motivation

Throughout most of my career, I’ve always focused on growing technically through study and applying what I’ve learned in the best way possible.  
However, I realized I was missing a space to document my learning process — a **devlog** — that could serve both as a personal knowledge base and a way to share insights with other developers.

During my research, I came across **Hugo**, a simple yet extremely powerful tool for creating static websites. Its speed and ease of development caught my attention, so I decided to use it to build this knowledge hub. And here we are.
## How it was developed

So, what exactly is **Hugo**?  
According to the [official documentation](https://themes.gohugo.io/):

> “Hugo is one of the most popular open-source static site generators. With its amazing speed and flexibility, Hugo makes building websites fun again.”

With a few [prerequisites](https://gohugo.io/getting-started/quick-start/#prerequisites) installed, you can have it running in just a few minutes.

After installation, you can confirm everything is working correctly:

```bash
> hugo version
# hugo v0.151.0-c70ab27ceb841fc9404eab5d2c985ff7595034b7+extended windows/amd64 BuildDate=2025-10-02T13:30:36Z VendorInfo=gohugoio
```

Once that’s done, you can create a new site using one of Hugo’s **basic templates**:

```bash
hugo new site quickstart
cd quickstart
git init
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
echo "theme = 'ananke'" >> hugo.toml
hugo server
```

The command above starts a local server, and your site will be available at `http://localhost:1313/`.

![Image Description](/devlogs/images/Pasted-image-20251006203921.png)
## Choosing the theme and configuring the project

For the initial setup, I used the **Ananke** theme just for demonstration.  
Then, I browsed through the [community theme repository](https://themes.gohugo.io/tags/blog/) and selected [**re-terminal**](https://github.com/panr/hugo-theme-terminal) — I liked its retro, terminal-like appearance, which fits well with the message I want to convey in this blog.
### Installing the theme

The theme provides three installation methods, described in the [official documentation](https://github.com/panr/hugo-theme-terminal?tab=readme-ov-file#how-to-start).  
After testing them all, I found **option 3** to be the easiest:

```bash
git submodule add -f https://github.com/panr/hugo-theme-terminal.git themes/terminal
```

Once installed, adjust the main configuration file (`hugo.toml`):

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

Finally, start the project again:

```bash
hugo server -t terminal
```

## Creating the first post

**Hugo** follows a well-organized directory structure, as described in the [official documentation](https://gohugo.io/getting-started/directory-structure/):

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

Posts are stored in the **`content/posts`** folder. If you want to support multiple languages (like in this blog), simply create files with language suffixes — for example, `post.en.md` and `post.pt.md`.  

These languages must be defined in your `hugo.toml` configuration file:

```toml
[languages]
  [languages.en]
    languageName = "English"
    [languages.en.params]
      title = "DevLogs"
      subtitle = "A simple DevLog"

  [languages.pt]
    languageName = "Portuguese"
    [languages.pt.params]
      title = "DevLogs"
      subtitle = "A simple DevLog"
```

Hugo will then automatically recognize the translations and generate corresponding language versions of your site.
## Conclusion

With the basic blog setup complete, I started adding features I felt were missing — such as **search**, **numbered pagination**, and **language switching**.  

In upcoming posts, I’ll walk through how I implemented these **features** and how you can add them to your own **Hugo** blog as well.