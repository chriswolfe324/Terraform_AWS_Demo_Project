const { ECSClient, RunTaskCommand } = require("@aws-sdk/client-ecs");

exports.handler = async (event) => {

  const ecsClient = new ECSClient({
    region: "us-east-1"
  });

  const params = {
    cluster: "project-ecs-cluster",
    taskDefinition: "book_report_worker"
  };

  const command = new RunTaskCommand(params);
  const response = await ecsClient.send(command);

  console.log(response);
};























