{{/* vim: set filetype=mustache: */}}
{{ define "backup.sharedVolumes" }}
{{- if .gcs.uploadToBucket }}
volumes:
  - name: "service-account-volume"
    secret:
      secretName: {{ .gcs.serviceAccountSecretName | quote }}
{{- end }}
{{ end }}
{{- define "backup.sharedPodConfiguration" -}}
{{- if .context.Values.gcs.uploadToBucket }}
volumeMounts:
  - name: "service-account-volume"
    mountPath: "/var/run/secret/cloud.google.com"
{{- end }}
resources:
  limits:
    cpu: 750m
    memory: 900Mi
securityContext:
  privileged: true
  capabilities:
    add:
      - SYS_ADMIN
env:
- name: DB_PASSWORD
  {{- if .db.passwordSecretName }}
  valueFrom:
    secretKeyRef:
      name: {{ .db.passwordSecretName | quote }}
      key: {{ .db.passwordSecretKey | quote }}
  {{- end }}
- name: DB_USER
  value: {{ .db.username | quote }}
- name: DB_HOST
  value: {{ .db.hostname | quote }}
- name: DB_PORT
  value: {{ .db.port | quote }}
- name: DO_UPLOAD
  value: {{ if .context.Values.gcs.uploadToBucket }}"1"{{else}}"0"{{end}}
- name: GCS_BUCKET_NAME
  value: {{ .context.Values.gcs.bucketName | quote }}
- name: BACKUP_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .context.Values.backupSecretName }}
      key: {{ .context.Values.backupSecretKey }}
{{- end -}}