const { ECSClient, RunTaskCommand } = require("@aws-sdk/client-ecs");

exports.handler = async (event) => {

  const ecsClient = new ECSClient({
    region: "us-east-1"
  });

  const params = {
    cluster: "project-ecs-cluster",
    taskDefinition: "book_report_worker",
    launchType: "FARGATE",

    networkConfiguration: {
      awsvpcConfiguration: {
        subnets: ["subnet-01d64dfcafae59863", "subnet-01d64dfcafae59863"],
        securityGroups: ["sg-06fb7f50dd1e48862"],
        assignPublicIp: "DISABLED"
      }
    }
  };

  const command = new RunTaskCommand(params);
  const response = await ecsClient.send(command);

  console.log(response);
};























