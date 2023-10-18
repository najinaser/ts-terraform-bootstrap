import { APIGatewayProxyEventV2 } from 'aws-lambda';
import { handler } from './index';

describe("test 1", ()=>{
    test("should print 1", async ()=>{
        const fakeEvent = {} as APIGatewayProxyEventV2
        expect("1").toBe("1")
        const res = await handler(fakeEvent) as any;
        expect(res.statusCode).toBe(200)
    })
})