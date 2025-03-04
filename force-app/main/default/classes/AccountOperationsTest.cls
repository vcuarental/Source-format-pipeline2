@IsTest
private class AccountOperationsTest {
    
    @IsTest
    static void testSetDefaultDescription() {
        // Test with null description
        Account acc1 = new Account(Name = 'Test1');
        Account result1 = AccountOperations.setDefaultDescription(acc1);
        System.assertEquals('Default description', result1.Description, 'Default description should be set for null description');
        
        // Test with empty description
        Account acc2 = new Account(Name = 'Test2', Description = '  ');
        Account result2 = AccountOperations.setDefaultDescription(acc2);
        System.assertEquals('Default description', result2.Description, 'Default description should be set for empty description');
        
        // Test with existing description
        Account acc3 = new Account(Name = 'Test3', Description = 'Existing Description');
        Account result3 = AccountOperations.setDefaultDescription(acc3);
        System.assertEquals('Existing Description', result3.Description, 'Existing description should not be changed');
    }
    
    @IsTest
    static void testSetDefaultPhone() {
        // Test with null phone
        Account acc1 = new Account(Name = 'Test1');
        Account result1 = AccountOperations.setDefaultPhone(acc1);
        System.assertEquals('1234567890', result1.Phone, 'Default phone should be set for null phone');
        
        // Test with empty phone
        Account acc2 = new Account(Name = 'Test2', Phone = '  ');
        Account result2 = AccountOperations.setDefaultPhone(acc2);
        System.assertEquals('1234567890', result2.Phone, 'Default phone should be set for empty phone');
        
        // Test with existing phone
        Account acc3 = new Account(Name = 'Test3', Phone = '9876543210');
        Account result3 = AccountOperations.setDefaultPhone(acc3);
        System.assertEquals('9876543210', result3.Phone, 'Existing phone should not be changed');
    }
    
    @IsTest
    static void testSetDefaultURL() {
        // Test with null website
        Account acc1 = new Account(Name = 'Test1');
        Account result1 = AccountOperations.setDefaultURL(acc1);
        System.assertEquals('www.mydefaultsite.com', result1.Website, 'Default website should be set for null website');
        
        // Test with empty website
        Account acc2 = new Account(Name = 'Test2', Website = '  ');
        Account result2 = AccountOperations.setDefaultURL(acc2);
        System.assertEquals('www.mydefaultsite.com', result2.Website, 'Default website should be set for empty website');
        
        // Test with existing website
        Account acc3 = new Account(Name = 'Test3', Website = 'www.existing.com');
        Account result3 = AccountOperations.setDefaultURL(acc3);
        System.assertEquals('www.existing.com', result3.Website, 'Existing website should not be changed');
    }
    
    @IsTest
    static void testSetDefaultValues() {
        // Test with null list
        List<Account> nullList = null;
        List<Account> nullResult = AccountOperations.setDefaultValues(nullList);
        System.assertEquals(0, nullResult.size(), 'Should return empty list for null input');
        
        // Test with empty list
        List<Account> emptyList = new List<Account>();
        List<Account> emptyResult = AccountOperations.setDefaultValues(emptyList);
        System.assertEquals(0, emptyResult.size(), 'Should return empty list for empty input');
        
        // Test with actual accounts
        List<Account> testAccounts = new List<Account>{
            new Account(Name = 'Test1'),
            new Account(Name = 'Test2', Description = 'Custom Description', Phone = '9999999999', Website = 'www.custom.com'),
            new Account(Name = 'Test3', Description = '', Phone = '', Website = '')
        };
        
        List<Account> results = AccountOperations.setDefaultValues(testAccounts);
        
        System.assertEquals(3, results.size(), 'Should return same number of accounts');
        
        // Verify first account (all defaults)
        System.assertEquals('Default description', results[0].Description, 'Default description should be set');
        System.assertEquals('1234567890', results[0].Phone, 'Default phone should be set');
        System.assertEquals('www.mydefaultsite.com', results[0].Website, 'Default website should be set');
        
        // Verify second account (custom values preserved)
        System.assertEquals('Custom Description', results[1].Description, 'Custom description should be preserved');
        System.assertEquals('9999999999', results[1].Phone, 'Custom phone should be preserved');
        System.assertEquals('www.custom.com', results[1].Website, 'Custom website should be preserved');
        
        // Verify third account (empty values replaced with defaults)
        System.assertEquals('Default description', results[2].Description, 'Default description should be set for empty');
        System.assertEquals('1234567890', results[2].Phone, 'Default phone should be set for empty');
        System.assertEquals('www.mydefaultsite.com', results[2].Website, 'Default website should be set for empty');
    }
}