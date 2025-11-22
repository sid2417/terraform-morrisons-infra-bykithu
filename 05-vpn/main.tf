resource "aws_key_pair" "vpn_key" {
  key_name   = "vpn_key"
  public_key = file(var.public_key_path) # Here you mention the path of the public key
  # public_key = file("C:/Users/SIDDHARTHA/Desktop/DevOps/newkeys/kithu.pub")   
  # public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSSX0JmnRiE7UractUelcw6NhAJh4s/vWKizYOQ21K7sqAgvZAoH2jJ03t2Zt9QbJ0KMvSX3MnaCYvwEn9PvZPuA1dqYQ7BgQ5zPHw2voVJW/3T1eVGAr5BvL9P8lWnngZjsnSQzL7zXc6eubj5VnVvhCO4IhW+lK7paOISEhi75yWRl7pQC/Y1lv1ylF6PjyZ3LQyWp2sMVW6cKIwhKVhs9ZU2LvayFh4JNaIHwzFi3VFa/Eqf4F/BGvNA5iyFN4ukJaRBq2rNoGx24oauDNZdFIvlxdHbmrlXF7e8GQ5MuCriJ+ItoP8wchQMCwqfRu+LsVnnol9V3nLyRkYKo3IPi+/pdRUm5p1v7CKxidY2iF+CvYACS+xoFHQU0OtSMgnepZSMOeg40HhhZELQNhjqEKJmV533J+Jxzl+LTNPQi6ZHU8iAqZc7l6neCwXIB4OwyJC5DRy221jQUxFXmbVgOsmlocPvT3issjHFTQSC5LUMuBsAPt9PqVL6BSv3NU/bpRC6w4oLNnPCZDcqhRDXBU9o/AU1xQ6CZAt7b3m25ONofIZbbio/vw0dvejDArYej1Fev2qCTiB2v42pAe3hhE6jW/kwbYHYxoqzAjQot5ikOnxu6HVMHJsRAuHWHb0kbowsUrOdANIM26T+yR0+dMyD0yp/z6G22Hxh86/xQ== SIDDHARTHA@LAPTOP-HJASD3HA"
}

module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn_key.key_name
  name = "${var.project_name}-${var.environment}-vpn"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]  # This is List
  instance_type = "t3.micro"

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


