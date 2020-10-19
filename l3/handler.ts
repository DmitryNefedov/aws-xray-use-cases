import * as AWSXray from 'aws-xray-sdk-core';
AWSXray.captureHTTPsGlobal(require('http'), true);
AWSXray.captureHTTPsGlobal(require('https'), true);

import axios from 'axios';
import {APIGatewayProxyHandler} from 'aws-lambda';
import 'source-map-support/register';

const sleep = (milliseconds) => {
  return new Promise(resolve => setTimeout(resolve, milliseconds))
};

export const hello: APIGatewayProxyHandler = async (event, _context) => {

  const id = event.queryStringParameters.personId;
  const host = process.env.SW_HOST;

  // make it slower
  await sleep(90 + Math.floor(Math.random() * 10));

  const response = await axios.get(`${host}/${id}`);

  return {
    statusCode: 200,
    body: JSON.stringify(
        response.data,
        null,
        2
    ),
  };
};
