{{/*
Expand the name of the chart.
*/}}
{{- define "kamus.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "appsettings.secrets.json" }}
{{ printf "{" }}
{{ if eq .Values.keyManagement.provider "AzureKeyVault"}}
{{ printf "\n\t\"ActiveDirectory\": { " }}
{{ printf "\t\t\"ClientSecret\": \"%s\" " .Values.keyManagement.azureKeyVault.clientSecret }}
{{ printf "} \n"}}
{{- end -}}
{{ if  eq .Values.keyManagement.provider "AESKey"}}
{{ printf "\"KeyManagement\": { \n\t\t\"AES\": { \"Key\": \"%s\" } }" .Values.keyManagement.AES.key }}
{{- end -}}
{{ printf "}" }}
{{- end }}

{{- define "common.configurations" -}}
KeyManagement__Provider: {{ .Values.keyManagement.provider }}
{{- if .Values.keyManagement.azureKeyVault }}
KeyManagement__KeyVault__Name: {{ .Values.keyManagement.azureKeyVault.keyVaultName }}
KeyManagement__KeyVault__KeyType: {{ default "RSA-HSM" .Values.keyManagement.azureKeyVault.keyType }}
KeyManagement__KeyVault__KeyLength: {{ default "2048" .Values.keyManagement.azureKeyVault.keySize | quote }}
KeyManagement__KeyVault__MaximumDataLength: {{ default "214" .Values.keyManagement.azureKeyVault.maximumDataLength | quote }}
ActiveDirectory__ClientId: {{ .Values.keyManagement.azureKeyVault.clientId }}
{{ end }}
{{- if .Values.keyManagement.googleKms }}
KeyManagement__GoogleKms__Location: {{ .Values.keyManagement.googleKms.location }}
KeyManagement__GoogleKms__KeyRingName: {{ .Values.keyManagement.googleKms.keyRing }}
KeyManagement__GoogleKms__ProtectionLevel: {{ default "HSM" .Values.keyManagement.googleKms.protectionLevel }}
KeyManagement__GoogleKms__RotationPeriod: {{ default "" .Values.keyManagement.googleKms.rotationPeriod }}
KeyManagement__GoogleKms__ProjectId: {{ default "" .Values.keyManagement.googleKms.projectId }}
GOOGLE_APPLICATION_CREDENTIALS: "/home/dotnet/app/secrets/googlecloudcredentials.json"
{{ end }}
{{- if .Values.keyManagement.awsKms }}
KeyManagement__AwsKms__Region: {{ default "" .Values.keyManagement.awsKms.region }}
{{- if .Values.keyManagement.awsKms.key }}
KeyManagement__AwsKms__Key: {{ .Values.keyManagement.awsKms.key }}
{{- end }}
{{- if .Values.keyManagement.awsKms.secret }}
KeyManagement__AwsKms__Secret: {{ default "" .Values.keyManagement.awsKms.secret }}
{{- end }}
KeyManagement__AwsKms__CmkPrefix: {{ default "" .Values.keyManagement.awsKms.cmkPrefix }}
KeyManagement__AwsKms__AutomaticKeyRotation: {{ default "false" .Values.keyManagement.awsKms.enableAutomaticKeyRotation | quote }}
{{- if .Values.keyManagement.awsKms.region }}
AWS_REGION: {{ .Values.keyManagement.awsKms.region }}
{{ end }}
{{ end }}
{{- if .Values.keyManagement.AES }}
KeyManagement__AES__UseKeyDeriviation: {{ default "false" .Values.keyManagement.AES.useKeyDerivation | quote }}
{{- end -}}
{{- end -}}}}
