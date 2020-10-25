# nim-x2j
A very tiny simple unbundled nim helper module for converting simple XML documents to JsonNode objects. **Everything must be wrapped in tags**. You can use a custom tag like `<raw>Raw Content</raw>` to represent raw portions of your XML code. This does not handle `cdata` stuff =(. You might want to write your own parser =D which is easy.

The program converts the following XML representation.
```xml
<element1-name attr-key="attr-val" ...>
  <element2-name attr-key="attr-val" ...>
     Content
  </element2-name>
  ...
</element1-name>
```
to
```json 
{
  "element1-name" : {
    "attrs" : {
      "attr-key" : "attr-val"
    },
    "children" : {
      "element2-name" : {
        "attrs" : {
          "attr-key" : "attr-val"
        },
        "children" : {
          
        }
      }
    },
  }
}
```

This is not handled.
```xml
<foo>
   Hello
  <bar>...</bar>
</foo>  
```

Rewrite that to this
```xml
<foo>
  <raw>Hello</raw>
  <bar>..</bar>
</foo>
```
