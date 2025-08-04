# Velero - Backup Kubernetes no GCP

Este README descreve o processo de download, configuração e instalação do Velero para realizar backups de clusters Kubernetes na Google Cloud Platform (GCP).

## Velero - Backup e Restauração do Cluster Kubernetes

O [Velero](https://velero.io) é uma ferramenta open source que permite realizar backups, restaurações e migrações de clusters Kubernetes. Ele é altamente recomendado para ambientes de produção ou quando há necessidade de disaster recovery.

### O que o Velero faz:

- Backup de recursos e volumes persistentes do Kubernetes
- Restauração de recursos para o mesmo cluster ou outro
- Agendamento automático de backups
- Suporte a provedores como GCP, AWS, Azure, entre outros

### Instalação no GKE

1. **Crie um bucket no Google Cloud Storage (GCS):**

```bash
gsutil mb -p YOUR_PROJECT_ID -c standard -l us-central1 gs://YOUR_VELERO_BUCKET/
```

2. **Crie a service account e conceda permissões:**

```bash
gcloud iam service-accounts create velero \
  --display-name "Velero service account"

gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member serviceAccount:velero@YOUR_PROJECT_ID.iam.gserviceaccount.com \
  --role roles/storage.admin
```

3. **Gere a chave do service account:**

```bash
gloud iam service-accounts keys create credentials-velero.json \
  --iam-account velero@YOUR_PROJECT_ID.iam.gserviceaccount.com
```

## Download e Instalação do Velero CLI

```bash
# Baixe o Velero
wget https://github.com/vmware-tanzu/velero/releases/download/v1.10.0/velero-v1.10.0-linux-amd64.tar.gz

# Extraia o conteúdo
tar -zxvf velero-v1.10.0-linux-amd64.tar.gz

# Mova o binário para o PATH
sudo mv velero-v1.10.0-linux-amd64/velero /usr/local/bin

# Limpeza dos arquivos
rm -rf velero-v1.10.0-linux-amd64.tar.gz velero-v1.10.0-linux-amd64

# Geração de credenciais no GCP
gcloud iam service-accounts keys create credentials-velero.json --iam-account sa-velero-backup@devops-464620.iam.gserviceaccount.com

# Instalação do Velero no Cluster Kubernetes
velero install \
  --provider gcp \
  --plugins velero/velero-plugin-for-gcp:v1.12.0 \
  --bucket backup-velero-devops-464620 \
  --secret-file ./devops-464620-d66ed5a01b31.json
```

# Comandos úteis

```bash
# Criar um backup manual
velero backup create meu-backup --include-namespaces default

# Listar backups disponíveis
velero backup get

# Restaurar a partir de um backup
velero restore create --from-backup meu-backup

```

---
