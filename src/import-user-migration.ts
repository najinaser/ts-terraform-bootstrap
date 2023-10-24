const validUsers: any = {
     password: "12", 
     emailAddress: "naji.naser+30@moo.com" 
  };
  
  // Replace this mock with a call to a real authentication service.
  const authenticateUser = (email: string, password: string) => {
    // we call Site
    if (validUsers.emailAddress === email && validUsers.password === password) {
      return validUsers;
    } else {
      return null;
    }
  };
  
  
const handler = async (event: any) => {

    console.log("event", { event })

    if (event.triggerSource == "UserMigration_Authentication") {
        console.log("1111")
      // Authenticate the user with your existing user directory service
      const user = authenticateUser(event.userName, event.request.password);
      console.log('user is ', user)
      if (user) {
        event.response.userAttributes = {
          email: user.emailAddress,
          email_verified: "true",
        };
        event.response.finalUserStatus = "CONFIRMED";
        event.response.messageAction = "SUPPRESS";
      }
    }
  
    return event;
  };
  
  export { handler };
  



// export const handler = async (event: any): Promise<any>=>{
//     console.log("we are in import-user-migratino handler")
//     return {
//         statusCode: 200,
//         headers: {
//             'Content-Type': 'text/html; charset=utf-8',
//         },
//         body: `<p>Hello Naji and Phil!</p>`,
//     }
// }