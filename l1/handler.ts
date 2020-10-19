import * as AWSXray from 'aws-xray-sdk-core';
AWSXray.captureHTTPsGlobal(require('http'), true);
AWSXray.captureHTTPsGlobal(require('https'), true);

import { APIGatewayProxyHandler } from 'aws-lambda';
import 'source-map-support/register';

import axios from 'axios';

export const hello: APIGatewayProxyHandler = async (event, _context) => {

  const orgId = event.queryStringParameters.orgId;

  const response = await axios.get(process.env.L2_HOST, {
    params: {
      orgId: orgId
    },
    headers: {
      'x-api-key': process.env.L2_KEY
    }
  });
  return {
    statusCode: 200,
    body: JSON.stringify(response.data, null, 2),
  };
}
