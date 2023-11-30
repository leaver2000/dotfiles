{{/* Expand the name of the chart. */}}
{{- define "project.name" -}}
	{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "project.fullname" -}}
	{{- if .Values.fullnameOverride }}
		{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
	{{- else }}
		{{- $name := default .Chart.Name .Values.nameOverride }}
		{{- if contains $name .Release.Name }}
			{{- .Release.Name | trunc 63 | trimSuffix "-" }}
		{{- else }}
			{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
		{{- end }}
	{{- end }}
{{- end }}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "project.chart" -}}
	{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Common labels */}}
{{- define "project.labels" -}}
helm.sh/chart: {{ include "project.chart" . }}
{{ include "project.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Selector labels */}}
{{- define "project.selectorLabels" -}}
app.kubernetes.io/name: {{ include "project.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Create the name of the service account to use */}}
{{- define "project.serviceAccountName" -}}
	{{- if .Values.serviceAccount.create }}
		{{- default (include "project.fullname" .) .Values.serviceAccount.name }}
	{{- else }}
		{{- default "default" .Values.serviceAccount.name }}
	{{- end }}
{{- end }}

{{/* create a default fully qualified redis name. */}}
{{- define "project.redis.fullname" -}}
	{{- include "common.names.dependency.fullname" (dict "chartName" "redis-master" "chartValues" .Values.redis "context" $) -}}
{{- end -}}

{{/* map the port to an envrionment variable */}}
{{- define "project.redis.port" -}}
	{{- default 6379 .Values.redis.master.containerPorts.redis | quote -}}
{{- end -}}

{{/* Get the Redis&reg; user name */}}
{{- define "project.redis.user" -}}
	{{- default "redis_user" .Values.redis.auth.username -}}
{{- end -}}

{{/* Get the Redis&reg; credentials secret. */}}
{{- define "project.redis.secretName" -}}
	{{- if and (.Values.redis.enabled) (not .Values.redis.auth.existingSecret) -}}
		{{- $name := default "redis" .Values.redis.nameOverride -}}
		{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
	{{- else }}
		{{- printf "%s" .Values.redis.auth.existingSecret -}}
	{{- end -}}
{{- end -}}

{{/* create a default fully qualified redis name. */}}
{{- define "project.postgresql.fullname" -}}
	{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/* set a default port of 5432 for postgres */}}
{{- define "project.postgresql.port" -}}
	{{- default 5432 .Values.postgresql.containerPorts.postgresql | quote -}}
{{- end -}}

{{/* get the database user name */}}
{{- define "project.postgresql.user" -}}
	{{- default "postgresql_user" .Values.postgresql.auth.username -}}
{{- end -}}

{{/* 
Create a include for the postgresql secret
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
if not set the value will be something like "project-release-postgresql"
*/}}
{{- define "project.postgresql.secretName" -}}
	{{- if and (.Values.postgresql.enabled) (not .Values.postgresql.auth.existingSecret) }}
		{{- $name := default "postgresql" .Values.postgresql.nameOverride }}
		{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
	{{- else }}
		{{- printf "%s" .Values.postgresql.auth.existingSecret }}
	{{- end }}
{{- end -}}