{{- /*
merge overrides the keys in a destination map with the values from a source map.
*/ -}}
{{- define "merge" -}}
{{- $dst := first . -}}
{{- $src := last . -}}
{{- if typeIs "map[string]interface {}" $src -}}
  {{- range $key, $val := $src -}}
    {{- if and (hasKey $dst $key) (typeIs "map[string]interface {}" $val) -}}
      {{- $_ := set $dst $key (include "merge" (list (get $dst $key) $val)) -}}
    {{- else -}}
      {{- $_ := set $dst $key $val -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- $dst -}}
{{- end -}}