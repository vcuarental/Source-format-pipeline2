/**
 * @description Test class for AccountOperations
 * @author BuildAgent
 * @date 2025-03-04
 */
@isTest
private class AccountOperationsTest {
    // Constants for test data
    private static final Decimal HIGH_REVENUE = 2000000;
    private static final Decimal MEDIUM_REVENUE = 750000;
    private static final Decimal LOW_REVENUE = 250000;
    
    /**
     * @description Sets up test data
     * @return List<Account> List of test accounts
     */
    private static List<Account> createTestAccounts() {
        List<Account> testAccounts = new List<Account>();
        
        // Account with no description
        testAccounts.add(new Account(
            Name = 'Test Account 1',
            AnnualRevenue = HIGH_REVENUE
        ));
        
        // Account with existing description
        testAccounts.add(new Account(
            Name = 'Test Account 2',
            Description = 'Existing Description',
            AnnualRevenue = MEDIUM_REVENUE
        ));
        
        // Account with no revenue
        testAccounts.add(new Account(
            Name = 'Test Account 3',
            Description = null,
            AnnualRevenue = null
        ));
        
        return testAccounts;
    }
    
    /**
     * @description Tests setDefaultDescription method with null input
     */
    @isTest
    static void testSetDefaultDescriptionNull() {
        // Test null input
        List<Account> result = AccountOperations.setDefaultDescription(null);
        System.assertEquals(null, result, 'Null input should return null');
        
        // Test empty list
        result = AccountOperations.setDefaultDescription(new List<Account>());
        System.assertEquals(0, result.size(), 'Empty list should return empty list');
    }
    
    /**
     * @description Tests setDefaultDescription method with valid accounts
     */
    @isTest
    static void testSetDefaultDescription() {
        // Arrange
        List<Account> testAccounts = createTestAccounts();
        
        // Act
        Test.startTest();
        List<Account> updatedAccounts = AccountOperations.setDefaultDescription(testAccounts);
        Test.stopTest();
        
        // Assert
        System.assertEquals(2, updatedAccounts.size(), 'Should return accounts needing updates');
        for(Account acc : updatedAccounts) {
            System.assertEquals('Default Description', acc.Description, 
                'Account should have default description');
        }
    }
    
    /**
     * @description Tests updateAccountRating method
     */
    @isTest
    static void testUpdateAccountRating() {
        // Arrange
        List<Account> testAccounts = createTestAccounts();
        
        // Act
        Test.startTest();
        List<Account> updatedAccounts = AccountOperations.updateAccountRating(testAccounts);
        Test.stopTest();
        
        // Assert
        System.assertEquals(2, updatedAccounts.size(), 'Should return accounts with revenue');
        
        for(Account acc : updatedAccounts) {
            if(acc.AnnualRevenue == HIGH_REVENUE) {
                System.assertEquals('Hot', acc.Rating, 'High revenue account should be rated Hot');
            } else if(acc.AnnualRevenue == MEDIUM_REVENUE) {
                System.assertEquals('Warm', acc.Rating, 'Medium revenue account should be rated Warm');
            }
        }
    }
    
    /**
     * @description Tests calculateTotalRevenue method
     */
    @isTest
    static void testCalculateTotalRevenue() {
        // Arrange
        List<Account> testAccounts = createTestAccounts();
        Decimal expectedTotal = HIGH_REVENUE + MEDIUM_REVENUE; // Only accounts with revenue
        
        // Act
        Test.startTest();
        Decimal totalRevenue = AccountOperations.calculateTotalRevenue(testAccounts);
        Test.stopTest();
        
        // Assert
        System.assertEquals(expectedTotal, totalRevenue, 
            'Total revenue should match sum of accounts with revenue');
    }
    
    /**
     * @description Tests updateAccounts method with successful updates
     */
    @isTest
    static void testUpdateAccountsSuccess() {
        // Arrange
        List<Account> testAccounts = createTestAccounts();
        insert testAccounts;
        
        for(Account acc : testAccounts) {
            acc.Description = 'Updated Description';
        }
        
        // Act
        Test.startTest();
        Database.SaveResult[] results = AccountOperations.updateAccounts(testAccounts);
        Test.stopTest();
        
        // Assert
        System.assertNotEquals(null, results, 'Should return save results');
        for(Database.SaveResult sr : results) {
            System.assert(sr.isSuccess(), 'Update should be successful');
        }
    }
    
    /**
     * @description Tests updateAccounts method with batch size limit
     */
    @isTest
    static void testUpdateAccountsBatchLimit() {
        // Arrange
        List<Account> largeAccountList = new List<Account>();
        for(Integer i = 0; i < 10001; i++) {
            largeAccountList.add(new Account(Name = 'Test Account ' + i));
        }
        
        // Act & Assert
        Test.startTest();
        try {
            AccountOperations.updateAccounts(largeAccountList);
            System.assert(false, 'Should throw exception for exceeding batch size');
        } catch(AccountOperations.AccountOperationsException e) {
            System.assert(e.getMessage().contains('Batch size exceeds maximum limit'), 
                'Should throw batch size limit exception');
        }
        Test.stopTest();
    }
    
    /**
     * @description Tests updateAccounts method with null input
     */
    @isTest
    static void testUpdateAccountsNull() {
        // Act
        Test.startTest();
        Database.SaveResult[] results = AccountOperations.updateAccounts(null);
        Test.stopTest();
        
        // Assert
        System.assertEquals(null, results, 'Null input should return null');
    }
    
    /**
     * @description Tests updateAccounts method with DML error
     */
    @isTest
    static void testUpdateAccountsError() {
        // Arrange
        Account invalidAccount = new Account(); // No Name field, will cause DML error
        List<Account> invalidAccounts = new List<Account>{invalidAccount};
        
        // Act
        Test.startTest();
        Database.SaveResult[] results = AccountOperations.updateAccounts(invalidAccounts);
        Test.stopTest();
        
        // Assert
        System.assertNotEquals(null, results, 'Should return save results');
        for(Database.SaveResult sr : results) {
            System.assert(!sr.isSuccess(), 'Update should fail');
            System.assert(!sr.getErrors().isEmpty(), 'Should have error messages');
        }
    }
}