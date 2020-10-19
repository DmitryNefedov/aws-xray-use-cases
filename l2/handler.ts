import * as AWSXray from 'aws-xray-sdk-core';
import {DynamoDB} from 'aws-sdk';

AWSXray.captureHTTPsGlobal(require('http'), true);
AWSXray.captureHTTPsGlobal(require('https'), true);

import {APIGatewayProxyHandler} from 'aws-lambda';
import 'source-map-support/register';

import axios from 'axios';

const dynamodbClient: DynamoDB.DocumentClient | any = new DynamoDB.DocumentClient({
  region: 'ap-southeast-2'
});
AWSXray.captureAWSClient(dynamodbClient.service);

export const hello: APIGatewayProxyHandler = async (event, _context) => {

  const orgId = event.queryStringParameters.orgId;

  const queryParams = {
    TableName: process.env.USER_TABLE,
    KeyConditionExpression: 'org = :org',
    ExpressionAttributeValues: {
      ':org': orgId
    }
  };

  console.log(`queryParams ${JSON.stringify(queryParams)}`);

  const dynamoResult = await dynamodbClient.query(queryParams).promise();

  console.log(`dynamoResult ${JSON.stringify(dynamoResult)}`);

  let result = [];
  const forLoop = async userIds => {
    for (let i = 0; i < userIds.length; i++) {

      try {
        const response = await axios.get(process.env.L3_HOST, {
          params: {
            personId: userIds[i]
          },
          headers: {
            'x-api-key': process.env.L3_KEY
          }
        });

        result = result.concat(response.data);
      } catch (e) {
        console.error(e);
      }
    }
  };

  // crazy loop
  await forLoop(dynamoResult.Items[0].userIds);

  return {
    statusCode: 200,
    body: JSON.stringify(
      result, null, 2),
  };
};
