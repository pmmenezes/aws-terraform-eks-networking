
##  AWS EKS Networking - VPC Setup
https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html

### Inicialize o backend do Terraform com o arquivo backend.tfvars
terraform init -backend-config=environment/prod/backend.tfvars
### Valide a configuração do Terraform
terraform validate
### Planeje a aplicação da configuração do Terraform usando o arquivo de variáveis
terraform plan -var-file=environment/prod/terraform.tfvars
### Aplique a configuração do Terraform usando o arquivo de variáveis
terraform apply -var-file=environment/prod/terraform.tfvars -auto-approve
### Exporte o estado atual do Terraform para um arquivo JSON
terraform show -json > terraform-state.json
### Use o jq para extrair o ID da VPC do arquivo JSON e definir como uma variável de ambiente
export VPC_ID=$(jq -r '.values.root_module.resources[] | select(.type=="aws_vpc") | .values.id' terraform-state.json)



#### Extras

[split Function](https://developer.hashicorp.com/terraform/language/functions/split)
[Element Function](https://developer.hashicorp.com/terraform/language/functions/element)
[For Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)
