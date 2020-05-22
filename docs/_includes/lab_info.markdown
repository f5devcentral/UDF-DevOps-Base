### [{{ lab.title }}]({{site.url}}{{ site.baseurl }}{{ lab.url }})
<small>Lab Time: {{ lab.lab_time }}</small> | 
<small>Last Updated: {{ lab.edit_date }}</small> | 
<small>tags: {% for tag in lab.tags %}{{ tag }}{% if forloop.last %}{% else %}, {% endif %}{% endfor %}</small>

{{ lab.description }}

---