---
title: 'W1: Principles and Practices'
assignment: Build an html page describing your project. Use git for version control and for deployment to the fabacademy server.
goal: I'm going to create a website about the fabgrid project. As a small challenge, i'll try to use Vue.js with TypeScript
links:
  - text: Liquid Short Reference
    url: https://github.com/Shopify/liquid/wiki/Liquid-for-Designers

layout: lesson
previous: fabacademy/index.md
next: fabacademy/week-2/index.md
---

## Table of Contents

* TOC
{:toc}

---

## Notes on Jekyll

In order to create a website that offers both good user experience *and* developer experience, i decided to build upon [jekyll](https://jekyllrb.com/).

Cool thing about jekyll is, as with all static site generators, you can use complex logic with bad performance in your templates without taking any influence on the resulting page load time. Everything is compiled to plain html (plus css and js) before it is deployed to a server, so all the server needs to do is deliver static files. No additinal computing. This has an influence on the security of the website, as well.

### Theme

As i wanted something clean to start with, i created a theme from scratch using [Bootstrap v4](http://v4-alpha.getbootstrap.com/). I didn't use the plain CSS but rather the [SCSS](http://sass-lang.com/) version to allow for better customization options without dirty overrides. Also, jekyll has SCSS capabilities built-in so there is no additional setup required to have CSS built from our sources.

Fonts are provided by [google webfonts](https://fonts.google.com/), and the [font awesome](http://fontawesome.io/icons/) icon font offers half a ton of icons and symbols. The latter is probably an overkill, but well – it's just so much easier to write that one line of css and have hundreds of icons available than to pull each one in as a separate svg or even start to mess with a sprite sheet.

### Templates

Jekyll uses the [Liquid](https://shopify.github.io/liquid/) templating engine. It lets you define "blueprints" of the structure of a page. After that, you can use plain [markdown](https://en.wikipedia.org/wiki/Markdown) and not worry about any styling and stuff when writing the content – it will be rendered as you specified it in the template.

This is an example of the template that is being used for the page you are currently looking at:

{% raw %}
```html
---
layout: base
---
<main>
	<header>
		<h1>{{ page.title }}</h1>

		{% include lesson-metaboxes.html %}
	</header>

	<article>
		{{ content }}
	</article>

	<footer>
		{% include pagination.html %}
	</footer>
</main>
```

At the very top, it says `layout: base`, which indicates to use in turn another file `base.html` as a layout and render the current template into it. In the *base* layout, the outermost html structure is defined. It contains the `<html>` `<head>` and `<body>` with all the meta stuff and things common to all pages, like the sidebar. You can check the [full template file at github](https://github.com/fabgrid/docs/tree/master/_layouts).

`{% include lesson-metaboxes.html %}` instructs the templating engine to load another template from the mentioned file and insert it into the document instead of the `{% include … %}` statement.

The `{{ content }}` placeholder in the above template is where the actual text body of the page is going to be placed. It is very common in templating engines to use double curly braces `{{ }}` to indicate placeholders. At `{{ page.title }}`, the value of the `title` variable of the current page is going to be inserted. The variable is defined in the corresponding markdown files. Of course, an arbitrary number of markdown (or html) files can use the same template. An example:

<div class="language-html highlighter-rouge"><pre class="highlight" v-pre><code>---
title: 'W1: Principles and Practices, Project Management'
layout: lesson
---

- This text is going to appear as html where the {{ content }} placeholder is in the template
- This markdown list will be converted to a &lt;ul&gt;</code></pre></div>

In the top section between the triple dashes `---` we use the [yaml](http://yaml.org/) language to define some variables. We define a *title*, which will be accessible in the template as `{{ page.title }}`, and a *layout*. The layout declares which template to use. In this case, it's the *lesson* template, which refers to the `lesson.html` file shown above. We can make up variables as we need them, there are virtually no limits.

So in the end, using templates saves us time, even though it takes more effort upfront to create the template. But this saves us time on a task that we repeat much more often than that: writing the content. I'm going to use the template for the fabacademy lessons roughly around 20 times. That's how many lessons there are in the fabacademy. When writing the documentation, i can follow a far more *data-driven* approach: Some information, that will be there on most lessons is stored in additional variables. Look at the three boxes at the very top of this page. The information shown in them is pulled from the following variables at the top of my source file:

```yaml
assignment: Build an html page describing your project. Use git for version control and for deployment to the fabacademy server.
goal: I'm going to create a website about the fabgrid project. As a small challenge, i'll try to use Vue.js with TypeScript
links:
  - text: Liquid Short Reference
    url: https://github.com/Shopify/liquid/wiki/Liquid-for-Designers
```

I implemented a check on the variable presence so i can hide the box by not specifying the variable at all in my markdown file. In addition, the *Lecture Notes* link is dynamically added when a file named `lecture-notes.md` is present next to the source file of this page. Remember, we can easily afford all this extra logic through our offline build process? To see how this is implemented in detail, [use the source](https://github.com/fabgrid/docs/blob/master/_includes/lesson-metaboxes.html).

Now all i need to do when creating a new page is to fill in that variables and it's gonna be displayed correctly. I don't have to remember how the markup has to be structured or look it up in the bootstrap docs. So i don't write the same code, or more precisely markup, over and over again, implementing the [DRY principle](https://en.wikipedia.org/wiki/Don't_repeat_yourself) which is one of the keys to keeping code maintainable.

So there comes another advantage of this approach: Let's say i want to remove those boxes and display their contents in a table at the bottom of each page. With this setup, it's fairly easy. There is only one place to make the edits, no copies that need syncing.

---

## Step-by-step Guide

### 1. Setup Jekyll

In order to start a new jekyll project, `jekyll new project_name` can be issued, assuming that the [jekyll gem is installed](https://jekyllrb.com/docs/installation/), of course. This gives you a fairly basic website, which you can see after running `jekyll serve` from the project folder and visiting [http://127.0.0.1:4000](http://127.0.0.1:4000) in a browser. It should look something like this:

{% endraw %}

<div class="row">
	<div class="col-sm-7">
		<zoom src="01-jekyll-initial-website.png" shadow="true"></zoom>
	</div>
	<div class="col-sm-4">
		<zoom src="02-jekyll-initial-files.png" shadow="true"></zoom>
	</div>
</div>

{% raw %}

This default setup contains three pages:

- index.md
- about.md
- _posts/2017-01-28-welcome-to-jekyll.markdown

They are by default rendered using the *minima* theme. The content ends up as html pages in the `_site` folder, along with the assets. So we **never change anything in the _site folder**, as it will be lost on our next build (which happens btw on every file change as long as  `jekyll serve` is running).

### 2. Theme creation

#### Cleanup

As mentioned before, this version of jekyll uses the *minimal* theme by default. Which theme to use is configured in `_config.yml` and the package is required in the `Gemfile`. We want to build our own theme so we edit both those files to make them look like this (eg. remove everything theme specific):

**Gemfile**
```ruby
source "https://rubygems.org"
ruby RUBY_VERSION

# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll", "3.3.1"
```

**_config.yml**
```yaml
title: Your awesome title

# Build settings
markdown: kramdown
exclude:
  - Gemfile
  - Gemfile.lock
  - package.json
  - yarn.lock
```

The entire `_posts` folder can be deleted, as we don't want a blog for now. `about.md` can also be deleted. We just keep the `index.md` file and make it look like the following:

**index.md**
```markdown
---
title: fabgrid
layout: page
---

Hello FabAcademy

```

#### Creating a blank Theme

Now our page is broken – because jekyll can't find the templates anymore. So we need to create `_layouts/page.html`, as we specified the `layout` to be `page` in our index page. This file is fairly simple:

**_layouts/page.html**
```html
---
layout: base
---

{{ content }}
```

What this template says is basically "pass the content through to the base.html template". So we need to create that as well. This is to keep common definitions in one place for use by other layouts added later besides the *page* layout.

**_layouts/base.html**
```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>{{ page.title }} – {{ site.title }}</title>
	</head>

	<body>
		{{ content }}
	</body>
</html>
```

So now let's make sure `jekyll serve` is running without errors, then open [http://127.0.0.1:4000](http://127.0.0.1:4000) again and see the result. This is what it should look like:

{% endraw %}

<zoom src="03-blank-theme.png" shadow="true"></zoom>

{% raw %}

#### Including Twitter Bootstrap

Great, looks like we've created a jekyll theme. Well, it's quite basic but yet, it does what it's supposed to: Let us control how our content is going to be displayed. So let's start with that.

First, we're going to include Twitter Bootstrap - that's basically a huge bunch of CSS providing a [grid system](https://v4-alpha.getbootstrap.com/layout/grid/) and lots of other [fancy stuff](https://v4-alpha.getbootstrap.com/components). We're going to use the v4-alpha, as it uses [flexbox](https://developer.mozilla.org/docs/Web/CSS/CSS_Flexible_Box_Layout/Using_CSS_flexible_boxes). All that is done mainly for the sake of [responsiveness](https://en.wikipedia.org/wiki/Responsive_web_design).

As we're not going to manually copy any external dependencies around, we need a package manager first. And as there has recently a shiny alternative to npm come alive, well try that one now. After [installing yarn](https://yarnpkg.com/en/docs/install), we first need to initialize our `package.json` by answering a few questions (most of them can be left at their defaults):

```bash
yarn init
```

Now that we have a `package.json` file, we can specify bootstrap as a dependency:

```bash
yarn add bootstrap@4.0.0-alpha.6
```

This places bootstrap into the newly created `node_modules` folder. Now we're going to create a SCSS file that loads all the Bootstrap files so jekyll can compile them into a CSS file, that is going to be loaded on all our pages. As an entry point we're going to create an `assets/css/main.scss` file, which will be built into `_site/assets/css/main.css` by jekyll (note the different file extensions).

**assets/css/main.scss**
```scss
---
---
@import "custom-bootstrap";
```

The jekyll header (`---`) must be present, otherwise jekyll will just copy the file without compiling SCSS to CSS.

Now, we're going to create a `_sass` folder in our project root. This is where jekyll will search for SCSS includes. Inside that folder, we put a `_custom-bootstrap.scss`, which we've referenced in our `main.scss` file:

**_sass/_custom-bootstrap.scss**
```scss
/*!
 * Bootstrap v4.0.0-alpha.6 (https://getbootstrap.com)
 * Copyright 2011-2017 The Bootstrap Authors
 * Copyright 2011-2017 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 */

// Core variables and mixins
@import "bootstrap_variables";
@import "../node_modules/bootstrap/scss/mixins";
@import "../node_modules/bootstrap/scss/custom";

// Reset and dependencies
@import "../node_modules/bootstrap/scss/normalize";
@import "../node_modules/bootstrap/scss/print";

// Core CSS
@import "../node_modules/bootstrap/scss/reboot";
@import "../node_modules/bootstrap/scss/type";
@import "../node_modules/bootstrap/scss/images";
@import "../node_modules/bootstrap/scss/code";
@import "../node_modules/bootstrap/scss/grid";
@import "../node_modules/bootstrap/scss/tables";
@import "../node_modules/bootstrap/scss/forms";
@import "../node_modules/bootstrap/scss/buttons";

// Components
@import "../node_modules/bootstrap/scss/transitions";
@import "../node_modules/bootstrap/scss/dropdown";
@import "../node_modules/bootstrap/scss/button-group";
@import "../node_modules/bootstrap/scss/input-group";
@import "../node_modules/bootstrap/scss/custom-forms";
@import "../node_modules/bootstrap/scss/nav";
@import "../node_modules/bootstrap/scss/navbar";
@import "../node_modules/bootstrap/scss/card";
@import "../node_modules/bootstrap/scss/breadcrumb";
@import "../node_modules/bootstrap/scss/pagination";
@import "../node_modules/bootstrap/scss/badge";
@import "../node_modules/bootstrap/scss/jumbotron";
@import "../node_modules/bootstrap/scss/alert";
@import "../node_modules/bootstrap/scss/progress";
@import "../node_modules/bootstrap/scss/media";
@import "../node_modules/bootstrap/scss/list-group";
@import "../node_modules/bootstrap/scss/responsive-embed";
@import "../node_modules/bootstrap/scss/close";

// Components w/ JavaScript
@import "../node_modules/bootstrap/scss/modal";
@import "../node_modules/bootstrap/scss/tooltip";
@import "../node_modules/bootstrap/scss/popover";
@import "../node_modules/bootstrap/scss/carousel";

// Utility classes
@import "../node_modules/bootstrap/scss/utilities";

```

Here we import all the bootstrap files from the `node_modules` folder. We could leave out many of the imports, giving up the respective bootstrap features, while cutting down the size of the resulting file.

At the very top, it says `@import "bootstrap_variables"` - this file we need to create inside our `_sass` folder. Actually it's just a renamed copy of `node_modules/bootstrap/scss/_variables.scss`. So go ahead and copy it to `_sass/bootstrap_variables.scss`. The reason for this is that we want to edit that file. Everything inside `node_modules` is an external dependency managed by yarn - we don't ever touch those files. But the `_variables.scss` file sets some critical details that we want to adjust, like colors, spacing or font attributes.

What's left now is to include the `main.css` file in our the `<head>` section of our `base.html` template and wrap the entire body content in a `.containter` so bootstrap keeps our content from becoming wider than 1140px on large screens:

**_layouts/base.html**
```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>{{ page.title }} – {{ site.title }}</title>

		<link rel="stylesheet" type="text/css" href="assets/css/main.css" />
	</head>

	<body>
		<div class="container">
			{{ content }}
		</div>
	</body>
</html>
```

After a page refresh, we should notice that the font has changed and a padding has been added to the content, which proves that we have set up bootstrap correctly:

{% endraw %}

<zoom src="04-blank-theme-with-bootstrap.png" shadow="true"></zoom>

{% raw %}

At this point, our project should contain the following files and directories:

{% endraw %}

<zoom src="05-blank-theme-files.png" shadow="true"></zoom>

{% raw %}

#### Using custom fonts

#### Further customization

- Primary color
- Border-radius
- Heading margins
- Syntax highlighting

### 3. Adding some content

### 4. Building the slide menu

---

## Open Source tools used

Not quite a minimalist setup, but at least i managed to keep away from webpack, gulp and the like. Still, this website is built using a handful of wide-spread open source tools, that considerably ease the work of today's web developer. ;) In the end, it all helps to create a website that is both fun to use and fun to develop. And "fun to develop" means not only to develop once and never look at it anymore. It means to constantly care about and improve your code. And this process should be designed as easy and joyful as possible.

So here's the list:

- Jekyll
- Twitter Bootstrap
- Yarn
- SASS
- TypeScript
- Vue.js
- Tom Preston-Werner's syntax.css

Of course, countless other open source projects are less directly involved, such as GIT, the Javascript, Ruby or C languages or the Linux kernel or GNU toolsuite, to name just some very popular examples.

{% endraw %}

