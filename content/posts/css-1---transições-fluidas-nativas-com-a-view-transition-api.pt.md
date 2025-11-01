---
title: "CSS #1 - Transições Fluidas Nativas com a View Transition API"
date: 2025-11-01
draft: false
tags:
  - css
  - animations
  - transitions
  - view-transition
  - firefox
---

A experiência do usuário (UX) em aplicações web modernas exige fluidez e continuidade, algo que historicamente era difícil de alcançar em sites tradicionais  sem o uso de frameworks complexos de SPA. O recarregamento completo da página muitas vezes quebra o contexto do usuário com uma "tela branca" entre o carregamento de forma brusca.

A **View Transition API** surge como a solução nativa da plataforma web. Ela permite criar transições animadas e suaves entre diferentes estados do DOM (na mesma página - SPA) ou até mesmo entre diferentes documentos (na navegação entre páginas - MPA), tudo de forma declarativa e com o poder do CSS. Agora, com o suporte expandido (incluindo Firefox, Chrome e Safari), é o momento ideal para adotá-la!

### Como Funciona a View Transition API?

O princípio de funcionamento é engenhoso e se baseia em capturas de tela (snapshots) e pseudo-elementos CSS. O processo de transição ocorre em 4 passos principais:

1. **Gatilho da Transição:** A transição é iniciada, seja por uma chamada JavaScript (`document.startViewTransition()`) em SPAs, ou automaticamente na navegação entre páginas em MPAs.
2. **Captura de Snapshot (Old View):** O navegador congela e captura uma imagem (snapshot) do estado visual atual da página.
3. **Atualização do DOM:** O conteúdo da página é atualizado (o DOM é modificado, ou a nova página é carregada) **sem que o usuário veja**, pois o snapshot anterior está sendo exibido.
4. **Transição Animada:** O navegador insere os pseudo-elementos da transição e usa animações CSS para fazer a transição suave do "snapshot antigo" para o "novo estado".

O resultado é uma transição visualmente suave, onde o conteúdo muda de forma elegante, mantendo o usuário imerso.

### Como Implementar no Seu Blog (MPA)

A beleza da View Transition API para sites multi-páginas (MPA) — como a maioria dos blogs baseados em CMS — é que ela requer **quase nada de JavaScript** para a transição padrão!

#### Passo 1: Habilitar a Transição (Opt-in)

Para que o navegador saiba que você deseja transições entre páginas, adicione esta regra CSS em sua folha de estilos global:

```CSS
/* Seu arquivo CSS global (style.css, por exemplo) */
@view-transition {
  navigation: auto;
}

::view-transition-group(root) {
  animation-duration: 800ms;
  animation-timing-function: ease-in-out;
}
```

> **Nota:** Esta única linha habilita a transição de visualização em todos os links do seu site para navegações de mesma origem (same-origin). Por padrão, ela aplica um efeito de _cross-fade_ (dissolver suavemente), que já é uma grande melhoria.

![[screen-capture-_2_.gif]]

#### Passo 2: Animar Elementos Específicos (Shared Elements)

Para criar transições mais complexas e que movem elementos específicos (como um título ou uma imagem), você precisa dar um "nome" ao elemento no estado antigo e no novo estado.

**Exemplo (Transição de um Título de Post):**

1. **No HTML/CSS do Título na Lista de Posts (Página A):**
    
    ```HTML
    <h2 class="post-card-title">
      Título do Post
    </h2>
    ```
    
    ```CSS
    .post-card-title {
      /* O nome da transição precisa ser único por página! */
      view-transition-name: post-title-123; 
    }
    ```
    
2. **No HTML/CSS do Título na Página do Post (Página B):**
    
    ```HTML
    <h1 class="post-hero-title">
      Título do Post
    </h1>
    ```
    
    ```CSS
    .post-hero-title {
      /* Deve ter o MESMO nome na página de destino */
      view-transition-name: post-title-123; 
    }
    ```
    

Ao clicar no link, o navegador fará a transição suave da posição, tamanho e forma do elemento com o `view-transition-name` entre as duas páginas!

###  Personalização e a Relação com CSS

Aqui é onde a View Transition API se torna uma potência. A personalização é feita puramente com CSS, utilizando pseudo-elementos específicos injetados pelo navegador durante a transição.

#### A Estrutura da Transição (Pseudo-elementos)

Durante a transição, o navegador cria a seguinte estrutura (oculta) no topo da sua página:

```
::view-transition
└── ::view-transition-group(root) ou ::view-transition-group(nome-personalizado)
    ├── ::view-transition-image-pair(root) ou ::view-transition-image-pair(nome-personalizado)
    │   ├── ::view-transition-old(root) ou ::view-transition-old(nome-personalizado)
    │   └── ::view-transition-new(root) ou ::view-transition-new(nome-personalizado)
```

| **Pseudo-elemento**             | **Descrição**                                                         |
| ------------------------------- | --------------------------------------------------------------------- |
| `::view-transition`             | O _overlay_ que cobre toda a viewport.                                |
| `::view-transition-group(nome)` | Contém o par de imagens, com a posição e tamanho do elemento nomeado. |
| `::view-transition-old(nome)`   | O snapshot da vista antiga. É animado para **sair**.                  |
| `::view-transition-new(nome)`   | O snapshot da vista nova. É animado para **entrar**.                  |

#### Customizando a Animação Padrão

Por padrão, a transição global (`root`) é um `cross-fade` que dura `500ms`. Você pode mudar isso usando `@keyframes` e direcionando os `pseudo-elementos`.
Além disso, podemos editar a animação de in e out, com os `pseudo-elementos` de transição. Abaixo vamos observar o efeito utilizado nesse blog na data de publicação.

```CSS
/* Define duração e suavidade global */
::view-transition-group(root) {
  animation-duration: 800ms;
  animation-timing-function: ease-in-out;
}

/* Página antiga — tela vai escurecendo e ficando pixelada */
::view-transition-old(root) {
  animation-name: pixel-fade-out;
}

/* Página nova — tela surge do preto e volta a ficar nítida */
::view-transition-new(root) {
  animation-name: pixel-fade-in;
}

/* --- Keyframes --- */

/* Desaparecendo estilo "entrando em fase" */
@keyframes pixel-fade-out {
  0% {
    opacity: 1;
    filter: none;
    transform: none;
  }
  40% {
    filter: brightness(70%) saturate(80%) blur(2px);
  }
  70% {
    filter: brightness(30%) saturate(30%) blur(6px);
  }
  100% {
    opacity: 0;
    filter: brightness(0%) blur(10px);
  }
}

/* Reaparecendo da escuridão, como se saísse da tela preta */
@keyframes pixel-fade-in {
  0% {
    opacity: 0;
    filter: brightness(0%) blur(12px);
    transform: scale(1.02);
  }
  30% {
    opacity: 0.5;
    filter: brightness(40%) blur(8px);
  }
  60% {
    opacity: 0.8;
    filter: brightness(80%) blur(4px);
  }
  100% {
    opacity: 1;
    filter: none;
    transform: none;
  }
}
```

Tive com inspiração, os efeitos de transição de jogos snes como super mario world, onde durante o carregamento de uma nova fase, a tela escurece e fica um pouco pixelada. Abaixo podemos observar o resultado.

![[screen-capture-_3_.gif]]

### Conclusão e Próximos Passos

A **View Transition API** é uma ótima adição para a web. Ela democratiza as transições de página de alta qualidade, tornando-as acessíveis a qualquer projeto, de SPAs complexas a blogs estáticos simples. O fato de ser nativa e personalizável via CSS a torna uma ferramenta poderosa no arsenal de qualquer desenvolvedor.

Com a chegada do suporte ao Firefox, não há mais desculpas para não oferecer navegações mais coesas e agradáveis. 


