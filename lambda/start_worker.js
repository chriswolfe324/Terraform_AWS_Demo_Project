//this is just placeholder code for now

exports.handler = async (event) => {
  console.log("Lambda function executed");
  console.log("Event:", JSON.stringify(event));

  return {
    statusCode: 200,
    body: "Lambda executed successfully"
  };
};