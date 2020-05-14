## [{{ lab.title }}]({{site.url}}{{ site.baseurl }}{{ lab.url }})
{{ lab.description }}
###### Tags: {% for tag in lab.tags %}{{ tag }}{% if forloop.last %}{% else %}, {% endif %}{% endfor %}