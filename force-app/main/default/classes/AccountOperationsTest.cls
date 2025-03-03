@IsTest
private class AccountOperationsTest {
    @IsTest
    static void testSetDefaultDescription() {
        // Test data setup
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2', Description = 'Existing Description'),
            new Account(Name = 'Test Account 3')
        };
        //comment
        // Execute test
        Test.startTest();
        insert accounts;
        Test.stopTest();
        
        // Verify results
        List<Account> updatedAccounts = [SELECT Id, Description FROM Account ORDER BY Name];
        System.assertEquals(3, updatedAccounts.size(), 'Should have 3 accounts');
        System.assertEquals('Default Description', updatedAccounts[0].Description, 
            'Account 1 should have default description');
        System.assertEquals('Existing Description', updatedAccounts[1].Description, 
            'Account 2 should maintain existing description');
        System.assertEquals('Default Description', updatedAccounts[2].Description, 
            'Account 3 should have default description');
    }
    
    @IsTest
    static void testNullInput() {
        // Test null input
        List<Account> result = AccountOperations.setDefaultDescription(null);
        System.assertEquals(null, result, 'Should handle null input gracefully');
        
        // Test empty list
        result = AccountOperations.setDefaultDescription(new List<Account>());
        System.assertEquals(0, result.size(), 'Should handle empty list gracefully');
    }
}