# Kamus Helm Chart

[Kamus](https://github.com/Soluto/kamus) is an open source, git-ops, zero-trust secret encryption and decryption solution for Kubernetes applications.
This chart should be used to deploy Kamus in a production environment.

Kamus deployment contains 2 pods, one for encryption and one for decryption. Both pods are installed by this chart.

### Installing the Chart

To install the chart with the release name `my-kamus`:

```
helm repo add soluto https://charts.soluto.io
helm install --name my-kamus soluto/kamus
```

The chart can be customized using the following configurable parameters. Most settings affect both APIs, unless specified otherwise:

| Parameter                                      | Description                                                                                                                                                              | Default                                                            |
|------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------|
| `replicaCount`                                 | The number of replicas                                                               | 1
| `useAirbag`                                    | Enable [Airbag](https://github.com/Soluto/airbag) side car for encryption API. Enable to protect encryption API with Openid-Connect authentication.  | `false`
| `airbag.repository`                       | The docker repository to pull Airbag from.                                    | `soluto`
| `airbag.tag`                       | The docker image tag to use when pulling Airbag. Image name will be `airbag:{tag}`.                                    | `soluto`     
| `airbag.authority`                             | The authority issueing the token | 
| `airbag.audience`                              | The audience used to validate the token (`aud` claim) |
| `airbag.issuer`                                | The issuer used to validate the token (`iss` claim) |              
| `image.version`                                | The image of Kamus to pull. Image naming convention is `kamus:encryption-{version}` and `kamus:encryption-{version}`                        | `0.9.0.7`
| `image.repository`                              | The docker repository to pull the images from                                                     | `ghcr.io/soluto`                                        
| `image.pullPolicy`                              | Kamus containers pull policy                                          | `IfNotPresent`                                                            
| `service.type`                                 | The type of the service (careful, values other than `ClusterIp` expose the decryptor to the internet)                         | `ClusterIp`   
| `service.name`                                 | The name of the service                         | `kamus-encryptor`
| `service.port`                                 | The port of the service                         | `80`
| `serviceAccount.annotations`                   | The annotations for the serviceaccount |
| `service.annotations`                          | The annotations for the service |  `prometheus.io/scrape: "true"`
| `ingress.enabled`                              | Enable or disable ingress for encryptor API |  `false`
| `ingress.ingressClassName`                     | The `ClassName` of the `Ingress` |
| `ingress.hosts`                                 | Array of hosts for the ingress |                 
| `ingress.annotations`                          | The annotations for the ingress | 
| `ingress.tls.secretName`                       | The name of the TLS secret that should be used by the ingress | 
| `resources.limit.cpu`                          | The maximum CPU cores that can be consumed  | `500m`
| `resources.limit.memory`                       | The maximum amount of memory that can be consumed    | `600Mi`
| `resource.request.cpu`                         | The minimum CPU cores     | `100m`
| `resource.request.memory`                      | The minimum amount of memory | ` 128Mi`   
| `autoscale.minReplicas`                        | The minimum number of pods   | 2
| `autoscale.maxReplicas`                        | The maximum number of pods   | 10 
| `autoscale.targetCPU`                          | Scale up the numnber of pods when CPU usage is above this percentage       |   50
| `keyManagement.provider`                        | The KMS provider (AESKey/AzureKeyVault/GoogleKms/AwsKms)  | AES
| `keyManagement.secretName`                        | Use pre-created secret for keyManagement |
| `keyManagement.AES.key`                         | The encryption key used by the AES provider, *ovveride for production deployments*. This value *must* kept secret            | `rWnWbaFutavdoeqUiVYMNJGvmjQh31qaIej/vAxJ9G0=`
| `keyManagement.AES.useKeyDerivation`            | Should the AES key be derived from the service account name            | false
| `keyManagement.azureKeyVault.clientId`           | A client ID for a valid Azure Active Directory that has permissions to access the requested key vault |    
| `keyManagement.azureKeyVault.clientSecret`          | A client secret for a valid Azure Active Directory that has permissions to access the requested key vault. This value *must* kept secret |   
| `keyManagement.azureKeyVault.keyVaultName`          | The name of the KeyVault to use | 
| `keyManagement.azureKeyVault.keyType`                | The type of the keys  |  `RSA-HSM` 
| `keyManagement.azureKeyVault.keySize`                | The size of the keys. Do not set to values smaller than 2048 for RSA keys   |  `2048` 
| `keyManagement.azureKeyVault.maximumDataLength`                | The maximum number of bytes that can be encrypted by KeyVaults. For data in bigger size, envelope encryption is used.   |  `214` 
| `keyManagement.googleKms.location`                | The location of the keyring used for encryption/decryption   |  
| `keyManagement.googleKms.keyRing`                | The name of the keyring used for encryption/decryption   |  
| `keyManagement.googleKms.projectId`                | The id of the project used for encryption/decryption  | 
| `keyManagement.googleKms.protectionLevel`                | The protection of the keys, can be either HSM or SOFTWARE   |  HSM
| `keyManagement.googleKms.rotationPeriod`                | The [rotation period](https://cloud.google.com/kms/docs/key-rotation) to set for the keys (optional)  | 
| `keyManagement.googleKms.credentials`                | Base64 encoded credentials files (the JSON file that is created when creating keys for service account on google)  | 
| `keyManagement.awsKms.key`                | User access key to use for AWS KMS authentication   |  
| `keyManagement.awsKms.secret`                | User access secret to use for AWS KMS authentication   |  
| `keyManagement.awsKms.region`                | AWS KMS region   | 
| `keyManagement.awsKms.cmkPrefix`                | Prefix for the customer master keys that are created in the KMS  | 
| `pod.annotations`                             | Set the annotations for Kamus's pods | 
| `encryptor.automountServiceAccountToken`        | Whether the service account token should be mounted on the encryptor pods | `false`      
| `controller.reconciliationIntervalInSeconds`        | Controller reconciliation interval in seconds | 60
Then use this command to install the chart:
```bash
helm install --name my-kamus soluto/kamus -f values.yaml
```

Consult the [installtion guide](https://github.com/Soluto/kamus/blob/master/docs/install.md) for more details on how to configure Kamus for a production deployment.

## Using with EKS IAM Role for service account
In order for the deployments to be able to read the EKS token file, you'll have to pass to the values:
```
  securityContext:
    fsGroup: 65534
```
