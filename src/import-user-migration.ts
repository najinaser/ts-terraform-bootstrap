const validUsers: any = {
    "naji.naser+31@moo.com":{
        password: "12", 
        emailAddress: "naji.naser+31@moo.com" 
    },
    "philip.cadwallader+30@moo.com": {
        password: "1234", 
        emailAddress: "philip.cadwallader+30@moo.com" 
    },
    "philip.cadwallader+31@moo.com": {
        password: "31", 
        emailAddress: "philip.cadwallader+31@moo.com" 
    },
    "philip.cadwallader+32@moo.com": {
        password: "32", 
        emailAddress: "philip.cadwallader+32@moo.com" 
    },
    "naji@moo.com":{
        password: "12", 
        emailAddress: "naji@moo.com" 
    },
    "naji@oo.com":{
        password: "12", 
        emailAddress: "naji@oo.com" 
    },
  };
  
  // Replace this mock with a call to a real authentication service.
const authenticateUser = (email: string, password: string) => {
    const validSingleUsers = validUsers[email]
    // we call Site
    if (validSingleUsers.emailAddress === email && validSingleUsers.password === password) {
      return validSingleUsers;
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
  
  export { handler, authenticateUser };
  



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