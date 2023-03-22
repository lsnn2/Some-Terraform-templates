#!/bin/bash
terraform apply -target=aws_lightsail_key_pair.outline-key -target=ws_lightsail_instance.outline-instance -target=aws_lightsail_instance_public_ports.outline