public class AccountOperations {
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
        
        List<Account> accountsToUpdate = new List<Account>();
        
        // Process accounts in bulk
        for (Account acc : accounts) {
            // Only set description if it's null
            if (acc.Description == null) {
                acc.Description = 'Default Description';
                accountsToUpdate.add(acc);
            }
        }
        
        return accountsToUpdate;
    }
}