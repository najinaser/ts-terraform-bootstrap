// import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";

export const handler = async (
    event: any
): Promise<any> => {
    console.log("event-2", { event })
    event.response = {
        claimsOverrideDetails: {
          claimsToAddOrOverride: {
            my_first_attribute: "first_value",
            my_second_attribute: "second_value",
          },
          claimsToSuppress: ["email"],
        },
      };
    
      return event;
    // const queries = event.queryStringParameters;
    // let name = 'there';  

    // if (queries !== null && queries !== undefined) {
    //     if (queries["name"]) {  
    //         name = queries["name"] 
    //     }
    // }

    // return {
    //     statusCode: 200,
    //     headers: {
    //         'Content-Type': 'text/html; charset=utf-8',
    //     },
    //     body: `<p>Hello 12 ${name}!</p>`,
    // }
}