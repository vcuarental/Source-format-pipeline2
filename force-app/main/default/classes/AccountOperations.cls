/**
 * @description Class to handle Account-related operations
 * @author BuildAgent
 * @date 2025-03-04
 */
public class AccountOperations {
    // Constants for reusability and maintenance
    private static final String DEFAULT_DESCRIPTION = 'Default Description';
    private static final String DEFAULT_RATING = 'Warm';
    private static final Integer MAX_BATCH_SIZE = 10000;

    /**
     * Sets a default description for accounts if none exists
     * @param accounts List of accounts to process
     * @return List<Account> Processed accounts with default descriptions
     */
    public static List<Account> setDefaultDescription(List<Account> accounts) {
        // Exit if no accounts to process
        if (accounts == null || accounts.isEmpty()) {
            return accounts;
        }
        //comment
        
        List<Account> accountsToUpdate = new List<Account>();
        
        // Process accounts in bulk
        for (Account acc : accounts) {
            // Only set description if it's null
            if (acc.Description == null) {
                acc.Description = DEFAULT_DESCRIPTION;
                accountsToUpdate.add(acc);
            }
        }
        
        return accountsToUpdate;
    }

    /**
     * Updates account rating based on annual revenue
     * @param accounts List of accounts to process
     * @return List<Account> Processed accounts with updated ratings
     */
    public static List<Account> updateAccountRating(List<Account> accounts) {
        if (accounts == null || accounts.isEmpty()) {
            return accounts;
        }

        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account acc : accounts) {
            if (acc.AnnualRevenue != null) {
                // Set rating based on revenue
                if (acc.AnnualRevenue > 1000000) {
                    acc.Rating = 'Hot';
                } else if (acc.AnnualRevenue > 500000) {
                    acc.Rating = 'Warm';
                } else {
                    acc.Rating = 'Cold';
                }
                accountsToUpdate.add(acc);
            }
        }
        
        return accountsToUpdate;
    }

    /**
     * Calculates the total revenue for a list of accounts
     * @param accounts List of accounts to process
     * @return Decimal Total revenue of all accounts
     */
    public static Decimal calculateTotalRevenue(List<Account> accounts) {
        if (accounts == null || accounts.isEmpty()) {
            return 0;
        }

        Decimal totalRevenue = 0;
        
        for (Account acc : accounts) {
            if (acc.AnnualRevenue != null) {
                totalRevenue += acc.AnnualRevenue;
            }
        }
        
        return totalRevenue;
    }

    /**
     * Updates accounts in bulk with error handling
     * @param accountsToUpdate List of accounts to update
     * @return Database.SaveResult[] Results of the DML operation
     */
    public static Database.SaveResult[] updateAccounts(List<Account> accountsToUpdate) {
        if (accountsToUpdate == null || accountsToUpdate.isEmpty()) {
            return null;
        }

        // Ensure we don't exceed governor limits
        if (accountsToUpdate.size() > MAX_BATCH_SIZE) {
            throw new AccountOperationsException('Batch size exceeds maximum limit of ' + MAX_BATCH_SIZE);
        }

        try {
            Database.SaveResult[] results = Database.update(accountsToUpdate, false);
            
            // Log errors if any
            for (Database.SaveResult sr : results) {
                if (!sr.isSuccess()) {
                    for (Database.Error err : sr.getErrors()) {
                        System.debug(LoggingLevel.ERROR, 'Error updating account: ' + err.getMessage());
                    }
                }
            }
            
            return results;
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in updateAccounts: ' + e.getMessage());
            throw new AccountOperationsException('Failed to update accounts: ' + e.getMessage());
        }
    }

    /**
     * Custom exception class for Account Operations
     */
    public class AccountOperationsException extends Exception {}
}