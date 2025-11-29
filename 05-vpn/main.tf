resource "aws_key_pair" "vpn_key" {
  key_name   = "vpn_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDT32GTptBRqkMOYZha/YXUGr7mE2AmPauvcB5tUpVsXVXNp/y8MMK7AdlsqrrjPAqzuSZG+FIZeKb6YXG+2DE0giczIvSwo82Y9mJe1xtpwDfRXc7S9gjZVz5LaFSIXaZ0dpXpJbLHF4BEKaWYf70vwGKaH1c7LPC68u9vwc6+7WAOXElGR/Gw8xEzNvYsBdtxGkjNDmaRG+guUGq0m+RWIUmJmYwbNHHgcFmjKFs3bGsRfow7YB38xQiwrh0EwZ40kOYoIEOfC23zzAK37gwdc/j35OEk9e/f6ufOGG/AvpC+TjhQzvWlvcfSi5Cm5YfKjem2+e+XkAehDmUei0NvIRebcgzM+kqGA3L4ZwsO7TP5i/zgEErsqzCUgOd807lQjx/VwgNOjcd0PuMPVDudw4Mm0AxFxwLuiAaBl39rhJHGQgWOfH8VbvrJnoD6EEQDZ8GuDcRiGpC3QqUHrjo/jBfC+pZOknzXSHXS811yIPJFlHyrPPAphNWyjXwSjpos/smwj6AW7TJMMktmwJx2I8PUmE6xbe+G5cXq5dq98S/cKQiS9YBjXR03VhLPxd0szjvV4Aqa5OFlRux+1s5yavsrcihG6DITOOEgonZmj4ciQlr7xP9CyxVDLN7wcC3b+BouaweL1XGe6qPNHMDDeX5M/8rfbSFqMhYk2H3j9w== SIDDHARTHA@LAPTOP-HJASD3HA"
} 
  #public_key = file(var.public_key_path) # Here you mention the path of the public key
  # public_key = file("C:/Users/SIDDHARTHA/Desktop/DevOps/newkeys/kithu.pub")   
  # public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSSX0JmnRiE7UractUelcw6NhAJh4s/vWKizYOQ21K7sqAgvZAoH2jJ03t2Zt9QbJ0KMvSX3MnaCYvwEn9PvZPuA1dqYQ7BgQ5zPHw2voVJW/3T1eVGAr5BvL9P8lWnngZjsnSQzL7zXc6eubj5VnVvhCO4IhW+lK7paOISEhi75yWRl7pQC/Y1lv1ylF6PjyZ3LQyWp2sMVW6cKIwhKVhs9ZU2LvayFh4JNaIHwzFi3VFa/Eqf4F/BGvNA5iyFN4ukJaRBq2rNoGx24oauDNZdFIvlxdHbmrlXF7e8GQ5MuCriJ+ItoP8wchQMCwqfRu+LsVnnol9V3nLyRkYKo3IPi+/pdRUm5p1v7CKxidY2iF+CvYACS+xoFHQU0OtSMgnepZSMOeg40HhhZELQNhjqEKJmV533J+Jxzl+LTNPQi6ZHU8iAqZc7l6neCwXIB4OwyJC5DRy221jQUxFXmbVgOsmlocPvT3issjHFTQSC5LUMuBsAPt9PqVL6BSv3NU/bpRC6w4oLNnPCZDcqhRDXBU9o/AU1xQ6CZAt7b3m25ONofIZbbio/vw0dvejDArYej1Fev2qCTiB2v42pAe3hhE6jW/kwbYHYxoqzAjQot5ikOnxu6HVMHJsRAuHWHb0kbowsUrOdANIM26T+yR0+dMyD0yp/z6G22Hxh86/xQ== SIDDHARTHA@LAPTOP-HJASD3HA"


module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn_key.key_name
  name = "${var.project_name}-${var.environment}-vpn"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]  # This is List
  instance_type = "t2.micro"

  # convert StringList to list and get first element
  subnet_id     = element(split(",",data.aws_ssm_parameter.public_subnet_ids.value), 0) 
  ami = data.aws_ami.openvpn_info.id
  tags = merge(
          var.common_tags, 
          var.vpn_tags, 
          {Name = "${var.project_name}-${var.environment}-vpn"}
  )
}

#{ Name = "${var.project_name}-${var.environment}-vpn" }


