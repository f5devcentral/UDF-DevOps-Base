# Development Overview

## GitHub Pages and Jekyll
The documentation uses GitHub pages and Jekyll to render the static resources.  The action of creating the static resources is handled by GitHub once new code is contributed to the /docs folder.  **Note**: this process may take up to 10 minutes depending on GitHub resource load. 

## Folder structure
All lab guide data lives in the /docs folder. 

### _labs
The _labs folder contains the markdown files for each individual lab.  Creating a new markdown file will automatically add the lab to the lab index page upon commit to the main branch. 

#### Markdown metadata
Each lab markdown file needs specific markdown header data for Jekyll to render the layout correctly. 

| Attribute | Description | Value |
| --------- |:------------|:-----:|
| name | lab name | string |
| title | lab title | string |
| description | lab description | string |
| layout | Jekyll laout, should always be lab | string |
| edit_date | date the lat was last updated | string |
| lab_time | estimated amount of time to complete the lab | string |
| tags | tags to help identify what the lab covers (for future functionality) | list (string) |

An example is provided below:

```markdown
---
name: Lab Name
title: Lab - short title
description: Description of the lab 
layout: lab
edit_date: 09/09/2020
lab_time: 20 mins
tags: 
    - f5-cli
    - DO
---