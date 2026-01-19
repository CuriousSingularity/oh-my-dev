#!/usr/bin/env python
from argparse import ArgumentParser
import boto3
import botocore
from pathlib import Path


def get_ec2_config():
    ec2_yaml_path = Path.home() / ".ec2.yaml"
    if ec2_yaml_path.exists():
        import yaml

        with open(ec2_yaml_path, "r") as f:
            ec2_config = yaml.safe_load(f)
        instances = ec2_config.get("instances", [])
        instances = [tuple(instance) for instance in instances]
    else:
        instances = [
            ("i-0000000000000000A", "ec2-server-01"),
            ("i-0000000000000000B", "ec2-server-02"),
        ]

    return instances


def main(args):
    # Use functional user
    boto3.setup_default_session(profile_name=args.profile)
    # Configure the number of retries
    config = botocore.config.Config(retries=dict(max_attempts=args.max_attempts))
    ec2_client = boto3.client(
        "ec2",
        region_name=args.region,
        config=config,
        use_ssl=not args.no_ssl,
        verify=not args.no_ssl,
    )

    instances = get_ec2_config()

    for attempt in range(args.max_attempts):
        try:
            response = ec2_client.describe_instance_status(IncludeAllInstances=True)
            break
        except Exception as e:
            if attempt == args.max_attempts - 1:
                print(f"Max attempts reached. Exiting with error {e}")
                exit(1)

    instances_id_all = []
    instance_status_all = []
    for instance in response["InstanceStatuses"]:
        instance_id = instance["InstanceId"]
        instance_state = instance["InstanceState"]
        system_status = instance["SystemStatus"]
        instance_status = instance["InstanceStatus"]
        instances_id_all.append(instance_id)
        instance_status_all.append(instance_state["Name"])

    print("-" * 75)

    for index, instance in enumerate(instances):
        try:
            print(
                f"|{index+1:>3} | {instance[1]:>30} | {instance_status_all[instances_id_all.index(instance[0])]} | {instance[0]} |"
            )
        except Exception as e:
            pass

    print("-" * 75)

    if args.start is not None and 1 <= args.start <= len(instances):
        print("Starting instance ", instances[args.start - 1])
        ec2_client.start_instances(InstanceIds=[instances[args.start - 1][0]])

    if args.stop is not None and 1 <= args.stop <= len(instances):
        print("Stopping instance ", instances[args.stop - 1])
        ec2_client.stop_instances(InstanceIds=[instances[args.stop - 1][0]])


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("--start", help="ec2 instance to start, e.g. 1", type=int)
    parser.add_argument("--stop", help="ec2 instance to stop, e.g. 1", type=int)
    parser.add_argument(
        "--max_attempts",
        default=6,
        help="Maximum number of attempts, default: 6",
        type=int,
    )
    parser.add_argument(
        "--profile",
        default="ec2_access",
        help="AWS profile to use, default: ec2_access",
    )
    parser.add_argument(
        "--region",
        default="eu-central-1",
        help="AWS region to use, default: eu-central-1",
    )
    parser.add_argument(
        "--no_ssl", action="store_true", help="Disable SSL, default: False"
    )

    args = parser.parse_args()
    main(args)
