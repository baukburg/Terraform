echo "apply" >> output.txt
grep my_count ./terraform.tfvars >> output.txt
grep set_count ./terraform.tfvars >> output.txt
date >> output.txt
terraform apply -parallelism=20
date >> output.txt
echo "----------" >> output.txt
