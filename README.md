# nim-x2j
A very tiny simple unbundled nim helper module for converting simple XML documents to JsonNode objects. **Everything must be wrapped in tags**. You can use a custom tag like `<raw></raw>` to represent raw portions of your XML code.

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
    "content" : {
      "element2-name" : {
        "attrs" : {
          "attr-key" : "attr-val",
          "char-data" : "Content"
        },
        "children" : {
          
        }
      }
    },
  }
}
```
