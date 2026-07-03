; extends

; tree-sitter-rstml ships these captures with priority 101, which is lower than
; rust-analyzer semantic tokens. Keep Leptos/RSTML tags and attributes visible.
(open_tag
  [
    "<"
    ">"
  ] @tag.delimiter
  (#set! "priority" 160))

(close_tag
  [
    "</"
    ">"
  ] @tag.delimiter
  (#set! "priority" 160))

(self_closing_element_node
  [
    "<"
    "/>"
  ] @tag.delimiter
  (#set! "priority" 160))

(open_tag
  name: (node_identifier) @tag
  (#set! "priority" 160))

(close_tag
  name: (node_identifier) @tag
  (#set! "priority" 160))

(self_closing_element_node
  name: (node_identifier) @tag
  (#set! "priority" 160))

(node_attribute
  name: (node_identifier) @tag.attribute
  (#set! "priority" 160))

(generic_identifier
  [
    [
      "<"
      ">"
    ] @punctuation.delimiter
    (node_identifier) @tag
  ]
  (#set! "priority" 160))
