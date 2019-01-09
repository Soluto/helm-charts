# helm-charts
Soluto's Helm Charts Repository. 

## Available Charts
* [Kamus](charts/kamus) - A GitOps, secrets encryption/decryption solution for Kubernetes.

## Usage
Add our repository to helm:
```
helm repo add soluto charts.soluto.io
```
Now run the following command to see all the available charts:
```
helm search soluto/
```

## Security
We take security seriously at Soluto. 
To learn more about the security aspects of Kamus refer to the Threat Modeling docs containing all the various threats and mitigations we discussed.
Before installing Kamus in production refer the installation guide to learn the best practices of deploying Kamus securely.
In case you find a security issue or have something you would like to discuss refer to our [security.md](security.md) policy.

## Contributing
Find a bug? Have a missing feature? Please open an issue and let us know. 
We would like to help you using Kamus!
Please notice: Do not report security issues on GitHub. 
We will immediately delete such issues.
