---
description: Organizing entries
---

# Categories and Tags

I've been re-writing my on-line recipe collection using Gatsby as an exercise. In the original Jekyll site, I had recipes organized into categories like chapters in a printed cookbook, and tags that allowed more fine-detailed structure, listing such things as ingredients, cuising type, and other things like being gluten-free. Both categories and tags were stored as entries in the frontmatter of each recipe in the collection.

To make that work, I needed to write a Jekyll plug-in to generate the category and tag pages. And to make it work in Gatsby, I needed to write something in `gatsby-node.js`

### Categories as Subdirectories

Instead of putting the category in the frontmatter, I decided to organize the recipe markdown into subdirectories under the `recipes/` content directory.

#### A hook for categories

To pull out the categories, I created a custom hook `useCategories` to run a static query and return the collection of category names:

```javascript
import { graphql, useStaticQuery } from "gatsby"
export const useRecipeCategories = () => {
  const { allDirectory } = useStaticQuery(
    graphql`
      query RECIPE_CATEGORIES {
        allDirectory(filter: { absolutePath: { glob: "**/recipes/*" } }) {
          nodes {
            relativePath
          }
        }
      }
    `
  )
  return allDirectory.nodes.map(category => category.relativePath)
}
```

Putting that query into the GraphiQL IDE, the response is:

```text
{
  "data": {
    "allDirectory": {
      "nodes": [
        {
          "relativePath": "baked-goods"
        },
        {
          "relativePath": "desserts"
        },
        {
          "relativePath": "breakfast"
        },
        {
          "relativePath": "drinks"
        },
        {
          "relativePath": "main-dishes"
        },
        {
          "relativePath": "kitchen-tips"
        },
        {
          "relativePath": "appetizers"
        },
        {
          "relativePath": "pizza"
        },
        {
          "relativePath": "salads"
        },
        {
          "relativePath": "sandwiches"
        },
        {
          "relativePath": "sauces"
        },
        {
          "relativePath": "side-dishes"
        },
        {
          "relativePath": "soups"
        }
      ]
    }
  }
}
```

That gives me a nice, reusable list of categories anywhere in the site.

#### Generating the Table of Contents

The `CategoriesMenu` component creates a list of the categories with links to each category page:

```javascript
import React from "react"
import { Link } from "gatsby"
import { useRecipeCategories } from "../hooks/useCategories.js"

export default () => {
  const categories = useRecipeCategories()

  return (
    <ul>
      {categories.map((category, index) => (
        <li key={`category-menu-item-${index}`}>
          <Link to={`/${category}/`}>{category}</Link>
        </li>
      ))}
    </ul>
  )
}

```

\(I'm still in the midst of generating a style for the site, so eventually the `ul` and `li` will get replaced with some styled components. That's not important for this discussion.\)

The `Link` to each category page expects them to be a page at the root of the route. These pages are not in the repo itself, and must be generated. The code to generate the category page is in `gatsby-node.js` :

```javascript
const { createFilePath } = require(`gatsby-source-filesystem`)
const path = require(`path`)

exports.createPages = ({ actions, graphql }) => {
  // ...
  const categoryTemplate = path.resolve("./src/templates/categoryTemplate.js")

  return graphql(`
    {
      # .. other queries
      allDirectory(filter: { absolutePath: { glob: "**/recipes/*" } }) {
        nodes {
          relativePath
        }
      }
    }
  `).then(result => {

    // ... stuff for mdx pages

    const categories = result.data.allDirectory.nodes
    categories.forEach(category => {
      createPage({
        path: "/" + category.relativePath + "/",
        component: categoryTemplate,
        context: {
          category: category.relativePath,
        },
      })
    })
    
    // ... more stuff
  })
}

```

The partial graphql query returns the relative paths from the recipes area, which is the same as we do in the `useCategories` hook; there ought to be a way to reuse that, but here it's part of a larger query \(redacted from the example\). Looping through the categories, I'm running `createPage` on each node \(i.e. category\) and building a page using a template, quite like one does for making Markdown/MDX pages. The context contains the category "slug", which is created below.

The categories need to be made into nodes:

```javascript
exports.onCreateNode = ({ node, actions, getNode }) => {
  const { createNodeField } = actions
  if (node.internal.type === `Mdx`) {
    const value = createFilePath({ node, getNode })
    // .. other nodes
    createNodeField({
      name: `recipeCategory`,
      node,
      value: value.split("/")[1],
    })
  }
}
```

This is pretty similar again to how you make slugs for Markdown/MDX psges. The `value` comes from file path created in line 4, and it looks like `/:relativePath/:recipeFilename/`. Since what we're looking for is the recipe category, that is the `:relativePath` in the string above. Splitting on the divider gives a `null` first value in the array, and `:relativePath` in the second slot, so the index is 1 to pull it out. There's probably better ways to do this, but this works.

### Tag pages

Tag pages are also created in `gatsby-node.js` but the way tags are collected to start with is very different from categories. Categories are determined by placement in a subdirectory, but tags are declared in the frontmatter of the recipe MDX file.

\(One _could_ do the same thing with categories, using a field in the frontmatter, but after working with that form in the Jekyll version for years, I've decided doing them as subdirectories made more sense to me.\)

Going back to the `gatsby-node.js` file, the full query looks like this:

```graphql
    {
      allMdx {
        nodes {
          fields {
            slug
          }
          frontmatter {
            title
            tags
          }
          fileAbsolutePath
        }
      }
      allDirectory(filter: { absolutePath: { glob: "**/recipes/*" } }) {
        nodes {
          relativePath
        }
      }
    }

```

In this case, we need to collect the _unique_ tags from every recipe file, so while we are shooting the list building the recipe pages, we'll also collect the tags into a Set:

```graphql
    const recipes = result.data.allMdx.nodes
    let tags = new Set()

    // create page for each mdx file
    recipes.forEach(recipe => {
      createPage(/* .. for each recipe page .. */)

      if (recipe && recipe.frontmatter && recipe.frontmatter.tags) {
        recipe.frontmatter.tags.map(tag => {
          tags.add(tag)
        })
      }
    })
```

If there are a collection of tags in the recipe file, this adds them to the `tags` Set, which ensures only unique tags are collected.

Further down, we need to create the tag _pages_ :

```javascript
    tags.forEach(tag => {
      createPage({
        path: `/tags/${tag}/`,
        component: tagTemplate,
        context: {
          tag,
        },
      })
    })
```

### Putting Categories and Tags to use

#### The Category Menu in the Sidebar

I decided for this design iteration to put the categories into a sidebar arrangement \(I still haven't done any styling on this\). Recall the code up at **Generating the table of contents**: 

```jsx
return (
    <ul>
      {categories.map((category, index) => (
        <li key={`category-menu-item-${index}`}>
          <Link to={`/${category}/`}>{category}</Link>
        </li>
      ))}
    </ul>
  )
```

which generates a link to each category page. This is mounted in the Sidebar.

#### Tag links in each recipe display

Tags are a little different at this point: they are only listed in each individual recipe page, using the `TagList` component:

```jsx
import React from "react"
import { Link } from "gatsby"
import styled from "styled-components"

export default ({ tags }) => {
  if (!tags || tags.length < 1) {
    return null
  }
  return (
    <TagListWrapper>
      {tags.map((tag, index) => {
        return (
          <TagListItem key={`tag-item-${index}`}>
            <Link to={`/tags/${tag}/`}>{tag}</Link>
          </TagListItem>
        )
      })}
    </TagListWrapper>
  )
}

const TagListWrapper = styled.ul`
  display: inline;
  list-style: none;
`
const TagListItem = styled.li`
  display: inline-block;
  &:after {
    content: ", ";
    padding-right: 0.5em;
  }
  &:last-child:after {
    content: "";
  }
`
```

\(Yay, some styling\)

Eventually, I'm going to want a tag cloud of some sort, too.

That's basically it. It took a minute for me to go from looking at how the Markdown / MDX in every gatsby tutorial worked, and had to work out how to generate the pages from other data queries. This seems pretty simple, but seems to be lacking from the tutorials.

