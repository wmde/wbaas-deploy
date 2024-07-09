{{- define "wbaas.values.local.ui" -}}
image:
  tag: sha-52d3977

ui:
  recaptchaSitekeySecretName: {{ .Values.external.recaptcha3.secretName }}
  recaptchaSitekeySecretKey: site_key

foo: bar

ingress:
  tls: null
{{- end -}}