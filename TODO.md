

```markdown
---
title: Some title
panflute-filters: [remove-tables, include]
panflute-path: 'panflute/docs/source'
...

Lorem ipsum
```

then:

```bash
pandoc ... -F panflute
```

