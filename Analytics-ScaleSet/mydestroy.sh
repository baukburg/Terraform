echo "destroy" >> output.txt
grep my_count ./terraform.tfvars >> output.txt
date >> output.txt
terraform destroy -parallelism=10
date >> output.txt
echo "----------" >> output.txt
