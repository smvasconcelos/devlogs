---
title: "CSS #1 - Transitions with the View Transition API"
date: 2025-11-01
draft: false
tags:
  - css
  - animations
  - transitions
  - view-transition
  - firefox
---

The user experience (UX) in modern web applications demands fluidity and continuity, something that was historically difficult to achieve on traditional websites without the use of complex SPA frameworks. The full page reload often breaks the user's context with an abrupt "white screen" between loading.

The **View Transition API** emerges as the native web platform solution. It allows you to create smooth, animated transitions between different DOM states (on the same page - SPA) or even between different documents (during page navigation - MPA), all declaratively and with the power of CSS. Now, with expanded support (including Firefox, Chrome, and Safari), it is the ideal time to adopt it!

### How Does the View Transition API Work?

The working principle is ingenious and based on snapshots and CSS pseudo-elements. The transition process occurs in 4 main steps:

1.  **Transition Trigger:** The transition is initiated, either by a JavaScript call (`document.startViewTransition()`) in SPAs, or automatically during navigation between pages in MPAs.
2.  **Snapshot Capture (Old View):** The browser freezes and captures an image (snapshot) of the current visual state of the page.
3.  **DOM Update:** The page content is updated (the DOM is modified, or the new page is loaded) **without the user seeing it**, as the previous snapshot is being displayed.
4.  **Animated Transition:** The browser inserts the transition's pseudo-elements and uses CSS animations to smoothly transition from the "old snapshot" to the "new state."

The result is a visually smooth transition, where content changes elegantly, keeping the user immersed.

### How to Implement it on Your Blog (MPA)

The beauty of the View Transition API for multi-page sites (MPA) — like most CMS-based blogs — is that it requires **almost no JavaScript** for the standard transition!

#### Step 1: Enable the Transition (Opt-in)

For the browser to know that you want transitions between pages, add this CSS rule to your global stylesheet:

```css
/* Your global CSS file (style.css, for example) */
@view-transition {
  navigation: auto;
}

::view-transition-group(root) {
  animation-duration: 800ms;
  animation-timing-function: ease-in-out;
}
````

> **Note:** This single line enables view transitions on all same-origin links on your site. By default, it applies a *cross-fade* effect (a soft dissolve), which is already a significant improvement.

![Image Description](/devlogs/images/screen-capture-_2_.gif)

#### Step 2: Animate Specific Elements (Shared Elements)

To create more complex transitions that move specific elements (like a title or an image), you need to give the element a "name" in both the old state and the new state.

**Example (Post Title Transition):**

1.  **In the HTML/CSS of the Title on the Post List (Page A):**

    ```html
    <h2 class="post-card-title">
      Post Title
    </h2>
    ```

    ```css
    .post-card-title {
      /* The transition name must be unique per page! */
      view-transition-name: post-title-123; 
    }
    ```

2.  **In the HTML/CSS of the Title on the Post Page (Page B):**

    ```html
    <h1 class="post-hero-title">
      Post Title
    </h1>
    ```

    ```css
    .post-hero-title {
      /* Must have the SAME name on the destination page */
      view-transition-name: post-title-123; 
    }
    ```

When you click the link, the browser will smoothly transition the position, size, and shape of the element with the `view-transition-name` between the two pages\!

### Customization and the Relationship with CSS

This is where the View Transition API becomes a powerhouse. Customization is done purely with CSS, using specific pseudo-elements injected by the browser during the transition.

#### The Transition Structure (Pseudo-elements)

During the transition, the browser creates the following structure (hidden) at the top of your page:

```
::view-transition
└── ::view-transition-group(root) or ::view-transition-group(custom-name)
    ├── ::view-transition-image-pair(root) or ::view-transition-image-pair(custom-name)
    │   ├── ::view-transition-old(root) or ::view-transition-old(custom-name)
    │   └── ::view-transition-new(root) or ::view-transition-new(custom-name)
```

| **Pseudo-element** | **Description** |
| :--- | :--- |
| `::view-transition` | The *overlay* that covers the entire viewport. |
| `::view-transition-group(name)` | Contains the image pair, with the position and size of the named element. |
| `::view-transition-old(name)` | The snapshot of the old view. It is animated to **exit**. |
| `::view-transition-new(name)` | The snapshot of the new view. It is animated to **enter**. |

#### Customizing the Default Animation

By default, the global transition (`root`) is a `cross-fade` that lasts `500ms`. You can change this using `@keyframes` and targeting the `pseudo-elements`.
Furthermore, we can edit the in and out animation with the transition `pseudo-elements`. Below we observe the effect used in this blog on the date of publication.

```css
/* Define global duration and easing */
::view-transition-group(root) {
  animation-duration: 800ms;
  animation-timing-function: ease-in-out;
}

/* Old page — screen darkens and becomes pixelated */
::view-transition-old(root) {
  animation-name: pixel-fade-out;
}

/* New page — screen emerges from black and becomes sharp again */
::view-transition-new(root) {
  animation-name: pixel-fade-in;
}

/* --- Keyframes --- */

/* Fading out "phasing out" style */
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

/* Reappearing from darkness, as if emerging from the black screen */
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

I was inspired by the transition effects of SNES games like Super Mario World, where during the loading of a new stage, the screen darkens and becomes a bit pixelated. Below we can see the result.

![Image Description](/devlogs/images/screen-capture-_3_.gif)

### Conclusion and Next Steps

The **View Transition API** is a great addition to the web. It democratizes high-quality page transitions, making them accessible to any project, from complex SPAs to simple static blogs. The fact that it is native and customizable via CSS makes it a powerful tool in any developer's arsenal.

With the arrival of Firefox support, there are no more excuses not to offer more cohesive and pleasant navigations.
