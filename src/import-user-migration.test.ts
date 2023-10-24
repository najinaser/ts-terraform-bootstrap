import { authenticateUser } from './import-user-migration'
describe("import users", ()=>{
    test("many users", ()=>{
        expect(authenticateUser("naji.naser+31@moo.com", "12")).not.toBeNull()

        expect(authenticateUser("philip.cadwallader+30@moo.com", "1234")).not.toBeNull()
    })
})