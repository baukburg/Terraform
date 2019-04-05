echo "apply" >> output.txt
grep my_count ./terraform.tfvars >> output.txt
date >> output.txt
terraform apply -parallelism=200
date >> output.txt
echo "----------" >> output.txt
